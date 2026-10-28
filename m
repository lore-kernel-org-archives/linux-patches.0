Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208229;
	b=4ORZmpvvUKeiEAYMLLIk7mwyknxoiV21rF6eyIr5qb9ETTnBS8tEe/xqUsfnTV6WZRyO
	 KYbGnLfFagmqLHgIXl+UrAoLYwyiJiJ3P7DndYqeaA47Tpw9CoRIPI5q6wd1MQtGP7dMd
	 PgUZ8F8YxewX99zPLNYaElhtA4slmm2x0BLy6dLNPs6Wzn/66g3OfQdOU8MmbW96FfhTT
	 Eds3rnjwB/h9/IOn8gmAYh3/fTx0TTIkgSXgjhR99WDsxDV95eTtl8SaNZFXSd39M24vY
	 y2LbMRX+UJ9Cm6pJz8S8zrlGL+wgV3kMQ5fluVgbGzGD37NEx6XgckHrl52YVqS6rvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CYoUAF36lPR0nF6YimsH2J3efiNt/9UZ+g8qm7lkOdU=;
	b=YB3cVkkmXzRS4JEA+bxxQYZuZ+xUEm+bdk7xAS7yxFVab7Vwth6AkCDT90d5sKrkjz7U
	 2DcfMeZVx+23yY6zwZNXFgPJb+AcCPXGVXMabwli+0lkqmdLfx+Dbow36liCfT/RlXYhf
	 cBZhzqNrNE5FblCCpCV1c6ht0b7ikD/1/1XsL7hsLeMlPAslYdQkgoQP9wPZByoaPl2ba
	 sCBTnGxI7+j1F/klR7WRuwDxCDQVnstxK8ky8geq8YSGN9GtOfiWQglBRJvOHZsBEGRf5
	 4gL/Bn68x+DQHrObLac5eTzZ1ZWt5zXpysEqUnJjzexAZyJotEKe7YEF8zCqhJPhSPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnGgFBrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E61606A31C;
	Wed, 28 Oct 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnGgFBrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E411F01829;
	Wed, 28 Oct 2026 17:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208229;
	bh=CYoUAF36lPR0nF6YimsH2J3efiNt/9UZ+g8qm7lkOdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnGgFBrFWMFkRhZIFzdx5XX3FSjWhJlPzgMSjvG3q/agC3W3Ch2BS+UCfuZepitIS
	 J6cEqHpUJflZHtzYyM8gr4ynPmPuiVJWTHScTbhnLr1A2/q3D5oYjOtdWkvC/g64Ty
	 Z3z50+WUWnLjkjmKBaU74evl94TAWPiyGDvSOScA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/516] KEYS: trusted: Fix TPM teardown ordering
Date: Wed, 28 Oct 2026 17:53:16 +0100
Message-ID: <20261028170004.576402764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 5e2d672280d97d83de43031d93761b12dadd7b8a ]

trusted_tpm_exit() drops the TPM chip reference and frees the digest
array before unregistering the trusted key type. key_type_lookup()
holds key_types_sem for reading until the key operation finishes, while
unregister_key_type() takes it for writing. It therefore provides the
synchronization point that must precede backend teardown.

The current order permits this interleaving:

  CPU 0                              CPU 1
  trusted_tpm_exit()                 key_type_lookup("trusted")
    put_device(&chip->dev)             trusted_tpm_seal()
    kfree(digests)                       pcrlock()
    unregister_key_type()                  tpm_pcr_extend(..., digests)

CPU 1 can consequently dereference the freed digest array. The chip can
also be released before callbacks stop using it.

KASAN reported:

  BUG: KASAN: slab-use-after-free in tpm_pcr_extend+0x1f0/0x200
  Read of size 2 at addr ffff88810872d000 by task poc/89
  Call Trace:
    tpm_pcr_extend+0x1f0/0x200
    pcrlock+0x42/0x70 [trusted]
    trusted_tpm_seal+0x1b6/0x570 [trusted]
    trusted_instantiate+0x293/0x340 [trusted]
    __key_instantiate_and_link+0xb2/0x2b0
    __key_create_or_update+0x61e/0xb50
    __do_sys_add_key+0x1b8/0x310
  Allocated by task 88:
    __kmalloc_noprof+0x1a7/0x490
    do_one_initcall+0xa1/0x390
    do_init_module+0x2df/0x840
  Freed by task 90:
    kfree+0x131/0x3c0
    trusted_tpm_exit+0x59/0xa0 [trusted]
    __do_sys_delete_module+0x346/0x510

Move unregister_key_type() before releasing either resource. This stops
new lookups and waits for in-flight key operations to finish before the
backend state is destroyed.

Fixes: 0b6cf6b97b7e ("tpm: pass an array of tpm_extend_digest structures to tpm_pcr_extend()")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Link: https://lore.kernel.org/r/20260731140925.2973492-1-nicoyip.dev@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
[ preserved the additional trusted_shash_release() cleanup after unregister_key_type() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 3e9dc03d59c91..ca5efa7988e6a 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -1287,10 +1287,10 @@ static int __init init_trusted(void)
 static void __exit cleanup_trusted(void)
 {
 	if (chip) {
+		unregister_key_type(&key_type_trusted);
 		put_device(&chip->dev);
 		kfree(digests);
 		trusted_shash_release();
-		unregister_key_type(&key_type_trusted);
 	}
 }
 
-- 
2.53.0



