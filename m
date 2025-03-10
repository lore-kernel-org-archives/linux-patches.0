Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CCF230D0F;
	Mon, 10 Mar 2025 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630520; cv=none; b=G622wa6hhPqwGobVUFXtg8GnK3f0d8VXPXNhEHp1VOmerDuRTc2XoKnx/Vt+yaQc/eE68uAbG3vCSAbY51I/PoToQnyHwWA8HYT6g7T5n5JnFShU87RBtpH7ehtIZWEUn1Hhmy8aPgHoUgfBWIeWrUZ2gumcC7dTMmeKmnqO9Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630520; c=relaxed/simple;
	bh=czVgeV/K4dbdUrTYh6yLn2IyPogjjqRa0IKDH/y9hF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY4gsc28FMioRu1TQRHWpavISAv1GodEhPIMqKd7qkqy1VPSpEKYRIq1I9wy9ptNRXIjr/KQDpFpXaNpONRkjdm8JU6CF4lqBWbDDL28OuAyt0r4N1JFQpPaFlgFiZL82Et0iU7uJjf4bT1CXhis5mfzDhf8ctRaQwY1cHlLIjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMkX++0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMkX++0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68256C4CEE5;
	Mon, 10 Mar 2025 18:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630519;
	bh=czVgeV/K4dbdUrTYh6yLn2IyPogjjqRa0IKDH/y9hF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMkX++0SR1sSYCdHsedonE+jWX2s7I8kyxvJ/3W1JaCKAh0DLaFkOd3dPPEwUxomC
	 RmogcRIn0poM5ZH7kgrytYAkeBNfOdM/Gf+isJXIa2+O0VthD/TVxZj8llcE9b1Pw2
	 cwJRvP+T/xgCxM01DhPhji1H2i+53qKO9Zc6DTIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 442/620] ASoC: renesas: rz-ssi: Add a check for negative sample_space
Date: Mon, 10 Mar 2025 18:04:48 +0100
Message-ID: <20250310170603.045175368@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 82a0a3e6f8c02b3236b55e784a083fa4ee07c321 ]

My static checker rule complains about this code.  The concern is that
if "sample_space" is negative then the "sample_space >= runtime->channels"
condition will not work as intended because it will be type promoted to a
high unsigned int value.

strm->fifo_sample_size is SSI_FIFO_DEPTH (32).  The SSIFSR_TDC_MASK is
0x3f.  Without any further context it does seem like a reasonable warning
and it can't hurt to add a check for negatives.

Cc: stable@vger.kernel.org
Fixes: 03e786bd4341 ("ASoC: sh: Add RZ/G2L SSIF-2 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/e07c3dc5-d885-4b04-a742-71f42243f4fd@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 9ef7d0a12d985..b6a7011b4e3b1 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -487,6 +487,8 @@ static int rz_ssi_pio_send(struct rz_ssi_priv *ssi, struct rz_ssi_stream *strm)
 	sample_space = strm->fifo_sample_size;
 	ssifsr = rz_ssi_reg_readl(ssi, SSIFSR);
 	sample_space -= (ssifsr >> SSIFSR_TDC_SHIFT) & SSIFSR_TDC_MASK;
+	if (sample_space < 0)
+		return -EINVAL;
 
 	/* Only add full frames at a time */
 	while (frames_left && (sample_space >= runtime->channels)) {
-- 
2.39.5



