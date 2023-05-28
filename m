Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E9B611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5F6C433D2;
	Sun, 28 May 2023 19:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302784;
	bh=V3QgCQRFaZUZCgWhOEnasoZlTbLKFH2JR8tf9wMfth8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhPd5cbt6M4T7MFRRYRytXTpwuk6ekYGLv0Rnuv/P2A8yAyafcZxi0nN/+zVeeHFR
	 LtVVkNruD5OfykQPuE3BxEcxrf2UbPVcaOQlz+5qSmxinGXYTxMERKpvJScmjWibDw
	 nhTKhe7Mcj6tdPjY77HBc2pEzLyx8IG7L5/pN8NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Novich <royno@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/211] linux/dim: Do nothing if no time delta between samples
Date: Sun, 28 May 2023 20:08:46 +0100
Message-Id: <20230528190843.651083064@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roy Novich <royno@nvidia.com>

[ Upstream commit 162bd18eb55adf464a0fa2b4144b8d61c75ff7c2 ]

Add return value for dim_calc_stats. This is an indication for the
caller if curr_stats was assigned by the function. Avoid using
curr_stats uninitialized over {rdma/net}_dim, when no time delta between
samples. Coverity reported this potential use of an uninitialized
variable.

Fixes: 4c4dbb4a7363 ("net/mlx5e: Move dynamic interrupt coalescing code to include/linux")
Fixes: cb3c7fd4f839 ("net/mlx5e: Support adaptive RX coalescing")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://lore.kernel.org/r/20230507135743.138993-1-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dim.h | 3 ++-
 lib/dim/dim.c       | 5 +++--
 lib/dim/net_dim.c   | 3 ++-
 lib/dim/rdma_dim.c  | 3 ++-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/dim.h b/include/linux/dim.h
index 6c5733981563e..f343bc9aa2ec9 100644
--- a/include/linux/dim.h
+++ b/include/linux/dim.h
@@ -236,8 +236,9 @@ void dim_park_tired(struct dim *dim);
  *
  * Calculate the delta between two samples (in data rates).
  * Takes into consideration counter wrap-around.
+ * Returned boolean indicates whether curr_stats are reliable.
  */
-void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
+bool dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 		    struct dim_stats *curr_stats);
 
 /**
diff --git a/lib/dim/dim.c b/lib/dim/dim.c
index 38045d6d05381..e89aaf07bde50 100644
--- a/lib/dim/dim.c
+++ b/lib/dim/dim.c
@@ -54,7 +54,7 @@ void dim_park_tired(struct dim *dim)
 }
 EXPORT_SYMBOL(dim_park_tired);
 
-void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
+bool dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 		    struct dim_stats *curr_stats)
 {
 	/* u32 holds up to 71 minutes, should be enough */
@@ -66,7 +66,7 @@ void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 			     start->comp_ctr);
 
 	if (!delta_us)
-		return;
+		return false;
 
 	curr_stats->ppms = DIV_ROUND_UP(npkts * USEC_PER_MSEC, delta_us);
 	curr_stats->bpms = DIV_ROUND_UP(nbytes * USEC_PER_MSEC, delta_us);
@@ -79,5 +79,6 @@ void dim_calc_stats(struct dim_sample *start, struct dim_sample *end,
 	else
 		curr_stats->cpe_ratio = 0;
 
+	return true;
 }
 EXPORT_SYMBOL(dim_calc_stats);
diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
index dae3b51ac3d9b..0e4f3a686f1de 100644
--- a/lib/dim/net_dim.c
+++ b/lib/dim/net_dim.c
@@ -227,7 +227,8 @@ void net_dim(struct dim *dim, struct dim_sample end_sample)
 				  dim->start_sample.event_ctr);
 		if (nevents < DIM_NEVENTS)
 			break;
-		dim_calc_stats(&dim->start_sample, &end_sample, &curr_stats);
+		if (!dim_calc_stats(&dim->start_sample, &end_sample, &curr_stats))
+			break;
 		if (net_dim_decision(&curr_stats, dim)) {
 			dim->state = DIM_APPLY_NEW_PROFILE;
 			schedule_work(&dim->work);
diff --git a/lib/dim/rdma_dim.c b/lib/dim/rdma_dim.c
index f7e26c7b4749f..d32c8b105adc9 100644
--- a/lib/dim/rdma_dim.c
+++ b/lib/dim/rdma_dim.c
@@ -88,7 +88,8 @@ void rdma_dim(struct dim *dim, u64 completions)
 		nevents = curr_sample->event_ctr - dim->start_sample.event_ctr;
 		if (nevents < DIM_NEVENTS)
 			break;
-		dim_calc_stats(&dim->start_sample, curr_sample, &curr_stats);
+		if (!dim_calc_stats(&dim->start_sample, curr_sample, &curr_stats))
+			break;
 		if (rdma_dim_decision(&curr_stats, dim)) {
 			dim->state = DIM_APPLY_NEW_PROFILE;
 			schedule_work(&dim->work);
-- 
2.39.2



