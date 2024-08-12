Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424BF1891BB;
	Mon, 12 Aug 2024 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478905; cv=none; b=D/E6eVnn5JJK7dxq4IHncHfdIcv/GBU6Oz/PUNr/wOgiTGofasJRQAcpHbOm/IcP7HpM/czOLuxkNqk9uOp6L7ISeuCnJi++kkOi3sGFsqwy5lk5p618/e2nWaNQOz2xE6xjoWptQ0S9ipBtdTz7lIZrN67uRKIQhed/KBfGrvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478905; c=relaxed/simple;
	bh=KFzXYLvGD2t2N4hIj8TmwOgtDYB1gbXzTMOGBXhoC6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmjiMsOYkiBq23dqZc/qiiSIc6+LlVFgeH5EN6kN1o9AgjpQaRXsxvVjZNQyaGvHqjCh0A6oUOzusbyK9uKzRFlCYVC4E6UNOdXjFDxVhBLXo+B+qmqxakmXhqmQgW/V0s+ARF33GgY0kN2zfInll0wpS3umWmIpFLcpsmqAmKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zg4lN3oJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zg4lN3oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0062C32782;
	Mon, 12 Aug 2024 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478905;
	bh=KFzXYLvGD2t2N4hIj8TmwOgtDYB1gbXzTMOGBXhoC6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zg4lN3oJ+06bt26GCiRwOhz9gNqqyoiv7jP1b18AQy/y19XLHgS64FymH/Xif/eDQ
	 6jaI0f13ra4i6KpAZkAFY1GBTLFiRB2hQ6ZVC7zKSxNDDrhYi7cZY7ymK0CVXEBgts
	 dTXDLGHA3juvMB4nICeEcKXgU1urjCrlsUEp+9bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/150] ASoC: codecs: wsa881x: Correct Soundwire ports mask
Date: Mon, 12 Aug 2024 18:02:34 +0200
Message-ID: <20240812160127.993243694@linuxfoundation.org>
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
index 264ec05a3c675..054da9d2776cd 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1131,7 +1131,7 @@ static int wsa881x_probe(struct sdw_slave *pdev,
 	wsa881x->sconfig.frame_rate = 48000;
 	wsa881x->sconfig.direction = SDW_DATA_DIR_RX;
 	wsa881x->sconfig.type = SDW_STREAM_PDM;
-	pdev->prop.sink_ports = GENMASK(WSA881X_MAX_SWR_PORTS, 0);
+	pdev->prop.sink_ports = GENMASK(WSA881X_MAX_SWR_PORTS - 1, 0);
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
 	gpiod_direction_output(wsa881x->sd_n, 1);
-- 
2.43.0



