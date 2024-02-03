Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BBD1BF3F;
	Sat,  3 Feb 2024 04:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933499; cv=none; b=QVBSN08yZP4zh+mWi6yz+phxwG5L2SbQWDuYigmQX7mJN8WHiaF+/ekugsCk/Zkc8ZZKCX9EsidQ0trI3a6PhvhOOnt6XY6KWvXh6IurOS/CM8xZy3iscGXJlLMpgwJvPOYvJ3nfp7qG9EOPvoQOLDkTe3ebQ7H2MHiKlgj+04s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933499; c=relaxed/simple;
	bh=1AHauRYHtZu58dzwVeqc5o2Xs4gUtOPBnf36noNT/VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejlxrzmjpZKMPhIeixqrh0v5CArz530NvfU8UXj2Hi+oM4ljI/xSHjRvERqjAGdtM/q6pmKQqFqrf8nlhWX8hIUecBNEzWXH/V5ZPkambShj79TWuohfjxYyVavJX+jSpZqcjzAoQRiuLpvHPNlUhDPRX19FNNbQzhDg7q6W/cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ph6GQwWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ph6GQwWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E29C433C7;
	Sat,  3 Feb 2024 04:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933499;
	bh=1AHauRYHtZu58dzwVeqc5o2Xs4gUtOPBnf36noNT/VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ph6GQwWsReVEE+gd59zutLPb6cyEqy6UkZo5pJ7BBnJ0ExHQlLWTfkmjSORrSBLkN
	 Oq+QqyH1WgKk2DLOEnJI5K6VFYDiFe/wLj5rmwuUXXIz3Ifqso2fLv1RNZBw/cXTOm
	 +9GzBCOn6SkT+GsGlpdrq31biexNl30iUOMtNkqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/322] hwrng: starfive - Fix dev_err_probe return error
Date: Fri,  2 Feb 2024 20:02:08 -0800
Message-ID: <20240203035400.064996118@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

[ Upstream commit 2d37b3649c412b3bcecfea932cb677f7a5775b15 ]

Current dev_err_probe will return 0 instead of proper error code if
driver failed to get irq number. Fix the return err code.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311160649.3GhKCfhd-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/jh7110-trng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 38474d48a25e..b1f94e3c0c6a 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -300,7 +300,7 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
 			       (void *)trng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, irq,
+		return dev_err_probe(&pdev->dev, ret,
 				     "Failed to register interrupt handler\n");
 
 	trng->hclk = devm_clk_get(&pdev->dev, "hclk");
-- 
2.43.0



