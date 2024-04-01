Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8B21DFF4;
	Mon,  1 Apr 2024 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991027; cv=none; b=UXEbunFv/a5yGs2N3jis1TeJttHcvur6eTqZCWygPwTpuVQfnXQyalgDS0CIvxC7mHdFDuPD1LAqSJjDi8QqqlpAYsZrngoj7sbP0W+XJpA062RrUmUHJf0MLDsLJghXZd5SCSNL3m621EdyYIpf1sbrKzf7AqYTRG71eFXwSPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991027; c=relaxed/simple;
	bh=dcQHKLmOXkZF4rTBTXPnxxFmSPCpoBtauahfLOsUP3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWXjjMoJqK8TFfi9nlBVvB3Y1M6mpnS137nZxXkWqUhl+WYYXo6ATX9MW15PlurZ9/b7Di5h1YM4QLrlhvhGNk3QDDdZNmuBjwWF3iHKIDhBKU7wUpa8d3pliXQ4wIQMfi+npRndHoQ2eNIW0rmnHWjy20Y5aitHtlPbB0rWSSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFIWr0jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFIWr0jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A1AC43390;
	Mon,  1 Apr 2024 17:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991027;
	bh=dcQHKLmOXkZF4rTBTXPnxxFmSPCpoBtauahfLOsUP3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFIWr0jfM2Xn3g8B1MYIDiE+AXajd/tVsMBvddODCZ3Syjfz+BzU9LFqJFVvV9ceB
	 R0XuohFeqZ6ORgiAlvxxDHfU35Sdds7oqfYarXGV687CHSqqVQ2zJkYHVXeph4dH2H
	 PTqQu3ghOsbuzXryn8GytefvbV8BtzTewPEaB4UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Pittman <jpittman@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/272] dm snapshot: fix lockup in dm_exception_table_exit
Date: Mon,  1 Apr 2024 17:45:30 +0200
Message-ID: <20240401152535.052128963@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b748901a4fb55..1c601508ce0b4 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -679,8 +679,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
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



