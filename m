Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684911C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4DAC433C9;
	Mon, 28 Aug 2023 10:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219835;
	bh=Y9JNocup4Hqt4Bq5XtJN4xL9jEyLJu/LT2bOf2QLX0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJys/IJCQgofdRjWQFzFDWovPKwj2A/RiiP0oCoWQa7ZcK0xWpW9aVDhmvCV/VoHN
	 RM044R4pElBBKyaOctEWlAY8M2hgRFO9FlqZpxIPRA5B1/KlhI3uIEQkM3de1Quu/a
	 YXXLsZKl0QPPCnXW1ljSCGTpQgeiiteRb6+BY+Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>
Subject: [PATCH 5.10 73/84] ASoC: rt711: add two jack detection modes
Date: Mon, 28 Aug 2023 12:14:30 +0200
Message-ID: <20230828101151.757309756@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

commit 683b0df26c3333a5c020a2764b71a70d082c1c61 upstream.

Some boards use different circuits for jack detection.
This patch adds two modes as below
1. JD2/2 ports/external resister 100k
2. JD2/1 port/JD voltage 1.8V

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20210617090822.16960-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Philip Müller <philm@manjaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt711-sdw.h |    2 ++
 sound/soc/codecs/rt711.c     |   30 ++++++++++++++++++++++++++++++
 sound/soc/codecs/rt711.h     |   29 ++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/rt711-sdw.h
+++ b/sound/soc/codecs/rt711-sdw.h
@@ -267,7 +267,9 @@ static const struct reg_default rt711_re
 	{ 0x8393, 0x00 },
 	{ 0x7319, 0x00 },
 	{ 0x8399, 0x00 },
+	{ 0x752008, 0xa807 },
 	{ 0x752009, 0x1029 },
+	{ 0x75200b, 0x7770 },
 	{ 0x752011, 0x007a },
 	{ 0x75201a, 0x8003 },
 	{ 0x752045, 0x5289 },
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -389,6 +389,36 @@ static void rt711_jack_init(struct rt711
 				RT711_HP_JD_FINAL_RESULT_CTL_JD12,
 				RT711_HP_JD_FINAL_RESULT_CTL_JD12);
 			break;
+		case RT711_JD2_100K:
+			rt711_index_update_bits(rt711->regmap, RT711_VENDOR_REG,
+				RT711_JD_CTL2, RT711_JD2_2PORT_100K_DECODE | RT711_JD2_1PORT_TYPE_DECODE |
+				RT711_HP_JD_SEL_JD2 | RT711_JD1_2PORT_TYPE_100K_DECODE,
+				RT711_JD2_2PORT_100K_DECODE_HP | RT711_JD2_1PORT_JD_HP |
+				RT711_HP_JD_SEL_JD2 | RT711_JD1_2PORT_JD_RESERVED);
+			rt711_index_update_bits(rt711->regmap, RT711_VENDOR_REG,
+				RT711_CC_DET1,
+				RT711_HP_JD_FINAL_RESULT_CTL_JD12,
+				RT711_HP_JD_FINAL_RESULT_CTL_JD12);
+			break;
+		case RT711_JD2_1P8V_1PORT:
+			rt711_index_update_bits(rt711->regmap, RT711_VENDOR_REG,
+				RT711_JD_CTL1, RT711_JD2_DIGITAL_JD_MODE_SEL,
+				RT711_JD2_1_JD_MODE);
+			rt711_index_update_bits(rt711->regmap, RT711_VENDOR_REG,
+				RT711_JD_CTL2, RT711_JD2_1PORT_TYPE_DECODE |
+				RT711_HP_JD_SEL_JD2,
+				RT711_JD2_1PORT_JD_HP |
+				RT711_HP_JD_SEL_JD2);
+			rt711_index_update_bits(rt711->regmap, RT711_VENDOR_REG,
+				RT711_JD_CTL4, RT711_JD2_PAD_PULL_UP_MASK |
+				RT711_JD2_MODE_SEL_MASK,
+				RT711_JD2_PAD_PULL_UP |
+				RT711_JD2_MODE2_1P8V_1PORT);
+			rt711_index_update_bits(rt711->regmap, RT711_VENDOR_REG,
+				RT711_CC_DET1,
+				RT711_HP_JD_FINAL_RESULT_CTL_JD12,
+				RT711_HP_JD_FINAL_RESULT_CTL_JD12);
+			break;
 		default:
 			dev_warn(rt711->component->dev, "Wrong JD source\n");
 			break;
