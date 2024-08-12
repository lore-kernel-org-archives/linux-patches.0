Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68169183CD4;
	Mon, 12 Aug 2024 16:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480254; cv=none; b=r1JX65yivKhjER5GXK3C9gLwdL4nQ3uU+QoRQNtztkQpoT/+xm8ETRNWbXIQtxOKzH0ISsyC99VyInbLaOSB8yJ4JrZlnX7r/h0pW6vQFh5JQWBTAQaU2cilWcMhorbyZxjxzHiTOcznmtANVSIPI284KqvSBtRSLPStiGOa6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480254; c=relaxed/simple;
	bh=Duzijd12NhNAG5F20YSD4OqT7LR38E2EHei54m1jHac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRe9mHkhGzUTwoJknqIBqzD/CdqTBGPXVlDDPCWT/CP3CjJtIdOEdye8AwLuHeYVgf6gjeMq3Oy7mfn2P2ijl877fezf4LMfKrJxbKkdjVI/+muSiNke9nBssrBKnaCakHrCSZQO7KKiD2QUlx0nak01YTGD0d9kw4P+XvNUKGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WBvGpyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WBvGpyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BEFC32782;
	Mon, 12 Aug 2024 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480254;
	bh=Duzijd12NhNAG5F20YSD4OqT7LR38E2EHei54m1jHac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WBvGpyntjULOoGFHCmyFbV/SixJSApaK7p5u2LrD2LuQ4wDjyKecioAjcKjtL+rL
	 UDylkchK0Tuc9InIpAjp3Z67ImC/mgT/P+Z+95KZ+JdCu5rKEG0OO2/6EwY2tzBLLQ
	 oPEZFnDYMCm+u63CYyy0g4KYc0OU0XcRAZEDvHPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 141/263] ASoC: codecs: wsa881x: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:22 +0200
Message-ID: <20240812160151.945382700@linuxfoundation.org>
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

[ Upstream commit eb11c3bb64ad0a05aeacdb01039863aa2aa3614b ]

Device has up to WSA881X_MAX_SWR_PORTS number of ports and the array
assigned to prop.sink_dpn_prop has 0..WSA881X_MAX_SWR_PORTS-1 elements.
On the other hand, GENMASK(high, low) creates an inclusive mask between
<high, low>, so we need the mask from 0 up to WSA881X_MAX_SWR_PORTS-1.

Theoretically, too wide mask could cause an out of bounds read in
sdw_get_slave_dpn_prop() in stream.c, however only in the case of buggy
driver, e.g. adding incorrect number of ports via
sdw_stream_add_slave().

Fixes: a0aab9e1404a ("ASoC: codecs: add wsa881x amplifier support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240726-asoc-wcd-wsa-swr-ports-genmask-v1-4-d4d7a8b56f05@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa881x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index 1253695bebd86..53b828f681020 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1152,7 +1152,7 @@ static int wsa881x_probe(struct sdw_slave *pdev,
 	wsa881x->sconfig.frame_rate = 48000;
 	wsa881x->sconfig.direction = SDW_DATA_DIR_RX;
 	wsa881x->sconfig.type = SDW_STREAM_PDM;
-	pdev->prop.sink_ports = GENMASK(WSA881X_MAX_SWR_PORTS, 0);
+	pdev->prop.sink_ports = GENMASK(WSA881X_MAX_SWR_PORTS - 1, 0);
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
 	pdev->prop.clk_stop_mode1 = true;
-- 
2.43.0



