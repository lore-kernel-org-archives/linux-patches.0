Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9493C1509BF;
	Tue, 20 Feb 2024 21:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462968; cv=none; b=WkPlLFrXrEae+9nekA1TYFA4yd3Z4kE0Ota7KKW0mD/gJ3VW6+VfoSazrVq9pD2RcsHxSxbK8c/xMpAPQkvFPuX+dTuJ9AWtMt0kdnmrxEJNlc1W8SdK7NlLJYSCM7znMSeTPVKg/MYWiu90SvIhV+PXKF5P12o5nIGIgUA3xLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462968; c=relaxed/simple;
	bh=ji8/C1G8nuF0pWGNlrLWgbX8KugLnv8pDU79I8iOq8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVU5cCjktVU8tmAu6yRdlWycGJAA9ek5O4UXsUfMyTwQ/sH5D74Iqn6g0sFR2jWGtbxuj77Qs46lhKGHNy0s9Ye4xp26pmdejaiSGZWTD/CvAy/Fsa/7c+g/QaDZ8Ms9LihDgsx2wcY09WgYw65sv+XPnAOZaZCMyp3oUDtyOgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iITBoiS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iITBoiS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03286C433C7;
	Tue, 20 Feb 2024 21:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462968;
	bh=ji8/C1G8nuF0pWGNlrLWgbX8KugLnv8pDU79I8iOq8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iITBoiS6ypOd2TXkT2DUuySOhj5D02FCk+EVgFjQRo7fMKFJa7KawqN+j33sMnQ7T
	 2kw1vJd4ejSLqk3f7iw9sARdRninY04QsDcGAEUm1cDH2qSkN1pVpkxR1apVeVVgth
	 jsD9K+mKZYwT+l8ukVX+r0Aed8rZ8sDoiUacM7K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 093/197] ASoC: codecs: wcd938x: handle deferred probe
Date: Tue, 20 Feb 2024 21:50:52 +0100
Message-ID: <20240220204843.869394429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3588,7 +3588,7 @@ static int wcd938x_probe(struct platform
 	ret = wcd938x_populate_dt_data(wcd938x, dev);
 	if (ret) {
 		dev_err(dev, "%s: Fail to obtain platform data\n", __func__);
-		return -EINVAL;
+		return ret;
 	}
 
 	ret = wcd938x_add_slave_components(wcd938x, dev, &match);


