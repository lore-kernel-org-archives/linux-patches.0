Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6C313AD22;
	Wed,  5 Feb 2025 13:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763382; cv=none; b=LC4bbrz3ARXmqOAZP9RAIbTruD8Hx845sxkoWeCfKjbcmXnfIZZ/KFYNVYrpBKmdz/X0cDkN8PS9nDQg5qSxQ5iosp8fn2L+ExUIaBKiRdxwoloU+xW6UcNphKOm+q92KZACeoemVry6nntxzYFGF2kE8u7tBZRjdZ7F9vh/ERM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763382; c=relaxed/simple;
	bh=NEvgRo8kUJbXZXHOr7p72O1D9LlWkydjhs9VMQrPhp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O88N3yd8fkVEylldluTEqDhoHXC53yOWVnao+LLk2wGvJYEYU+8p79NMdUzK3iJwOBHiydl6IbqRQPprOr/PdE2RMhCbktN+K2grfFJYhuKWbvsthuWACFYhSCoUsDJAWIDNyBSVkDtbTCcZ1W+m1b0/U8Mj0faIijSjMHBZcX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOs/Coq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOs/Coq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB34C4CED1;
	Wed,  5 Feb 2025 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763382;
	bh=NEvgRo8kUJbXZXHOr7p72O1D9LlWkydjhs9VMQrPhp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOs/Coq1X4m6gHwG4kBE1Ju2rvrptze2xw+R6viVGGt6ui2LURb7+wiSrqTBUm+j5
	 RUkHpLrazfku0HZZISGFqxmEgvYl5QVM7FB2Yx1uqg8YaGoOP/sUjmbWGHrr7zxAhN
	 MTqPV5UDXXW0tovCO+ATFmtIjly+qK1gL9kMDfu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Loic Poulain <loic.poulain@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/393] wifi: wcn36xx: fix channel survey memory allocation size
Date: Wed,  5 Feb 2025 14:39:33 +0100
Message-ID: <20250205134422.365736557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 6200d947f050efdba4090dfefd8a01981363d954 ]

KASAN reported a memory allocation issue in wcn->chan_survey
due to incorrect size calculation.
This commit uses kcalloc to allocate memory for wcn->chan_survey,
ensuring proper initialization and preventing the use of uninitialized
values when there are no frames on the channel.

Fixes: 29696e0aa413 ("wcn36xx: Track SNR and RSSI for each RX frame")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Acked-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://patch.msgid.link/20241104-wcn36xx-memory-allocation-v1-1-5ec901cf37b6@mainlining.org
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 2bd1163177f08..9bbbc86fd2d93 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1586,7 +1586,10 @@ static int wcn36xx_probe(struct platform_device *pdev)
 	}
 
 	n_channels = wcn_band_2ghz.n_channels + wcn_band_5ghz.n_channels;
-	wcn->chan_survey = devm_kmalloc(wcn->dev, n_channels, GFP_KERNEL);
+	wcn->chan_survey = devm_kcalloc(wcn->dev,
+					n_channels,
+					sizeof(struct wcn36xx_chan_survey),
+					GFP_KERNEL);
 	if (!wcn->chan_survey) {
 		ret = -ENOMEM;
 		goto out_wq;
-- 
2.39.5



