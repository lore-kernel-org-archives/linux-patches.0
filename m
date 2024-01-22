Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B00613343B;
	Tue, 23 Jan 2024 00:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969136; cv=none; b=fPge5Iibs0M/KWSSkRGOkR4QnXkKrO0wbhadhZ+8fpCxCg5DGHxZc/Aw7f6icj6GONeH4EOs9EkoVQSNeesgkUzOzmCXCecGb/C8s22cCuZs3PebhUaJ2vQQkWj3HikDS2dPUHMWwgWj5Uc3raEyjaSL7DP86G3SpfDqoUn/nWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969136; c=relaxed/simple;
	bh=xLEHs8LRg6SMA893lHjGv9jWQwn4R1JRbEydsiI2z00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq8bhmbqcIvK7VybLuHdF4qoMfmXP2q8hbAHKcMXIj0XDfKmsyT6th6Be9l7HV014ETM9Q+NVeIO+qAlSvQNHs/XTc0TAqTRMJ6iwW5a8VNdM862rXH3iix18WiEAlWYdlZsmd2XNC4SfwcmvJEJ4qetAnp84BUIWwz3mpA3tBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkKxbE8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkKxbE8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F84C433C7;
	Tue, 23 Jan 2024 00:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969135;
	bh=xLEHs8LRg6SMA893lHjGv9jWQwn4R1JRbEydsiI2z00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkKxbE8jJZ5ZXftH14wwvxFyZSyHvZX+iZxpBEtBuLqMc3lvntJAlUq0MTBMA8Isz
	 THfcWAtjCPyarqygdbLUQHtbeG8t7Xj0/c1OY7dMXbI2BzeccxDU6pNIGkWc3fbACE
	 dEdJp+5x59mfcrU1rTMdOyk7qvXJUjZtW6qlsNk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chanho Park <chanho61.park@samsung.com>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 045/641] crypto: jh7110 - Correct deferred probe return
Date: Mon, 22 Jan 2024 15:49:09 -0800
Message-ID: <20240122235819.493173146@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit d57343022b71b9f41e731282dbe0baf0cff6ada8 ]

This fixes list_add corruption error when the driver is returned
with -EPROBE_DEFER. It is also required to roll back the previous
probe sequences in case of deferred_probe. So, this removes
'err_probe_defer" goto label and just use err_dma_init instead.

Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 08e974e0dd12..3a67ddc4d936 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -180,12 +180,8 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	spin_unlock(&dev_list.lock);
 
 	ret = starfive_dma_init(cryp);
-	if (ret) {
-		if (ret == -EPROBE_DEFER)
-			goto err_probe_defer;
-		else
-			goto err_dma_init;
-	}
+	if (ret)
+		goto err_dma_init;
 
 	/* Initialize crypto engine */
 	cryp->engine = crypto_engine_alloc_init(&pdev->dev, 1);
@@ -233,7 +229,7 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 
 	tasklet_kill(&cryp->aes_done);
 	tasklet_kill(&cryp->hash_done);
-err_probe_defer:
+
 	return ret;
 }
 
-- 
2.43.0



