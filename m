Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4367F3644BE;
	Sat, 12 Sep 2026 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199874; cv=none; b=lQkYleEc4Hg186aOBk8lmRvIUY2/9oQZ+p//6XVWNJwCFoEqNp2/9mrWiEn26y55oMwne9LZpibEwFkdDvlc703gL0ttnsObJDf47bPo+nenU0QelNOKqETOZvFxDa+Sj3XIKrwLDbZvXg8GEcja2CTqfEW00bU52cSAtA+oX3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199874; c=relaxed/simple;
	bh=A354f5N53JBiLkVNzoY2SdrhmE0y5zNggc0dLSuIxZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIAcJ8IpUCBJ3j6ddhKvkCL8WgtGJxhKLs20wFlkglVLUA3H0qFuZi2wK0VbhrQo0vH1lSMg0dyyXvSbLoTTPqzayxwHnkXwrlgoTfrRDwQeVNOqYYVrkfc18aStcjc/Cl0k4uOn+fLhoU3xzRTuDY5SPTV0LU1CbjowfFYST1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLZ0q37A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLZ0q37A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB921F000FF;
	Sat, 12 Sep 2026 07:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199873;
	bh=tVD15vByAiTEZbXjZyIszSbUYBNXjFkp1w6Cf3blmbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLZ0q37AXDFTtEixgW+tqBie0DMmp0k+e6eI8TnqzW/u6X00l9RDjjVZxXId071CN
	 0NCmSRd4XhPcd/8rmeAKiEPWh5a+VRJ0Je0l/MHZNErt+UiBlEQX09I8c893Xi/CHC
	 r6DrdJoom1lY4q8aTPv+sJPd7zFMFQOMBoE2JvEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0673/1815] crypto: keembay - Initialize completion before requesting IRQ
Date: Sat, 12 Sep 2026 08:40:23 +0200
Message-ID: <20260912065704.687159419@linuxfoundation.org>
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
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 0e424024224e5..460a943cca227 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1602,6 +1602,8 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	if (IS_ERR(aes_dev->base_reg))
 		return PTR_ERR(aes_dev->base_reg);
 
+	init_completion(&aes_dev->irq_completion);
+
 	/* Get and request IRQ */
 	aes_dev->irq = platform_get_irq(pdev, 0);
 	if (aes_dev->irq < 0)
@@ -1619,8 +1621,6 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	list_add_tail(&aes_dev->list, &ocs_aes.dev_list);
 	spin_unlock(&ocs_aes.lock);
 
-	init_completion(&aes_dev->irq_completion);
-
 	/* Initialize crypto engine */
 	aes_dev->engine = crypto_engine_alloc_init(dev, true);
 	if (!aes_dev->engine) {
-- 
2.53.0



