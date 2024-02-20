Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E41446C9;
	Tue, 20 Feb 2024 21:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464845; cv=none; b=Qx4qAgx/lcGgS2J+frUpG1cYZlYV5XacamBuN1B2xtmfC0qvYPhu7SZJIuIQivjE4WW3QuqhzO3dCFICWM5KdqjT363vsq6CJPYPHyBUDOgXxb2cQ8d+Ck1jnHAXhrPaHXrMLS290Dw687bkJgTOewAkSG3GNt5AHD/3K09+QqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464845; c=relaxed/simple;
	bh=sEnLr223iC5Dwrz/m4Rn471Eg7woCm/G1kCgERpHD+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgoZfbhYJ5REdKagLpU8XBwZxGbRTLIhMOmczqlWG7/XPXzlbp/dRsUR7xwbGq9B/TTX9VqHu2VAgMsb+REghYQQ9eh/JCW7jdDlfPJ767LTwpVLN1DQxEJa5YeRf03/FcGUxt5wTDPVxWiAqsQ8tm12klSlKiQPJEdT/k274xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzC11+Ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzC11+Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A48C433F1;
	Tue, 20 Feb 2024 21:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464845;
	bh=sEnLr223iC5Dwrz/m4Rn471Eg7woCm/G1kCgERpHD+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzC11+CilnEMdbB0X5FSt2msXpF44wGgls0ItL2dBKIObQL502WsF0qKZ8soAChW1
	 k3FiqfylP24bbzusztZ6jjAw7zR0L9vPAGLw6d7435oPWWRfBjSIMn6VXuOttzESwC
	 SvMBk4ryQNaLSvsylMVOhvLdFTbPvAyG2BtJFjp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.7 154/309] ASoC: codecs: wcd938x: handle deferred probe
Date: Tue, 20 Feb 2024 21:55:13 +0100
Message-ID: <20240220205637.984431895@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 086df711d9b886194481b4fbe525eb43e9ae7403 upstream.

WCD938x sound codec driver ignores return status of getting regulators
and returns EINVAL instead of EPROBE_DEFER.  If regulator provider
probes after the codec, system is left without probed audio:

  wcd938x_codec audio-codec: wcd938x_probe: Fail to obtain platform data
  wcd938x_codec: probe of audio-codec failed with error -22

Fixes: 16572522aece ("ASoC: codecs: wcd938x-sdw: add SoundWire driver")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://msgid.link/r/20240117151208.1219755-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -3589,7 +3589,7 @@ static int wcd938x_probe(struct platform
 	ret = wcd938x_populate_dt_data(wcd938x, dev);
 	if (ret) {
 		dev_err(dev, "%s: Fail to obtain platform data\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	ret = wcd938x_add_slave_components(wcd938x, dev, &match);