--- a/sound/soc/codecs/rt711.h
+++ b/sound/soc/codecs/rt711.h
@@ -52,7 +52,9 @@ struct sdw_stream_data {
 
 /* Index (NID:20h) */
 #define RT711_DAC_DC_CALI_CTL1				0x00
+#define RT711_JD_CTL1				0x08
 #define RT711_JD_CTL2				0x09
+#define RT711_JD_CTL4				0x0b
 #define RT711_CC_DET1				0x11
 #define RT711_PARA_VERB_CTL				0x1a
 #define RT711_COMBO_JACK_AUTO_CTL1				0x45
@@ -171,10 +173,33 @@ struct sdw_stream_data {
 /* DAC DC offset calibration control-1 (0x00)(NID:20h) */
 #define RT711_DAC_DC_CALI_TRIGGER (0x1 << 15)
 
+/* jack detect control 1 (0x08)(NID:20h) */
+#define RT711_JD2_DIGITAL_JD_MODE_SEL (0x1 << 1)
+#define RT711_JD2_1_JD_MODE (0x0 << 1)
+#define RT711_JD2_2_JD_MODE (0x1 << 1)
+
 /* jack detect control 2 (0x09)(NID:20h) */
 #define RT711_JD2_2PORT_200K_DECODE_HP (0x1 << 13)
+#define RT711_JD2_2PORT_100K_DECODE (0x1 << 12)
+#define RT711_JD2_2PORT_100K_DECODE_HP (0x0 << 12)
 #define RT711_HP_JD_SEL_JD1 (0x0 << 1)
 #define RT711_HP_JD_SEL_JD2 (0x1 << 1)
+#define RT711_JD2_1PORT_TYPE_DECODE (0x3 << 10)
+#define RT711_JD2_1PORT_JD_LINE2 (0x0 << 10)
+#define RT711_JD2_1PORT_JD_HP (0x1 << 10)
+#define RT711_JD2_1PORT_JD_LINE1 (0x2 << 10)
+#define RT711_JD1_2PORT_TYPE_100K_DECODE (0x1 << 0)
+#define RT711_JD1_2PORT_JD_RESERVED (0x0 << 0)
+#define RT711_JD1_2PORT_JD_LINE1 (0x1 << 0)
+
+/* jack detect control 4 (0x0b)(NID:20h) */
+#define RT711_JD2_PAD_PULL_UP_MASK (0x1 << 3)
+#define RT711_JD2_PAD_NOT_PULL_UP (0x0 << 3)
+#define RT711_JD2_PAD_PULL_UP (0x1 << 3)
+#define RT711_JD2_MODE_SEL_MASK (0x3 << 0)
+#define RT711_JD2_MODE0_2PORT (0x0 << 0)
+#define RT711_JD2_MODE1_3P3V_1PORT (0x1 << 0)
+#define RT711_JD2_MODE2_1P8V_1PORT (0x2 << 0)
 
 /* CC DET1 (0x11)(NID:20h) */
 #define RT711_HP_JD_FINAL_RESULT_CTL_JD12 (0x1 << 10)
@@ -215,7 +240,9 @@ enum {
 enum rt711_jd_src {
 	RT711_JD_NULL,
 	RT711_JD1,
-	RT711_JD2
+	RT711_JD2,
+	RT711_JD2_100K,
+	RT711_JD2_1P8V_1PORT
 };
 
 int rt711_io_init(struct device *dev, struct sdw_slave *slave);


