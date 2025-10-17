Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7828032C92B;
	Fri, 17 Oct 2025 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715806; cv=none; b=bEi7AxMB/TYHdGn16nPLnFFdhkzQyOjJE0c84LFcKtjVhc617N7ZeSMlI1C5ggqKd+dRyITs+JIm1J6curzPHjFMeWW95kra32ohD43OWWPcDL/k4vuahKUkytDZcwfGXtRXabyz2XaAPDfSTso8bdLjvlsjeYNT1nSfupQVLrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715806; c=relaxed/simple;
	bh=mEkHf2V/ncKdm0G3SzWTg07tePbaBA4LSr4AkW+dFvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJzvGSL4b8rFQ5SlNiJo+s4lZ/5dPRttwPbFmrIr4NMU3JOgDdMmH7rlr359Ct66dosWyxGuLFLQPFZYjt1xK7W2ZnhyrHG0j6/hJXmXhhenQG1+E13N+OOC3J1MmBkos0/+cUqYYMGyZZnYd6Dt+ll3hp1P9qxbUbkB3nEc+Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQEMkLO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQEMkLO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE72C4CEE7;
	Fri, 17 Oct 2025 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715806;
	bh=mEkHf2V/ncKdm0G3SzWTg07tePbaBA4LSr4AkW+dFvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQEMkLO7bpO1YXg3ze/IASoFnpYepqie1rTK/lujwM8a3TEmiJQ7D8cLzt3FN7df0
	 q5dRq0QsnHizKn4L9+r+WzACkfv9Nic54fbNdDMCIyE3g2jsHtSmpIKTpffbkQdfI8
	 JR51NK0zEMdvmaKExrW3SZOB3equrqtqR42zoPzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.17 310/371] wifi: ath11k: HAL SRNG: dont deinitialize and re-initialize again
Date: Fri, 17 Oct 2025 16:54:45 +0200
Message-ID: <20251017145213.293797142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 32be3ca4cf78b309dfe7ba52fe2d7cc3c23c5634 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/core.c |    6 +-----
 drivers/net/wireless/ath/ath11k/hal.c  |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath11k/hal.h  |    1 +
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2215,14 +2215,10 @@ static int ath11k_core_reconfigure_on_cr
 	mutex_unlock(&ab->core_lock);
 
 	ath11k_dp_free(ab);
-	ath11k_hal_srng_deinit(ab);
+	ath11k_hal_srng_clear(ab);
 
 	ab->free_vdev_map = (1LL << (ab->num_radios * TARGET_NUM_VDEVS(ab))) - 1;
 
-	ret = ath11k_hal_srng_init(ab);
-	if (ret)
-		return ret;
-
 	clear_bit(ATH11K_FLAG_CRASH_FLUSH, &ab->dev_flags);
 
 	ret = ath11k_core_qmi_firmware_ready(ab);
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1386,6 +1386,22 @@ void ath11k_hal_srng_deinit(struct ath11
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
@@ -965,6 +965,7 @@ int ath11k_hal_srng_setup(struct ath11k_
 			  struct hal_srng_params *params);
 int ath11k_hal_srng_init(struct ath11k_base *ath11k);
 void ath11k_hal_srng_deinit(struct ath11k_base *ath11k);
+void ath11k_hal_srng_clear(struct ath11k_base *ab);
 void ath11k_hal_dump_srng_stats(struct ath11k_base *ab);
 void ath11k_hal_srng_get_shadow_config(struct ath11k_base *ab,
 				       u32 **cfg, u32 *len);


