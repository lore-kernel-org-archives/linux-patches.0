Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB2E1E1C0F;
	Wed, 19 Feb 2025 09:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956084; cv=none; b=Fua1k0Nk3w3wWZY+uTpXZFD1qWcciryjJrSNMAsW6/GeHOSBSn+ty5xviYWxGNbC7VGuGX4j/zlkpM42KxKJVF3v2SWCxk2xP2ztg04Efihdks4zMes8t8Gl8DDWJxGDT9Y65Q+G4qhNqPJTZpdm0uOOTiADElo3NLLz+40v/Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956084; c=relaxed/simple;
	bh=Dkxs3qXdYNqNQPXAxyoMaS6YJzDauP1NuMEKKLcz2+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRbrHFHOCUXGrT4VdgYK0t7f9yFOb1rc3SENSro9Ph7yPfSczyylmAKL/1Y31qmYk5Z4RKP6SE1FKDPb3FS4R/lRe8wbznozTBehTA2iKWGgfVMcgZTg/G4w8xym9/Lfdez/H8zDVMz4Pd60fzS2sXxrRw/DH/4gqFJtI0WWEtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b7xJdH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b7xJdH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302FDC4CED1;
	Wed, 19 Feb 2025 09:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956083;
	bh=Dkxs3qXdYNqNQPXAxyoMaS6YJzDauP1NuMEKKLcz2+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b7xJdH+CbcshZ6zAgIMzt8gisOV80YXiR7uhmASv+36gTVdoRO3ABsMmZoJUX5am
	 kc5kxBBSd8TeTSNDijAiXUEPC22PF/RDbsskBYT5byKYxbm8aRPE/UOw3aK3+/hiiI
	 sI2IJvvO0mdd8yVMkqs8C/pNvvUMh5pUUtqBftvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Loic Poulain <loic.poulain@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/578] wifi: wcn36xx: fix channel survey memory allocation size
Date: Wed, 19 Feb 2025 09:20:45 +0100
Message-ID: <20250219082654.510343775@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6b8d2889d73f4..b3a685f2ddd2d 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1585,7 +1585,10 @@ static int wcn36xx_probe(struct platform_device *pdev)
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



