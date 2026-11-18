Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042596;
	b=d4Xbjrb8Irb626Y0WNH0bSDQwM4U09VMmcOqptSq3BYG2POjzdNxpcmYGayViN1jhpuI
	 vTzRIFEkv+izphmL0tHK7bLECJETIExLP4KqdF8h9bqiRJ6QqYHW+WOtSO0YoaErudJmr
	 Z8y+USMeeD7Iq+wD9vbT5VgCPLAdb6NQDLU/qPob0BxTTa9ZvPq6C4Em2pA0DXxS6qiTH
	 LrJyEZnlGmeq62SOQIPgL5pT5PT2b2mcsFMlbB8A3MaUIs+9dxTiz+aqti8ZY+LZmKhMH
	 /Wnu9d7e1fNLa7qaZw5KH3qFKvY3joouG39un/LQsbffAjpTKPwwXoNJvDHPEc9CeRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cAfV+zATYHFAqA6A/70kUT4mf/J8r6J3WfnQ5e5mhS8=;
	b=VerCPffAgQFOK9NlwoaIcdnhg0gw6lJaRJv3Ag+vxOafInXew9DDTj/Il6q+bXon17go
	 CCruQX4qGoK795QBMt92EEhGJx3WlWf0Ct0kaHhi15SI/IQDzsMg3Moumb1lHwm8xqrdG
	 CwmwzIrHeBppYl+wl2IoDa5XHnCn0dQJlRfblAxowpSib7uW6C38jFVZxgSe4/TAYOCHQ
	 /wVQAwX6QGJZ0SxrI/7ipZ2lEk+Oo9Md4eQUA3D6UtwBUplXlQ5QyQAwWkYRM0Xu9WQMn
	 s+b/Eyg3dfdFYpyPP/l1nhcQHVGHELoklKLjN4n35BXQn8c/aaKIaL3LP2PfL+mLS5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWgavzRq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6CB606A320;
	Wed, 18 Nov 2026 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWgavzRq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8F61F000C4;
	Wed, 18 Nov 2026 22:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042596;
	bh=cAfV+zATYHFAqA6A/70kUT4mf/J8r6J3WfnQ5e5mhS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWgavzRq0AChC0mV7hOzq+QbnkSuaWehRvfXy230/Fqb8UcY3uagFmO7ytbhmXugQ
	 4LPaDofuELpVL51YFXeqJxCI7jn+FXileYBbSU92EIEnrYlQqguWCyIV51DdsqJrdn
	 8UEnMCxxBMvKRkW6vKZiAASqkLXuKp94TCTPNjbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3227/3318] blk-cgroup: dont free a blkg with its punt work queued
Date: Wed, 18 Nov 2026 16:04:09 +0100
Message-ID: <20261118150456.525902807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4def096314cf29fb6940b74c087a0b923185580e ]

blkg_async_bio_workfn() relies on the bios on the list pinning the blkg.
But blkcg_punt_bio_submit() can call queue_work() after a running
instance already took and completed the bio, and queue_work() succeeds
on an empty list for the same reason. Nothing holds the blkg then, and
free_work shares its memory with async_bio_work on top of that.

Hold a reference across blkcg_punt_bio_submit(), give the two works
memory of their own, and cancel async_bio_work in blkg_free_workfn().

Fixes: d3f77dfdc718 ("blkcg: implement REQ_CGROUP_PUNT")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-20-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 13 ++++++++++++-
 block/blk-cgroup.h |  6 ++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c8183e384e894..98f2b3b968a3d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -124,6 +124,11 @@ static void blkg_free_workfn(struct work_struct *work)
 	struct request_queue *q = blkg->q;
 	int i;
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	/* It may have been queued for bios which an earlier run has taken */
+	cancel_work_sync(&blkg->async_bio_work);
+#endif
+
 	/*
 	 * pd_free_fn() can also be called from blkcg_deactivate_policy(),
 	 * in order to make sure pd_free_fn() is called in order, the deletion
@@ -218,7 +223,7 @@ static void blkg_async_bio_workfn(struct work_struct *work)
 	struct blk_plug plug;
 	bool need_plug = false;
 
-	/* as long as there are pending bios, @blkg can't go away */
+	/* blkg_free_workfn() waits for us */
 	spin_lock(&blkg->async_bio_lock);
 	bio_list_merge(&bios, &blkg->async_bios);
 	bio_list_init(&blkg->async_bios);
@@ -246,10 +251,16 @@ void blkcg_punt_bio_submit(struct bio *bio)
 	struct blkcg_gq *blkg = bio->bi_blkg;
 
 	if (blkg->parent) {
+		/*
+		 * Once it is on the list, a run which is under way can submit
+		 * @bio, and its reference goes when it completes.
+		 */
+		blkg_get(blkg);
 		spin_lock(&blkg->async_bio_lock);
 		bio_list_add(&blkg->async_bios, bio);
 		spin_unlock(&blkg->async_bio_lock);
 		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
+		blkg_put(blkg);
 	} else {
 		/* never bounce for the root cgroup */
 		submit_bio(bio);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 59ea7cc24f358..642e129efc492 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -75,11 +75,9 @@ struct blkcg_gq {
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	spinlock_t			async_bio_lock;
 	struct bio_list			async_bios;
+	struct work_struct		async_bio_work;
 #endif
-	union {
-		struct work_struct	async_bio_work;
-		struct work_struct	free_work;
-	};
+	struct work_struct		free_work;
 
 	atomic_t			use_delay;
 	atomic64_t			delay_nsec;
-- 
2.53.0



