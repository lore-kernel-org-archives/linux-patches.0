Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0251C0DE7;
	Mon,  1 Apr 2024 16:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989987; cv=none; b=l4eGdiTlH+Z63y7TzM5W8kr9LYSFUMnDZoI2/cMaoL2WIRlGQ+gQ9EM+55+uozv8U10tEpnngYOp+6OlL/vlTBuRKKhQmBJoQW20/X/Enbc6NXyRynB9kdYhkiytSmAYMlS8zMnCcuRXuzs1EJxAZZb6gywVKZdeQVeSzgivc44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989987; c=relaxed/simple;
	bh=8bPielUPj091FCau8e63UmZh/qWE0FXC+4JoN0WwcB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El9iJPVDscc46i/Oo0kCtOsDqsOcf+AgSecPldHCA9QZ4dTKSdql2MqxyOk4X1ZPdNa5b9Ds8HuMxfZta1o+YxDHA50gSsUqu7dKkrhzbXPXJkaZ+yKnQYOdWWRIvQ5IdhYKjhi7PSsvYUkfuShgJpdp6tim4fclwXJqE8iC+p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJ2sr+E8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJ2sr+E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD69CC433F1;
	Mon,  1 Apr 2024 16:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989987;
	bh=8bPielUPj091FCau8e63UmZh/qWE0FXC+4JoN0WwcB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJ2sr+E8yQ4CAKCPfoeGU8zC2jYV6aqagDUcjc6pC9wGZeW6ueIL6bbkIeL99mUdV
	 0usA/ac0kG8GTTSiU3oO6PBRAzwqdoFQNcDsQ7Ap8PP0UdULOQQsmo41TPcT2ZIi9h
	 DND/m2IdWaAzLCvOUGXpI4ouPOqCKVe+BdBOhnLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Pittman <jpittman@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/396] dm snapshot: fix lockup in dm_exception_table_exit
Date: Mon,  1 Apr 2024 17:43:53 +0200
Message-ID: <20240401152553.426683007@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



