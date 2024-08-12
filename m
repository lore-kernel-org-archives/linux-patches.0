Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B02183CD4;
	Mon, 12 Aug 2024 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480251; cv=none; b=nFfmcSa2xh7XoS7plUA9bsm2dTAxrSc18mPtzEpDTTxNGAKhpdUHkbSjBwYPvbBElpiDOHqbvysRhGkquN0YymKymkn/0c6i9yyNyCcQal2k0HXgkYA721Ac77LhBOxhsBBCD0C9FdfzJlQbsxx7dhvvBx2gHeFUSgYWFoTiTSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480251; c=relaxed/simple;
	bh=iVYWmTD0pOrNfGX4LuTNNf84we0jXgq16yz+H/udOaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEXor/y197SCTxfIfgz5yOQl7eEk0PC20kSdqx9TxbFjwUEmJsmZ+IrdHWHYj3Arv05ygpi0dAFZdj76ghsgi60EraONp6LkTMSa+Px5iGqBZ99iOSwvLwlfaN9LSA681t8C+dzszIpZSKX/O7Xw8c4zSS9Qug9vCJEUzevASYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0CyZyuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0CyZyuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D8FC4AF0C;
	Mon, 12 Aug 2024 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480251;
	bh=iVYWmTD0pOrNfGX4LuTNNf84we0jXgq16yz+H/udOaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0CyZyuU+50KyhQLu8pCDdVIqQqP/N5O4wDst+TsHrqzSfxS8nGQpT30v0iIW+3MA
	 wOg+wI0CJ+AtesF1k3Fxrc76TDOvn6wOjNUHYE6JZmnoHkU5FjNKhGRWc+87xBcdYZ
	 UVcCsWqcUe6fCcQ7zrENZsQHB2y0gIPIB88W3qaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 140/263] ASoC: codecs: wcd939x-sdw: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:21 +0200
Message-ID: <20240812160151.907370535@linuxfoundation.org>
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

[ Upstream commit 74a79977c4e1d09eced33e6e22f875a5bb3fad29 ]

Device has up to WCD939X_MAX_TX_SWR_PORTS (or WCD939X_MAX_RX_SWR_PORTS
for sink) number of ports and the array assigned to prop.src_dpn_prop
and prop.sink_dpn_prop has 0..WCD939X_MAX_TX_SWR_PORTS-1 elements.  On
the other hand, GENMASK(high, low) creates an inclusive mask between
<high, low>, so we need the mask from 0 up to WCD939X_MAX_TX_SWR_PORTS-1.

Theoretically, too wide mask could cause an out of bounds read in
sdw_get_slave_dpn_prop() in stream.c, however only in the case of buggy
driver, e.g. adding incorrect number of ports via
sdw_stream_add_slave().

Fixes: be2af391cea0 ("ASoC: codecs: Add WCD939x Soundwire devices driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240726-asoc-wcd-wsa-swr-ports-genmask-v1-3-d4d7a8b56f05@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd939x-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wcd939x-sdw.c b/sound/soc/codecs/wcd939x-sdw.c
index 8acb5651c5bca..392f4dcab3e09 100644
--- a/sound/soc/codecs/wcd939x-sdw.c
+++ b/sound/soc/codecs/wcd939x-sdw.c
@@ -1453,12 +1453,12 @@ static int wcd9390_probe(struct sdw_slave *pdev, const struct sdw_device_id *id)
 	pdev->prop.lane_control_support = true;
 	pdev->prop.simple_clk_stop_capable = true;
 	if (wcd->is_tx) {
-		pdev->prop.source_ports = GENMASK(WCD939X_MAX_TX_SWR_PORTS, 0);
+		pdev->prop.source_ports = GENMASK(WCD939X_MAX_TX_SWR_PORTS - 1, 0);
 		pdev->prop.src_dpn_prop = wcd939x_tx_dpn_prop;
 		wcd->ch_info = &wcd939x_sdw_tx_ch_info[0];
 		pdev->prop.wake_capable = true;
 	} else {
-		pdev->prop.sink_ports = GENMASK(WCD939X_MAX_RX_SWR_PORTS, 0);
+		pdev->prop.sink_ports = GENMASK(WCD939X_MAX_RX_SWR_PORTS - 1, 0);
 		pdev->prop.sink_dpn_prop = wcd939x_rx_dpn_prop;
 		wcd->ch_info = &wcd939x_sdw_rx_ch_info[0];
 	}
-- 
2.43.0



