Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062170;
	b=zoj/GqCMUByNK8z+HHBX7uqLj1Ret7rg57hsMQ+Jn9VAM32a2Jm2ea652FbUNjnu/CPA
	 ZYgDO9bc8VlAC5W6b2NQlcvIusJHMDj7UqohRlRf7fI0dz4kgAdNwyxpEVFdZOyIemvLJ
	 atIxff1g4TWGUy9ygT1ax5To5U9m0KlEr+NkdPBkj39IyJYnIWFvjAKEMXZ9dUZN26mjJ
	 qPyv5rVdi8PplrvwnYJLzdXllipLFPhQyNf6ySdAZYg33IyRrphxAjvgoZTi7IkzUsGfz
	 kSjqOj+of5GcheMN4ZhkYUpFo61fqyp4SES/XnEakgcTK+LN8Y6jUReB8Gn5qvTx8uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vu4YZ9o0WXqo5IlY40gwGOfkRmWyqT9lQw+i26WVcRA=;
	b=emEJXXusFIyD85lIS11R8dib0vvwU79BrMBQ6A8IsrwZIstvRROwRwt2pdEPcuJ7Jt0W
	 uRD5keXVSU9bp+K0PpCKANzTSpwQW0s8y0gzNmZ/IuqWV5og+PProeQYidCMIAtvuQLSP
	 tVaEbVF8OndAHY2F8hPWU/oA64sq+ncZSjAaQ3C1LovUiHB/aXGmzuVfKyuialMWeNkbD
	 WB6JiSSD2CmFvY3Di3IKwyPMAT1z9RFz3+CzuG26LGkFebMkRq7uLj0Q7rkIT2Kvu/h/c
	 eoZWHXH7wnFpRB0HVuhlwyj584hiOj7OGPQ5C3GVsKwEU8l4s11FNTLnN5X7KbnYkdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A+Kc7xSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB63606A326;
	Sat,  7 Nov 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A+Kc7xSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C1D1F0089F;
	Sat,  7 Nov 2026 14:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062170;
	bh=vu4YZ9o0WXqo5IlY40gwGOfkRmWyqT9lQw+i26WVcRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+Kc7xSEhQWm5NKdkBDhOXTpxAN1srcAgGPsRg1/CrqQkit15O95aN32r+vhoDSNo
	 aqScslLgUVvqAow0//Sf9chwRNiVozXWFSl+W3cgI7ZJRm5CBauxlHaAuwf6xqDOTf
	 zq8Cg0FY2Cs6VC5LyoZ9PvHLh4VZ3b151+HFtDlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1131/1536] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Sat,  7 Nov 2026 08:52:27 -0500
Message-ID: <20261107135029.479376630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhaoJinming <zhaojinming@uniontech.com>

[ Upstream commit a91d9346a70b68f77884cba9d9ec3b70f96bf9d2 ]

caam_rsa_set_priv_key_form() frees the partially allocated key
components (p, q, tmp1, tmp2, dp, dq) with kfree_sensitive() on its
error path, but does not set those pointers to NULL afterward.

When the function returns an error, caam_rsa_set_priv_key() jumps to
its err label and calls caam_rsa_free_key(), which frees all of those
same pointers again, resulting in a double-free.

This is reachable when the allocation of q, tmp1, tmp2, dp, dq or qinv
fails, e.g. under memory pressure, or for a malformed key whose CRT
members decode to zero length and make caam_read_rsa_crt() return NULL.

Set each pointer to NULL right after freeing it so that the subsequent
caam_rsa_free_key() call becomes a no-op for the already-freed fields.

Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caampkc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index cb001aa1de661..ac515ed8c5755 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1033,16 +1033,22 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 free_dq:
 	kfree_sensitive(rsa_key->dq);
+	rsa_key->dq = NULL;
 free_dp:
 	kfree_sensitive(rsa_key->dp);
+	rsa_key->dp = NULL;
 free_tmp2:
 	kfree_sensitive(rsa_key->tmp2);
+	rsa_key->tmp2 = NULL;
 free_tmp1:
 	kfree_sensitive(rsa_key->tmp1);
+	rsa_key->tmp1 = NULL;
 free_q:
 	kfree_sensitive(rsa_key->q);
+	rsa_key->q = NULL;
 free_p:
 	kfree_sensitive(rsa_key->p);
+	rsa_key->p = NULL;
 	return -ENOMEM;
 }
 
-- 
2.53.0



