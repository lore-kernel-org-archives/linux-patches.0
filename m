Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2A2F3C31;
	Wed, 28 Jan 2026 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614790; cv=none; b=XMsJTI5VUkh/kXSbMjrqJhziNr582q52i+UEhRICRdnE1IEwlQOh1yMC9U/J0XtPV3oOaCpAFoo42lQUhgBHF87etgEZNwQJozgKwOrLahaJXVNNsg0PXX5FTfdMOmlPtyCvpcylrMX0DgRMWKswQjxDLKyIfIMa5GszIZH06xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614790; c=relaxed/simple;
	bh=/QwkfbcgC8YELA5gj1/cN5rPIAk77Vd33Uo3wEHknks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYytOUKwt3Oii0Z+gMzifkphbQAYCa8e5XD1FrlvAROLS4SvmqJ1K8XTTUN5FRIG8J01Hqblc3qmT+KcagrRVowF7XC7MmabUBMJnXSzX4DoHonYR/OROmggXV6KtkC92VjErgr12AtNEHSpVP1bc7JWCtVKi2mrIoILzmleNT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fxv0yP20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fxv0yP20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA6BC4CEF1;
	Wed, 28 Jan 2026 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614790;
	bh=/QwkfbcgC8YELA5gj1/cN5rPIAk77Vd33Uo3wEHknks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fxv0yP20fV5dBAX2WK9fIaFTEpZA1gpRM/gzo7IkLWdfXIywSWTGBzM5jKjxYsEST
	 YIAfEHPwuJtBLAFGJH9mxdb+3sJyIsNHDwA5StEq4ztm9B8yeIuzEi3bnKsh7Ri42Z
	 Qr41SYfv4yqQJ/Jw0rJUrbBF3Fi0/SxRpapAh7YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/254] ASoC: codecs: wsa883x: fix unnecessary initialisation
Date: Wed, 28 Jan 2026 16:23:37 +0100
Message-ID: <20260128145353.467652544@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 49aadf830eb048134d33ad7329d92ecff45d8dbb ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa883x.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -444,6 +444,7 @@ struct wsa883x_priv {
 	int active_ports;
 	int dev_mode;
 	int comp_offset;
+	bool hw_init;
 };
 
 enum {
@@ -1003,6 +1004,9 @@ static int wsa883x_init(struct wsa883x_p
 	struct regmap *regmap = wsa883x->regmap;
 	int variant, version, ret;
 
+	if (wsa883x->hw_init)
+		return 0;
+
 	ret = regmap_read(regmap, WSA883X_OTP_REG_0, &variant);
 	if (ret)
 		return ret;
@@ -1046,6 +1050,8 @@ static int wsa883x_init(struct wsa883x_p
 				   wsa883x->comp_offset);
 	}
 
+	wsa883x->hw_init = true;
+
 	return 0;
 }
 
@@ -1054,6 +1060,9 @@ static int wsa883x_update_status(struct
 {
 	struct wsa883x_priv *wsa883x = dev_get_drvdata(&slave->dev);
 
+	if (status == SDW_SLAVE_UNATTACHED)
+		wsa883x->hw_init = false;
+
 	if (status == SDW_SLAVE_ATTACHED && slave->dev_num > 0)
 		return wsa883x_init(wsa883x);
 


