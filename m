Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006A323DE;
	Wed,  7 May 2025 19:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645110; cv=none; b=FLL1w1oYa9o63GLcpaPq0l4mZFFnsH1gZGLz+/m6NIz04e47RBd1cQkn6+YwdmBcXOe7W+w43IL3AnKtd3/MPCEjhonh5Jz2Bnf3wyoILjGBvXhMIz8yYQ/J7uC7Cw+9dGk0bl+Nq8B6jPt6jJYC7oJyJlq3gl1oOy/PB34lPBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645110; c=relaxed/simple;
	bh=+BhL9XeRcoh6oJFhGGQNL32KHNAuR75pFfjpAc6DG2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjQoyfjtrJkXkmmwy+boOTTqUIejd8RTQyfdr9DcrYca9Y8F1noyS7SMigQFp8+o3c/j837YLkJ5EE39wW7LmO5vyR7YdaEvdZRy0Lnty8iuouyClP+Xbp0eC9P+B0xmDQBQ7ugNu1vH9Nhssld4l9CT/ChdIrbp8PxyJmORTG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9lya3BT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9lya3BT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89136C4CEE2;
	Wed,  7 May 2025 19:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645109;
	bh=+BhL9XeRcoh6oJFhGGQNL32KHNAuR75pFfjpAc6DG2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9lya3BTH6sSMxp4LKrCSod+m8vge8UVWHVp+jlhfD0DK3ZUMJqh84AvW/51M4ct8
	 dPltWotetH4U7Iupc3rh+t5IT9lkLrHOQTx1dkuYWQ1cwm/tgC9473BIFgAnLZa1WC
	 XxjSj7vNBdrDs1qQC4S6SONASTMo60qlsBsOA6J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 097/129] ASoC: soc-core: Stop using of_property_read_bool() for non-boolean properties
Date: Wed,  7 May 2025 20:40:33 +0200
Message-ID: <20250507183817.427640763@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 6eab7034579917f207ca6d8e3f4e11e85e0ab7d5 upstream.

On R-Car:

    OF: /sound: Read of boolean property 'simple-audio-card,bitclock-master' with a value.
    OF: /sound: Read of boolean property 'simple-audio-card,frame-master' with a value.

or:

    OF: /soc/sound@ec500000/ports/port@0/endpoint: Read of boolean property 'bitclock-master' with a value.
    OF: /soc/sound@ec500000/ports/port@0/endpoint: Read of boolean property 'frame-master' with a value.

The use of of_property_read_bool() for non-boolean properties is
deprecated in favor of of_property_present() when testing for property
presence.

Replace testing for presence before calling of_property_read_u32() by
testing for an -EINVAL return value from the latter, to simplify the
code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/db10e96fbda121e7456d70e97a013cbfc9755f4d.1737533954.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-core.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2935,7 +2935,7 @@ int snd_soc_of_parse_pin_switches(struct
 	unsigned int i, nb_controls;
 	int ret;
 
-	if (!of_property_read_bool(dev->of_node, prop))
+	if (!of_property_present(dev->of_node, prop))
 		return 0;
 
 	strings = devm_kcalloc(dev, nb_controls_max,
@@ -3009,23 +3009,17 @@ int snd_soc_of_parse_tdm_slot(struct dev
 	if (rx_mask)
 		snd_soc_of_get_slot_mask(np, "dai-tdm-slot-rx-mask", rx_mask);
 
-	if (of_property_read_bool(np, "dai-tdm-slot-num")) {
-		ret = of_property_read_u32(np, "dai-tdm-slot-num", &val);
-		if (ret)
-			return ret;
-
-		if (slots)
-			*slots = val;
-	}
-
-	if (of_property_read_bool(np, "dai-tdm-slot-width")) {
-		ret = of_property_read_u32(np, "dai-tdm-slot-width", &val);
-		if (ret)
-			return ret;
+	ret = of_property_read_u32(np, "dai-tdm-slot-num", &val);
+	if (ret && ret != -EINVAL)
+		return ret;
+	if (!ret && slots)
+		*slots = val;
 
-		if (slot_width)
-			*slot_width = val;
-	}
+	ret = of_property_read_u32(np, "dai-tdm-slot-width", &val);
+	if (ret && ret != -EINVAL)
+		return ret;
+	if (!ret && slot_width)
+		*slot_width = val;
 
 	return 0;
 }
@@ -3289,12 +3283,12 @@ unsigned int snd_soc_daifmt_parse_clock_
 	 * check "[prefix]frame-master"
 	 */
 	snprintf(prop, sizeof(prop), "%sbitclock-master", prefix);
-	bit = of_property_read_bool(np, prop);
+	bit = of_property_present(np, prop);
 	if (bit && bitclkmaster)
 		*bitclkmaster = of_parse_phandle(np, prop, 0);
 
 	snprintf(prop, sizeof(prop), "%sframe-master", prefix);
-	frame = of_property_read_bool(np, prop);
+	frame = of_property_present(np, prop);
 	if (frame && framemaster)
 		*framemaster = of_parse_phandle(np, prop, 0);
 


