Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB68D168C4;
	Mon, 27 May 2024 19:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837602; cv=none; b=glLkfV4SZArzwUs8WJjUkAHKiL7qNWwnqeMpPHB7YWU9O3qek8QTWRXRmvh1PvESypIgvOB1IElj5SJ8kziPkxbBti4yDaX2oaJEbqtK6b63zw7TSqZiawJY9JPVuF+ps3Xz7RyKBvAlNjk1AOK8Cz5LCqYWTJIN7+fK+BorsYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837602; c=relaxed/simple;
	bh=XBuAuz4nGcRu7izVY0X3U7Vo6MargZgM7e8ZI49G+NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pY14wwJcBAdZBsVgrV0ONHC1Tp1SL0MFiffZW7ALyohPTf3GyLOIxfuEcjGAwogdnAQqHie+7sA6ivb3/o93vZsQEFoqV/TB3fHqkO9ymoCsatZPVL2LGCbf8vPZBtSo+pQD1WiRyxsYe4rCQNm0eRPLdSOygeEEbtI0CKctqo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ub21jA5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ub21jA5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CB8C2BBFC;
	Mon, 27 May 2024 19:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837602;
	bh=XBuAuz4nGcRu7izVY0X3U7Vo6MargZgM7e8ZI49G+NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ub21jA5a/BJ3C74RyxAObEwM4k1XZAORcAZ6FEV0L6Zu2p90ZLnrkfNGuKIqoVnSa
	 zujPATSdL4ThYOw8oEuLwyjM5q28asEaKDh0LbKwYgP7VkEvs6aHw9lGV4C1agbFuK
	 bvJQhENTkPJCzRpqCwuCUD8LkxMe9AKpEFT+TY1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 073/493] ASoC: rt722-sdca: add headset microphone vrefo setting
Date: Mon, 27 May 2024 20:51:15 +0200
Message-ID: <20240527185632.284755081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 140e0762ca055d1aa84b17847cde5d9e47f56f76 ]

Add vrefo settings to fix jd and headset mic recording issue.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://msgid.link/r/727219ed45d3485ba8f4646700aaa8a8@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca.c | 25 +++++++++++++++++++------
 sound/soc/codecs/rt722-sdca.h |  3 +++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca.c b/sound/soc/codecs/rt722-sdca.c
index 4338cdb3a7917..9ff607984ea19 100644
--- a/sound/soc/codecs/rt722-sdca.c
+++ b/sound/soc/codecs/rt722-sdca.c
@@ -1438,9 +1438,12 @@ static void rt722_sdca_jack_preset(struct rt722_sdca_priv *rt722)
 	int loop_check, chk_cnt = 100, ret;
 	unsigned int calib_status = 0;
 
-	/* Read eFuse */
-	rt722_sdca_index_write(rt722, RT722_VENDOR_SPK_EFUSE, RT722_DC_CALIB_CTRL,
-		0x4808);
+	/* Config analog bias */
+	rt722_sdca_index_write(rt722, RT722_VENDOR_REG, RT722_ANALOG_BIAS_CTL3,
+		0xa081);
+	/* GE related settings */
+	rt722_sdca_index_write(rt722, RT722_VENDOR_HDA_CTL, RT722_GE_RELATED_CTL2,
+		0xa009);
 	/* Button A, B, C, D bypass mode */
 	rt722_sdca_index_write(rt722, RT722_VENDOR_HDA_CTL, RT722_UMP_HID_CTL4,
 		0xcf00);
@@ -1474,9 +1477,6 @@ static void rt722_sdca_jack_preset(struct rt722_sdca_priv *rt722)
 		if ((calib_status & 0x0040) == 0x0)
 			break;
 	}
-	/* Release HP-JD, EN_CBJ_TIE_GL/R open, en_osw gating auto done bit */
-	rt722_sdca_index_write(rt722, RT722_VENDOR_REG, RT722_DIGITAL_MISC_CTRL4,
-		0x0010);
 	/* Set ADC09 power entity floating control */
 	rt722_sdca_index_write(rt722, RT722_VENDOR_HDA_CTL, RT722_ADC0A_08_PDE_FLOAT_CTL,
 		0x2a12);
@@ -1489,8 +1489,21 @@ static void rt722_sdca_jack_preset(struct rt722_sdca_priv *rt722)
 	/* Set DAC03 and HP power entity floating control */
 	rt722_sdca_index_write(rt722, RT722_VENDOR_HDA_CTL, RT722_DAC03_HP_PDE_FLOAT_CTL,
 		0x4040);
+	rt722_sdca_index_write(rt722, RT722_VENDOR_HDA_CTL, RT722_ENT_FLOAT_CTRL_1,
+		0x4141);
+	rt722_sdca_index_write(rt722, RT722_VENDOR_HDA_CTL, RT722_FLOAT_CTRL_1,
+		0x0101);
 	/* Fine tune PDE40 latency */
 	regmap_write(rt722->regmap, 0x2f58, 0x07);
+	regmap_write(rt722->regmap, 0x2f03, 0x06);
+	/* MIC VRefo */
+	rt722_sdca_index_update_bits(rt722, RT722_VENDOR_REG,
+		RT722_COMBO_JACK_AUTO_CTL1, 0x0200, 0x0200);
+	rt722_sdca_index_update_bits(rt722, RT722_VENDOR_REG,
+		RT722_VREFO_GAT, 0x4000, 0x4000);
+	/* Release HP-JD, EN_CBJ_TIE_GL/R open, en_osw gating auto done bit */
+	rt722_sdca_index_write(rt722, RT722_VENDOR_REG, RT722_DIGITAL_MISC_CTRL4,
+		0x0010);
 }
 
 int rt722_sdca_io_init(struct device *dev, struct sdw_slave *slave)
diff --git a/sound/soc/codecs/rt722-sdca.h b/sound/soc/codecs/rt722-sdca.h
index 44af8901352eb..2464361a7958c 100644
--- a/sound/soc/codecs/rt722-sdca.h
+++ b/sound/soc/codecs/rt722-sdca.h
@@ -69,6 +69,7 @@ struct rt722_sdca_dmic_kctrl_priv {
 #define RT722_COMBO_JACK_AUTO_CTL2		0x46
 #define RT722_COMBO_JACK_AUTO_CTL3		0x47
 #define RT722_DIGITAL_MISC_CTRL4		0x4a
+#define RT722_VREFO_GAT				0x63
 #define RT722_FSM_CTL				0x67
 #define RT722_SDCA_INTR_REC			0x82
 #define RT722_SW_CONFIG1			0x8a
@@ -127,6 +128,8 @@ struct rt722_sdca_dmic_kctrl_priv {
 #define RT722_UMP_HID_CTL6			0x66
 #define RT722_UMP_HID_CTL7			0x67
 #define RT722_UMP_HID_CTL8			0x68
+#define RT722_FLOAT_CTRL_1			0x70
+#define RT722_ENT_FLOAT_CTRL_1		0x76
 
 /* Parameter & Verb control 01 (0x1a)(NID:20h) */
 #define RT722_HIDDEN_REG_SW_RESET (0x1 << 14)
-- 
2.43.0



