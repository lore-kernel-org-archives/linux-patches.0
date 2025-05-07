Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57758211A2A;
	Wed,  7 May 2025 18:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643729; cv=none; b=d1CuQFfyEnHtmC5V17y/W+wjY4BG/ROLEX/E2iFAcw5iCdDj/Ay4hJ9tV8zUKABLxaw204qBaa0o5JyjwE4QZb7NNCVImarmJpMBX/sgHOsAOoR7FnxZeTLbwOLOUhjE7pzn23jbT8D0dRXIPPBGDIeYXFcFzNxZrrHVkTbiU4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643729; c=relaxed/simple;
	bh=obrMHVLtdKy3NhHssQo7B0my49V79BIrxziKj3h90Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1sKacFklQYpJbk0a7cPDSY2ohNb8xTQA7Pj7N1tp0lztXUgRR4ctclkQYlkQMIxx9bu2D8PwzqaDIRRoBCE3nnxC2inxoqzUORFVUSfH1HMbwz8OZ+Ez8+EKu7FKELtLNatyTMloASvY5EWmucUEQw1t1w6Yr77esN7i/bXQqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YwVOMLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YwVOMLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB43EC4CEE2;
	Wed,  7 May 2025 18:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643729;
	bh=obrMHVLtdKy3NhHssQo7B0my49V79BIrxziKj3h90Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YwVOMLt2o9EyiXRbjSUwjM5aPwiO/0f5DfBR18UXSJxVE0QV+iIoa8Kty3VyYJjq
	 1G+TQkYNPVkurSdtii3ER6gYtS09TXHx9WB8m4yuj6XEz+jkdlj79nzuZYMWvLNFJV
	 NH5/mjWz84sTRfZO9/D2m5AKvSMNzdwGNWoWeGPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 97/97] ASoC: soc-core: Stop using of_property_read_bool() for non-boolean properties
Date: Wed,  7 May 2025 20:40:12 +0200
Message-ID: <20250507183810.881645306@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6eab7034579917f207ca6d8e3f4e11e85e0ab7d5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 58e07296144e0..b13370d2ec1d7 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2837,7 +2837,7 @@ int snd_soc_of_parse_pin_switches(struct snd_soc_card *card, const char *prop)
 	unsigned int i, nb_controls;
 	int ret;
 
-	if (!of_property_read_bool(dev->of_node, prop))
+	if (!of_property_present(dev->of_node, prop))
 		return 0;
 
 	strings = devm_kcalloc(dev, nb_controls_max,
@@ -2911,23 +2911,17 @@ int snd_soc_of_parse_tdm_slot(struct device_node *np,
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
@@ -3183,12 +3177,12 @@ unsigned int snd_soc_daifmt_parse_clock_provider_raw(struct device_node *np,
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
 
-- 
2.39.5



