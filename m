Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047907;
	b=ZnGeThD42lTbSrnBZvq6t1zJgq1kIN5ud+zvFkELohcBpUw1yQu2DJj9HL9LwgAx8VTh
	 78iJM1Oq2iHY2iBJYVpL219tP1DotDoTo7vCSTYO3OdCaUgZrHxbUw6A2at23UGjDW9jb
	 BihLyCfmvjoue7dTsmCvGjAZy6Qi3uhvUtw+m85i+CwccV/Imiw2LbjDl/h1iPznl4FUo
	 sL8pvVZPILi1k0A6jPfYDnACWZ5Mjxcq9y64/kty4AA2SihjywMbQEqfNrFvkS3P7CCjC
	 aX+xeV7yMjfaB+y20CGgK5PllATGDP3Qo9h55aeq1Avf5KUt9eZyk7W+lQ5cmnEKtAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gIcBA2CTa1nzyEFTI+I3pJFPQg2J0DtMFmlNXqkr4Mw=;
	b=b1n2FepaWlHvPEnOEQW6Zrzayz118wSqOBcLkhgq6xCVqUKx+YigP1DHHCVzDmRoZgHU
	 wmHac+kzHE9VElJXaO+ifLoWU9xVHDAkZ6hI1i/HqpcmhgVjm4qRmyjSyBjyyJ99yo1EE
	 dCGt48nv5JHfkPOtJ3w7mN1d2kwbmw9dMBMZK0i6pcsb7nsR3hIHGeS9EPVABlGb1qFx4
	 FwtoF9u5YfvqaVXefUvn9oJz/m/n0RgBSHVpygULDIl9dwsnQvpE1uv8Kz20zUovBwDmt
	 5rjXvlnmI2VXyME49AUPuHPZ6qqxG1FW4hBuZpPiPDn11Q2XhId2wKxs7MUOWFcNyew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRjv1Dre;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A243606A31C;
	Thu, 19 Nov 2026 00:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uRjv1Dre
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7D51F000C4;
	Thu, 19 Nov 2026 00:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047907;
	bh=gIcBA2CTa1nzyEFTI+I3pJFPQg2J0DtMFmlNXqkr4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRjv1Drewi0u6MUYATsAZeV4dk+IkBAS4Pbz+y2H5cpZDwZAG/qiT9kn9+4JuUB0x
	 ky9ebcDfgtiZ3rtmOhiXKrSXZe/npRp+fDXtvosZrp54Cx7AFZ9blJVlT873/1Y3NA
	 x78XGIIdGVvFE5NL8BMPrR58GW+7+ZnAJ7UXZFE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1805/2857] spi: mtk-nor: fix runtime PM usage count leak in probe error path
Date: Wed, 18 Nov 2026 15:47:19 +0100
Message-ID: <20261118150306.241720570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4cee1ed13e2687f1a9fec7dd50e31eb179506d75 ]

mtk_nor_probe() takes a runtime PM reference with
pm_runtime_get_noresume() before registering the controller, but the
error path never drops it.

Balance the get with pm_runtime_put_noidle() in the error path.

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260904-mtk-nor-v1-1-cefdca098f83@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index ee4e9c9dc3c83..bc91292db3ea3 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -912,6 +912,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



