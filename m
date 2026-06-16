Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7DE46AF20;
	Tue, 16 Jun 2026 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626593; cv=none; b=i++J7WDWu8y8FyokSbuMxV479bVngdqpN2iPGFseaUE/dFZGBSmjACjBs0UNit6COBok6hOLQzpM2pDFaotQnbYE2oHCY2qDdlFYpB5B6JhXuoCq8YaPCufCV8zjS4GkTJrYQEyYGocE2Qpyc7hD8N0soibLReOVEiFrJldM3a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626593; c=relaxed/simple;
	bh=0UE4D1omt/vvkZDzbjgCzfLNPVaLGpnqtdjTQSvw1F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KY9lRr+ENCfl77XPOB4LnO3BX5+iWl7k/YwjXi90taYjNGMGpZSHOlAxYB+0LOSVoaFkbBGSRF08aPCrYt/NbuRS6iNpK5GFyuK0j/o81m1sx6kmy6oBX1SknID82xi3TXcIVw8tfs2aIHj7r3Sjh5bfcKpH4dW8pe7/R/B985I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujBTEHl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujBTEHl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B151F000E9;
	Tue, 16 Jun 2026 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626592;
	bh=xehfJSBFPMZsFLhzUvbePGOZDrpnOh+To2ODgIfdcb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujBTEHl7+5IN1+AdeZVe4w7ZAznS7LeUHlgqpuzHIk5RywTyI1LzDfTqIPdx65iL7
	 g8meU6dsBWvTUlpZnGuPjWZgpzlG/zeZggyTWU72VJBegoWdfKnQNwkcUg1JRHJja8
	 pjM03PUNojruwr2tYryaDG1VwA9hx34QRJh+Wy2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/261] dm cache policy smq: check allocation under invalidate lock
Date: Tue, 16 Jun 2026 20:27:42 +0530
Message-ID: <20260616145046.106543209@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit d3f0a606b9f278ece8a0df626ded9c4044071235 ]

commit 2d1f7b65f5de ("dm cache policy smq: fix missing locks in
invalidating cache blocks") added mq->lock around the destructive part of
smq_invalidate_mapping(), but left the e->allocated check outside the
critical section.

That leaves a check-then-act race. Two concurrent invalidators can both
observe e->allocated as true before either of them takes mq->lock. The
first invalidator that acquires the lock removes the entry from the
queues and hash table and then calls free_entry(), which clears
e->allocated and puts the entry back on the free list. The second
invalidator can then acquire mq->lock and continue with the stale result
of the unlocked check.

This can corrupt the SMQ queues or hash table by deleting an entry that
is no longer on those structures. It can also hit the allocation check in
free_entry() when the same entry is freed again.

Move the allocation check under mq->lock so the predicate and the
destructive operations are serialized by the same lock.

Fixes: 2d1f7b65f5de ("dm cache policy smq: fix missing locks in invalidating cache blocks")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-policy-smq.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index d81a87142cacfa..5f48bcbdaf4351 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1590,18 +1590,22 @@ static int smq_invalidate_mapping(struct dm_cache_policy *p, dm_cblock_t cblock)
 	struct smq_policy *mq = to_smq_policy(p);
 	struct entry *e = get_entry(&mq->cache_alloc, from_cblock(cblock));
 	unsigned long flags;
-
-	if (!e->allocated)
-		return -ENODATA;
+	int r = 0;
 
 	spin_lock_irqsave(&mq->lock, flags);
+	if (!e->allocated) {
+		r = -ENODATA;
+		goto out;
+	}
 	// FIXME: what if this block has pending background work?
 	del_queue(mq, e);
 	h_remove(&mq->table, e);
 	free_entry(&mq->cache_alloc, e);
+
+out:
 	spin_unlock_irqrestore(&mq->lock, flags);
 
-	return 0;
+	return r;
 }
 
 static uint32_t smq_get_hint(struct dm_cache_policy *p, dm_cblock_t cblock)
-- 
2.53.0



