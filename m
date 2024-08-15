Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475941A01AE;
	Thu, 15 Aug 2024 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730433; cv=none; b=RoDT4fFnXR5JPlHHMaMvO81QpzHBjPnmJY0QlbGWSOhR7xDT0vNfkAG22GZzhPbHg+XPksyPih4BKCRWbKIHyjeh35Xzf3JHisBThffUBaEPW+p2o1ZBSlP8u38RCVCsh1I500SSwCQ0WhjQo27p1NyxKXo94xt4UExcumdOwY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730433; c=relaxed/simple;
	bh=3SFwlXMR3lKI22JbRlz2ldPHCACfIu7/oNzLICwTEfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx/1QhhSbBv/clH3EBUAcxXjbGi1Fdd5yGmHJDe5HUbqGMmNT5TQQKRKFv01tMsFQ2sz6S8Lb9JJrvOs5oK0kSA+KjZzV+z0oru0PdJYeRaL1wqVvoa9oA77kfCkKsIDniajrf3EDtKm/fF5eNXMzIlfiEE9N0z15p9kGt3etLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZDfk6q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZDfk6q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CD2C4AF0D;
	Thu, 15 Aug 2024 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730433;
	bh=3SFwlXMR3lKI22JbRlz2ldPHCACfIu7/oNzLICwTEfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZDfk6q0o6rnKQmDGmKrOkt0WXEpPheU4e8JzxHn+D0GAd+S/QuwiW3AQWwBz9+Bw
	 OTCKwCRqAdpIpWRLAfGdLg0mYtd89lrHko+knsd9tvi2I2abwvHnnFet8sWynBM8p/
	 DG3lgA8VdP/O3/LKiA7XUepkISJ0UyHfQ04VKELs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 407/484] ASoC: codecs: wcd938x-sdw: Correct Soundwire ports mask
Date: Thu, 15 Aug 2024 15:24:25 +0200
Message-ID: <20240815131957.171758866@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 84a67bd98dc05..cfe694fddd139 100644
--- a/sound/soc/codecs/wcd938x-sdw.c
+++ b/sound/soc/codecs/wcd938x-sdw.c
@@ -250,12 +250,12 @@ static int wcd9380_probe(struct sdw_slave *pdev,
 					SDW_SCP_INT1_PARITY;
 	pdev->prop.lane_control_support = true;
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



