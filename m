Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2706F178CE4;
	Mon, 12 Aug 2024 16:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479454; cv=none; b=tvozLqA6hBeFffqp10ThPkcfO1kx832Qa1mxgI1R2EzKRYK/RXPYUzBQCmvFP10ctZbXpUbQL1Vl9mQ2S+XW/R2UF98EAoma4l9IcATBAI7qbdvz2VEwqQJ3B5QXuZDPDZ0cSMeQ00ZOTzTzI97hn8L9JN0FkX55qTi7IHuiaaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479454; c=relaxed/simple;
	bh=Lx1tfoyf6jXYcyiZ0763Rg2argdq7Hu/u2HKgM0+U04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bv0ArM36IFXw4qmldGoAogLrnIWmfFF1Fpy3NyVBPL+CIKGRnfhuesKCMzxrj3LSxzgMU3pSY1EWlITZr5VjpexFG2mBp1iR073JyjZeif3ASqcyOKSB6aijnr3SbiAWPsL2bbfx4i72MqPRDK4JTl19gbk6QApudXFeMQzJAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u06rx9zD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u06rx9zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED15C32782;
	Mon, 12 Aug 2024 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479454;
	bh=Lx1tfoyf6jXYcyiZ0763Rg2argdq7Hu/u2HKgM0+U04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u06rx9zDJNrCi7vlr4saBr6IoPxBDo50bAS+YjVK+euuMvtyAhp/tTmzwj3eiwvd2
	 zHI5I2r7YWSfR8XLdDvTYsc6ddwxv05epv5HYED3+9du884D0o6XflldxWMng5nZly
	 1unEng8Od2YXpSHdOehtxumPaXBYNJrIztT+BqQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/189] ASoC: codecs: wsa883x: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:27 +0200
Message-ID: <20240812160135.646013670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 6801ac36f25690e14955f7f9eace1eaa29edbdd0 ]

Device has up to WSA883X_MAX_SWR_PORTS number of ports and the array
assigned to prop.sink_dpn_prop has 0..WSA883X_MAX_SWR_PORTS-1 elements.
On the other hand, GENMASK(high, low) creates an inclusive mask between
<high, low>, so we need the mask from 0 up to WSA883X_MAX_SWR_PORTS-1.

Theoretically, too wide mask could cause an out of bounds read in
sdw_get_slave_dpn_prop() in stream.c, however only in the case of buggy
driver, e.g. adding incorrect number of ports via
sdw_stream_add_slave().

Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240726-asoc-wcd-wsa-swr-ports-genmask-v1-5-d4d7a8b56f05@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index 5443a5c4100c0..2169d93989841 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1407,7 +1407,7 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 					WSA883X_MAX_SWR_PORTS))
 		dev_dbg(dev, "Static Port mapping not specified\n");
 
-	pdev->prop.sink_ports = GENMASK(WSA883X_MAX_SWR_PORTS, 0);
+	pdev->prop.sink_ports = GENMASK(WSA883X_MAX_SWR_PORTS - 1, 0);
 	pdev->prop.simple_clk_stop_capable = true;
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
-- 
2.43.0



