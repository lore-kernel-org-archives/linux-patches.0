Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE944377ABA;
	Sat, 12 Sep 2026 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239125; cv=none; b=PqPql90w1n5aIBpOvXOKOfu1LIoPPE8U9bP+uDcKaJGK4se6iE2YkyaOR6YRonOov0yFHcPcqqCNd+eGp6wwiaVHDQuAb0Ny4RiiEquSVIWnMM2b6Epk6KDG96ff/6Alz12ZAObjc7tVk9vNXLl4rljwrwbz8uTB++6LZ7cKLWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239125; c=relaxed/simple;
	bh=LWUJCzxTon+ddteVrcBkkEsPiJYQzzl6kaek39wWQao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRYxTIfM7TujI/LUzPpENUkpj7nFz1915bYvChOO1DsvjxMAhMmBoRTj7+CvWNoNxLghpGRPJS+GmHRQZIWrSYXmx5v9PUPMtAFTkZM/HwD/4hkdeIpzzYYZTUF+IHuXsNSg7hs1QEhkWt9AMfCaM862EWoESTc9AdvJrwPC1KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6t9y9Vu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6t9y9Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5501F000FF;
	Sat, 12 Sep 2026 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239124;
	bh=MJGdEfsBy2wmrKkrLxn1PqYWAjayAKYUzPJahjesTWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6t9y9Vu0cMIGkS/pLLme4KsxmoA1qhHdceN30Am2/ampPaklGYlGktPmCMuAPoer
	 e0kMlmzTe8fhl2hF0tMTqx3hi2QYKdmbPFHOL9ZnF7Z1MmIuqpH59UPIlPDzzlIt0U
	 NGLec9bVcc+MXSz24fXiYRSz6/om0y70P57a9af8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 601/935] crypto: keembay - Initialize completion before requesting IRQ
Date: Sat, 12 Sep 2026 09:00:31 +0200
Message-ID: <20260912065540.625641441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit fce20289dd622cc7ab78d72c8a979a9f8b7cb10e ]

kmb_ocs_aes_probe() requests the device IRQ before initializing
irq_completion. Once the handler is registered it can run immediately,
and ocs_aes_irq_handler() unconditionally calls complete(). An
interrupt in this window would therefore use an uninitialized
completion.

Initialize the completion before requesting the IRQ, as the sibling
OCS HCU and ECC drivers already do.

Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-aes-core.c b/drivers/crypto/keembay/keembay-ocs-aes-core.c
index e2a39fdaf623e..5206be54eb202 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1626,6 +1626,8 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	if (IS_ERR(aes_dev->base_reg))
 		return PTR_ERR(aes_dev->base_reg);
 
+	init_completion(&aes_dev->irq_completion);
+
 	/* Get and request IRQ */
 	aes_dev->irq = platform_get_irq(pdev, 0);
 	if (aes_dev->irq < 0)
@@ -1643,8 +1645,6 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	list_add_tail(&aes_dev->list, &ocs_aes.dev_list);
 	spin_unlock(&ocs_aes.lock);
 
-	init_completion(&aes_dev->irq_completion);
-
 	/* Initialize crypto engine */
 	aes_dev->engine = crypto_engine_alloc_init(dev, true);
 	if (!aes_dev->engine) {
-- 
2.53.0



