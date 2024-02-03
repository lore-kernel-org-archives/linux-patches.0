Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A59C1C68D;
	Sat,  3 Feb 2024 04:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933501; cv=none; b=kzYg/yTjjdCIqtc8xE2vCrKvpuzGYvafR2EXdHohYML1JByonKK+XyryNjEmvjl8HJRghTnv/OwLxG0ST29mtPrBNIBatDQza6/cpkFEIU1HJZ5Yr/qWp4KOFwMBQL7Qo5kT+TejAGuDr9Pxz3KAPG4tIuyra3X/3KDtl91Mvco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933501; c=relaxed/simple;
	bh=55JggL62xzRf/il2iG/99dYEurrIP/ZFbQQkc+5HHHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtkN0I3TrLXVz20JhymnTK0DVnvOWKXeG1u4rE6T4a9TdK1yvZVfQgJ2nZgST/5rtb2V1ucTIdXtc53QKWF5CAQzQrjM9MgAitbbCeYxRrtXH1RoA3r6npQ12p+2t4pvqb1g34OHWY21E/8q1L4DVeNc14YWh5eU/kElUtIBWkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3EnOTAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3EnOTAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1411FC433C7;
	Sat,  3 Feb 2024 04:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933501;
	bh=55JggL62xzRf/il2iG/99dYEurrIP/ZFbQQkc+5HHHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3EnOTAfRogAiQ3My9pvLGbjBfxp0ShYLVm86iFRiWBGCpSBqRSK67QW0GTUR0MZS
	 DV/Y5EbRAQ46+eRdFiWgOMnL3ex4gr6Ej0T+MCwSX7bOxrowKAc+h5ajiyEopgOtjt
	 k9FZzL+eoeAbd06elOO0IhtUBxi69vtAhx4Yha9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/322] crypto: p10-aes-gcm - Avoid -Wstringop-overflow warnings
Date: Fri,  2 Feb 2024 20:02:09 -0800
Message-ID: <20240203035400.103072598@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit aaa03fdb56c781db4a4831dd5d6ec8817918c726 ]

The compiler doesn't know that `32` is an offset into the Hash table:

 56 struct Hash_ctx {
 57         u8 H[16];       /* subkey */
 58         u8 Htable[256]; /* Xi, Hash table(offset 32) */
 59 };

So, it legitimately complains about a potential out-of-bounds issue
if `256 bytes` are accessed in `htable` (this implies going
`32 bytes` beyond the boundaries of `Htable`):

arch/powerpc/crypto/aes-gcm-p10-glue.c: In function 'gcmp10_init':
arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: error: 'gcm_init_htable' accessing 256 bytes in a region of size 224 [-Werror=stringop-overflow=]
  120 |         gcm_init_htable(hash->Htable+32, hash->H);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: note: referencing argument 1 of type 'unsigned char[256]'
arch/powerpc/crypto/aes-gcm-p10-glue.c:120:9: note: referencing argument 2 of type 'unsigned char[16]'
arch/powerpc/crypto/aes-gcm-p10-glue.c:40:17: note: in a call to function 'gcm_init_htable'
   40 | asmlinkage void gcm_init_htable(unsigned char htable[256], unsigned char Xi[16]);
      |                 ^~~~~~~~~~~~~~~

Address this by avoiding specifying the size of `htable` in the function
prototype; and just for consistency, do the same for parameter `Xi`.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20231121131903.68a37932@canb.auug.org.au/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index 4b6e899895e7..f62ee54076c0 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -37,7 +37,7 @@ asmlinkage void aes_p10_gcm_encrypt(u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
 asmlinkage void aes_p10_gcm_decrypt(u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
-asmlinkage void gcm_init_htable(unsigned char htable[256], unsigned char Xi[16]);
+asmlinkage void gcm_init_htable(unsigned char htable[], unsigned char Xi[]);
 asmlinkage void gcm_ghash_p10(unsigned char *Xi, unsigned char *Htable,
 		unsigned char *aad, unsigned int alen);
 
-- 
2.43.0



