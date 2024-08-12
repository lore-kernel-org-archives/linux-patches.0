Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78B918454D;
	Mon, 12 Aug 2024 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479591; cv=none; b=MKLhHu+B8meQd0iB9mQoecpRTh8vSGTWs3eTJAsN0xuzzKemOV/RWGxGsMyZEm4x2LRj5DH73pU/WjUkNPeVJnWzxIzivNgVx49fJ16N30BlgCl/sSLRuuVkUAJqQLf1K7uECMz6ra75lCopc1b1+xs/oKjmCR1KBIRo5GQvG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479591; c=relaxed/simple;
	bh=X4JaAPJXwFYFO4fiz6QD4+A4LCEWvnHIzaCJ13J8ivY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twfphulZ4VU7kR4APygFG2qLOuhJ5Ofq3BTHSo/LkpqqiHJVcEvGKbquw2k2lqDssmKAfqvM7B6Riswdm6+amOLvXi9MbUjg8sJKUd6s4xi4/4lsUSL85iyWQS1kHdT8QrQe7PeoQk6l/JbC734WbdvhJIBJqoLR7eBl5JPrjYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVhlyiBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVhlyiBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EACFC32782;
	Mon, 12 Aug 2024 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479591;
	bh=X4JaAPJXwFYFO4fiz6QD4+A4LCEWvnHIzaCJ13J8ivY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVhlyiBnQ51gumkFI30WL3HuIVBuHyNQrmkYMI8hf4thfo4VjkGrR+wIgJ/n1P433
	 NtlnC+mE0Rvk7iuaQ6bT8zkf/OmuNhaX8uWPU4WYhAb2oSBYIyCj8b/BXZpl2OGot8
	 TDbzdAB0nGkO/BuRqf4dV07I7wTP70VSZquB1VXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/189] ASoC: codecs: wsa884x: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:29 +0200
Message-ID: <20240812160135.723976247@linuxfoundation.org>
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

[ Upstream commit dcb6631d05152930e2ea70fd2abfd811b0e970b5 ]

Device has up to WSA884X_MAX_SWR_PORTS number of ports and the array
assigned to prop.sink_dpn_prop has 0..WSA884X_MAX_SWR_PORTS-1 elements.
On the other hand, GENMASK(high, low) creates an inclusive mask between
<high, low>, so we need the mask from 0 up to WSA884X_MAX_SWR_PORTS-1.

Theoretically, too wide mask could cause an out of bounds read in
sdw_get_slave_dpn_prop() in stream.c, however only in the case of buggy
driver, e.g. adding incorrect number of ports via
sdw_stream_add_slave().

Fixes: aa21a7d4f68a ("ASoC: codecs: wsa884x: Add WSA884x family of speakers")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20240726-asoc-wcd-wsa-swr-ports-genmask-v1-6-d4d7a8b56f05@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index ed8110511a5b1..1cd52fab7b40d 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -1866,7 +1866,7 @@ static int wsa884x_probe(struct sdw_slave *pdev,
 					WSA884X_MAX_SWR_PORTS))
 		dev_dbg(dev, "Static Port mapping not specified\n");
 
-	pdev->prop.sink_ports = GENMASK(WSA884X_MAX_SWR_PORTS, 0);
+	pdev->prop.sink_ports = GENMASK(WSA884X_MAX_SWR_PORTS - 1, 0);
 	pdev->prop.simple_clk_stop_capable = true;
 	pdev->prop.sink_dpn_prop = wsa884x_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
-- 
2.43.0



