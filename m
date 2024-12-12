Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393F92054F8;
	Thu, 12 Dec 2024 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018929; cv=none; b=I/id1vvB+9rln/yP+bFs4kXkN+/edwDhDMXdBO20VfwdnqRs7WCu46RsYVzz9b624X9gQ0LAUDo4M/8U0tdUKF9PABe3rztn3HgbeohKgekOSSk8kLxnYaG/o79IONbjtWFWSBf2XAcJ746uiqE31ETlL2SGToNiqTNGihOIXvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018929; c=relaxed/simple;
	bh=fJ9TN8imXdMvyUo1lpNDVpggAj5BDnvWqn1UlgFzmX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK/j68gB1NDELR9tTp7idiJh55cN/UTjgMIgYWhkzQxaNqmU3VRUg3Uznugh39AIta2E1hURHTuoWt+k73Zt15E1nBiqWmvh6ZXHYkh9ABsViRHfOpue5rMcsr89P1goQPpbeEFCyPHSmpNe/sj/t/PGqfoT2XcGvJDxNkFb7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6KFFTZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6KFFTZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBA8C4CED3;
	Thu, 12 Dec 2024 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018929;
	bh=fJ9TN8imXdMvyUo1lpNDVpggAj5BDnvWqn1UlgFzmX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6KFFTZAG4FqtR25RFMgLw4UGiC2r2jxMegTF8AzIjFwPlxJLa05ZfAr0SRLiFqKn
	 3tCJMl5Jn59aUlD1nl/DPggzMQDftw71SSWAlcklIO6Je3xMfq4gj/BQxHsVDWL+tL
	 0lMm1FPQc7pSswOz+NN5NAs6ohaGKav5vRr1cAl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/772] crypto: pcrypt - Call crypto layer directly when padata_do_parallel() return -EBUSY
Date: Thu, 12 Dec 2024 15:50:18 +0100
Message-ID: <20241212144352.946130904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 005a36cb21bc4..2d7f98709e97c 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -117,8 +117,10 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
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
@@ -166,8 +168,10 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
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



