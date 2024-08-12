Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610D4136348;
	Mon, 12 Aug 2024 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479441; cv=none; b=LY+TMK+ef3ddhwK1cZ47EIhmy2uCZ3nT+QjUDA8hd/nrenKIRWuAyYs9qNhjo4pEJjXufMLVQQh+EpGQZpd1+uqx1EUGwVTBk0/jICWyHYgQAD8z6YJCJmotdBIKGDCM8MOmM3iZbJNx8Hy0hivhzDRJ44fePZTt0sn/T/p5WSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479441; c=relaxed/simple;
	bh=1C2hRXP27CKQBrNg1b+kSGQxfvL2E/NgQLRqAbhaQvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE4bJob68L91E0OHeUphmrpknOGYGOc9iEoCKl+4NAJbtymcXGF7WrHnt6VTqdvyHrkL5cqQZwTT850UbdQp+yG4JHLF/zBc8RHv4yRU2LjsEYvWhlWKQ4QF2KU+lpX154lqoTgN8FKe1A9ljEYsF1TU5ihdHE6tUwtytZKwQKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T49OZFnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T49OZFnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF906C32782;
	Mon, 12 Aug 2024 16:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479441;
	bh=1C2hRXP27CKQBrNg1b+kSGQxfvL2E/NgQLRqAbhaQvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T49OZFnbR0PWVz1pQhbgEOfcNL6Y5G1AKEkacdjWqIJ9ISaGXPMZJBOFdZ7hcCNkX
	 yNcRoXD70cYxwGcE7QBfp1ANfZC6Qp/J5sPCqJFhVJzovRiYyFdwa8vcVCZqRgZ0Jt
	 8Eo06mgL9qrIAevBc87kYEqdgROeqCAD8F1Hl0tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/189] ASoC: codecs: wcd938x-sdw: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:24 +0200
Message-ID: <20240812160135.529594373@linuxfoundation.org>
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



