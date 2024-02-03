Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3C31C290;
	Sat,  3 Feb 2024 04:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933503; cv=none; b=DHt0QZcn9+3UWvJdUX7S3Tj58DK4+iXQKHcKs7Un80WHgHM66Mad+dZJzLpNf+zYnpjXGmZYi5DT7/OPs0CNBDK7FQ6dg7/Amh9pTAsQazTL0b0JXQqBZn5d1pRjM70AYpd3LE68XUFho2IlwI3nQJomthY3P+ynYLAEN074UMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933503; c=relaxed/simple;
	bh=c/X+oZEwPIpUZj/D0xowzFkfABbIYWiBN71rTKDwW4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXJZHLBFjkYKK0R/J4MEvCzy4BQOIUVqFyIX5+VKtUTh0aPZUKnSK+loijE8eKs8MsDW/iYw1oLaKSNoXp2aXnZvwN/qmWup0OqjS9+1wz4+R7wAzsB88h/u5GhRPREu8vTcLkj/aKn7FRAoHHwYn8LD8fSJZH46HR2eAX4y1tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deaF0Tgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deaF0Tgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20997C43394;
	Sat,  3 Feb 2024 04:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933503;
	bh=c/X+oZEwPIpUZj/D0xowzFkfABbIYWiBN71rTKDwW4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deaF0Tgz/TW/rjiahK3gT9FwwfUS0jxH4TvlB9JFrVIRT1IqX24xEM6XBN5ORUgrK
	 X7nwKuOonsI+MXOHGcL8M1Rt5RA3qVy9F0TMODySJlf+luGCGP6FD6nBi/jx3Lk/n0
	 tdmbU7N4DUIMg0v5RQ0dvTYH1wrB6gzyX0L15lks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/322] crypto: starfive - Fix dev_err_probe return error
Date: Fri,  2 Feb 2024 20:02:12 -0800
Message-ID: <20240203035400.204825446@linuxfoundation.org>
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

[ Upstream commit 8517c34e87025b3f74f3c07813d493828f369598 ]

Current dev_err_probe will return 0 instead of proper error code if
driver failed to get irq number. Fix the return code.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 3a67ddc4d936..4f5b6818208d 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -168,7 +168,7 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, irq, starfive_cryp_irq, 0, pdev->name,
 			       (void *)cryp);
 	if (ret)
-		return dev_err_probe(&pdev->dev, irq,
+		return dev_err_probe(&pdev->dev, ret,
 				     "Failed to register interrupt handler\n");
 
 	clk_prepare_enable(cryp->hclk);
-- 
2.43.0



