Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9063A3B8BA8;
	Wed, 21 Jan 2026 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020335; cv=none; b=ESLHHYi2KMa9kG16r2NCCPqnmlwwbEJhJNuheiuGpgUrWgtOXlrtdjXtA0lgh+/QxuuKImEKYo5943gndBhzQ+VTsUI1t8HlZ1QcG/6HzHXR2af+N3pKS0FaFr3EwT4r8Ww1CTrwEtNqDcTRk3X86/Ew2SHCGhveyvka5jEK0TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020335; c=relaxed/simple;
	bh=6sR+P3dSEuOlOuHat3I3EDWb8is42nvh4EVOAWQWAXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/A2GSj/lUsVjDw0fMTgt9lRtITzi0e7h+ryERnHCw5e0nGN9n3xBMLRJQIS1RrRlt0TtUo1zhQw0AwlPq6H7e+A4B+y9ysyCa5XWOcd/1k9igEQ8dI9iLhL8b3tnLajAuflJnpd9FXdh17FiNfMU1rcxCL1Ble31TF+itmhiOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECVuws/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECVuws/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DE8C16AAE;
	Wed, 21 Jan 2026 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020335;
	bh=6sR+P3dSEuOlOuHat3I3EDWb8is42nvh4EVOAWQWAXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECVuws/uctADB4RtOL6xXqRG7+gyIkbKUGDVGPqFxKF9Xww2inlG8g6KQT81NSCVQ
	 e3W5orLcVJQlQ06NmFwdQLGjPpdJ1QTyiAQ/OuhkPGNlIF6bIax/j7PHf8FnSDE1jf
	 BXN325aq5n08KcomGRfm1t6ZIehUdh79UvHYAcco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 127/198] ASoC: codecs: wsa881x: fix unnecessary initialisation
Date: Wed, 21 Jan 2026 19:15:55 +0100
Message-ID: <20260121181423.119473634@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 29d71b8a5a40708b3eed9ba4953bfc2312c9c776 upstream.

The soundwire update_status() callback may be called multiple times with
the same ATTACHED status but initialisation should only be done when
transitioning from UNATTACHED to ATTACHED.

Fixes: a0aab9e1404a ("ASoC: codecs: add wsa881x amplifier support")
Cc: stable@vger.kernel.org	# 5.6
Cc: Srinivas Kandagatla <srini@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260102111413.9605-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa881x.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -678,6 +678,7 @@ struct wsa881x_priv {
 	 */
 	unsigned int sd_n_val;
 	int active_ports;
+	bool hw_init;
 	bool port_prepared[WSA881X_MAX_SWR_PORTS];
 	bool port_enable[WSA881X_MAX_SWR_PORTS];
 };
@@ -687,6 +688,9 @@ static void wsa881x_init(struct wsa881x_
 	struct regmap *rm = wsa881x->regmap;
 	unsigned int val = 0;
 
+	if (wsa881x->hw_init)
+		return;
+
 	regmap_register_patch(wsa881x->regmap, wsa881x_rev_2_0,
 			      ARRAY_SIZE(wsa881x_rev_2_0));
 
@@ -724,6 +728,8 @@ static void wsa881x_init(struct wsa881x_
 	regmap_update_bits(rm, WSA881X_OTP_REG_28, 0x3F, 0x3A);
 	regmap_update_bits(rm, WSA881X_BONGO_RESRV_REG1, 0xFF, 0xB2);
 	regmap_update_bits(rm, WSA881X_BONGO_RESRV_REG2, 0xFF, 0x05);
+
+	wsa881x->hw_init = true;
 }
 
 static int wsa881x_component_probe(struct snd_soc_component *comp)
@@ -1067,6 +1073,9 @@ static int wsa881x_update_status(struct
 {
 	struct wsa881x_priv *wsa881x = dev_get_drvdata(&slave->dev);
 
+	if (status == SDW_SLAVE_UNATTACHED)
+		wsa881x->hw_init = false;
+
 	if (status == SDW_SLAVE_ATTACHED && slave->dev_num > 0)
 		wsa881x_init(wsa881x);
 


