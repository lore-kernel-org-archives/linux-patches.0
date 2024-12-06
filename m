Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2E11547E7;
	Fri,  6 Dec 2024 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496752; cv=none; b=oFNCGaOScLtgYztlaGyY61T4QhW6Rq/RluAA5ODmJ4PZjDYz1tJgXBeGMQlK9e2sI2OLA0mChgCrU7hC5X0on98s5Rg6raGv2kBGtBN3kIsbHGvtd/rJ0p7sIRaRrCj/7imzuEUPChNfd5qI8KdMh/hB4AvNKG4iypEYF8tYnt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496752; c=relaxed/simple;
	bh=koN+Y5yIJTwSJYrv9vJy+xHWY3LVAL4Z1mvzwao6suE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8igWPfWGlwhhnEkqPAs6Qfa5FHWN14XRG9nx1evcCF9k9T944wq61/h8cQSj7d/7V8EyQALkq9NfVglFBZhfjE77ghnwE2jiSh/ooQhgLOCAWdfqP1YVaRz8rHXa+gl7/345wUoQPYI/xsIcaAr6+3ZhccRitFYX8XPcAkUy/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/OvJkiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/OvJkiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADD1C4CED1;
	Fri,  6 Dec 2024 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496751;
	bh=koN+Y5yIJTwSJYrv9vJy+xHWY3LVAL4Z1mvzwao6suE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/OvJkiGDmuIkAvGHF+sc+Ms9ojVnGwR106AWkbvzXm9ZTLyX1cklSZvalO9UAC27
	 PDJrNDpOevQGNfKJtfwR+BgUKo6RSQXgUK/DJlFRstlLOgutCUef2Svf7PrH8x9Xxk
	 1H/LyuIGD1liU03E8bp1mAmbCn3vqqCpUYB9ixtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/676] crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()
Date: Fri,  6 Dec 2024 15:28:31 +0100
Message-ID: <20241206143656.953609852@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



