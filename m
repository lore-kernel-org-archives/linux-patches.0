Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20CAC129;
	Mon,  1 Apr 2024 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988557; cv=none; b=plG5QlrfeTLhcmktszkeMyGJXoQ7TykJqBixmv9OXiKRgjCVxoi5FgCjzET96ovwalLKrf2BUEOi3OnIE+hldC4waXsbDH9akY37J+TB4ZLQi9N4OQm+Naq2MAyUpTpukEiAoXQMguwzhP2iso+iN0NsKFLMATBEJFaUtJYXj6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988557; c=relaxed/simple;
	bh=FYT0OzPU2QWCQq88JgRE3mWfL2W5ZNr0V14B5mmo2wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDHk/+2jvjGuLNkkY9ikbmv9rXdoFw+Bt+bdH6xOVTAoE9gBuaYZUevQVUaxCriUM3Z/OhMQOgS6xGuGPIXWlEkKQ77y8m80qYyHekYP4mvgH0z/ukvej5tbhYsYuc5k0uOUIhoKAF2iAXb4Ld7sWgpY8tVx+A9tXavUYCb/ylI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDnYiOv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDnYiOv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A46DC433F1;
	Mon,  1 Apr 2024 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988557;
	bh=FYT0OzPU2QWCQq88JgRE3mWfL2W5ZNr0V14B5mmo2wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDnYiOv5UkmnxJc/Pu/nBT4Ler0dV6b14IfB2lHJakmIx2U7OTV25XB8LPHaBqrPC
	 0Af5omvHYsHfMvOtsPgv5xcdF1gDLyq6Y8V5ODKg+dDTOICglpiJFGWj6Euex8M1Nf
	 fuySBuw0vb7yI7xfm9G63HCjQmEl0fqx/bjR49FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Pittman <jpittman@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 220/432] dm snapshot: fix lockup in dm_exception_table_exit
Date: Mon,  1 Apr 2024 17:43:27 +0200
Message-ID: <20240401152559.700107372@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6e7132ed3c07bd8a6ce3db4bb307ef2852b322dc ]

There was reported lockup when we exit a snapshot with many exceptions.
Fix this by adding "cond_resched" to the loop that frees the exceptions.

Reported-by: John Pittman <jpittman@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index bf7a574499a34..0ace06d1bee38 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -684,8 +684,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);
-- 
2.43.0



