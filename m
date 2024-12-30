Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD2A156678;
	Mon, 30 Dec 2024 15:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574236; cv=none; b=d1XJXc+hpneD6FZ8lQTDSmbwO5G6lCqsY8YfYfRN98sFAuZLMutP4Pt1K+IaVo9D115PKiPjIL7o57Om7QZ41HfyFiZ062nJfipaApM4HxA+V4sYI003VVgCFiTWSYKd2fTbl5+KuyIzG6vpxcJloKjw3VtLrGBOXRZURTDp4gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574236; c=relaxed/simple;
	bh=fxOwYAu1P4oziF0EZfttf2FA5Soqd4O+TMyEthBemo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZKBbuL7Nf/mnHUsdmVroqooofhkFB1UNZ094nbcrKzdrOMt2fJXBppC1V+b8JXjh1qPrM2oy8Xu1fRBijruG9rcovXc0740A5hkTo8bNF9Y/RcE+0xL7tRJUJ5d3Jyj6HdJKsqD9VJrBDFsCJFJmG/wDgAJpu0VfSlQsdumSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZ3s3f99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZ3s3f99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B94C4CED2;
	Mon, 30 Dec 2024 15:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574236;
	bh=fxOwYAu1P4oziF0EZfttf2FA5Soqd4O+TMyEthBemo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ3s3f99ZjZPI0KKonHVdCrKTqroVMK0Kp/MKac180/TT7zIodIfQUUSpwjMTMlun
	 j8lueAd2D8AdujRp5vbqoWsROFL+nrAEvK//qCn2KaXFp0gwozOsGFBYO9NSGNOIx7
	 qSr/WHNAScxXuQFa7X31oEp02IuQSUiaPBIdJfUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Peter Newman <peternewman@google.com>,
	Babu Moger <babu.moger@amd.com>,
	Luck Tony <tony.luck@intel.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/114] blk-mq: register cpuhp callback after hctx is added to xarray table
Date: Mon, 30 Dec 2024 16:43:13 +0100
Message-ID: <20241230154221.020631255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 4bf485a7db5d82ddd0f3ad2b299893199090375e ]

We need to retrieve 'hctx' from xarray table in the cpuhp callback, so the
callback should be registered after this 'hctx' is added to xarray table.

Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Peter Newman <peternewman@google.com>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Luck Tony <tony.luck@intel.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20241206111611.978870-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d5995021815d..4e76651e786d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3903,16 +3903,11 @@ static int blk_mq_init_hctx(struct request_queue *q,
 {
 	hctx->queue_num = hctx_idx;
 
-	if (!(hctx->flags & BLK_MQ_F_STACKING))
-		cpuhp_state_add_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
-				&hctx->cpuhp_online);
-	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
-
 	hctx->tags = set->tags[hctx_idx];
 
 	if (set->ops->init_hctx &&
 	    set->ops->init_hctx(hctx, set->driver_data, hctx_idx))
-		goto unregister_cpu_notifier;
+		goto fail;
 
 	if (blk_mq_init_request(set, hctx->fq->flush_rq, hctx_idx,
 				hctx->numa_node))
@@ -3921,6 +3916,11 @@ static int blk_mq_init_hctx(struct request_queue *q,
 	if (xa_insert(&q->hctx_table, hctx_idx, hctx, GFP_KERNEL))
 		goto exit_flush_rq;
 
+	if (!(hctx->flags & BLK_MQ_F_STACKING))
+		cpuhp_state_add_instance_nocalls(CPUHP_AP_BLK_MQ_ONLINE,
+				&hctx->cpuhp_online);
+	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
+
 	return 0;
 
  exit_flush_rq:
@@ -3929,8 +3929,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
  exit_hctx:
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
- unregister_cpu_notifier:
-	blk_mq_remove_cpuhp(hctx);
+ fail:
 	return -1;
 }
 
-- 
2.39.5



