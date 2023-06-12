Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2363BD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE96C433D2;
	Mon, 12 Jun 2023 10:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566977;
	bh=+kMLXY4lgD2Mv7nga3++2qRY1hn5wrgGUg69dVIsmiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sO5ASk5yEfNAP+b+u5+6ZEV7jciTEFfYDtAGJi2iMbCzZlHstj+cPtTULbLxGA26n
	 8UZm3yGrVYQoPGgb8B+py7puzaNvTd+sjeWAELoaKsxCjumxxoVKR2fkiZM8KSMA6j
	 q8irLUvbjL5bJ4+n0X4qd6OmZYxElhdvUV/EH8MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Krystian Pradzynski <krystian.pradzynski@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.3 103/160] accel/ivpu: Fix sporadic VPU boot failure
Date: Mon, 12 Jun 2023 12:27:15 +0200
Message-ID: <20230612101719.728301044@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>

commit a3efabee5878b8d7b1863debb78cb7129d07a346 upstream.

Wait for AON bit in HOST_SS_CPR_RST_CLR to return 0 before
starting VPUIP power up sequence, otherwise the VPU device
may sporadically fail to boot.

An error in power up sequence is propagated to the runtime
power management - the device will be in an error state
until the VPU driver is reloaded.

Fixes: 35b137630f08 ("accel/ivpu: Introduce a new DRM driver for Intel VPU")
Cc: stable@vger.kernel.org # 6.3.x
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Reviewed-by: Krystian Pradzynski <krystian.pradzynski@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230607094502.388489-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_hw_mtl.c     | 13 ++++++++++++-
 drivers/accel/ivpu/ivpu_hw_mtl_reg.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_mtl.c b/drivers/accel/ivpu/ivpu_hw_mtl.c
index 156dae676967..fef35422c6f0 100644
--- a/drivers/accel/ivpu/ivpu_hw_mtl.c
+++ b/drivers/accel/ivpu/ivpu_hw_mtl.c
@@ -197,6 +197,11 @@ static void ivpu_pll_init_frequency_ratios(struct ivpu_device *vdev)
 	hw->pll.pn_ratio = clamp_t(u8, fuse_pn_ratio, hw->pll.min_ratio, hw->pll.max_ratio);
 }
 
+static int ivpu_hw_mtl_wait_for_vpuip_bar(struct ivpu_device *vdev)
+{
+	return REGV_POLL_FLD(MTL_VPU_HOST_SS_CPR_RST_CLR, AON, 0, 100);
+}
+
 static int ivpu_pll_drive(struct ivpu_device *vdev, bool enable)
 {
 	struct ivpu_hw_info *hw = vdev->hw;
@@ -239,6 +244,12 @@ static int ivpu_pll_drive(struct ivpu_device *vdev, bool enable)
 			ivpu_err(vdev, "Timed out waiting for PLL ready status\n");
 			return ret;
 		}
+
+		ret = ivpu_hw_mtl_wait_for_vpuip_bar(vdev);
+		if (ret) {
+			ivpu_err(vdev, "Timed out waiting for VPUIP bar\n");
+			return ret;
+		}
 	}
 
 	return 0;
@@ -256,7 +267,7 @@ static int ivpu_pll_disable(struct ivpu_device *vdev)
 
 static void ivpu_boot_host_ss_rst_clr_assert(struct ivpu_device *vdev)
 {
-	u32 val = REGV_RD32(MTL_VPU_HOST_SS_CPR_RST_CLR);
+	u32 val = 0;
 
 	val = REG_SET_FLD(MTL_VPU_HOST_SS_CPR_RST_CLR, TOP_NOC, val);
 	val = REG_SET_FLD(MTL_VPU_HOST_SS_CPR_RST_CLR, DSS_MAS, val);
diff --git a/drivers/accel/ivpu/ivpu_hw_mtl_reg.h b/drivers/accel/ivpu/ivpu_hw_mtl_reg.h
index d83ccfd9a871..593b8ff07417 100644
--- a/drivers/accel/ivpu/ivpu_hw_mtl_reg.h
+++ b/drivers/accel/ivpu/ivpu_hw_mtl_reg.h
@@ -91,6 +91,7 @@
 #define MTL_VPU_HOST_SS_CPR_RST_SET_MSS_MAS_MASK			BIT_MASK(11)
 
 #define MTL_VPU_HOST_SS_CPR_RST_CLR					0x00000098u
+#define MTL_VPU_HOST_SS_CPR_RST_CLR_AON_MASK				BIT_MASK(0)
 #define MTL_VPU_HOST_SS_CPR_RST_CLR_TOP_NOC_MASK			BIT_MASK(1)
 #define MTL_VPU_HOST_SS_CPR_RST_CLR_DSS_MAS_MASK			BIT_MASK(10)
 #define MTL_VPU_HOST_SS_CPR_RST_CLR_MSS_MAS_MASK			BIT_MASK(11)
-- 
2.41.0



