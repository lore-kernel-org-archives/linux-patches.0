Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A5C3EAC82;
	Wed, 20 May 2026 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296397; cv=none; b=NeYZMT0jR35zsMVw1BEVK81yneJ6GzdtKdPX9wDoQ9AIbN9AaEwIpJxtjsSE+h80IzDM/m35cnfAVQOx1Odblu9JlEIcguySUGim4PEjtUx3467FcA8ELogVgrZIw3ConjUMpNYhZKsnl+sn3ZRDV2qncuxpbpHpjhihwuA2McY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296397; c=relaxed/simple;
	bh=Ezb8tMlMNJ56k5BzTRraEagxQQeoF8mTczq6vLg4DBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgQwV1LpJW6L0kpc2f/WJ1iGUATb6qdehOl8LD10vKM4mu4hm4sXVgorg003ybTxXaS9xG/lEXMYEwTvIQCNm2CgmA5pmhKxCWrk1ztSLyH3+khi5JYfXUYtFgDE62AE3Lqhp6TocH5mCFQRRO39Qi6c4NFKy69k10axm8dn7v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMl6rNCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMl6rNCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00241F000E9;
	Wed, 20 May 2026 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296395;
	bh=kmHV+8B6wHHdUEkop9D7bsm/Uc3byqcJnoPdvdRvr3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMl6rNCwlWfRy4YZB0qwPA2he4UEIi8iR9E3yXeUEqVa0yE66NaRxFfkClu28pYc4
	 8kvSnM1E9sheUewg7dmGxWCYmlxkb1uFtzTNy2gSa08JyYBevQGvXMPI/pOifHIznu
	 8jNwekn64xValdeK6ZgL6NmSP2lW+o7fuHr7mjkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Kenneth Kasilag <kenneth@kasilag.me>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0742/1146] crypto: eip93 - fix hmac setkey algo selection
Date: Wed, 20 May 2026 18:16:32 +0200
Message-ID: <20260520162204.998969323@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 3ba3b02f897b14e34977e1886d95ffe64d907204 ]

eip93_hmac_setkey() allocates a temporary ahash transform for
computing HMAC ipad/opad key material. The allocation uses the
driver-specific cra_driver_name (e.g. "sha256-eip93") but passes
CRYPTO_ALG_ASYNC as the mask, which excludes async algorithms.

Since the EIP93 hash algorithms are the only ones registered
under those driver names and they are inherently async, the
lookup is self-contradictory and always fails with -ENOENT.

When called from the AEAD setkey path, this failure leaves the
SA record partially initialized with zeroed digest fields. A
subsequent crypto operation then dereferences a NULL pointer in
the request context, resulting in a kernel panic:

```
  pc : eip93_aead_handle_result+0xc8c/0x1240 [crypto_hw_eip93]
  lr : eip93_aead_handle_result+0xbec/0x1240 [crypto_hw_eip93]
  sp : ffffffc082feb820
  x29: ffffffc082feb820 x28: ffffff8011043980 x27: 0000000000000000
  x26: 0000000000000000 x25: ffffffc078da0bc8 x24: 0000000091043980
  x23: ffffff8004d59e50 x22: ffffff8004d59410 x21: ffffff8004d593c0
  x20: ffffff8004d593c0 x19: ffffff8004d4f300 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: 0000007fda7aa498
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: fffffffff8127a80 x9 : 0000000000000000
  x8 : ffffff8004d4f380 x7 : 0000000000000000 x6 : 000000000000003f
  x5 : 0000000000000040 x4 : 0000000000000008 x3 : 0000000000000009
  x2 : 0000000000000008 x1 : 0000000028000003 x0 : ffffff8004d388c0
  Code: 910142b6 f94012e0 f9002aa0 f90006d3 (f9400740)
```

The reported symbol eip93_aead_handle_result+0xc8c is a
resolution artifact from static functions being merged under
the nearest exported symbol. Decoding the faulting sequence:

```
  910142b6  ADD  X22, X21, #0x50
  f94012e0  LDR  X0, [X23, #0x20]
  f9002aa0  STR  X0, [X21, #0x50]
  f90006d3  STR  X19, [X22, #0x8]
  f9400740  LDR  X0, [X26, #0x8]
```

The faulting LDR at [X26, #0x8] is loading ctx->flags
(offset 8 in eip93_hash_ctx), where ctx has been resolved
to NULL from a partially initialized or unreachable
transform context following the failed setkey.

Fix this by dropping the CRYPTO_ALG_ASYNC mask from the
crypto_alloc_ahash() call. The code already handles async
completion correctly via crypto_wait_req(), so there is no
requirement to restrict the lookup to synchronous algorithms.

Note that hashing a single 64-byte block through the hardware
is likely slower than doing it in software due to the DMA
round-trip overhead, but offloading it may still spare CPU
cycles on the slower embedded cores where this IP is found.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
[Detailed investigation report of this bug]
Signed-off-by: Kenneth Kasilag <kenneth@kasilag.me>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index f4ad6beff15e0..259714a4ee4d3 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -731,7 +731,7 @@ int eip93_hmac_setkey(u32 ctx_flags, const u8 *key, unsigned int keylen,
 		return -EINVAL;
 	}
 
-	ahash_tfm = crypto_alloc_ahash(alg_name, 0, CRYPTO_ALG_ASYNC);
+	ahash_tfm = crypto_alloc_ahash(alg_name, 0, 0);
 	if (IS_ERR(ahash_tfm))
 		return PTR_ERR(ahash_tfm);
 
-- 
2.53.0



