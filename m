Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CEF37E5D1;
	Sat, 12 Sep 2026 12:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216501; cv=none; b=bkluEqqsX6H2aJ0lrmiOjB/E02laxlzNIxkQb1X1LN91mn8zIkTZBQsGo9TVIpG5Li3igyKdhUEYeD6jfZ1daoPuoINlriF41s1CC+SZo+d7Vph9gVJrZLJw3cz3K+RdkrJtl9pSOIUdO+Z01Q96MrJkLqInMaADKIYLz8DY+kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216501; c=relaxed/simple;
	bh=vabhGmgRBomjpLlc0h9Ktu32EhO1Ah0BIT6TPjHYkmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhxGvwQxCBku59DkC11Beczp+wODZcze+RJOPXkIJydGNioKx93CAB3gBjywgMsZurBwvkg4DvEQbO0p+sQyjnCrBNsQKGQjdNnLz/PRaIe+2igFM3zbo6k6dMLmWhLN7OW72Ba+An/yPHBVC/L42A4G8XGJnzOWeBocFoq0nps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaZGNK9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaZGNK9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40C41F000FF;
	Sat, 12 Sep 2026 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216499;
	bh=56rTSoaq+qNi+Aaqu6olk50veZJz17AyKdg4Tf0vaCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaZGNK9xjukyB6zLZI4nWB5yAoTzu7HAR4r4V4KNr0R9br9/J5E2/hehjnruwwqxy
	 qm4jVFvHtHKHuUl/Xy5zuaJnIUb4zILZS4D7R/AdlFdUr/PkcDhCiiNR9ou+UwSZYO
	 dqWNpnETUs4yqXehHKXVWB6HAjSBJMLJdip2n61A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0695/1376] crypto: keembay - Initialize completion before requesting IRQ
Date: Sat, 12 Sep 2026 08:52:01 +0200
Message-ID: <20260912065623.034615033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a02a75bd29860..9dc69a2706663 100644
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



