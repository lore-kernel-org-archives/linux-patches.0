Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9249023DE;
	Wed,  7 May 2025 19:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644524; cv=none; b=ZN1HIjjHGXu4yhvDgTaAQv0tWD7u3vvGFfCsTnGtsvnUDglTlKBQviVtA/dJcvTXlW83ugEB3mquJQLOg0R6BAugHbxu4mgYzwa2YYmFsFdq8g4cfw7EDQDxTV3wvIOm/NOMFQ6SQJUJ5EvXRmp4+CGlXsPyLpXB5Wt9wrs0crA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644524; c=relaxed/simple;
	bh=IzojUPivCJTEtsSNDxlTT+g0Dwt7XIG2TaI9/tkgLck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gg3x2w/WMkb/FPOsI2A175QCPQcty8EzR1NVmWLYChRv1YtBnRzHGIo/63YeLv7kZpaowzZJYUnDJZ3p/40DEndqE84Qrw2+bz2b/zaZGokBxXuxZ+1H2GCQTpFSOaFDUM1EeOqsZ5xTM44bVBVbVVZ1G3dmp+e0TamzGBMZL9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiUS0qlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiUS0qlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D932C4CEE2;
	Wed,  7 May 2025 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644524;
	bh=IzojUPivCJTEtsSNDxlTT+g0Dwt7XIG2TaI9/tkgLck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiUS0qlO27TRWMkY7H1bd+v/w8ISjRDT0LnU23F9l1BNqofhpXJDl6/PWYyU4OuOe
	 srgtWLlW5CKF118xo8jMZeyf0gYvqys8psaOmcOn1VloPapxmwqXUv79iUbK3UQm3N
	 5GvYTZCF0uxIp2fV8l/kRq6O0DRa7CqKf3rPch4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/164] accel/ivpu: Correct DCT interrupt handling
Date: Wed,  7 May 2025 20:39:17 +0200
Message-ID: <20250507183823.880577878@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@intel.com>

[ Upstream commit e53e004e346062e15df9511bd4b5a19e34701384 ]

Fix improper use of dct_active_percent field in DCT interrupt handler
causing DCT to never get enabled. Set dct_active_percent internally before
IPC to ensure correct driver value even if IPC fails.
Set default DCT value to 30 accordingly to HW architecture specification.

Fixes: a19bffb10c46 ("accel/ivpu: Implement DCT handling")
Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250416102616.384577-1-maciej.falkowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_hw_btrs.h |  2 +-
 drivers/accel/ivpu/ivpu_pm.c      | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.h b/drivers/accel/ivpu/ivpu_hw_btrs.h
index 71792dab3c210..3855e2df1e0c8 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.h
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.h
@@ -14,7 +14,7 @@
 #define PLL_PROFILING_FREQ_DEFAULT   38400000
 #define PLL_PROFILING_FREQ_HIGH      400000000
 
-#define DCT_DEFAULT_ACTIVE_PERCENT 15u
+#define DCT_DEFAULT_ACTIVE_PERCENT 30u
 #define DCT_PERIOD_US		   35300u
 
 int ivpu_hw_btrs_info_init(struct ivpu_device *vdev);
diff --git a/drivers/accel/ivpu/ivpu_pm.c b/drivers/accel/ivpu/ivpu_pm.c
index fbb61a2c3b19c..d1fbad78f61ba 100644
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -421,16 +421,17 @@ int ivpu_pm_dct_enable(struct ivpu_device *vdev, u8 active_percent)
 	active_us = (DCT_PERIOD_US * active_percent) / 100;
 	inactive_us = DCT_PERIOD_US - active_us;
 
+	vdev->pm->dct_active_percent = active_percent;
+
+	ivpu_dbg(vdev, PM, "DCT requested %u%% (D0: %uus, D0i2: %uus)\n",
+		 active_percent, active_us, inactive_us);
+
 	ret = ivpu_jsm_dct_enable(vdev, active_us, inactive_us);
 	if (ret) {
 		ivpu_err_ratelimited(vdev, "Filed to enable DCT: %d\n", ret);
 		return ret;
 	}
 
-	vdev->pm->dct_active_percent = active_percent;
-
-	ivpu_dbg(vdev, PM, "DCT set to %u%% (D0: %uus, D0i2: %uus)\n",
-		 active_percent, active_us, inactive_us);
 	return 0;
 }
 
@@ -438,15 +439,16 @@ int ivpu_pm_dct_disable(struct ivpu_device *vdev)
 {
 	int ret;
 
+	vdev->pm->dct_active_percent = 0;
+
+	ivpu_dbg(vdev, PM, "DCT requested to be disabled\n");
+
 	ret = ivpu_jsm_dct_disable(vdev);
 	if (ret) {
 		ivpu_err_ratelimited(vdev, "Filed to disable DCT: %d\n", ret);
 		return ret;
 	}
 
-	vdev->pm->dct_active_percent = 0;
-
-	ivpu_dbg(vdev, PM, "DCT disabled\n");
 	return 0;
 }
 
@@ -458,7 +460,7 @@ void ivpu_pm_dct_irq_thread_handler(struct ivpu_device *vdev)
 	if (ivpu_hw_btrs_dct_get_request(vdev, &enable))
 		return;
 
-	if (vdev->pm->dct_active_percent)
+	if (enable)
 		ret = ivpu_pm_dct_enable(vdev, DCT_DEFAULT_ACTIVE_PERCENT);
 	else
 		ret = ivpu_pm_dct_disable(vdev);
-- 
2.39.5



