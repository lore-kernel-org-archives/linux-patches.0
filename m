Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C1B2210EA;
	Thu, 12 Dec 2024 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024994; cv=none; b=CZFIphsDXV4FqGlmRPu43ROWFIEHxc3TO80+4e8nII0XisKHpDLDViMDQ9ZIPrMQj5MK2ceTI/UlyngI889PFPbekk2zGTe1kG8uNzfvcP5k4uK7A2/jHrIWAy1mAP4PtMoJWYDu4KP/ynD74rD+i0XtJBBLHrHpgmxQSlguors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024994; c=relaxed/simple;
	bh=A+Lfo9vUOOUHs5Pl8R2OW7qa8QunSRcB69v6+jh6LJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXOoajte6HLT9AVjCfnTGWktFx/yALZ9ick0GMjssNE1WRiwp+Wi9+4U6Fj5z8RGu1qM3cFvJuEMdPYg4GfsHfu9/QaEIM561E/8XynlBEsikQev6/nCCmHrv+PoOmxZ0+BBJsj1jXDuyosIOi+VioUcA9dWMC8CAROK/pJTMyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtG6hvzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtG6hvzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93EBC4CECE;
	Thu, 12 Dec 2024 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024994;
	bh=A+Lfo9vUOOUHs5Pl8R2OW7qa8QunSRcB69v6+jh6LJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtG6hvzmxuSysl5tCstRztZ8dWZ7PTZVi84Vjo921uYjA8xSmC3LnskaLGKgfElqt
	 +fwpw0NclJFtbzby4fIPX54jpDXEBb2iDUnMsIVB9Dt5ilivXG01RM8WGFImRyMRNn
	 SGJDIKMUCcVW0jnhRnDFzHVBD1qFqbgRA/ZBQ4FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Yifan <luoyifan@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/321] ASoC: stm: Prevent potential division by zero in stm32_sai_mclk_round_rate()
Date: Thu, 12 Dec 2024 15:58:59 +0100
Message-ID: <20241212144230.483956440@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Yifan <luoyifan@cmss.chinamobile.com>

[ Upstream commit 63c1c87993e0e5bb11bced3d8224446a2bc62338 ]

This patch checks if div is less than or equal to zero (div <= 0). If
div is zero or negative, the function returns -EINVAL, ensuring the
division operation (*prate / div) is safe to perform.

Signed-off-by: Luo Yifan <luoyifan@cmss.chinamobile.com>
Link: https://patch.msgid.link/20241106014654.206860-1-luoyifan@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 7e965848796c3..b7dc9d3192597 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -379,8 +379,8 @@ static long stm32_sai_mclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	int div;
 
 	div = stm32_sai_get_clk_div(sai, *prate, rate);
-	if (div < 0)
-		return div;
+	if (div <= 0)
+		return -EINVAL;
 
 	mclk->freq = *prate / div;
 
-- 
2.43.0



