Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E136A36A;
	Wed, 20 May 2026 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298013; cv=none; b=oD8HYVqhYqJabON4FxrWqORZm/ZLnXz4JAacARkZISYqlZ4FkS1fCdcf+A8BFEiTDpiVl3atthlypO6I40edTr8HySGKubZHcEFCAO4u0vPjdE0h5ThUA4l9M3/WZbdFlZFOZcPhmiT0AetEhLD8mzhTUcjN3p+zFvuXtMHVpJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298013; c=relaxed/simple;
	bh=U9p4HdZFlVUwb5vuBQv5qSMKYXrPko7RWMSUPrN+qlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaRKrw8YrYMEgX5K7g9pGcQYH/7aRPIe0JkpJSI7qGZf6N/sUI4o0tXEDvKwY2SY8QHM0Q9jfZn3TbhKyDbMhFqzlYFZlfeytpIpLOCxLc2uTOTgPj0xvPX49tTfsFqt4NQ1VKby+ejvXbWhTWOip3zQFwqr1fmPH4jc37oXBHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SrlE0aV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SrlE0aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9AE1F000E9;
	Wed, 20 May 2026 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298012;
	bh=3sERcYQqgSK9nUTAtdHj/P6FM8qmpfuLWiIAnsJ3U2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SrlE0aVDwWRSp56pTdNe2OTDCtaRav59BAjDCBj223ZsLfPmfmti7BRvHXoYBwIt
	 VBRduJJb1zGk2r/V6JrJR5BYVEw/ejzh3xi1CWyrQGGqDQXLaFKh9/5OZN5pJTJeAr
	 u7QaO3Txb47+U6GaBuR1kgBTcDCD32PWYmb2z5Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/957] ASoC: rockchip: rockchip_sai: Set slot width for non-TDM mode
Date: Wed, 20 May 2026 18:12:11 +0200
Message-ID: <20260520162139.921404750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6695349ee561e..b38c2cb81f807 100644
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



