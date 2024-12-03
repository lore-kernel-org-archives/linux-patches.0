Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5133A1F7585;
	Tue,  3 Dec 2024 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237940; cv=none; b=T4neaI01XKfD07SlmdKzQp+bt9rU+RPciH19Pa1V1QCkob02XJ2yWH9/hB1Ebj8j9tytVeFhQCf+ckaw833Z5u/LDQE3A1i8REJD6VtKVafzebGKQdxbsgN52k0NuNLrr52WJRGrbIOL9IdXdwAWYPYMuVMSj5R+xLPRBynG+k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237940; c=relaxed/simple;
	bh=JgmB+kT6Txi2aE3gCGNQ4ja48vEGXCpIl9H2Z1ItRaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N07j77q/4JXvIqTOLw/iKXPhAJWpFT56zdKVEk4cntCvdd59287ex9rRCgSQKpKPkoD7F2jNtm6uGJQARjggbqfg5ei3woaFm00PGS+1f/NJhuzqhxcFFJxS+BI3QnyLwQmpuBacnmvst14KC111hNWWvlGYHI5bxMFunqQskWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fno0VMEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fno0VMEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43B8C4CECF;
	Tue,  3 Dec 2024 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237940;
	bh=JgmB+kT6Txi2aE3gCGNQ4ja48vEGXCpIl9H2Z1ItRaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fno0VMEKh7KOdy/M9pMFNmq9F3TDIdeGP3/rm+Np/C9rm/Wu+GbP/bNi1ujSo6UVh
	 GH5kMc6GKh/rbNJYi7ausNxzcttLZSvomXiJWhDNs0hnWskAWJOi06Su9RH/S/EOmy
	 W6RE8bPwqwgxYorNkQ6I1ZzjvmwmANgT38WDD3TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 114/817] crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()
Date: Tue,  3 Dec 2024 15:34:46 +0100
Message-ID: <20241203144000.164163644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit a10549fcce2913be7dc581562ffd8ea35653853e ]

The commit 320406cb60b6 ("crypto: inside-secure - Replace generic aes
with libaes") replaced crypto_alloc_cipher() with kmalloc(), but did not
modify the handling of the return value. When kmalloc() returns NULL,
PTR_ERR_OR_ZERO(NULL) returns 0, but in fact, the memory allocation has
failed, and -ENOMEM should be returned.

Fixes: 320406cb60b6 ("crypto: inside-secure - Replace generic aes with libaes")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index e17577b785c33..f44c08f5f5ec4 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2093,7 +2093,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto_tfm *tfm)
 
 	safexcel_ahash_cra_init(tfm);
 	ctx->aes = kmalloc(sizeof(*ctx->aes), GFP_KERNEL);
-	return PTR_ERR_OR_ZERO(ctx->aes);
+	return ctx->aes == NULL ? -ENOMEM : 0;
 }
 
 static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
-- 
2.43.0



