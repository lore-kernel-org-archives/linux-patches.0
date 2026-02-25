Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB02701B8;
	Wed, 25 Feb 2026 01:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983664; cv=none; b=Aa1SQsnICcUIrOsYRoaTIf+O5LEBlWqvXcRm6eB5G1JOS0v3lMyiicQfSAHQjcaCvyiU5q2qTj2mFSgHbLzrImLzavx4v5Iu4/gUcfqw/Mur8x/FGE2FhxBrBcskJ07XLRFQ3/W1lQO4Cz3ZY9lMLOpZ7SKyNlmXlS8xOH7MCac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983664; c=relaxed/simple;
	bh=p7qo+K8iRIKq4ocrvzPIllFQIGVqNYnuBk2tIjJmfUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCmRyHplU8EC4M57c+vtPSVlTGliFlgctuLdg19xTaVFk2HCjdzxHgNdk5Klotaz/NmwcMvRpGAD1IlAMQ05pOijMC6Z4NAUPC5ShBROJlXD3guhpivT/f2pVEGflGnQn87J06FsqbJz2j2eFO4khoZPYAkJ7m/voKHwN92b+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwsKyoqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwsKyoqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE17CC116D0;
	Wed, 25 Feb 2026 01:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983664;
	bh=p7qo+K8iRIKq4ocrvzPIllFQIGVqNYnuBk2tIjJmfUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwsKyoqssUCsB4XYoZXkHCjswYcK4gqf2dJhK2Jpbp/DsNVeHGfNT6YhsePYsU5sq
	 K/vefRZFjE2jN5aUmBa0EyULJm7AHtcdQgXL/bWOcQfqb4d6bP/kSDag2UosWPsheT
	 vDbmu4ht4uf5d2A0bgcHwuZnaaqu3itXt0SdppwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 743/781] ASoC: rockchip: i2s-tdm: Use param rate if not provided by set_sysclk
Date: Tue, 24 Feb 2026 17:24:12 -0800
Message-ID: <20260225012417.949531828@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit 0783052534f547f8f201dd4554b1df9f1f8615b5 ]

Drivers will not always call set_sysclk() for all clocks, especially when
default mclk-fs can be used.
When that is the case, use the clock rate set in the params multiplied by the
default mclk-fs.

Fixes: 5323186e2e8d ("ASoC: rockchip: i2s_tdm: Re-add the set_sysclk callback")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Reported-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260218201834.924358-1-detlev.casanova@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s_tdm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/rockchip/rockchip_i2s_tdm.c b/sound/soc/rockchip/rockchip_i2s_tdm.c
index 770b9bfbb384a..fc52149ed6ae3 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -22,6 +22,7 @@
 
 #define DRV_NAME "rockchip-i2s-tdm"
 
+#define DEFAULT_MCLK_FS				256
 #define CH_GRP_MAX				4  /* The max channel 8 / 2 */
 #define MULTIPLEX_CH_MAX			10
 
@@ -665,6 +666,15 @@ static int rockchip_i2s_tdm_hw_params(struct snd_pcm_substream *substream,
 			mclk_rate = i2s_tdm->mclk_rx_freq;
 		}
 
+		/*
+		 * When the dai/component driver doesn't need to set mclk-fs for a specific
+		 * clock, it can skip the call to set_sysclk() for that clock.
+		 * In that case, simply use the clock rate from the params and multiply it by
+		 * the default mclk-fs value.
+		 */
+		if (!mclk_rate)
+			mclk_rate = DEFAULT_MCLK_FS * params_rate(params);
+
 		err = clk_set_rate(mclk, mclk_rate);
 		if (err)
 			return err;
-- 
2.51.0



