Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D763E33F59E;
	Sat, 12 Sep 2026 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230100; cv=none; b=NqoUaAb8T/24Bvr8IaBOyDObr1xNye6dxJif1SUaPn+Eav6nkEQw10mMC/W+O9i/AiSxSW6cfy9VOd++ARKyq3G57tEG0NXbPjrajle1L7OUyo1r3llSHjFNDL9qY/YzmIAERu9Bzw1SPkbuSZvJbXDbTKxYPIFxgxbsUK7fKJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230100; c=relaxed/simple;
	bh=2UpErz7RPg6sJa/J/onyPshhd2iZuHQZhWWqO1zZsbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mC5gIZsynW2FaZqDoj2D3F0ZLX8bXTVnaIsLx/9uXrZIvx0Dco2p5c37cKLOkfaFgOFS5OJv7ng/R4X0IoBHK/K5VqNwT1rtezD0tvKlsFiN2o4s7JaIG8+stEupkYb4EUy88wFosfod+rFPNRdZN56QYXKk0IVizWYBMnMhKGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wY1EEz84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wY1EEz84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909861F000FF;
	Sat, 12 Sep 2026 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230099;
	bh=fUOUW+q4wr46wUfSgoND+elSnCZNGFh6ySvphRRh9x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wY1EEz84UGN3uHxGYO1r60sQZt7VoHOCCU3zPGhEenoNIZqAsGZnzMJgmf+19LmsJ
	 43CPuaumDRPn5DKfANXjl09Q3IIsz2tNY5fQaj5+EhiQ/VwJe5+l00cSQsE2kqc2Jv
	 zwcaJ3cjdepzCp9/pf6igGyKKtDWiVqZoYt+91u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0724/1191] crypto: keembay - Initialize completion before requesting IRQ
Date: Sat, 12 Sep 2026 08:57:32 +0200
Message-ID: <20260912065604.541748836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9953f5590ac43..5549444533d47 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1619,6 +1619,8 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	if (IS_ERR(aes_dev->base_reg))
 		return PTR_ERR(aes_dev->base_reg);
 
+	init_completion(&aes_dev->irq_completion);
+
 	/* Get and request IRQ */
 	aes_dev->irq = platform_get_irq(pdev, 0);
 	if (aes_dev->irq < 0)
@@ -1636,8 +1638,6 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	list_add_tail(&aes_dev->list, &ocs_aes.dev_list);
 	spin_unlock(&ocs_aes.lock);
 
-	init_completion(&aes_dev->irq_completion);
-
 	/* Initialize crypto engine */
 	aes_dev->engine = crypto_engine_alloc_init(dev, true);
 	if (!aes_dev->engine) {
-- 
2.53.0



