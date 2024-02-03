Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6211813AC0;
	Sat,  3 Feb 2024 04:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933746; cv=none; b=HzqtQlonWZx2E2sWjGZOshQm3iHmIvQKN3V7xqcWrOHphZQu/J9+3Ug2x51H6Azm/p+dxxbMJEwyXIOY6NDJH2dIsREWOczAP9T5btF0sqUr3JqFP5R6dM985MKFF8YgpzSiBJEXICaOBa8dJRxub3CX29Fo+03jlvO945PKHw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933746; c=relaxed/simple;
	bh=LWkVVhtB2KwvLm4xwfv4//M60XrnMUQiKGj2DLSTI1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnrGPNrAbtg9RzRluOA5g69HzWvHxq5z9jFkguUdWMGxnqPlr9wQyRCCEhtS2I9arIcyrw8eXEJfvCWpVcY0At+LpHGValtQCev5R0XgMcKbggtj8yS2PB4TNY6GxYiZ9NLjvfXpnjG48cx7RD5/Ow4ptbEVL9rKHB2iBcT7yNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8rJhzAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8rJhzAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D7EC43399;
	Sat,  3 Feb 2024 04:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933745;
	bh=LWkVVhtB2KwvLm4xwfv4//M60XrnMUQiKGj2DLSTI1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8rJhzAryT32/yrJB/SbOYzylbOJAzmDvFAsbCENZwBmDh/9LSgtdb8hg2USwsg2X
	 Pcna/X3Oktkh0GEeBtr7paFVCGyAlQhnY+tK2XBQmfhMpfaewmDUqiyAFELITzXasw
	 MkiwpTruoXF9eQhtlKztAGLaGBrenjHMGyvywN+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 039/353] crypto: starfive - Fix dev_err_probe return error
Date: Fri,  2 Feb 2024 20:02:37 -0800
Message-ID: <20240203035405.037697600@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



