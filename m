Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609318452E;
	Sun,  1 Sep 2024 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209224; cv=none; b=A6WZ0/jx7UpxSka8DpZJX6ZtjEXmHjsJ0UBW901ovSXN82k1IjhRHhzBeGnrkcoPQrRQ5Wh1KIGP8wGPp0//stjZWKIwRdvKhRFEAxVgVZZKjxpwQzhw4vhjzTktBydliu/2gMDRgZisdbsA5OAu9KVabGP32GfSgJ64h8cC3PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209224; c=relaxed/simple;
	bh=WzSKuh1ZiTaClLoeiEXo5oeF8OZ0YyYcD26iGJe+VDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMh726irWVdGFUmE1Wrd58ScAJiL9hMKXtKx05g484gMKqWyvInJHFooWZQA0WmO+/SvoBRJ9q/HY8wpS63RxvbTTTDbNNQaG0yY8B+Rz7mNcmL2s8V0G1Hj5H+qurWWmtBs1t4SsDv4AxyWcYSsIOP2S0S5yijtNdAaL8/1Q9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0V6pW+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0V6pW+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C403C4CEC3;
	Sun,  1 Sep 2024 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209224;
	bh=WzSKuh1ZiTaClLoeiEXo5oeF8OZ0YyYcD26iGJe+VDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0V6pW+9EcF0EKKAYB9pyqhuPNV9sGvwBnQ76e2sObpnztRfzm3uFbeb9i2ngSCNh
	 1t9EEVNRfXaGAme6hnDmGmeWaqlMUTAmXosJYZh2MM8vLMsX1VZtvV6a80MwpzZmAi
	 P+s7WWr8e9aHHS51meY2Q1AK0ZlVoSVlz42cZ28o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piyush Mehta <piyush.mehta@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/71] phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume
Date: Sun,  1 Sep 2024 18:17:44 +0200
Message-ID: <20240901160803.366968914@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piyush Mehta <piyush.mehta@amd.com>

[ Upstream commit 5af9b304bc6010723c02f74de0bfd24ff19b1a10 ]

On a few Kria KR260 Robotics Starter Kit the PS-GEM SGMII linkup is not
happening after the resume. This is because serdes registers are reset
when FPD is off (in suspend state) and needs to be reprogrammed in the
resume path with the same default initialization as done in the first
stage bootloader psu_init routine.

To address the failure introduce a set of serdes registers to be saved in
the suspend path and then restore it on resume.

Fixes: 4a33bea00314 ("phy: zynqmp: Add PHY driver for the Xilinx ZynqMP Gigabit Transceiver")
Signed-off-by: Piyush Mehta <piyush.mehta@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1722837547-2578381-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 56 +++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index a8782aad62ca4..75b0f9f31c81f 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -166,6 +166,24 @@
 /* Timeout values */
 #define TIMEOUT_US			1000
 
+/* Lane 0/1/2/3 offset */
+#define DIG_8(n)		((0x4000 * (n)) + 0x1074)
+#define ILL13(n)		((0x4000 * (n)) + 0x1994)
+#define DIG_10(n)		((0x4000 * (n)) + 0x107c)
+#define RST_DLY(n)		((0x4000 * (n)) + 0x19a4)
+#define BYP_15(n)		((0x4000 * (n)) + 0x1038)
+#define BYP_12(n)		((0x4000 * (n)) + 0x102c)
+#define MISC3(n)		((0x4000 * (n)) + 0x19ac)
+#define EQ11(n)			((0x4000 * (n)) + 0x1978)
+
+static u32 save_reg_address[] = {
+	/* Lane 0/1/2/3 Register */
+	DIG_8(0), ILL13(0), DIG_10(0), RST_DLY(0), BYP_15(0), BYP_12(0), MISC3(0), EQ11(0),
+	DIG_8(1), ILL13(1), DIG_10(1), RST_DLY(1), BYP_15(1), BYP_12(1), MISC3(1), EQ11(1),
+	DIG_8(2), ILL13(2), DIG_10(2), RST_DLY(2), BYP_15(2), BYP_12(2), MISC3(2), EQ11(2),
+	DIG_8(3), ILL13(3), DIG_10(3), RST_DLY(3), BYP_15(3), BYP_12(3), MISC3(3), EQ11(3),
+};
+
 struct xpsgtr_dev;
 
 /**
@@ -214,6 +232,7 @@ struct xpsgtr_phy {
  * @tx_term_fix: fix for GT issue
  * @saved_icm_cfg0: stored value of ICM CFG0 register
  * @saved_icm_cfg1: stored value of ICM CFG1 register
+ * @saved_regs: registers to be saved/restored during suspend/resume
  */
 struct xpsgtr_dev {
 	struct device *dev;
@@ -226,6 +245,7 @@ struct xpsgtr_dev {
 	bool tx_term_fix;
 	unsigned int saved_icm_cfg0;
 	unsigned int saved_icm_cfg1;
+	u32 *saved_regs;
 };
 
 /*
@@ -299,6 +319,32 @@ static inline void xpsgtr_clr_set_phy(struct xpsgtr_phy *gtr_phy,
 	writel((readl(addr) & ~clr) | set, addr);
 }
 
+/**
+ * xpsgtr_save_lane_regs - Saves registers on suspend
+ * @gtr_dev: pointer to phy controller context structure
+ */
+static void xpsgtr_save_lane_regs(struct xpsgtr_dev *gtr_dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(save_reg_address); i++)
+		gtr_dev->saved_regs[i] = xpsgtr_read(gtr_dev,
+						     save_reg_address[i]);
+}
+
+/**
+ * xpsgtr_restore_lane_regs - Restores registers on resume
+ * @gtr_dev: pointer to phy controller context structure
+ */
+static void xpsgtr_restore_lane_regs(struct xpsgtr_dev *gtr_dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(save_reg_address); i++)
+		xpsgtr_write(gtr_dev, save_reg_address[i],
+			     gtr_dev->saved_regs[i]);
+}
+
 /*
  * Hardware Configuration
  */
@@ -838,6 +884,8 @@ static int xpsgtr_runtime_suspend(struct device *dev)
 	gtr_dev->saved_icm_cfg0 = xpsgtr_read(gtr_dev, ICM_CFG0);
 	gtr_dev->saved_icm_cfg1 = xpsgtr_read(gtr_dev, ICM_CFG1);
 
+	xpsgtr_save_lane_regs(gtr_dev);
+
 	return 0;
 }
 
@@ -848,6 +896,8 @@ static int xpsgtr_runtime_resume(struct device *dev)
 	unsigned int i;
 	bool skip_phy_init;
 
+	xpsgtr_restore_lane_regs(gtr_dev);
+
 	icm_cfg0 = xpsgtr_read(gtr_dev, ICM_CFG0);
 	icm_cfg1 = xpsgtr_read(gtr_dev, ICM_CFG1);
 
@@ -990,6 +1040,12 @@ static int xpsgtr_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	gtr_dev->saved_regs = devm_kmalloc(gtr_dev->dev,
+					   sizeof(save_reg_address),
+					   GFP_KERNEL);
+	if (!gtr_dev->saved_regs)
+		return -ENOMEM;
+
 	return 0;
 }
 
-- 
2.43.0



