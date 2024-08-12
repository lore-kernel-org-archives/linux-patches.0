Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06F3183CD4;
	Mon, 12 Aug 2024 16:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480248; cv=none; b=kyf+AIfWapP25YXHT57fBeVuz802vvaxofpprO/YSpLtTueFy1HuotE/FRMN/x/OhI+WZTjLB/RMaXsolXoVOeqRtefaPCOMqpAY2m8Wehk18fHjyTj5hwbW0z8t/N2mRsBE90+epctqETB4A3+kzsTgJ0OjRT9P3ngsfckoDGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480248; c=relaxed/simple;
	bh=GzSeAd4yqBbyr7/WrfbhdmNlzLiUYYBQ2i15cXwFmUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndKuuFQcc3sothpRBhkUp/HsAZwH3LNIhdRgE0iZaETqqT+6ZlTxsl7l0yszhxc5f3m8Nvh3qb/JAdzuSK3njNxTShNMHVfLYWm/Vd+c/OdPjDZ9g7aLnbStMTE7lwm2mAem+n7P2BgrzTxoPLyHb7x5dBQRF8SxCS0hz6L7f+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8jwf4xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8jwf4xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592B3C32782;
	Mon, 12 Aug 2024 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480247;
	bh=GzSeAd4yqBbyr7/WrfbhdmNlzLiUYYBQ2i15cXwFmUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8jwf4xqA3hVn8Dt+XyllJKwE9Ct59GjkEm7SoZsYnxYlVLr/efW5ocYQOnAOGWH4
	 Nf+ho8JaaY5YBA0zkgKp+lylU7ClklDHAezZZW/erE6z7tYADao/fQfG1mGmvQmygQ
	 QwaMN6AKfnSuRCjz8gXx0GHz8Y/oAxN1EHOuooF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 139/263] ASoC: codecs: wcd938x-sdw: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:20 +0200
Message-ID: <20240812160151.869237751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a1f04010da95f..132c1d24f8f6e 100644
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



