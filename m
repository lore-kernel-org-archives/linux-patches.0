Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062983;
	b=qU+I4m38Gj3hVQcGOMAWbBtZ8dNDJPHOc3/0UdtZyCTPMKDPCno8MaaWsP7fQLfm+0rX
	 d8rGxmX0OpSYhCbxO/shB9XD/yC4xlUeVNQf+tVHHySyhYSCgeld/HK0I3NB4RVkki11o
	 wKU1CdhGJC92CFTQrk2Tm9g3Amoftk/TfAJN63cTFysCbV3gqyk3iKUQqW1eGQDYT0eAJ
	 EIgKn9CSiJqd+xx6rMp1JutUyvRLz6vpGUxRIZQpKG+FfBou/SHurps3mVd0o5YP9B04q
	 GdYkpKYKtSXS3z2ovi5+jDCq8w891RJco9spLOob5jkk6cc+0dhoxjOI/jH7Y1zwVMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CbPre33r/0idbt2JMGjSm2faFIJ6aNEtvNyGba9mGC8=;
	b=hduBp1tUwffV5iEvF7atRqfpcQ06w6kWtB9vbHlyWm9wdYWfSESsUrFEVKt2L49PCSia
	 zjYwgDEb1d5pVl3H4rTMwgIEG3bDBokycg7cg7ZZQ8B1d+bZygkzDawNCohUB3b46Ct4h
	 68t9LqDzYG5JIoPSjRWtmOc76X2gXhc1eRKyMnVlYYuiZG9IsAjNWsMdsJiLIUExntal3
	 POXcb4CIeQfy2J1e5npnVa4hCkBvmcFH8a2ecL8hH9SCMwLXL27NWHiGEYfpNC7xP44Nb
	 ChpR7+FPG3zZVH5jmbf8NBoaSOMZfsktZeYWGXnTOup19kfb2inQQQ2aApoRUTbynDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqpTDK4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0BE606A32C;
	Sat,  7 Nov 2026 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqpTDK4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F2C1F0089F;
	Sat,  7 Nov 2026 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062983;
	bh=CbPre33r/0idbt2JMGjSm2faFIJ6aNEtvNyGba9mGC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqpTDK4lnkZ3+LsuwOTTy0I8TYBLxWvZbbaMW9u9hMKOBYHZHcDrRkL6HwbBShKIl
	 9lmqarWXHxOvH1gKENMzA5EF45UZFgBavuQiBCaH2NYmjJSbiyDr15MX4r0c58Kzpl
	 MFn965vXhXTRygS9J/tn+Yi3Yyct0MEU0neM0pUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/869] mtd: rawnand: nuvoton: fix clock cleanup on probe failure
Date: Sat,  7 Nov 2026 08:48:45 -0500
Message-ID: <20261107134900.047931160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 8a485a40f45a19c5fcafb5cbee7387c2762af7c4 ]

ma35_nand_probe() gets and enables the NAND clock with
devm_clk_get_enabled(), but the ma35_nand_chips_init() failure path
also calls clk_disable() before returning.

devm_clk_get_enabled() registers a managed cleanup that calls
clk_disable_unprepare() on probe failure and driver removal. Calling
clk_disable() explicitly first drops the clock enable count, so the
managed cleanup attempts to disable the clock again and triggers the
clock framework warning for an already disabled clock.

Remove the redundant clk_disable() and let the managed clock cleanup
handle the clock state.

This issue was found by manual code inspection.

Fixes: 5abb5d414d55 ("mtd: rawnand: nuvoton: add new driver for the Nuvoton MA35 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c b/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
index 1a285cd8fad62..f659d3a6b9ef4 100644
--- a/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
+++ b/drivers/mtd/nand/raw/nuvoton-ma35d1-nand-controller.c
@@ -993,7 +993,6 @@ static int ma35_nand_probe(struct platform_device *pdev)
 	ret = ma35_nand_chips_init(&pdev->dev, nand);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init NAND chips\n");
-		clk_disable(nand->clk);
 		return ret;
 	}
 
-- 
2.53.0



