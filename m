Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4944BEE27;
	Sat, 12 Sep 2026 07:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198949; cv=none; b=mKtqVbZlVS1JbJZEbTS8l3LC/klcBU6L0lmeoAbL+RfdwPkEEmItaXSpkBiKIBh/iuwUpzjRZndBfVkZXwnVAEOr/US0yEqR7+H4IgUOjb8dSME2j5JE1Ha0WeIrBlyAHgUf1LMi7vkr2qHRwZjdWYgRLIXmHrFIEnFlMvePz0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198949; c=relaxed/simple;
	bh=v9T+E93N6S/LIhB1X6rk4S0CE4EZYsKDGldrG5oF1Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DS1KB9CCBUw5DprBC4U22q1rrh4iLWpjZiSPLCK7QY9UbDYg2tIIPR2jo/ppPGaiB/lgeJFcE3sXfEiX4GwuoQ0arTDpnafCPQaQ3ftVdBI4kJm3v+LCSAshBc/v9HmGma1CR7Tn1l3pXBe3UM7kdsE8nWBPoVI1S9/s3YeZv3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcDyc9KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcDyc9KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18671F000FF;
	Sat, 12 Sep 2026 07:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198947;
	bh=pwgMPz7UVvA+5w8nTodF7/DQmTkE0zcUwGtlXFVNqnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcDyc9KMTKeJqudh6NQ1ay+/FQHOrYWNESrsTpgCMug0xtnSyJfqSnYFuQrAYbfkC
	 VSdqPzib3//YrvJb5BuZGcL5JfER4rNJBO7gnb6f0nuMZfvAPsSl2LHCYnLBwXg/Ov
	 0OBWX5PS8K2IZuDYWzU0CgUBZ0wkIy09JX1adnow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0484/1815] crypto: aspeed - Propagate platform_get_irq() errors
Date: Sat, 12 Sep 2026 08:37:14 +0200
Message-ID: <20260912065700.253310009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

[ Upstream commit eed5fde79651c66e0e24ba3d78a92afb63a76215 ]

platform_get_irq() returns a positive IRQ number on success and a negative
error code on failure. aspeed_acry_probe() and aspeed_hace_probe()
already detect negative returns, but both convert every failure to -ENXIO.

Return the original error code so callers can handle errors such as
-EPROBE_DEFER correctly.

Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
Fixes: 70513e1d6559 ("crypto: aspeed - Fix check for platform_get_irq() errors")
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/aspeed/aspeed-acry.c | 2 +-
 drivers/crypto/aspeed/aspeed-hace.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 5993bcba97163..301612556a769 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -728,7 +728,7 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 	/* Get irq number and register it */
 	acry_dev->irq = platform_get_irq(pdev, 0);
 	if (acry_dev->irq < 0)
-		return -ENXIO;
+		return acry_dev->irq;
 
 	rc = devm_request_irq(dev, acry_dev->irq, aspeed_acry_irq, 0,
 			      dev_name(dev), acry_dev);
diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index 3fe644bfe0373..1f9afa002ae8c 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -127,7 +127,7 @@ static int aspeed_hace_probe(struct platform_device *pdev)
 	/* Get irq number and register it */
 	hace_dev->irq = platform_get_irq(pdev, 0);
 	if (hace_dev->irq < 0)
-		return -ENXIO;
+		return hace_dev->irq;
 
 	rc = devm_request_irq(&pdev->dev, hace_dev->irq, aspeed_hace_irq, 0,
 			      dev_name(&pdev->dev), hace_dev);
-- 
2.53.0



