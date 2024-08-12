Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257CD18800D;
	Mon, 12 Aug 2024 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478902; cv=none; b=GRrRcGTgiqrROhfweWhmmg6fpfaglrJykGK/uNMtXtE2LdrEA3yXpGwa6wNz2QD091E0GkDNHIpoGwwneI2pn+j+eqrUk6KTxRE06Le/RRbcn0wiBn8qbdxrpQvDO++XwoA3DmPGXW+V56t28qThYHB4bybeJe9hIswWwRiuJTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478902; c=relaxed/simple;
	bh=LWj2aQXzUndy9ePQ7HUoZN0yx1BejGFZNpq9QqTlmYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz0K18pCm6gZYfUB6Uckiy8pdf+F09xVavcbjGIMJNV3oDsGH2eUkd+oPD8b/x9zHAnunN31vWxkANM2HLGKy4LY3NIaq7DP//tMaYwTZLaVRgfwRrcQIjwelLzkG2PzFKvZww6dtEXeDqooQPNflmZPjeFCjokJ4BG+aM2iTzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mj8I8vit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mj8I8vit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947EFC4AF0F;
	Mon, 12 Aug 2024 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478902;
	bh=LWj2aQXzUndy9ePQ7HUoZN0yx1BejGFZNpq9QqTlmYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mj8I8vitUYp35M1aKZ/GUjcAFAuNzd/04AIkHCF+M/y1mBLaot9bXOfaXWFrUglxr
	 S1QFcpLbDSX6kY7r1KjoUJvykgZIlXyVX5H20RCWsrK1VH5sgj7qVtikamEy3r/+2j
	 St8dYv9hj3jlGQMzwi/7n3NbaYGFYvNL/TyvG+Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/150] ASoC: codecs: wcd938x-sdw: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:33 +0200
Message-ID: <20240812160127.952874867@linuxfoundation.org>
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

[ Upstream commit 3f6fb03dae9c7dfba7670858d29e03c8faaa89fe ]

Device has up to WCD938X_MAX_SWR_PORTS number of ports and the array
assigned to prop.src_dpn_prop and prop.sink_dpn_prop has
0..WCD938X_MAX_SWR_PORTS-1 elements.  On the other hand, GENMASK(high,
low) creates an inclusive mask between <high, low>, so we need the mask
from 0 up to WCD938X_MAX_SWR_PORTS-1.

Theoretically, too wide mask could cause an out of bounds read in
sdw_get_slave_dpn_prop() in stream.c, however only in the case of buggy
driver, e.g. adding incorrect number of ports via
sdw_stream_add_slave().

Fixes: 16572522aece ("ASoC: codecs: wcd938x-sdw: add SoundWire driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240726-asoc-wcd-wsa-swr-ports-genmask-v1-2-d4d7a8b56f05@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wcd938x-sdw.c b/sound/soc/codecs/wcd938x-sdw.c
index 5b5b7c267a616..061c77d0cd45b 100644
--- a/sound/soc/codecs/wcd938x-sdw.c
+++ b/sound/soc/codecs/wcd938x-sdw.c
@@ -1252,12 +1252,12 @@ static int wcd9380_probe(struct sdw_slave *pdev,
 	pdev->prop.lane_control_support = true;
 	pdev->prop.simple_clk_stop_capable = true;
 	if (wcd->is_tx) {
-		pdev->prop.source_ports = GENMASK(WCD938X_MAX_SWR_PORTS, 0);
+		pdev->prop.source_ports = GENMASK(WCD938X_MAX_SWR_PORTS - 1, 0);
 		pdev->prop.src_dpn_prop = wcd938x_dpn_prop;
 		wcd->ch_info = &wcd938x_sdw_tx_ch_info[0];
 		pdev->prop.wake_capable = true;
 	} else {
-		pdev->prop.sink_ports = GENMASK(WCD938X_MAX_SWR_PORTS, 0);
+		pdev->prop.sink_ports = GENMASK(WCD938X_MAX_SWR_PORTS - 1, 0);
 		pdev->prop.sink_dpn_prop = wcd938x_dpn_prop;
 		wcd->ch_info = &wcd938x_sdw_rx_ch_info[0];
 	}
-- 
2.43.0



