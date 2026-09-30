Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96724530DEE;
	Wed, 30 Sep 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790600; cv=none; b=kKVJTAzv430N/P5OtCjxfv318ZhHeVQlljIBbV13LU0syBNLJy1OwTnXhPRe52gdz0oVaMk5NhWgFce2SdHSgiZnXjn3Gjf38zjZRDMLmXxW90oyEadnR6U9CpbhaMnqG3NHme1ImWzUH87BL347GQUL10jhNNtimbEJoKwMZBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790600; c=relaxed/simple;
	bh=otFMbLiEBCoQzrZsUxiEtKI2RlxmyrDgABgK1YfpeKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofP0LvUbnaDa5FoIX1ieS9pNC0POmZlyDZJO4xW7gqImlz5lELXjifcbATT+RgjqTZIMsV2bTPyF17cmHkTZ106NsbiQvdPLaBQTFiNTOEWHfDoBcBTE/LVFSBvEoQOl+P4K7LahJX6Dj+qaz5Y99AxViIdtn5kyxNCQDwcrLu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ROkWmXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ROkWmXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20451F000FF;
	Wed, 30 Sep 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790599;
	bh=GSXZM6ZPvf3ZLTrYfDPnWCCiRSSr36IF8vyWIyU3tk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ROkWmXJoak4MOAEQlKSX6xAGMI0+565A8+L1Jg7xsuHnuSKA6GbTm0ZzZL0XvjwZ
	 So9SAmM2yhYsWzMhLK9hXAq78taLyM5eqA7wrmPuJiuV92FN4nOFBJiSKRWxS7huwb
	 AtWmX4oteXR6XA+JQhZes7QGzs+TzuDVsfsmnVB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/752] bus: fsl-mc: wait for the MC firmware to complete its boot
Date: Wed, 30 Sep 2026 17:17:51 +0200
Message-ID: <20260930152358.171957700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 208858b1b48eba83d073542372329cf8ed606526 ]

There are use cases in which the Management Complex firmware boot
process is started by the bootloader which does not wait for the boot to
complete. This is mainly done in order to reduce the overall boot time
of a DPAA2 based SoC.

In this kind of circumstance, the fsl-mc bus driver needs to make sure
that the MC firmware boot process is finished before proceeding to the
usual operations such as interrogating the firmware to gather all
existent DPAA2 objects, creating the fsl-mc devices on the bus etc.

Add this kind of check early in the boot process of the fsl-mc bus and
defer the probe in case the firmware is still in its boot process.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20260401144508.3062019-1-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c | 46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index f958d6cfe4793..972f7a4627598 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -65,6 +65,13 @@ struct fsl_mc_addr_translation_range {
 #define GCR1_P1_STOP	BIT(31)
 #define GCR1_P2_STOP	BIT(30)
 
+#define FSL_MC_GSR		0x8
+#define FSL_MC_GSR_BOOT_DONE	BIT(0)
+#define FSL_MC_GSR_MCS_MASK	GENMASK(7, 0)
+#define FSL_MC_GSR_MCS_ERR_MASK	GENMASK(7, 1)
+#define FSL_MC_GSR_BC_MASK	GENMASK(15, 8)
+#define FSL_MC_GSR_BC_SHIFT	8
+
 #define FSL_MC_FAPR	0x28
 #define MC_FAPR_PL	BIT(18)
 #define MC_FAPR_BMT	BIT(17)
@@ -1084,6 +1091,41 @@ static int get_mc_addr_translation_ranges(struct device *dev,
 	return 0;
 }
 
+static u32 fsl_mc_read_gsr(struct fsl_mc *mc)
+{
+	return readl(mc->fsl_mc_regs + FSL_MC_GSR);
+}
+
+static int fsl_mc_firmware_check(struct platform_device *pdev)
+{
+	struct fsl_mc *mc = platform_get_drvdata(pdev);
+	u32 gsr, boot_done, boot_code, mcs;
+
+	gsr = fsl_mc_read_gsr(mc);
+	boot_code = (gsr & FSL_MC_GSR_BC_MASK) >> FSL_MC_GSR_BC_SHIFT;
+	if (boot_code == 0xDD) {
+		dev_err(&pdev->dev,
+			"fsl-mc: DPL processing was not started, DPAA2 will not work!\n");
+		return -EOPNOTSUPP;
+	}
+
+	boot_done = gsr & FSL_MC_GSR_BOOT_DONE;
+	if (!boot_done) {
+		dev_dbg(&pdev->dev,
+			"fsl-mc: DPL processing in progress, defer probe\n");
+		return -EPROBE_DEFER;
+	}
+
+	mcs = gsr & FSL_MC_GSR_MCS_MASK;
+	if (mcs & FSL_MC_GSR_MCS_ERR_MASK) {
+		dev_err(&pdev->dev,
+			"fsl-mc: MC boot completed with error 0x%x\n", mcs);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * fsl_mc_bus_probe - callback invoked when the root MC bus is being
  * added
@@ -1148,6 +1190,10 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 		       mc->fsl_mc_regs + FSL_MC_GCR1);
 	}
 
+	error = fsl_mc_firmware_check(pdev);
+	if (error)
+		return error;
+
 	/*
 	 * Get physical address of MC portal for the root DPRC:
 	 */
-- 
2.53.0



