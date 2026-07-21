Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D284C9579;
	Tue, 21 Jul 2026 17:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656110; cv=none; b=lDHEURQH+gV1h6clsvnIezW8U/ltHlsG3LDiHN6HWCd/uHfnXClH0PHAX67Gpw7N1+Af8560mUWb+nDCnAVzioFxyVMiz2RN+V1jApqw1C1BWYEqSqZSuq5fyy8AgmKT2f3oVHgBZvvtufKS+8NvIO8pl6lIfeKnu5jBF94+RvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656110; c=relaxed/simple;
	bh=9Yqw8ZtGUeJZehP95UrJjnKEJchAcOHJjgPLRGh6xis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G08CnztVfJw5a1Q2VeJTN0eLMKYSRjMmz1Gjf6AT1duKFjTsL7CilQw/t9oYxWTMqR4+pE9F5ChVLsBHmsPJNOAOITNaeJVIdkBASYlfrRpWd42hi4W0V6NsX3uC8juyRGGfrfJGYtK4kEtQmEC2r06Tl1OlrMGDQcUBvIID/tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA8RaxUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA8RaxUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD40D1F000E9;
	Tue, 21 Jul 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656109;
	bh=YIVKklnglRtay9bI4JEGBqkF4zap3MJ9A6kAIxklvw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GA8RaxUnsjy4dlRQP1DvRwN4BajsDaqMdHZSitV15Q6S7oOiwVBeh7nxIZgnYsvav
	 1/dyBTCWsXJhdiVIfAGW2fjBVALUgN6IRJNBmAzMKNjRuocqtxBXyOC5YBApjtJ0Bv
	 aTnD7TxFgq2G/leQQiYOozd+kkV6SqdJ3fyNNXTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0263/1611] crypto: inside-secure/eip93 - Add check for devm_request_threaded_irq
Date: Tue, 21 Jul 2026 17:06:19 +0200
Message-ID: <20260721152520.960560716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 85a61bf9145d4097c740ffcf3aa832d930a8913b ]

As the potential failure of the devm_request_threaded_irq(),
it should be better to check the return value and return
error if fails.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 76858bb4fcc22b..59b19e6ea4df7b 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -433,6 +433,8 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
 					NULL, IRQF_ONESHOT,
 					dev_name(eip93->dev), eip93);
+	if (ret)
+		return ret;
 
 	eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring), GFP_KERNEL);
 	if (!eip93->ring)
-- 
2.53.0



