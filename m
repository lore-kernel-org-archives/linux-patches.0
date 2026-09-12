Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBA9263F5D;
	Sat, 12 Sep 2026 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223920; cv=none; b=vDKmkigf5Tr4Wul/siyqwM8YbgWqCuofvYIY99cpBwIgvg+2sNpxay5d7qGUH8xta9bO7ue9uMDuqOoUEEb9g/OI/aL7gvS5yzGWLOcddoCgGVudJMgyMH0Mim9gcDs3raqeMIawwC0gMotA4aQ0fkXqsNARGWMHXQGBVtfGh48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223920; c=relaxed/simple;
	bh=UwMDg58QyccTL9XWV2qI2/q4eukeJQQkzRB5qEA8U0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdQGPndXGzt4u+HDf7ROx6c6DWIlJsX9ercuGC4PitI2x45Zlv2LGICpuZZIleaTO+lSmC4fXcHJxJINHHk2So9wsV9W7pm9Ng707Ra5NgPF+LmtdTihOZFns7Jjfr3TxOP2E5E1BeSiRau/HodB2NoGexYh8Lk4izKfVn0mxG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcnLs1Z9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcnLs1Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A886D1F000FF;
	Sat, 12 Sep 2026 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223918;
	bh=lmLur7DCC7HkOKcHmlNt0MY+sstsIs4WCd1iyYj1eHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcnLs1Z9muqg1QWt8Nm5lrxXiFkCZPLMpglX2eSNzbukV09nZFK9+Js2FPBAZxmDO
	 WW5CskQEXGY1FjV/DfJFjqINiMDeGLEEJqZAc/6qvNtYIOjm4VcQ7eSePSukOFCAjM
	 YQ1y9i+HPN0vC2EvlAWpshMtDhUxKv+VXENRKOpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0887/1424] crypto: keembay - Initialize completion before requesting IRQ
Date: Sat, 12 Sep 2026 08:55:19 +0200
Message-ID: <20260912065627.192807939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c8be35c7f000c..394613df96e7e 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1604,6 +1604,8 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	if (IS_ERR(aes_dev->base_reg))
 		return PTR_ERR(aes_dev->base_reg);
 
+	init_completion(&aes_dev->irq_completion);
+
 	/* Get and request IRQ */
 	aes_dev->irq = platform_get_irq(pdev, 0);
 	if (aes_dev->irq < 0)
@@ -1621,8 +1623,6 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 	list_add_tail(&aes_dev->list, &ocs_aes.dev_list);
 	spin_unlock(&ocs_aes.lock);
 
-	init_completion(&aes_dev->irq_completion);
-
 	/* Initialize crypto engine */
 	aes_dev->engine = crypto_engine_alloc_init(dev, true);
 	if (!aes_dev->engine) {
-- 
2.53.0



