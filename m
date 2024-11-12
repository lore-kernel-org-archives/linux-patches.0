Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AC82101A9;
	Tue, 12 Nov 2024 10:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407144; cv=none; b=P0M3KSMxTwiQbVQVgIdHOG+TD9lIYL+iDC5TJAJ3oNtmeuhpENBNRPhojJPARqsUU1BJe70GIfZnWrCwUjYeyLaf6Ah3fc8k2SHY0IsbF2pkooRD9oEP4bhbSNSwc4Nvwmgvuq/aLPfxNkBYTpDe3g1vet+xyeS9slztWSqbWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407144; c=relaxed/simple;
	bh=PEcPCxYMj0FMP74FaQV6UGReU4l1Jtqc4jZY085IdfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw8wge9oT0Vl/woCweT110Fg8cE6tYuSun/NnRjfgTyfk6q8dhfsuzGTO/OA2GsCjYrlf5BTvWpt/CLmkabxC661xiy6X36jXnwC3EZiTLLHcjNnoRJ55bm2a5/eEGlE9crQnkFGuqtX+Pq93K89TE//HHmxk0Z/sGQuKOW7LqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deMC8/OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deMC8/OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08915C4CECD;
	Tue, 12 Nov 2024 10:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407144;
	bh=PEcPCxYMj0FMP74FaQV6UGReU4l1Jtqc4jZY085IdfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deMC8/OX45UNE5JEgbP3KMfEz8GULZJKoRYBLWfT5iRITvjLrXe0tBKUXOLWJusfD
	 b2B8X2E8vjNB8+8PcfNnczNtZYbgdk8WAkVN/cBMyIEmEFXo8dOhQd8Eg3lih7+t4B
	 tn+KJLC7CNYPpqvniByJwghsaa5NRjxHQan2XLIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/76] ASoC: stm32: spdifrx: fix dma channel release in stm32_spdifrx_remove
Date: Tue, 12 Nov 2024 11:20:57 +0100
Message-ID: <20241112101841.010797583@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit 9bb4af400c386374ab1047df44c508512c08c31f ]

In case of error when requesting ctrl_chan DMA channel, ctrl_chan is not
null. So the release of the dma channel leads to the following issue:
[    4.879000] st,stm32-spdifrx 500d0000.audio-controller:
dma_request_slave_channel error -19
[    4.888975] Unable to handle kernel NULL pointer dereference
at virtual address 000000000000003d
[...]
[    5.096577] Call trace:
[    5.099099]  dma_release_channel+0x24/0x100
[    5.103235]  stm32_spdifrx_remove+0x24/0x60 [snd_soc_stm32_spdifrx]
[    5.109494]  stm32_spdifrx_probe+0x320/0x4c4 [snd_soc_stm32_spdifrx]

To avoid this issue, release channel only if the pointer is valid.

Fixes: 794df9448edb ("ASoC: stm32: spdifrx: manage rebind issue")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20241105140242.527279-1-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_spdifrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_spdifrx.c b/sound/soc/stm/stm32_spdifrx.c
index 48145f5535880..e3d6258afbac8 100644
--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -947,7 +947,7 @@ static int stm32_spdifrx_remove(struct platform_device *pdev)
 {
 	struct stm32_spdifrx_data *spdifrx = platform_get_drvdata(pdev);
 
-	if (spdifrx->ctrl_chan)
+	if (!IS_ERR(spdifrx->ctrl_chan))
 		dma_release_channel(spdifrx->ctrl_chan);
 
 	if (spdifrx->dmab)
-- 
2.43.0



