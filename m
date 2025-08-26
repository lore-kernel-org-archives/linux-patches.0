Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987DF2248A5;
	Tue, 26 Aug 2025 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207267; cv=none; b=D/JHARyktAZlFdwmJ/rcO6kl2LJWzXQ883a36KzV2YQLuQ9k6AcDkL2xjQdFw9301g3PNAnaC4IsBIr0YKh9ZAx0cZYsmgeO/dIRaVNtXwi3gR3AjfM4qhg1hErQ0Kze6aALVLrcSutBxuIwF1RYPlxJrLvW5gDg9ldEKhR8Hm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207267; c=relaxed/simple;
	bh=HAiFi9GGHPiwnV3mLk+/MRMcjzVAa3VzxKQGG5wKkYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bw6RNgjzbjJiBrLc24JRKNuKSwueR678hMy4R0tA/z5Tc7JgfndNv7QyDCI/bwfRm1VXRpFYTg6kzQ1gab5ESw0g0ZTIln+Fh6yThpZvoeQG9k96lV6xWbleESRJwCA6qZJ7NmDUEUqZENKMu4ThcUN8rf1ZJRRN4nofJtOLvig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZQO0H50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZQO0H50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAFBC4CEF1;
	Tue, 26 Aug 2025 11:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207267;
	bh=HAiFi9GGHPiwnV3mLk+/MRMcjzVAa3VzxKQGG5wKkYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZQO0H50IazBI8Cjyyf+b3j8KFtkajL6JC1uDcSY4LO2DvSevQNVe0aARFDthKcP1
	 3Vv4vXqiCO+0mmHR+aLkCCMUrTVnW8yWLkuU5AbAMN2o1BsUbD+gh17zOX5udSWzWJ
	 dljrZPap1ECiRTfYQQd334UwEv6m6/8gJ8hxcApg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.16 084/457] wifi: ath11k: fix dest ring-buffer corruption
Date: Tue, 26 Aug 2025 13:06:08 +0200
Message-ID: <20250826110939.455788541@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 8c1ba5091fa9a2d1478da63173b16a701bdf86bb upstream.

Add the missing memory barrier to make sure that destination ring
descriptors are read after the head pointers to avoid using stale data
on weakly ordered architectures like aarch64.

The barrier is added to the ath11k_hal_srng_access_begin() helper for
symmetry with follow-on fixes for source ring buffer corruption which
will add barriers to ath11k_hal_srng_access_end().

Tested-on: WCN6855 hw2.1 WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org	# 5.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250604143457.26032-2-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/ce.c    |    3 ---
 drivers/net/wireless/ath/ath11k/dp_rx.c |    3 ---
 drivers/net/wireless/ath/ath11k/hal.c   |   12 +++++++++++-
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -393,9 +393,6 @@ static int ath11k_ce_completed_recv_next
 		goto err;
 	}
 
-	/* Make sure descriptor is read after the head pointer. */
-	dma_rmb();
-
 	*nbytes = ath11k_hal_ce_dst_status_get_length(desc);
 
 	*skb = pipe->dest_ring->skb[sw_index];
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2650,9 +2650,6 @@ int ath11k_dp_process_rx(struct ath11k_b
 try_again:
 	ath11k_hal_srng_access_begin(ab, srng);
 
-	/* Make sure descriptor is read after the head pointer. */
-	dma_rmb();
-
 	while (likely(desc =
 	      (struct hal_reo_dest_ring *)ath11k_hal_srng_dst_get_next_entry(ab,
 									     srng))) {
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -823,13 +823,23 @@ u32 *ath11k_hal_srng_src_peek(struct ath
 
 void ath11k_hal_srng_access_begin(struct ath11k_base *ab, struct hal_srng *srng)
 {
+	u32 hp;
+
 	lockdep_assert_held(&srng->lock);
 
 	if (srng->ring_dir == HAL_SRNG_DIR_SRC) {
 		srng->u.src_ring.cached_tp =
 			*(volatile u32 *)srng->u.src_ring.tp_addr;
 	} else {
-		srng->u.dst_ring.cached_hp = READ_ONCE(*srng->u.dst_ring.hp_addr);
+		hp = READ_ONCE(*srng->u.dst_ring.hp_addr);
+
+		if (hp != srng->u.dst_ring.cached_hp) {
+			srng->u.dst_ring.cached_hp = hp;
+			/* Make sure descriptor is read after the head
+			 * pointer.
+			 */
+			dma_rmb();
+		}
 
 		/* Try to prefetch the next descriptor in the ring */
 		if (srng->flags & HAL_SRNG_FLAGS_CACHED)


