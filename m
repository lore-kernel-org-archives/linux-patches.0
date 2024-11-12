Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD32B1CBE8F;
	Tue, 12 Nov 2024 10:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407735; cv=none; b=l9aiTPN7Rk2UHo8hupjhRbvV4j88f6zICWFfmAZ0hK3bYv0b1Zgz+TdCeo5a32GCvb17maswEUYAAoKDjyCnxqp3zMlacpcxr56gZiuALA1zVzcM244SJoL0xO9gHmlfbQh0QDDi9oy2iwHryNDDpCTQBrCdDcpfc6ObmeODm1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407735; c=relaxed/simple;
	bh=SM1gvg4niXJsid1yhhNhwha+9MHuUQyEU7PQnfLVp20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZQ7GcTPl7JYgA923CKCqD5YM3j5pMnIU90dHuDGfnakMWiLOqkuKzf3I6E0qFsctXV6e2ftqQg8H4jTEGE9ACXFvthF/k640Mr3iA9C9VyVKsralHj2K0mDaWtJqrxb45SVtXsPv1U3oamXKqpPfzJOgNiEc13iB1trGamg5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4MZfhaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4MZfhaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC584C4CECD;
	Tue, 12 Nov 2024 10:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407735;
	bh=SM1gvg4niXJsid1yhhNhwha+9MHuUQyEU7PQnfLVp20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4MZfhaRzUJritevTfWcmuC4TBNh2qNHtMLfAynp80E7h2Wakj1QZTnZQfd2dd+g+
	 83RWVLGpKylfyvAOzTz7UxO8NEImZBaNlGnXLZO+BURl54j8Y3+/qhwp65s8HqPDUL
	 JlcRauMO+4V6MzvBzwP+WsNgXQSODhaqdHwiEIN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/119] ASoC: stm32: spdifrx: fix dma channel release in stm32_spdifrx_remove
Date: Tue, 12 Nov 2024 11:21:07 +0100
Message-ID: <20241112101850.971058345@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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
index a359b528b26b7..4e17909d21267 100644
--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -943,7 +943,7 @@ static void stm32_spdifrx_remove(struct platform_device *pdev)
 {
 	struct stm32_spdifrx_data *spdifrx = platform_get_drvdata(pdev);
 
-	if (spdifrx->ctrl_chan)
+	if (!IS_ERR(spdifrx->ctrl_chan))
 		dma_release_channel(spdifrx->ctrl_chan);
 
 	if (spdifrx->dmab)
-- 
2.43.0



