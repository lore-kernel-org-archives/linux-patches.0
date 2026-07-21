Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38D411661;
	Tue, 21 Jul 2026 19:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661139; cv=none; b=B4v/e8wDiovz8XL2eyGlofFddYeC8tMSmQ8rJCFSfQVP0Qesrybjdq9YFxRu/QrozYfO2ou0GeW8XFRQHtCOyYQVaKwjUzMfn9AGQHF2AWmDnlwak2h6beh5qKc0pk6To8fAqx+YqHdS3pAFnpzD55I4xuVnQY6432uEUiniLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661139; c=relaxed/simple;
	bh=VKZqWV5jj/52ymd13ybXyg2Yp2ZBF2cP7JEiObGNOWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrWtfKUpcHfoF6nwmfd+dIgubChPMA+fS6t6D2kTQtW2b5A2E+8k/H7mqf/DFffpdmd0wCUrkN+X5D/zZrXcpope3KPbwOzqrpo3BkR+7YtXXQtzga8kbnVkxSGF708p0C54/IQpCt7wDakXdwAP0N+0OpCwdS0LjA5xqpjossY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/mm3GPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/mm3GPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505311F00A3D;
	Tue, 21 Jul 2026 19:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661137;
	bh=Fh3lVkc3H9sPhQ5eqgdx6ml1j/7WzoHzTTlvGY2ee0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/mm3GPPosSkEawjRHSLVcY5Tbwm+a2lu7aJ3tKPuZqgSduYGb36uE1R6B8Qx6DmJ
	 MlDqY+RNPvZXGpVZkhpsoki4HVcdgRGAU3qKG410W8mlZO9n9ipVMlpDjXSIgcKKlA
	 hh36pJB07aPL5AegaEsQNEVHeLSIyys2EdNjZzDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1201/2077] ASoC: cs530x: Fix expected MCLK rates for CS5302/4/8
Date: Tue, 21 Jul 2026 17:14:34 +0200
Message-ID: <20260721152621.138223855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit cf81b260916c92cf610c907d41627a175e86e37d ]

When this driver was first added, it accepted rates of 24.56 MHz and
22.572 MHz for the MCLK when PLL bypass is enabled.

These rates seem to have no basis in the datasheets and were thus replaced
with 45.1584 MHz and 49.152 MHz, respectively, in commit e7ab858390f2
("ASoC: cs530x: Correct MCLK reference frequency values").

While the new rates are indeed correct for the CS4xxx ICs[0][1][2][3],
they are incorrect for the CS530x ICs the driver was originally written to
support as the MCLK frequencies are halved there[4][5][6].

Fix this by checking against the correct type-appropriate rates.

While at it, drop the CS530X_SYSCLK_REF_* macros. They arguably confuse
more than they help, especially as they are not applicable to the
cs5302/4/8.

[0]: https://statics.cirrus.com/pubs/proDatasheet/CS4282P_DS1318F1.pdf
[1]: https://statics.cirrus.com/pubs/proDatasheet/CS4302P_DS1315F1.pdf
[2]: https://statics.cirrus.com/pubs/proDatasheet/CS4304P_DS1316F1.pdf
[3]: https://statics.cirrus.com/pubs/proDatasheet/CS4308P_DS1317F1.pdf
[4]: https://statics.cirrus.com/pubs/proDatasheet/CS5302P_DS1312F1.pdf
[5]: https://statics.cirrus.com/pubs/proDatasheet/CS5304P_DS1313F1.pdf
[6]: https://statics.cirrus.com/pubs/proDatasheet/CS5308P_DS1314F1.pdf

Fixes: 2884c29152c0 ("ASoC: cs530x: Support for cs530x ADCs")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260617-cs530x-mclk-v1-1-0215b5f1a0a4@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs530x.c | 29 ++++++++++++++++++++++++-----
 sound/soc/codecs/cs530x.h |  6 ------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/cs530x.c b/sound/soc/codecs/cs530x.c
index 18b5ff75feec4b..2c7e331359117c 100644
--- a/sound/soc/codecs/cs530x.c
+++ b/sound/soc/codecs/cs530x.c
@@ -1093,6 +1093,29 @@ static int cs530x_component_probe(struct snd_soc_component *component)
 	return 0;
 }
 
+static bool cs530x_mclk_freq_is_valid(struct cs530x_priv *cs530x,
+				      unsigned int freq)
+{
+	/*
+	 * All these chips support 48 kHz- and 44.1 kHz-related sample rates,
+	 * but they differ in what MCLK frequency is required for achieving
+	 * the sample rate.
+	 */
+	switch (cs530x->devtype) {
+	case CS4282:
+	case CS4302:
+	case CS4304:
+	case CS4308:
+		return freq == 49152000 || freq == 45158400;
+	case CS5302:
+	case CS5304:
+	case CS5308:
+		return freq == 24576000 || freq == 22579200;
+	}
+
+	return false;
+}
+
 static int cs530x_set_sysclk(struct snd_soc_component *component, int clk_id,
 			     int source, unsigned int freq, int dir)
 {
@@ -1101,11 +1124,7 @@ static int cs530x_set_sysclk(struct snd_soc_component *component, int clk_id,
 
 	switch (source) {
 	case CS530X_SYSCLK_SRC_MCLK:
-		switch (freq) {
-		case CS530X_SYSCLK_REF_45_1MHZ:
-		case CS530X_SYSCLK_REF_49_1MHZ:
-			break;
-		default:
+		if (!cs530x_mclk_freq_is_valid(cs530x, freq)) {
 			dev_err(component->dev, "Invalid MCLK source rate %d\n", freq);
 			return -EINVAL;
 		}
diff --git a/sound/soc/codecs/cs530x.h b/sound/soc/codecs/cs530x.h
index 1e2f6a7a589c19..18aa4dfd0c8607 100644
--- a/sound/soc/codecs/cs530x.h
+++ b/sound/soc/codecs/cs530x.h
@@ -200,12 +200,6 @@
 /* IN_VOL_CTL5 and OUT_VOL_CTL5 */
 #define CS530X_INOUT_VU			BIT(0)
 
-/* MCLK Reference Source Frequency */
-/* 41KHz related */
-#define CS530X_SYSCLK_REF_45_1MHZ	45158400
-/* 48KHz related */
-#define CS530X_SYSCLK_REF_49_1MHZ	49152000
-
 /* System Clock Source */
 #define CS530X_SYSCLK_SRC_MCLK		0
 #define CS530X_SYSCLK_SRC_PLL		1
-- 
2.53.0



