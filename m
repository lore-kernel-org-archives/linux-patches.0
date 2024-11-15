Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F363D2BB1B;
	Fri, 15 Nov 2024 06:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653876; cv=none; b=La0YhCd2+EQOJrvsSt3k/sHVGxN7SssHRhM8mK+I30SZXWoMMXIe4Q4Zbb7gB5s9YEN2syrfuoHGvSPgUxlBeq9y6p5rfvhAM86hcVPRrF8ZK4MG0X3UUgPCLA5XaF+hGyLcQWganjFivpVmZ8iXl1raSrmG3Y959zS9+NixrBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653876; c=relaxed/simple;
	bh=GYGj9J8/rqSZ3bHaBOp0Tf6k1Q6i6YG+UUbgz68m5oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNyYevSyt69vAbRwD40qqaSxpC3UOfZUnv76zqgkF+iG01ZGGkrClJfIUSZD7VtgrzZogApTydT8uQK8kC7J3lJpGZmbeYbJtgeedmly8IqX0v7auqXLetl1e2cS8k4Rb0U2CE9/TrgeaTexgT0z29h4pRBFBimoeLHp6JBR6Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGgiLsgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGgiLsgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77044C4CECF;
	Fri, 15 Nov 2024 06:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653875;
	bh=GYGj9J8/rqSZ3bHaBOp0Tf6k1Q6i6YG+UUbgz68m5oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGgiLsgWtxH/4yy5r70iPokWcS/k4Ox8fKogsvo4h+4YWSLXcVNsTLVMGTUpRfFgo
	 1Z1dnF8J4JsdkLLrYDczYvrw04uBgeH1C3SjFvB0t9EAf7CkThCA10cpl+tdG5Wx5z
	 SghpsuusV5aMQjkyXKkR7c7kWx04Zg6BBpU/NUIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/82] ASoC: stm32: spdifrx: fix dma channel release in stm32_spdifrx_remove
Date: Fri, 15 Nov 2024 07:38:05 +0100
Message-ID: <20241115063726.579261538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1bfa3b2ba9744..ef518cff84f28 100644
--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -948,7 +948,7 @@ static int stm32_spdifrx_remove(struct platform_device *pdev)
 {
 	struct stm32_spdifrx_data *spdifrx = platform_get_drvdata(pdev);
 
-	if (spdifrx->ctrl_chan)
+	if (!IS_ERR(spdifrx->ctrl_chan))
 		dma_release_channel(spdifrx->ctrl_chan);
 
 	if (spdifrx->dmab)
-- 
2.43.0



