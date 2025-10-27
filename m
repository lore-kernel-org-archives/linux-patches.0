Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B56F2BD033;
	Mon, 27 Oct 2025 19:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592132; cv=none; b=Xhal322l79g2d/sZXdiWt7OO+1XMKEbCGbJMj4Je41S6bPt2JTOVGqn/C337h/kNMwGx49rwgjqU30zPposdS4sMMHSVnZm0Amm2gm5AKPQX+Nl/RBJYMAQzzOU5MTJFKeleSup6LrNJZibNkVSpyIlFVldV4fYAcUdk50nBBEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592132; c=relaxed/simple;
	bh=DFUDXIr4HokyZMICOVHr3/6BuB+VN5eMagMBRc4GGM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKALtJ8tSP+OcWcFi+KDIKvcv7XzNp9lsUv6bt5FoXmnsjM4giBNxiqeQW0zFvt9vhjrzpLGkpbOQmq17qCdbWbE4SWD1YcfCPy/QraTyNydXYrfQ/shmuyEe1MUHX1oe1Bp07Qw8DSr36n08Wmr9Gs0nGaSfxA4ZjZIC5lrGGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3deaqUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3deaqUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9322C4CEF1;
	Mon, 27 Oct 2025 19:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592132;
	bh=DFUDXIr4HokyZMICOVHr3/6BuB+VN5eMagMBRc4GGM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3deaqUxf6Rl0SdSWVfrcua5lbBmeoTbm4aYt10VmTyBxiojMtJka+326iMRdnZeI
	 JCHOQuGLNMB5d28qHnuR2njUocTX3VPVE10ZWax7PwUjpa5DDh22Rt41z/igLxP6Bm
	 X70ZpYQVxYjXtRVaXb4aTuguLPm4o9p0zdVrryoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/123] wifi: ath11k: HAL SRNG: dont deinitialize and re-initialize again
Date: Mon, 27 Oct 2025 19:36:24 +0100
Message-ID: <20251027183449.173691506@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 32be3ca4cf78b309dfe7ba52fe2d7cc3c23c5634 ]

Don't deinitialize and reinitialize the HAL helpers. The dma memory is
deallocated and there is high possibility that we'll not be able to get
the same memory allocated from dma when there is high memory pressure.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03926.13-QCAHSPSWPL_V2_SILICONZ_CE-2.52297.6

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://patch.msgid.link/20250722053121.1145001-1-usama.anjum@collabora.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/core.c |    6 +-----
 drivers/net/wireless/ath/ath11k/hal.c  |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath11k/hal.h  |    1 +
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -942,14 +942,10 @@ static int ath11k_core_reconfigure_on_cr
 	mutex_unlock(&ab->core_lock);
 
 	ath11k_dp_free(ab);
-	ath11k_hal_srng_deinit(ab);
+	ath11k_hal_srng_clear(ab);
 
 	ab->free_vdev_map = (1LL << (ab->num_radios * TARGET_NUM_VDEVS)) - 1;
 
-	ret = ath11k_hal_srng_init(ab);
-	if (ret)
-		return ret;
-
 	clear_bit(ATH11K_FLAG_CRASH_FLUSH, &ab->dev_flags);
 
 	ret = ath11k_core_qmi_firmware_ready(ab);
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1313,6 +1313,22 @@ void ath11k_hal_srng_deinit(struct ath11
 }
 EXPORT_SYMBOL(ath11k_hal_srng_deinit);
 
+void ath11k_hal_srng_clear(struct ath11k_base *ab)
+{
+	/* No need to memset rdp and wrp memory since each individual
+	 * segment would get cleared in ath11k_hal_srng_src_hw_init()
+	 * and ath11k_hal_srng_dst_hw_init().
+	 */
+	memset(ab->hal.srng_list, 0,
+	       sizeof(ab->hal.srng_list));
+	memset(ab->hal.shadow_reg_addr, 0,
+	       sizeof(ab->hal.shadow_reg_addr));
+	ab->hal.avail_blk_resource = 0;
+	ab->hal.current_blk_index = 0;
+	ab->hal.num_shadow_reg_configured = 0;
+}
+EXPORT_SYMBOL(ath11k_hal_srng_clear);
+
 void ath11k_hal_dump_srng_stats(struct ath11k_base *ab)
 {
 	struct hal_srng *srng;
--- a/drivers/net/wireless/ath/ath11k/hal.h
+++ b/drivers/net/wireless/ath/ath11k/hal.h
@@ -952,6 +952,7 @@ int ath11k_hal_srng_setup(struct ath11k_
 			  struct hal_srng_params *params);
 int ath11k_hal_srng_init(struct ath11k_base *ath11k);
 void ath11k_hal_srng_deinit(struct ath11k_base *ath11k);
+void ath11k_hal_srng_clear(struct ath11k_base *ab);
 void ath11k_hal_dump_srng_stats(struct ath11k_base *ab);
 void ath11k_hal_srng_get_shadow_config(struct ath11k_base *ab,
 				       u32 **cfg, u32 *len);


