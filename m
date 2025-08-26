Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C61FECAB;
	Tue, 26 Aug 2025 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208115; cv=none; b=Sym9/icYiBOvFs4/MKoVFrEN4/qHQKvO6oY4fqqWVtewu6RGmbRXZmQTKGcjb2C69XuM19RjLua0yly/KIcsafSfxsNPqagPjIHEt+MCTfii4nhXsHrSH2kA/iHF3l9FYR0uS2lJM+xZoGvQ24B6Iwa6nbhV2NmLYLxoBEfnoGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208115; c=relaxed/simple;
	bh=OReVZQPQ1+xgQUT/zxW7XMYnU0cdrkndbOTJWUwNh4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjbc74gk/pqjT4sw5lLnr0uOgpoIUqe6FdOA0sSjGYUwhkzI5cuB7QHcUHx2VDvO0Ck82G7QvKG8zd8OYPAnJxUyoBniDXsRIFwwt8546/Fl1X6fS5aF5EsiCuVzBhiDMDtgDjLLyUq5iyz4TF0lnJOmGaFWHmAnaM6vCOc9UC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiPpKKUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiPpKKUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BBEC4CEF1;
	Tue, 26 Aug 2025 11:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208115;
	bh=OReVZQPQ1+xgQUT/zxW7XMYnU0cdrkndbOTJWUwNh4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiPpKKUj2J80+8KOuPoZowMLltJ1Q+Eq3WPMRuIDapIMTfBd0rr5DzQ/rHFrUT7W2
	 YHigOW8vi1m0NVdd6JyPxwyWivb5fR98mKkybGO7aax3u4LbOz3MdQpp2odKRNVHah
	 dgt50d2bH09AS1V1qGsxneZcb+4k+drXUZZvzcT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 443/457] blk-mq: fix lockdep warning in __blk_mq_update_nr_hw_queues
Date: Tue, 26 Aug 2025 13:12:07 +0200
Message-ID: <20250826110948.233001612@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 2d82f3bd8910eb65e30bb2a3c9b945bfb3b6d661 ]

Commit 5989bfe6ac6b ("block: restore two stage elevator switch while
running nr_hw_queue update") reintroduced a lockdep warning by calling
blk_mq_freeze_queue_nomemsave() before switching the I/O scheduler.

The function blk_mq_elv_switch_none() calls elevator_change_done().
Running this while the queue is frozen causes a lockdep warning.

Fix this by reordering the operations: first, switch the I/O scheduler
to 'none', and then freeze the queue. This ensures that elevator_change_done()
is not called on an already frozen queue. And this way is safe because
elevator_set_none() does freeze queue before switching to none.

Also we still have to rely on blk_mq_elv_switch_back() for switching
back, and it has to cover unfrozen queue case.

Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Fixes: 5989bfe6ac6b ("block: restore two stage elevator switch while running nr_hw_queue update")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://lore.kernel.org/r/20250815131737.331692-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4cb2f5ca8656..355db0abe44b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5031,6 +5031,7 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 	unsigned int memflags;
 	int i;
 	struct xarray elv_tbl, et_tbl;
+	bool queues_frozen = false;
 
 	lockdep_assert_held(&set->tag_list_lock);
 
@@ -5054,9 +5055,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		blk_mq_sysfs_unregister_hctxs(q);
 	}
 
-	list_for_each_entry(q, &set->tag_list, tag_set_list)
-		blk_mq_freeze_queue_nomemsave(q);
-
 	/*
 	 * Switch IO scheduler to 'none', cleaning up the data associated
 	 * with the previous scheduler. We will switch back once we are done
@@ -5066,6 +5064,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 		if (blk_mq_elv_switch_none(q, &elv_tbl))
 			goto switch_back;
 
+	list_for_each_entry(q, &set->tag_list, tag_set_list)
+		blk_mq_freeze_queue_nomemsave(q);
+	queues_frozen = true;
 	if (blk_mq_realloc_tag_set_tags(set, nr_hw_queues) < 0)
 		goto switch_back;
 
@@ -5089,8 +5090,12 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 	}
 switch_back:
 	/* The blk_mq_elv_switch_back unfreezes queue for us. */
-	list_for_each_entry(q, &set->tag_list, tag_set_list)
+	list_for_each_entry(q, &set->tag_list, tag_set_list) {
+		/* switch_back expects queue to be frozen */
+		if (!queues_frozen)
+			blk_mq_freeze_queue_nomemsave(q);
 		blk_mq_elv_switch_back(q, &elv_tbl, &et_tbl);
+	}
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
 		blk_mq_sysfs_register_hctxs(q);
-- 
2.50.1



