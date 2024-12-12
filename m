Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A49213E6F;
	Thu, 12 Dec 2024 17:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025110; cv=none; b=bgR1YTd1Y2Z1nNnxdb0H8Od8PltwN4MkaXefZUC5d4PKsG1UFq82yAidQo7lrIj6tjJlHpfXYHaixQiaXuVg0cSj6UAFmK4QWtzBk6UR5Wtssvm+d39CGk/R74JdBlENE3rqp3t9DpqsB/IzFniZKunTY85hbX69JRxEmkuFe5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025110; c=relaxed/simple;
	bh=s6vmPcXochGrHCjnt7iJ3HOTN3Q65YLNUJ2i77x/hbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYdilJighZCe4KDzddO63Olx7q0RKdsIpkMPUS2CJaXOsOFdOtbiWMnj8sTOEyv49G4DpB+kpWL/UxujR9iGmLm3lHWZqDEV9BVTu9aSmZ1Ep7XA5NORBLoCCr1XPqF9xnygKCUFwvzY/PXwCOVBEGFKgUwEkpn1xQrpLTFdpD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxgAhvQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxgAhvQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3372BC4CECE;
	Thu, 12 Dec 2024 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025110;
	bh=s6vmPcXochGrHCjnt7iJ3HOTN3Q65YLNUJ2i77x/hbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxgAhvQmtl3u865GnHuF5UmQawybE7qQ1IoDZVi/ZE1KMANrRkjbJb13tXk5vcnsX
	 pNJC7MQxjEyCA0lPSbXclrLPqyctu6DBK510zycZw/E2YZA3vzZzNolZrSmivUnWGD
	 Zo+wuzJ6kjTlIBgVqDF2QDkM/MJPkMqY9mGEdPm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/321] crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY
Date: Thu, 12 Dec 2024 15:59:20 +0100
Message-ID: <20241212144231.656713905@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 662f2f13e66d3883b9238b0b96b17886179e60e2 ]

Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for
PADATA_RESET"), the pcrypt encryption and decryption operations return
-EAGAIN when the CPU goes online or offline. In alg_test(), a WARN is
generated when pcrypt_aead_decrypt() or pcrypt_aead_encrypt() returns
-EAGAIN, the unnecessary panic will occur when panic_on_warn set 1.
Fix this issue by calling crypto layer directly without parallelization
in that case.

Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 63e64164900e8..9e4179f5717e6 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -118,8 +118,10 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
-	if (err == -EBUSY)
-		return -EAGAIN;
+	if (err == -EBUSY) {
+		/* try non-parallel mode */
+		return crypto_aead_encrypt(creq);
+	}
 
 	return err;
 }
@@ -167,8 +169,10 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
-	if (err == -EBUSY)
-		return -EAGAIN;
+	if (err == -EBUSY) {
+		/* try non-parallel mode */
+		return crypto_aead_decrypt(creq);
+	}
 
 	return err;
 }
-- 
2.43.0



