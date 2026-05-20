Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4A366048;
	Wed, 20 May 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295191; cv=none; b=F2Gn5OJG08Gi8g4VCVt3cr+gBWZCd3eJ/rNsN/O/TJWXvv+XDVbSJNQBlaeqJMCfj/rZKH0hF4Wkdh7l3sC58WDgfFguqNvOaulggC3GBQ2PSB5wuHSMuxhRV5xKc8scyPqA55lJVYdoCK9JkeKPrFZ6QqUYSWtunbAqopo9hQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295191; c=relaxed/simple;
	bh=l1/Htgo++woRsD2AgHMYcvDmvCdY06s1EGFNxLGxtf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4COQg+f/BsdUJFDrAXP2Xdj86gDgYb6/AlVWdOu9/VjF+j4nAuukVf6bnCA2PSrFc6gfI+zfva19J7g9yTZUR0brSjWWFNlnP4nZE/Llrx4+PBZMHgQ0Jzqz8Mqdm0DvPiGGNq+PyK4z9hHM0OmSVHKLU/mHv9MttbxuQgK8r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR9+8pS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR9+8pS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D991F000E9;
	Wed, 20 May 2026 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295190;
	bh=JgwAF5eSerWzZ0+IEQZNnvTYvqY1Wu0GR/O8NssDZV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sR9+8pS+vBRlBdHm4vZ+cEK8MdoExKL80cwHT0CrLXOpBLx/HC5xhs2Uf03KN+O9U
	 kjFTJbCFtWd1ml4bVXgE+zJU7zrNMd5cZmCdZKZ1E84wLfSX8OuHmyz82laU4vApam
	 GpK7uTdPmLasZuP/2gohdO01idgwGTpqeNGn4WAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0325/1146] ASoC: rockchip: rockchip_sai: Set slot width for non-TDM mode
Date: Wed, 20 May 2026 18:09:35 +0200
Message-ID: <20260520162155.553690229@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 8a6391ec669366cbe7bde92b468c561e8b309fd6 ]

Currently the slot width in non-TDM mode is always kept at the POR value
of 32 bits, regardless of the sample width, which doesn't work well for
some codecs such as NAU8822.

Set the slot width according to the sample width in non-TDM mode, which
is what other CPU DAI drivers do.

Tested on the following RK3576 configurations:
- SAI2 + NAU8822 (codec as the clock master), custom board
- SAI1 + ES8388 (codec as the clock master), RK3576 EVB1
- SAI2 + RT5616 (SAI as the clock master), FriendlyElec NanoPi M5

NAU8822 didn't work prior to this patch but works after the patch. Other
two configurations work both before and after the patch.

Fixes: cc78d1eaabad ("ASoC: rockchip: add Serial Audio Interface (SAI) driver")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/20260318-sai-slot-width-v1-1-1f68186f71e3@flipper.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_sai.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/rockchip/rockchip_sai.c b/sound/soc/rockchip/rockchip_sai.c
index 1bf614dbdf4d0..ed393e5034a49 100644
--- a/sound/soc/rockchip/rockchip_sai.c
+++ b/sound/soc/rockchip/rockchip_sai.c
@@ -628,6 +628,10 @@ static int rockchip_sai_hw_params(struct snd_pcm_substream *substream,
 
 	regmap_update_bits(sai->regmap, reg, SAI_XCR_VDW_MASK | SAI_XCR_CSR_MASK, val);
 
+	if (!sai->is_tdm)
+		regmap_update_bits(sai->regmap, reg, SAI_XCR_SBW_MASK,
+				   SAI_XCR_SBW(params_physical_width(params)));
+
 	regmap_read(sai->regmap, reg, &val);
 
 	slot_width = SAI_XCR_SBW_V(val);
-- 
2.53.0



