Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4269170A01;
	Tue, 10 Sep 2024 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962520; cv=none; b=t1k43pkcAB25sarP8+LF6jyT3hDCkYNzZma4mVIOKhp31hk6iDDMM0tNsjlFMXoom1ONDn0D3nqC43HI2aL/ONfQ2na+DqgexaKTfU2Xl5NxjMULRbpLDFZ/Rk+AgCNaytj0P8fbJy8s+vUl/f+vWz+BSX0T38sPs1/6rzJ3RAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962520; c=relaxed/simple;
	bh=Psy4wPDpR+1X9ryyWvasRW9Mak9cBpIWZPI3KXPYcko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kfe1nkIKIpdY1G12TtS7kZFntIxMupaEqdLoOyeuWBa01MVO9KUMsvjHvv+shmzL6DkqN8WdxnpQLErVJe5gGtRdIU06UguP1y+MDM14EPuGemPzXua5pP4+/RQSSD7Yh3iAVXhFxxpKGVrEYTcCbNhJ5/v+FfA6O/61drhtQCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLmELxPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLmELxPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54053C4CEC3;
	Tue, 10 Sep 2024 10:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962519;
	bh=Psy4wPDpR+1X9ryyWvasRW9Mak9cBpIWZPI3KXPYcko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLmELxPwhspVYX4YH9dAzm/qg3GIKyx0VY52sM4nq6UIzDdxsWt4L3IZeY9wOXPaO
	 phbWFC2/OHi6f4RODTRkhN92LAaFqYHg8WP49NmBYKGL6aEPTMBYiAz5ai9aSgbLbN
	 A3LYqroay6pRaDzdIr5pfhqMyF6GvXdLJP5eGFHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Enrico Weigelt <info@metux.net>,
	John Stultz <john.stultz@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Yongqin Liu <yongqin.liu@linaro.org>,
	kbuild test robot <lkp@intel.com>
Subject: [PATCH 5.4 035/121] reset: hi6220: Add support for AO reset controller
Date: Tue, 10 Sep 2024 11:31:50 +0200
Message-ID: <20240910092547.394437541@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit 697fa27dc5fb4c669471e728e97f176687982f95 upstream.

This is required to bring Mali450 gpu out of reset.

Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Enrico Weigelt <info@metux.net>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
[jstultz: Added comment, Fix void return build issue
Reported-by: kbuild test robot <lkp@intel.com>]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Yongqin Liu <yongqin.liu@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/hisilicon/hi6220_reset.c |   69 ++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

--- a/drivers/reset/hisilicon/hi6220_reset.c
+++ b/drivers/reset/hisilicon/hi6220_reset.c
@@ -33,6 +33,7 @@
 enum hi6220_reset_ctrl_type {
 	PERIPHERAL,
 	MEDIA,
+	AO,
 };
 
 struct hi6220_reset_data {
@@ -92,6 +93,65 @@ static const struct reset_control_ops hi
 	.deassert = hi6220_media_deassert,
 };
 
+#define AO_SCTRL_SC_PW_CLKEN0     0x800
+#define AO_SCTRL_SC_PW_CLKDIS0    0x804
+
+#define AO_SCTRL_SC_PW_RSTEN0     0x810
+#define AO_SCTRL_SC_PW_RSTDIS0    0x814
+
+#define AO_SCTRL_SC_PW_ISOEN0     0x820
+#define AO_SCTRL_SC_PW_ISODIS0    0x824
+#define AO_MAX_INDEX              12
+
+static int hi6220_ao_assert(struct reset_controller_dev *rc_dev,
+			       unsigned long idx)
+{
+	struct hi6220_reset_data *data = to_reset_data(rc_dev);
+	struct regmap *regmap = data->regmap;
+	int ret;
+
+	ret = regmap_write(regmap, AO_SCTRL_SC_PW_RSTEN0, BIT(idx));
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, AO_SCTRL_SC_PW_ISOEN0, BIT(idx));
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, AO_SCTRL_SC_PW_CLKDIS0, BIT(idx));
+	return ret;
+}
+
+static int hi6220_ao_deassert(struct reset_controller_dev *rc_dev,
+				 unsigned long idx)
+{
+	struct hi6220_reset_data *data = to_reset_data(rc_dev);
+	struct regmap *regmap = data->regmap;
+	int ret;
+
+	/*
+	 * It was suggested to disable isolation before enabling
+	 * the clocks and deasserting reset, to avoid glitches.
+	 * But this order is preserved to keep it matching the
+	 * vendor code.
+	 */
+	ret = regmap_write(regmap, AO_SCTRL_SC_PW_RSTDIS0, BIT(idx));
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, AO_SCTRL_SC_PW_ISODIS0, BIT(idx));
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, AO_SCTRL_SC_PW_CLKEN0, BIT(idx));
+	return ret;
+}
+
+static const struct reset_control_ops hi6220_ao_reset_ops = {
+	.assert = hi6220_ao_assert,
+	.deassert = hi6220_ao_deassert,
+};
+
 static int hi6220_reset_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -117,9 +177,12 @@ static int hi6220_reset_probe(struct pla
 	if (type == MEDIA) {
 		data->rc_dev.ops = &hi6220_media_reset_ops;
 		data->rc_dev.nr_resets = MEDIA_MAX_INDEX;
-	} else {
+	} else if (type == PERIPHERAL) {
 		data->rc_dev.ops = &hi6220_peripheral_reset_ops;
 		data->rc_dev.nr_resets = PERIPH_MAX_INDEX;
+	} else {
+		data->rc_dev.ops = &hi6220_ao_reset_ops;
+		data->rc_dev.nr_resets = AO_MAX_INDEX;
 	}
 
 	return reset_controller_register(&data->rc_dev);
@@ -134,6 +197,10 @@ static const struct of_device_id hi6220_
 		.compatible = "hisilicon,hi6220-mediactrl",
 		.data = (void *)MEDIA,
 	},
+	{
+		.compatible = "hisilicon,hi6220-aoctrl",
+		.data = (void *)AO,
+	},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, hi6220_reset_match);


