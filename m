Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEA320969B;
	Thu, 12 Dec 2024 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018949; cv=none; b=Dh5poj6W5TCrC6d9ndUSk8DKhVs/jnHL/fAG1KUezdohHXwV/hLBIY/dVkeszHzNi8UkmvGtcaeOaERK26tdCc2MzAzHExfrPd2y+fg7dW9qApVOv0pkM6C/yfE6+ORlw1cO1OrO94hjxOUMcdKNP5H2uBlJbXYLONoF8b8LCPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018949; c=relaxed/simple;
	bh=d6Q2aj2m8a90wLd3xxWA1CRPc/ZZ68L+GRy6e6N2InE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMuA3D8W1pUF6IgTU7GQGzXs4sNvxj/7SNodURcLAnaZWd4GZ6d7JB09G1FEUsdeA0DfV3W4n6mryf5mPKhoLiMF2sf8P1qcIeNGQItmuWDse0KftWLkOowVtFR+qSk0HcezXtg0XjVN5QSDzba0FYEu+1/INZVDjA6F76OYWX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIjFqFqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIjFqFqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B91C4CECE;
	Thu, 12 Dec 2024 15:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018949;
	bh=d6Q2aj2m8a90wLd3xxWA1CRPc/ZZ68L+GRy6e6N2InE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIjFqFqqtTnAllW5pzMjTjmnqFUqh5eEc6U/C9LOLe7PS/i0H0dQswP2jY1nDRWjq
	 nwr4OFGZOqtF2Tdu4E3TMBX7rPX15EA5X8kmIpiZfxL3D2fKpoOEqQwF3/c7dEiX/7
	 zQMRGWoL5v30KSvnMDujiJTKNLuLiQQr9ZrDsdY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/772] crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()
Date: Thu, 12 Dec 2024 15:50:22 +0100
Message-ID: <20241212144353.116867621@linuxfoundation.org>
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
index 103fc551d2af9..ecf64cc35fffc 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2119,7 +2119,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto_tfm *tfm)
 
 	safexcel_ahash_cra_init(tfm);
 	ctx->aes = kmalloc(sizeof(*ctx->aes), GFP_KERNEL);
-	return PTR_ERR_OR_ZERO(ctx->aes);
+	return ctx->aes == NULL ? -ENOMEM : 0;
 }
 
 static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
-- 
2.43.0



