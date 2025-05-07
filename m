Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2778628BA9F;
	Wed,  7 May 2025 19:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645107; cv=none; b=mHFAA2e9ycSLCKp7QpzycBb6XHk0tvpXKGBKRSHcEcGMuLM8Ow02Qr1E4o8Ht395S2Jq4OLjKoaN8meDzkfXnrQmCjgIy4yg7FUv6Q34OFeOqo6WiOh+LPLWPH2C1c0Oowrus7tfkx00qAV7wiZA2SHoUZsqcrbaPExZudXP9ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645107; c=relaxed/simple;
	bh=X79Ocf4eOt2Z+0B9K6jf+q9YDyYuYglQqT15brtlwXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m45jcJ8D0HuoUr10pdd/1AMeeScfwYAAt4r2RKvPLOiroXE+7SPTT1rqCXotj2uyvdNoexfzG8vzHvLLRFtspa1voxA7B2dTSeamIgu+vNLlgG4hzhfHvXzdAjPw7W4/X1FlqaiHgrSRxCVZYKYhgbjthluK1oJrfKVyp7gC24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdRyjL1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdRyjL1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E28AC4CEE2;
	Wed,  7 May 2025 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645107;
	bh=X79Ocf4eOt2Z+0B9K6jf+q9YDyYuYglQqT15brtlwXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdRyjL1i9SB0yDoP+yf8AzqM8/JvfRjXaOb/NHEK/B/N7PaPZOZ5Z9bfCwKjgim7k
	 f+7L8eIvOI4+UNqsmeLkdG2Z2TrKDO/t6aPq+p4whyP3wgwlm/Cm5eE3l3pseMM7mY
	 gNztM5ohlWt6UF78BePnOJykd3ydIna+Jmgo4ysw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 096/129] ASoC: Use of_property_read_bool()
Date: Wed,  7 May 2025 20:40:32 +0200
Message-ID: <20250507183817.387633538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

commit 69dd15a8ef0ae494179fd15023aa8172188db6b7 upstream.

Use of_property_read_bool() to read boolean properties rather than
of_get_property(). This is part of a larger effort to remove callers
of of_get_property() and similar functions. of_get_property() leaks
the DT property data pointer which is a problem for dynamically
allocated nodes which may be freed.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20240731191312.1710417-20-robh@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/ak4613.c |    4 ++--
 sound/soc/soc-core.c      |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/ak4613.c
+++ b/sound/soc/codecs/ak4613.c
@@ -840,14 +840,14 @@ static void ak4613_parse_of(struct ak461
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
 
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3249,10 +3249,10 @@ unsigned int snd_soc_daifmt_parse_format
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
@@ -3289,12 +3289,12 @@ unsigned int snd_soc_daifmt_parse_clock_
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
 


