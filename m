Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC342AE8D;
	Tue, 11 Nov 2025 00:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822181; cv=none; b=CROwH4nfVusuB27cwLl7HaOOclkDOLMm0ng6aZzOZFFR5dxtj0Ba9Qes5NDg7qDEvTnUbn7C7sxEChs9uwMN1kIIUrP5dZIV+NlOepXUyqyO72oPr00q/au8425lsg75CaR1PHFzW8eWkWhitPiTsFrp5wsGsfxB9u9GyjAaEIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822181; c=relaxed/simple;
	bh=4xA1bokamPG390zOoAZOx+z0h/EqCIky06HwG6eRcdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gudDlktLjE4xVPR/tCMukAtBrqCfXq47BYMCncEx0EYRnhosgeh12ZPuHJCDhDGlXFFDAirgwleWFU8NGpKPW++XYo6zz/26OuGc+1aCNWg5sxOZ6JPs3F+DcaQHNg+wHAlufEeMByuWvP4ZogUfoY16SIIvM8MQ2oE1Z70y1P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITsGyzBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITsGyzBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD6CC4CEFB;
	Tue, 11 Nov 2025 00:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822181;
	bh=4xA1bokamPG390zOoAZOx+z0h/EqCIky06HwG6eRcdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITsGyzBGoylVx804XAtZJR10G3afdrMA7Vw/UGJaOa17VmnqGrPmqe5wl5Jgt1/uf
	 ZsBF9feocmezaUdye2ldhiaa4fOtRSfMqBvvPwWxrdDoXAXNoqEfUyIihcBF6wfSV5
	 dVV8APJBdtp3uRnCNqrobg5NmpcSdMYOvvbFWtG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 049/849] crypto: aspeed - fix double free caused by devm
Date: Tue, 11 Nov 2025 09:33:39 +0900
Message-ID: <20251111004537.621317723@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 3c9bf72cc1ced1297b235f9422d62b613a3fdae9 ]

The clock obtained via devm_clk_get_enabled() is automatically managed
by devres and will be disabled and freed on driver detach. Manually
calling clk_disable_unprepare() in error path and remove function
causes double free.

Remove the manual clock cleanup in both aspeed_acry_probe()'s error
path and aspeed_acry_remove().

Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/aspeed/aspeed-acry.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 8d1c79aaca07d..5993bcba97163 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -787,7 +787,6 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 err_engine_rsa_start:
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 clk_exit:
-	clk_disable_unprepare(acry_dev->clk);
 
 	return rc;
 }
@@ -799,7 +798,6 @@ static void aspeed_acry_remove(struct platform_device *pdev)
 	aspeed_acry_unregister(acry_dev);
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 	tasklet_kill(&acry_dev->done_task);
-	clk_disable_unprepare(acry_dev->clk);
 }
 
 MODULE_DEVICE_TABLE(of, aspeed_acry_of_matches);
-- 
2.51.0



