Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033088;
	b=wm+p082bKJRQ+lU+AfyMvBs2/VqNFyNXsv2iaMuFNJZRpyY+y5Imf2PljsH077KochZz
	 vhkFMlOfaaoHDKhm3Svq6kg/l5++BOPfMf5VZQDx/Uy6SCxj0DmvTPVWC6eVbR5H+djMm
	 jHnQYqcwZZsizSfOpqDNyud5T3Kk2e9A8chfQv+P66CSHWeFcfR+GWpNMrqO0Lh6Zxcze
	 GLri2EFghfD1pY92rTcaeKmoCzzHZHpJ+DbeSiT1bnIpSUVO5fy32YLrq396UKbOacZqh
	 uCOMx6atcGffLG6vn5zj0SHG3kRIgpAnkh4YAO6U7BoPkuUdB8c3B2IMxEiHGJrzvzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z+kKH+agG1GeL18QpnCtinRdO+ZvuxJPQah0FTZn8Pk=;
	b=Fodnb2VXw2lv0nSa7JuwmPuXNkrBuuyE5Ts5vq9aYrBv+ZFKc0p7x3BdLDgtG9tqZhe2
	 EUIpX82LWb+w56m6Bdg+M77LQrpFuNzK2MiJJJgINAfTLO3ZV3G2NSbLyQPEIb9T9mZz2
	 nV6VENAC+CpeAd3QIAhhR3WIVOBubMVbuQpZhnfixyNnEAwotgIBQ6Ca5NwTmiTGLHZ2D
	 04JUgMoVyo0+32tTBWAxxbgnqFr/iDmLAgY2Ma8hmCKWbLGykVtVtrdA5P2g0czzU/Qap
	 4Sk38zT5QK+k6+riqBLAZJsYz5zT0zBc3672gSC+tpY6agE+2kYxRGOx7m62uoZndrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSaIM5Tz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06F4606A31C;
	Wed, 18 Nov 2026 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSaIM5Tz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052C81F000C4;
	Wed, 18 Nov 2026 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033088;
	bh=z+kKH+agG1GeL18QpnCtinRdO+ZvuxJPQah0FTZn8Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSaIM5TzKllc4rOxwmv04ct6gTJkywSRfr6es97siTjgLuFS8SgD/2DQowKK1pj3h
	 JCR/EkXV4yH8s0fHg1g6Yr/dGSoVRW+wtE5+BSbMx1I4joAdQCkVkZeH8rEEHbFlFj
	 aYbQlOfCIxDncnQvr9pTploKdyxG5OCIF9S+FgjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1641/1756] blk-cgroup: dont free a blkg with its punt work queued
Date: Wed, 18 Nov 2026 16:02:48 +0100
Message-ID: <20261118150115.091987360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 18b52ece07e82..d1f3d3491bd36 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -118,6 +118,11 @@ static void blkg_free_workfn(struct work_struct *work)
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
@@ -212,7 +217,7 @@ static void blkg_async_bio_workfn(struct work_struct *work)
 	struct blk_plug plug;
 	bool need_plug = false;
 
-	/* as long as there are pending bios, @blkg can't go away */
+	/* blkg_free_workfn() waits for us */
 	spin_lock(&blkg->async_bio_lock);
 	bio_list_merge_init(&bios, &blkg->async_bios);
 	spin_unlock(&blkg->async_bio_lock);
@@ -239,10 +244,16 @@ void blkcg_punt_bio_submit(struct bio *bio)
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
index 270e58e5f38af..8189b275496fc 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -76,11 +76,9 @@ struct blkcg_gq {
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



