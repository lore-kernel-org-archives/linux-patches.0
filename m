Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2767234252D;
	Sat, 12 Sep 2026 09:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206413; cv=none; b=tZ6Q6DG2Ua1Givy8Wyz9CafL80XHrgXphtmwtrztE04E5NYvCvXZ2SfwzP5Rk8DJGlSIrPkiJd5+Nd1ORR9dHIHCFDfYZiydtcGk8E7kPMtXhgl1a0BXiq7Ywc5Yc4wqfUtjMhc6CYhCtpJNWzmGnrDDRasMs5VscTPg7mFPRoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206413; c=relaxed/simple;
	bh=lZpVInG3VAL4we0UservuJYV4zajwponoVrvHsYf29o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFsMZxjfDvb9W83F3SbxWVy3KKKucDJfP0vtg+8siOYUYU2GOCy/CWRjCK/gXHOtaAgo+oPjWIq/09Ckg6zgXHCAYhqMwNs1uBnh/yA8IbuO/hO1KxY8Cvcl6rbUsupEXZn2yf2azf7P9VgnoKQwCxcx6KRDZeFEpXiW8mNkPYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2ac93YF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2ac93YF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFAB1F000FF;
	Sat, 12 Sep 2026 09:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206412;
	bh=WVilIKloMxgDpurC8HYXzuu1FxIlofZfQHngZbITlMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2ac93YFmf1WtrQNXbLtU0ZmCeHwpXijvHuRG3yKtPJDiL4npFoYaJPBNX74pFgyc
	 932UwGU7ldGgSp75xtuR0RCLETW8FITLMaOuhsZ5wecQN5hlgQWtzVyE3ciZCNL+sV
	 Gr15Zx9Aj1aU4kElpuuNlgQWIUiW9Fpd2oRblAMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0202/1518] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Sat, 12 Sep 2026 08:39:31 +0200
Message-ID: <20260912065628.057787079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Lothar Rubusch <l.rubusch@gmail.com>

[ Upstream commit 72bbf11ba14bd7d5fbf31a1ec42fff608b657f74 ]

The nonblocking RNG path allocates a work_data structure to track the
state of an in-flight asynchronous I2C request. This pointer is stored
in rng->priv and later consumed by the read path once the transaction
completes.

If the underlying I2C transfer fails, the completion callback is invoked
with a non-zero status. In this case, the allocated work_data is not
usable for producing RNG output and must not remain associated with the
hwrng state.

Previously, the failure path only logged a warning but left the pointer
state uncleared, which can result in subsequent read attempts observing
stale state and interpreting it as valid completion data.

Fix this by freeing the pending work_data. The I2C transaction reports
an error. This ensures that failed requests do not leave residual state
behind that could be interpreted as valid RNG data on later reads.
Clearing rng->priv is done at the subsequent call to nonblocking read.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
Assisted-by: Gemini:1.5 Pro [google]
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha204a.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 8a3520c9a0ff5..d2031abbd8efa 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -31,10 +31,14 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
 	struct hwrng *rng = areq;
 
-	if (status)
+	if (status) {
 		dev_warn_ratelimited(&i2c_priv->client->dev,
 				     "i2c transaction failed (%d)\n",
 				     status);
+		kfree(work_data);
+		atomic_dec(&i2c_priv->tfm_count);
+		return;
+	}
 
 	rng->priv = (unsigned long)work_data;
 	atomic_dec(&i2c_priv->tfm_count);
-- 
2.53.0



