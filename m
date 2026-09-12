Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C313563FB;
	Sat, 12 Sep 2026 12:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214830; cv=none; b=R80WzjsKRpjcnWKbkjP5VxrrnQa5Scxyha7UPwBhk7PF/6xRSWLAWCdIyjbXPbz2fNPI5rOz4kH8vKB9giK2x/ZAcBnEJIMCDK9Fk8xRx8PLgm4Vu2ALgW7/sGd6T5yRKdF0bPoVMchvWUolULVm2E/T4ykJvS44EL/HkWDiQ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214830; c=relaxed/simple;
	bh=CynLRAI/Yipe2wtks2ymlVUp9w54zyT3FPY/RPXOwYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ykqw+6IFapGJaP8JaigxYN5ktv16+D2Zv9TIl7u3Cvyp58cDkw8AAAO7cd2ZoD14/V9md6c+yKi0Yt/ZZGPS/d3My7na9TPZpl2dYzC4kMmnPd+FWTNJoWOqsLNhQpsS2cfw4ij+rZfW2UUxqlrvPtx/j2WGiMCr5HdnEHGi2qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULdw5rTm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULdw5rTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83711F000FF;
	Sat, 12 Sep 2026 12:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214828;
	bh=mVidGcR5sx/e1rDKZ9Gl3c6RBXsvCw8vbSFJ0pyieGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULdw5rTmW0BUL81MlpNi8atQ2bpihkmb6rEcBop+wO/fYCtiYz6MV1Ez0CA6znUNl
	 HgKHFdaxuZs+w698sHS1WJvXTUQpuFPTkqK0BI8kFKKRjQBsFsvwL0r5G/yVap9tJd
	 qDYZrkblDVQaGIHkuEJZUVf6zOwDGiaBgAQ1s4Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0405/1376] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Sat, 12 Sep 2026 08:47:11 +0200
Message-ID: <20260912065616.568491604@linuxfoundation.org>
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



