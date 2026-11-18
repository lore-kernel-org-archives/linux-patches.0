Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022118;
	b=KJLqbP8Clvze4GcLJLDd6Qgx+2S/uowr2ZhRZ8jHVL8mTU1hDFcPdMACxHaT/+NewuMv
	 FGX1zZuXy6KIlPkDOQ0HW51+zbqD6P4Xh31UOv9Hc1pVFU791H5ijmL5/63aLU94PRx7H
	 lcnYjXxxb589nqyswST9TBVpHSMuJWMFXs9ur/xxZ7mxq2fx2IsXTfJLtNQgYDfaXerOX
	 S66rpfayxoUUixGlsiovyKT3K23QjyfBslF0tJYlDqMPH53lN9PhwnkbaQLd9hSIBpEeH
	 OTJU7gQBnWak29yzTmtLtwxVihyAHwWrjW3WFakTUO7zR0t4oEpc3sTx/ehl29bOmoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GzrxFjbNJEToPLB081+/iMZ5pQ+zUqYzAMgxmE5eaw8=;
	b=cZdgA37quQ7TBH42YQ9l9TmoyAqUd/lP9vVIYTB+baF7b1u0P6FW37ChlbGrNb8VWypB
	 iQl75Ruc2eYZzpjxfCG83NQCK5CBm0EiynlIL8np5bavRmUU9MhOgasXOP7SY2CdmLgGi
	 EQyrqj/QjdwSfyBsWT4DrXcrO8MCpxi7i1La/4IiHAG0R/nIOBl9OTc+ajhdANebT9i0c
	 uYf16ZNz9GmRB/6a44vVFuh434DWFv42frUuTEN7G1QRTMEB1Id1Spu8U4ZD6NsN30nf4
	 9smF+l1K1oHXv/25beMbX5jAJYOotTRG0G5GGfMJNJH0YbJYi01I6jOnYvEZaSCVtFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oK/JxwbV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3418D606A32C;
	Wed, 18 Nov 2026 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oK/JxwbV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE6D1F000C5;
	Wed, 18 Nov 2026 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022117;
	bh=GzrxFjbNJEToPLB081+/iMZ5pQ+zUqYzAMgxmE5eaw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oK/JxwbV7KbFLO83YRzs9IxDIg3IzKBK9cL82wBGVwA7CghTQ5+i1PIl6CECRq90N
	 DA+fwFRXwy4ftmjeYvMPVGcyEtuO/lzAaqwAihPlzjA8zHnpf5khblf4hILPAnAABV
	 YnYMX157SLLxiIZUhfGhyFdM+rL6fdOCgLuAeabE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2549/2651] blk-cgroup: dont free a blkg with its punt work queued
Date: Wed, 18 Nov 2026 16:03:09 +0100
Message-ID: <20261118150416.277174883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1404e89147829..c0a36f6d4e146 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -121,6 +121,11 @@ static void blkg_free_workfn(struct work_struct *work)
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
 	bio_list_merge_init(&bios, &blkg->async_bios);
 	spin_unlock(&blkg->async_bio_lock);
@@ -245,10 +250,16 @@ void blkcg_punt_bio_submit(struct bio *bio)
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
index e67c698391294..1fd60cb4157c8 100644
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



