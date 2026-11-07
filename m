Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063089;
	b=DgDPlgl3UTAqcFPth4R6UISdpuLuXuiDvKdXW7K/wWKQCY0QmhiP4AqVsc+3HE+iu+s0
	 goLcUu669txFVOQqp2lOGXaaH1QRVQki3wrH70NAtx5OE3EndMUhH1QCe9cZfX+A5VInE
	 84lkNAUZFtpCAYWdG+k4CcJ7PPzCY3kU5f6PEMgEnakcZMT/FgiBrj5KSBjQXRDKSFRgZ
	 b5F+dt93yzy3S3dQ0TMxMsMLfUoDiXjB++zfUCduCEoeKZciYynOlcL3uq8SZi+TGDQPy
	 Jyi7swUdJ1JWwPJJxurtWHYwCDcGID5mwS/oiJ2Q5FPrJQDic/ZjhdhJ4vcwq20w8yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cW9mi0XOswea0MkeNeYmyK8ZQtGIuh9lG0pUOiSi1mE=;
	b=UmeKADXChBwdfHjLPIIiNDjXQnmRxNifs/Woj0YMlAt9jqes1nAFoa6YyKApgVxBGNNH
	 ntksaioSkDGMw948dTsOQDTUz3dloJis9SLtcNPjjQplB8rCBV50MUWknRwav7YTYFtxi
	 Z7OwE7typ+B7YelQBDIqSTE1D2+Jn/Te7AWCOB5o54Czw97WwUJM/BwXKsNQG/KTpWOhr
	 bJ4l6RDWnHnpXpaofXXK3AN4HX8080k49GDFls93GrtK1Z/kOC8HNCL0ch6pvVdvc1BWI
	 wxDCDvRt17v8KD5saFvnCgD7N+3QZhQEADOpGvdJqSRJsEurxvwu/8MX80zaTevoprA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8tf3bsj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EA7606D804;
	Sat,  7 Nov 2026 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8tf3bsj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB081F0089F;
	Sat,  7 Nov 2026 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063089;
	bh=cW9mi0XOswea0MkeNeYmyK8ZQtGIuh9lG0pUOiSi1mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8tf3bsjLG+pe/4XI2B8yPShi981IeNvl1EJylQRXn1ZmPAc9vLDdmAgf4GLyUsdG
	 u4zbymxUEqRmTmn1C0Pu877awEUf5G5xyvFGuWfXVJ/8mboeErCLrgiiDi9UvJMdzP
	 4+GeeWj2m9h06N4hfH4PWjmT6zNl0snNAqbOSZso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 327/869] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Sat,  7 Nov 2026 08:50:09 -0500
Message-ID: <20261107134903.535431094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



