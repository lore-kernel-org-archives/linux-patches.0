Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA59D3911A2;
	Sat, 12 Sep 2026 18:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238340; cv=none; b=alXGsioohO7zwQslUfDyUb1ukyr72r1ea3QJotpHrFUkxruIEhm9qaJIcThp16fCuf29JyeWwqlp3cCGD0h700ZqO62+/9SXi/DEyiIPgaI52ubEcWJdflFm4pQllmcDbI69auJpo3HT8bKo89+zKsYSJhx0pSnnYGfr0oQS9Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238340; c=relaxed/simple;
	bh=3G+mhrxUiVwly6GzQbTHu2Lb+cX10RkDPwhMKtMANDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcVflibxu1tJ2151c6+etyOm0QMoo64rrG5a6uWXNmxC7b5G1agBc6aotAZ7cTM/FYmB/NQHEE4r23PXyC7K4wUxE5Nj0JCULB5pYEvmUL5cg3BdADoPHx81Iakn9yvXq79I+3qak8gXjvHz0pCcJOjUQMck9O/90cSMdDrWam0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kDfwDqe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kDfwDqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AA81F000FF;
	Sat, 12 Sep 2026 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238339;
	bh=ZSoQtMpvCJo2FdlUZ5NuL28FF6Uk1CfZRLn1+AbnoSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kDfwDqeuxwHnj/+Mx7DJ/rcq1QfZRKpsJ7U8HV4Zm4ugs5H4eGQLSUBB3LtJuc02
	 StcZTAezqxdDEmOZSrt06EDfDGw2FvIftznPTg6pP2PxgAHrg3nUDUVt/3l3PU+XGZ
	 7iu4EF3W4Veg5FlbR4921wNIL37Lz6ckK6LHyCec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/935] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Sat, 12 Sep 2026 08:57:50 +0200
Message-ID: <20260912065536.922502875@linuxfoundation.org>
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
index 850c822af5ff9..3251d1f7bcde0 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -30,10 +30,14 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
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



