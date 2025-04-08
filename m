Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C198926B2B0;
	Tue,  8 Apr 2025 12:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116187; cv=none; b=IKOX5T8q6r3PxcTG0NWL76apH3GW0mgQ+pIgnCzo/l9jnnXOW2c1t0lJ808fitQlZhPd0VwV0y7KAS7XKdxO5CNp+XuPHn6/mJQJYpmoKurz0QcqrHhejeXpV57ioXE59ENGg/WxII7CqzlEamJtKNf26F8Rkjo3pt1GzLjRjcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116187; c=relaxed/simple;
	bh=BVA6cM9rTRsZcDIWOpJCql2da4eXXcWqWPBiHyjsI5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQttwE16KmtbiE8YjD2lzSC9EujWpoFbULfUAOKccCfTO/hRlo4yQWSwQicBKKS2l3aHLhq6G1dTZyAbYPopUeOSX3aJ/yozXqQ3+9MaGlnyxcHCOze9Cpo+O3jTzqEIyTWbVp4j6Dpe+IailDG91B/9M6A2mTPF1Tzul4zcBjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Md2IlDMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Md2IlDMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51400C4CEE5;
	Tue,  8 Apr 2025 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116187;
	bh=BVA6cM9rTRsZcDIWOpJCql2da4eXXcWqWPBiHyjsI5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Md2IlDMMN0erwgq317jWK9AZfM8/NWHMZD/mjdvdhZ8jnN7OZM8ESLO49L4g2pwZ5
	 Nen+TR+J5S/ObH+hixI9YEl+E9DUSusJlvnGW4lonn1PL/Khkse8hY7+vajs5OZHb/
	 goryg3Fho5gWfny+CvG7XZKkep2buM9ze5+Ux5rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/423] ASoC: ti: j721e-evm: Fix clock configuration for ti,j7200-cpb-audio compatible
Date: Tue,  8 Apr 2025 12:46:11 +0200
Message-ID: <20250408104846.799612277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 45ff65e30deb919604e68faed156ad96ce7474d9 ]

For 'ti,j7200-cpb-audio' compatible, there is support for only one PLL for
48k. For 11025, 22050, 44100 and 88200 sampling rates, due to absence of
J721E_CLK_PARENT_44100, we get EINVAL while running any audio application.
Add support for these rates by using the 48k parent clock and adjusting
the clock for these rates later in j721e_configure_refclk.

Fixes: 6748d0559059 ("ASoC: ti: Add custom machine driver for j721e EVM (CPB and IVI)")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://patch.msgid.link/20250318113524.57100-1-j-choudhary@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/j721e-evm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/ti/j721e-evm.c b/sound/soc/ti/j721e-evm.c
index d9d1e021f5b2e..0f96cc45578d8 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -182,6 +182,8 @@ static int j721e_configure_refclk(struct j721e_priv *priv,
 		clk_id = J721E_CLK_PARENT_48000;
 	else if (!(rate % 11025) && priv->pll_rates[J721E_CLK_PARENT_44100])
 		clk_id = J721E_CLK_PARENT_44100;
+	else if (!(rate % 11025) && priv->pll_rates[J721E_CLK_PARENT_48000])
+		clk_id = J721E_CLK_PARENT_48000;
 	else
 		return ret;
 
-- 
2.39.5



