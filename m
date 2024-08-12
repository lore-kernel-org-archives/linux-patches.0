Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318C2187868;
	Mon, 12 Aug 2024 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478915; cv=none; b=SaoaTjC58Ucbz0F6SaIS3yFvBAqHXW3NY5F3zgVr+63PyzKtrgqothmWRY/SoYLSRNtJM+wYCia6MPDmEmVVH+JsuSaP37eSmRhz93CuBxWcYk96LOIq0B2k54kKMhRWwRAR5sPgNf/QjoiGMPh7NnXZeyn3YhZC8n6p9LboSrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478915; c=relaxed/simple;
	bh=1LlMB0/qcvi7Wgbtz+9pAK8Im3o/odtgdsg308YUon4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFfmfNWNij3J64MD4a0ZtfAPxzPoKk01oOywVpVJznhTFxZDgPFGORT2vGTVgk5LTTZmfvS5llqDbKj85uk010a8BVnuPlG/BSaIMwjOcF6rrAo7XKeF92KIAgHrrRQ4C2P41muaY8CG00E0IqxZpyBtoUlAcG9VHw3eFOt5Pzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwpBIPwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwpBIPwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95229C32782;
	Mon, 12 Aug 2024 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478915;
	bh=1LlMB0/qcvi7Wgbtz+9pAK8Im3o/odtgdsg308YUon4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwpBIPwJX9U6a27tVkqXQLcbqrR1tpSShPgA4z+xuEGTRpBJtQziqC9Rb2M9q8o9W
	 x0rG/VilXWUX1GnHXRr1JA/sspuzfmz63iDbFN74HScSfMKc1RI7MwLlDm+YtoLA6v
	 LzFrurg/k9sNgrcemckZ0PMxeSCC4uI3U6N8djXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/150] ASoC: codecs: wsa883x: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:36 +0200
Message-ID: <20240812160128.071409499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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
index 908f3c5035721..f4b81ebab3537 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1418,7 +1418,7 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 					WSA883X_MAX_SWR_PORTS))
 		dev_dbg(dev, "Static Port mapping not specified\n");
 
-	pdev->prop.sink_ports = GENMASK(WSA883X_MAX_SWR_PORTS, 0);
+	pdev->prop.sink_ports = GENMASK(WSA883X_MAX_SWR_PORTS - 1, 0);
 	pdev->prop.simple_clk_stop_capable = true;
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
-- 
2.43.0



