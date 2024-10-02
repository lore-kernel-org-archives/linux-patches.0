Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BC51D0F40;
	Wed,  2 Oct 2024 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877643; cv=none; b=PQmHh2Y+bSzmdOkk3QzfxDJ1cO7jbTkHpvmeUewf5o4/oGzy4Muyk9hX5Oe141bWvuv/36hXebtP2g0Wk4SuJDCVuXLPkH1CZqNOLfDCi+00nb1P0PHkiyA0aDLyu8T4hfv2zaeVN90n3jFoJQ28vpt3XFS6++1ipq1zk5FlJPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877643; c=relaxed/simple;
	bh=qL0R/Vuh9QR4ZftxaE90ec5P8qPQY4TXyIN4+WY1vJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6kPQHOAQ53PeOLo+8ovXhfThnqpqXDJseQSp0BnkS8lufL37wumbA4h01+qGJ1ZDg2tkqVbdZ9K5FYOlovzEBz+czg3ilgqTAoLl8tntHBQq2PWtF1IKx7jchRql/BDZYFsGMKKnNt7KrCHuUxlWSkKkWWZDuArdFnWHv1OCE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iS29aqDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iS29aqDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87247C4CEC2;
	Wed,  2 Oct 2024 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877642;
	bh=qL0R/Vuh9QR4ZftxaE90ec5P8qPQY4TXyIN4+WY1vJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iS29aqDI4gZhRlcy5W40ONEYzniQ/lkmkSQ+GA8glFtdWYtpP1f5F5irdVdDq2Fj0
	 Xup4xs3TZWAfI3vKBNtFS+SNktZMoXdxnjvivnHFfWYW3gLPgMklh2N0JkpmlTqIiU
	 YJCBG6GoHzB8eFaNVmpUNq3U/WCQ0BoQ9wyUr5Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 145/634] ASoC: tas2781: Use of_property_read_reg()
Date: Wed,  2 Oct 2024 14:54:05 +0200
Message-ID: <20241002125816.828987796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 31a45f9190b5b4f5cd8cdec8471babd5215eee04 ]

Replace the open-coded parsing of "reg" with of_property_read_reg().
The #ifdef is also easily replaced with IS_ENABLED().

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20240702215402.839673-1-robh@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c2c0b67dca3c ("ASoC: tas2781-i2c: Drop weird GPIO code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index c64d458e524e2..1963c777ba8e0 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
@@ -635,33 +636,20 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 
 		tas_priv->irq_info.irq_gpio =
 			acpi_dev_gpio_irq_get(ACPI_COMPANION(&client->dev), 0);
-	} else {
+	} else if (IS_ENABLED(CONFIG_OF)) {
 		struct device_node *np = tas_priv->dev->of_node;
-#ifdef CONFIG_OF
-		const __be32 *reg, *reg_end;
-		int len, sw, aw;
-
-		aw = of_n_addr_cells(np);
-		sw = of_n_size_cells(np);
-		if (sw == 0) {
-			reg = (const __be32 *)of_get_property(np,
-				"reg", &len);
-			reg_end = reg + len/sizeof(*reg);
-			ndev = 0;
-			do {
-				dev_addrs[ndev] = of_read_number(reg, aw);
-				reg += aw;
-				ndev++;
-			} while (reg < reg_end);
-		} else {
-			ndev = 1;
-			dev_addrs[0] = client->addr;
+		u64 addr;
+
+		for (i = 0; i < TASDEVICE_MAX_CHANNELS; i++) {
+			if (of_property_read_reg(np, i, &addr, NULL))
+				break;
+			dev_addrs[ndev++] = addr;
 		}
-#else
+
+		tas_priv->irq_info.irq_gpio = of_irq_get(np, 0);
+	} else {
 		ndev = 1;
 		dev_addrs[0] = client->addr;
-#endif
-		tas_priv->irq_info.irq_gpio = of_irq_get(np, 0);
 	}
 	tas_priv->ndev = ndev;
 	for (i = 0; i < ndev; i++)
-- 
2.43.0



