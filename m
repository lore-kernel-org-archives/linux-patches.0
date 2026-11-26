Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704362;
	b=c4SfdmMK7xX51D3ibIibJ9T6qgKXciwlR60Oft4q7bRdehdOCGGyO867DoRv7YoGGkLU
	 Jg+Ydm5DxRzGvTRDnJH4wZfV9b2T5YZXTznCi0Al7indjWU8Axx4C7wv8iRMXZsoXRfuD
	 Cq2b11JAMrMaT06mR/kMxD7mSI3VXXXNgXiPRjIhUjYO4/cmTF8v1uRrYCQJkafVcCX/n
	 7FMiqNtoQlkTxiI52YxFmhSFj9ilj76p0PmWqt05kWubS2gZrbcY60jslmA8wjmbK6DN4
	 2oIpVq6zApuq8QE/Ym1xg7ndVWdmD457sEqlXagENHyuuEJkjACpGolNgt7ItzqUfhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRGoxyf60NfXrvYdpRYVPUXryZuJPu9zoj5RbDq/tas=;
	b=xYrZ3gjC/KEVabgpX8Gn7FTI0xJBmb4HkMc/R4l8tJVAKCFVQAYNj1cYT3ujikVzf/vC
	 Dkgl7bmVfDG6YlmF5FsLgh3MHnI0V3aXXdxRf2nmttBkHH1Shjf2FlxXV022iDqWVObhT
	 ee4wbOG+19At4IRAxIFUhxEfW028yIA+OZoGoVJrt4ZhHVKFhHd4qbnlZALk10DZ7C8xG
	 a3sboXgEt8dG4jUBAIVE9J5EW+ik0pFJUP0chrZYEpakKeRhJ7FyGxhajvSH4GPPUGrpR
	 udH+nOv0Fn/o3p6XA8QSDlkh8dMcKNZ1O8sAXhSslWRMi8mgJFCmirbpGyINBgMyqIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbtwJjc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611F6606A32E;
	Thu, 26 Nov 2026 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbtwJjc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5AA1F000D4;
	Thu, 26 Nov 2026 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704362;
	bh=uRGoxyf60NfXrvYdpRYVPUXryZuJPu9zoj5RbDq/tas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbtwJjc3A+Rkpm1EzJUvnsbb8ip9ErytZn6TXl6DIBeQehDOk4seOwt3VHRt7rgjV
	 8NV/IQj93Gewm8ZjdmzCSI70bx8OJFRs1TfPFPKepKhMCCwPE77LYV17yvHgUrm7Vv
	 UA7Nyyf60SFv/WU6yVPXQDFcCkBhQXjkICwBVX8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/265] regulator: qcom_spmi: dont take a sleeping lock in the SAW IPI
Date: Thu, 26 Nov 2026 15:36:23 +0100
Message-ID: <20261126143608.810826569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 053c50a7052549aab0d310ad505947db3e211592 ]

The SAW voltage change runs on CPU 0 from an IPI, but it reaches the SAW
registers through the syscon regmap, which is protected by a spinlock_t.
That is a sleeping lock on PREEMPT_RT, and lockdep complains as soon as
VDD_APCC actually changes voltage:

  BUG: Invalid wait context
  ...
  regmap_lock_spinlock+0x18/0x30
  regmap_read+0x3c/0x78
  spmi_saw_set_vdd+0x50/0x1ac
  __flush_smp_call_function_queue+0x1ac/0x334

Map the SAW with a regmap of our own that uses a raw spinlock, and fail
the probe when that cannot be done instead of carrying an error pointer
around as the SAW regmap.

Fixes: 0caecaa87202 ("regulator: qcom_spmi: Add support for SAW")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20261019-fix-qcom-saw-v1-3-9c7ba3fc2493@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/Kconfig               |  1 +
 drivers/regulator/qcom_spmi-regulator.c | 35 +++++++++++++++++++------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 020a00d6696bf..5d92bfede22d8 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -865,6 +865,7 @@ config REGULATOR_QCOM_SMD_RPM
 config REGULATOR_QCOM_SPMI
 	tristate "Qualcomm SPMI regulator driver"
 	depends on SPMI || COMPILE_TEST
+	select REGMAP_MMIO
 	help
 	  If you say yes to this option, support will be included for the
 	  regulators found in Qualcomm SPMI PMICs.
diff --git a/drivers/regulator/qcom_spmi-regulator.c b/drivers/regulator/qcom_spmi-regulator.c
index 47931ce19e439..69b840398f872 100644
--- a/drivers/regulator/qcom_spmi-regulator.c
+++ b/drivers/regulator/qcom_spmi-regulator.c
@@ -11,13 +11,13 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/ktime.h>
 #include <linux/regulator/driver.h>
 #include <linux/regmap.h>
 #include <linux/list.h>
-#include <linux/mfd/syscon.h>
 #include <linux/io.h>
 
 /* Pin control enable input pins. */
@@ -1218,6 +1218,14 @@ static irqreturn_t spmi_regulator_vs_ocp_isr(int irq, void *data)
 
 static struct regmap *saw_regmap;
 
+static const struct regmap_config saw_regmap_config = {
+	.name = "saw",
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.use_raw_spinlock = true,
+};
+
 static void spmi_saw_set_vdd(void *data)
 {
 	u32 vctl, data3, avs_ctl, pmic_sts;
@@ -2110,7 +2118,8 @@ static int qcom_spmi_regulator_probe(struct platform_device *pdev)
 	const char *name;
 	struct device *dev = &pdev->dev;
 	struct device_node *node = pdev->dev.of_node;
-	struct device_node *syscon, *reg_node;
+	struct device_node *saw, *reg_node;
+	void __iomem *saw_base;
 	struct property *reg_prop;
 	int ret, lenp;
 	struct list_head *vreg_list;
@@ -2129,12 +2138,22 @@ static int qcom_spmi_regulator_probe(struct platform_device *pdev)
 	if (!match)
 		return -ENODEV;
 
-	syscon = of_parse_phandle(node, "qcom,saw-reg", 0);
-	if (syscon) {
-		saw_regmap = syscon_node_to_regmap(syscon);
-		of_node_put(syscon);
-		if (IS_ERR(saw_regmap))
-			dev_err(dev, "ERROR reading SAW regmap\n");
+	saw = of_parse_phandle(node, "qcom,saw-reg", 0);
+	if (saw) {
+		saw_base = devm_of_iomap(dev, saw, 0, NULL);
+		of_node_put(saw);
+		if (IS_ERR(saw_base))
+			return dev_err_probe(dev, PTR_ERR(saw_base),
+					     "failed to map the SAW\n");
+
+		saw_regmap = devm_regmap_init_mmio(dev, saw_base,
+						   &saw_regmap_config);
+		if (IS_ERR(saw_regmap)) {
+			ret = PTR_ERR(saw_regmap);
+			saw_regmap = NULL;
+			return dev_err_probe(dev, ret,
+					     "failed to set the SAW regmap up\n");
+		}
 	}
 
 	for (reg = match->data; reg->name; reg++) {
-- 
2.53.0



