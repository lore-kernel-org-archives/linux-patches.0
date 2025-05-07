Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8931DDC23;
	Wed,  7 May 2025 18:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643726; cv=none; b=TsUU8L6/YWZDo7gapYAduofxhfggUcPVL7YWN6RXwoTnyY6iFMR2BataT3SAWLXzmTr6z053GQRBOOO9seb7CB82EXi20dXG6HriSqH5j/Ogb0KzAD7n5MTH77LvbOAlgzp7GxbWgEQ9cXtJUeY3BmUhnrCpgS1iCmh77wAMZ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643726; c=relaxed/simple;
	bh=RsTFy/kLqbKwIgWpyZZ3BgMpIBONR4QMnBa6FSBGtI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kau8b4EchfnsDnvGwc3cjq9BbgjuIXnesk4GQsMu8XEiIQA0yeh/eDD9on4Rci4yStKCtzSum+nx9Xv4YfJgJrADFb4+2xZERGjEqfLGsfg48qgBm5O6zr2rDPSgjpssEL/zk1b1qDOTKM4Bc3C5ZqHziCOGO2Y/vvDyRuV/nds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTDEMBtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTDEMBtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7875EC4CEE2;
	Wed,  7 May 2025 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643726;
	bh=RsTFy/kLqbKwIgWpyZZ3BgMpIBONR4QMnBa6FSBGtI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTDEMBtRHyQS3TI6qEVXomP5Hil5IbCeMaPNeSb7hStoGHdvXwNQCoej9ipM3pZAw
	 fDtoqfcWA47jRRDQBrvEXy6wkyop2qerBHVR03lf+0FJzzZQlTwfoXOQeJV5SLsIih
	 RFydO7aqRg5wjm83Z7cw4XU6fC3TjxuyiQXf3DAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 96/97] ASoC: Use of_property_read_bool()
Date: Wed,  7 May 2025 20:40:11 +0200
Message-ID: <20250507183810.841684350@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 69dd15a8ef0ae494179fd15023aa8172188db6b7 ]

Use of_property_read_bool() to read boolean properties rather than
of_get_property(). This is part of a larger effort to remove callers
of of_get_property() and similar functions. of_get_property() leaks
the DT property data pointer which is a problem for dynamically
allocated nodes which may be freed.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20240731191312.1710417-20-robh@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6eab70345799 ("ASoC: soc-core: Stop using of_property_read_bool() for non-boolean properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4613.c | 4 ++--
 sound/soc/soc-core.c      | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/ak4613.c b/sound/soc/codecs/ak4613.c
index f75c19ef35511..3f790d1f11a94 100644
--- a/sound/soc/codecs/ak4613.c
+++ b/sound/soc/codecs/ak4613.c
@@ -840,14 +840,14 @@ static void ak4613_parse_of(struct ak4613_priv *priv,
 	/* Input 1 - 2 */
 	for (i = 0; i < 2; i++) {
 		snprintf(prop, sizeof(prop), "asahi-kasei,in%d-single-end", i + 1);
-		if (!of_get_property(np, prop, NULL))
+		if (!of_property_read_bool(np, prop))
 			priv->ic |= 1 << i;
 	}
 
 	/* Output 1 - 6 */
 	for (i = 0; i < 6; i++) {
 		snprintf(prop, sizeof(prop), "asahi-kasei,out%d-single-end", i + 1);
-		if (!of_get_property(np, prop, NULL))
+		if (!of_property_read_bool(np, prop))
 			priv->oc |= 1 << i;
 	}
 
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 6a4101dc15a54..58e07296144e0 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3143,10 +3143,10 @@ unsigned int snd_soc_daifmt_parse_format(struct device_node *np,
 	 * SND_SOC_DAIFMT_INV_MASK area
 	 */
 	snprintf(prop, sizeof(prop), "%sbitclock-inversion", prefix);
-	bit = !!of_get_property(np, prop, NULL);
+	bit = of_property_read_bool(np, prop);
 
 	snprintf(prop, sizeof(prop), "%sframe-inversion", prefix);
-	frame = !!of_get_property(np, prop, NULL);
+	frame = of_property_read_bool(np, prop);
 
 	switch ((bit << 4) + frame) {
 	case 0x11:
@@ -3183,12 +3183,12 @@ unsigned int snd_soc_daifmt_parse_clock_provider_raw(struct device_node *np,
 	 * check "[prefix]frame-master"
 	 */
 	snprintf(prop, sizeof(prop), "%sbitclock-master", prefix);
-	bit = !!of_get_property(np, prop, NULL);
+	bit = of_property_read_bool(np, prop);
 	if (bit && bitclkmaster)
 		*bitclkmaster = of_parse_phandle(np, prop, 0);
 
 	snprintf(prop, sizeof(prop), "%sframe-master", prefix);
-	frame = !!of_get_property(np, prop, NULL);
+	frame = of_property_read_bool(np, prop);
 	if (frame && framemaster)
 		*framemaster = of_parse_phandle(np, prop, 0);
 
-- 
2.39.5



