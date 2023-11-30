Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98978524C2;
	Thu, 30 Nov 2023 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlMw9hXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AD3C433C8;
	Thu, 30 Nov 2023 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361523;
	bh=rqlLDcuWrna/vDUSmQgElKQlrm+pmWb0g5J1XphmLrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlMw9hXRYkoV7LCHzSOTs5fKeOXjWNOMzNu/wuM2csSbmy11S/UeM4ZvAjVDfGHPu
	 re3pSh4BnxcEvFkX0Yc33L312RAkZ4GZkDX/2LC1r7okzBiyyUXiZdfjFnADXEZXdR
	 LLzjD/z+SlnHyNYGsf6/T5iivQCIwvycx/ezm7Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/112] accel/ivpu/37xx: Fix hangs related to MMIO reset
Date: Thu, 30 Nov 2023 16:21:19 +0000
Message-ID: <20231130162141.337328480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit 3f7c0634926daf48cd2f6db6c1197a1047074088 ]

There is no need to call MMIO reset using VPU_37XX_BUTTRESS_VPU_IP_RESET
register. IP will be reset by FLR or by entering d0i3. Also IP reset
during power_up is not needed as the VPU is already in reset.

Removing MMIO reset improves stability as it a partial device reset
that is not safe in some corner cases.

This change also brings back ivpu_boot_pwr_domain_disable() that
helps to properly power down VPU when it is hung by a buggy workload.

Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Fixes: 828d63042aec ("accel/ivpu: Don't enter d0i3 during FLR")
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231115111004.1304092-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_hw_37xx.c | 46 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_37xx.c b/drivers/accel/ivpu/ivpu_hw_37xx.c
index cb9f0196e3ddf..b8010c07eec17 100644
--- a/drivers/accel/ivpu/ivpu_hw_37xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_37xx.c
@@ -536,6 +536,16 @@ static int ivpu_boot_pwr_domain_enable(struct ivpu_device *vdev)
 	return ret;
 }
 
+static int ivpu_boot_pwr_domain_disable(struct ivpu_device *vdev)
+{
+	ivpu_boot_dpu_active_drive(vdev, false);
+	ivpu_boot_pwr_island_isolation_drive(vdev, true);
+	ivpu_boot_pwr_island_trickle_drive(vdev, false);
+	ivpu_boot_pwr_island_drive(vdev, false);
+
+	return ivpu_boot_wait_for_pwr_island_status(vdev, 0x0);
+}
+
 static void ivpu_boot_no_snoop_enable(struct ivpu_device *vdev)
 {
 	u32 val = REGV_RD32(VPU_37XX_HOST_IF_TCU_PTW_OVERRIDES);
@@ -634,25 +644,17 @@ static int ivpu_hw_37xx_info_init(struct ivpu_device *vdev)
 
 static int ivpu_hw_37xx_reset(struct ivpu_device *vdev)
 {
-	int ret;
-	u32 val;
-
-	if (IVPU_WA(punit_disabled))
-		return 0;
+	int ret = 0;
 
-	ret = REGB_POLL_FLD(VPU_37XX_BUTTRESS_VPU_IP_RESET, TRIGGER, 0, TIMEOUT_US);
-	if (ret) {
-		ivpu_err(vdev, "Timed out waiting for TRIGGER bit\n");
-		return ret;
+	if (ivpu_boot_pwr_domain_disable(vdev)) {
+		ivpu_err(vdev, "Failed to disable power domain\n");
+		ret = -EIO;
 	}
 
-	val = REGB_RD32(VPU_37XX_BUTTRESS_VPU_IP_RESET);
-	val = REG_SET_FLD(VPU_37XX_BUTTRESS_VPU_IP_RESET, TRIGGER, val);
-	REGB_WR32(VPU_37XX_BUTTRESS_VPU_IP_RESET, val);
-
-	ret = REGB_POLL_FLD(VPU_37XX_BUTTRESS_VPU_IP_RESET, TRIGGER, 0, TIMEOUT_US);
-	if (ret)
-		ivpu_err(vdev, "Timed out waiting for RESET completion\n");
+	if (ivpu_pll_disable(vdev)) {
+		ivpu_err(vdev, "Failed to disable PLL\n");
+		ret = -EIO;
+	}
 
 	return ret;
 }
@@ -685,10 +687,6 @@ static int ivpu_hw_37xx_power_up(struct ivpu_device *vdev)
 {
 	int ret;
 
-	ret = ivpu_hw_37xx_reset(vdev);
-	if (ret)
-		ivpu_warn(vdev, "Failed to reset HW: %d\n", ret);
-
 	ret = ivpu_hw_37xx_d0i3_disable(vdev);
 	if (ret)
 		ivpu_warn(vdev, "Failed to disable D0I3: %d\n", ret);
@@ -756,11 +754,11 @@ static int ivpu_hw_37xx_power_down(struct ivpu_device *vdev)
 {
 	int ret = 0;
 
-	if (!ivpu_hw_37xx_is_idle(vdev) && ivpu_hw_37xx_reset(vdev))
-		ivpu_err(vdev, "Failed to reset the VPU\n");
+	if (!ivpu_hw_37xx_is_idle(vdev))
+		ivpu_warn(vdev, "VPU not idle during power down\n");
 
-	if (ivpu_pll_disable(vdev)) {
-		ivpu_err(vdev, "Failed to disable PLL\n");
+	if (ivpu_hw_37xx_reset(vdev)) {
+		ivpu_err(vdev, "Failed to reset VPU\n");
 		ret = -EIO;
 	}
 
-- 
2.42.0



