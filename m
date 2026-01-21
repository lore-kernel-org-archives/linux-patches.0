Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35A63358AF;
	Wed, 21 Jan 2026 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020012; cv=none; b=N0lMNXkJw5EeWU+fPX5L2w7I4r+L27JbQHWqNR2+U5MI1hQbp27UWLuvJ3ItOUJZlRBJ1sXTYwRrpP2Bui2zvCFRiZXEtQVeB/t7A4AQ7sLizYlmq6S4TdvYtN8TqP07UjWMBcLU917v34DWzmCFzl86iHCfuknqmsg0zKP68Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020012; c=relaxed/simple;
	bh=dp/Moi4iWgudOkgg2IO+iUebZ39JT0asOLn82pGfKXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6mvfHYgqXcFPCelRprqK2Tr5Q1r/tsZejgFw8Q0wYw8MiE3n1brPz9ABmgYXXrMEE7T3srDgiQ09WrSCQVZp/w7LiBoaM+aOxR3leEWAzcDNvOcS3p0haV3z78q0vDTUC9WZADGMofN3VDCXB/h9LPNkuH06MhnrStLhgPuf0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbRtG+Ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbRtG+Ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46687C4CEF1;
	Wed, 21 Jan 2026 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020011;
	bh=dp/Moi4iWgudOkgg2IO+iUebZ39JT0asOLn82pGfKXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbRtG+UaqIQAOekPBcKg0gIddIhAnoj+FThQUceubUdoIScE4aevZPNtKRPegPRLc
	 31YZBJvRJyaVN7SKxNpCt9bvW65+2m44W3JYbG+riVEfFHyYxfETuBvw8pTGnPgPcJ
	 N1PB81CFSdMLiFEMzbQZP5OnAE16xC9KJveCYw9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 008/198] ASoC: codecs: wsa883x: fix unnecessary initialisation
Date: Wed, 21 Jan 2026 19:13:56 +0100
Message-ID: <20260121181418.844964413@linuxfoundation.org>
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

commit 49aadf830eb048134d33ad7329d92ecff45d8dbb upstream.

The soundwire update_status() callback may be called multiple times with
the same ATTACHED status but initialisation should only be done when
transitioning from UNATTACHED to ATTACHED.

This avoids repeated initialisation of the codecs during boot of
machines like the Lenovo ThinkPad X13s:

[   11.614523] wsa883x-codec sdw:1:0:0217:0202:00:1: WSA883X Version 1_1, Variant: WSA8835_V2
[   11.618022] wsa883x-codec sdw:1:0:0217:0202:00:1: WSA883X Version 1_1, Variant: WSA8835_V2
[   11.621377] wsa883x-codec sdw:1:0:0217:0202:00:1: WSA883X Version 1_1, Variant: WSA8835_V2
[   11.624065] wsa883x-codec sdw:1:0:0217:0202:00:1: WSA883X Version 1_1, Variant: WSA8835_V2
[   11.631382] wsa883x-codec sdw:1:0:0217:0202:00:2: WSA883X Version 1_1, Variant: WSA8835_V2
[   11.634424] wsa883x-codec sdw:1:0:0217:0202:00:2: WSA883X Version 1_1, Variant: WSA8835_V2

Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Cc: stable@vger.kernel.org	# 6.0
Cc: Srinivas Kandagatla <srini@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260102111413.9605-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa883x.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -475,6 +475,7 @@ struct wsa883x_priv {
 	int active_ports;
 	int dev_mode;
 	int comp_offset;
+	bool hw_init;
 	/*
 	 * Protects temperature reading code (related to speaker protection) and
 	 * fields: temperature and pa_on.
@@ -1043,6 +1044,9 @@ static int wsa883x_init(struct wsa883x_p
 	struct regmap *regmap = wsa883x->regmap;
 	int variant, version, ret;
 
+	if (wsa883x->hw_init)
+		return 0;
+
 	ret = regmap_read(regmap, WSA883X_OTP_REG_0, &variant);
 	if (ret)
 		return ret;
@@ -1085,6 +1089,8 @@ static int wsa883x_init(struct wsa883x_p
 				   wsa883x->comp_offset);
 	}
 
+	wsa883x->hw_init = true;
+
 	return 0;
 }
 
@@ -1093,6 +1099,9 @@ static int wsa883x_update_status(struct
 {
 	struct wsa883x_priv *wsa883x = dev_get_drvdata(&slave->dev);
 
+	if (status == SDW_SLAVE_UNATTACHED)
+		wsa883x->hw_init = false;
+
 	if (status == SDW_SLAVE_ATTACHED && slave->dev_num > 0)
 		return wsa883x_init(wsa883x);
 


