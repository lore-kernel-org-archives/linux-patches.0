Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114772686AB;
	Tue,  8 Apr 2025 11:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111398; cv=none; b=FFXODevHzp+mysttFvMMVClWPyGZrETedibBmJKK6ji6rLEvcyWLXwd2WBCXnjhdTijAb6Vi+pEh2PLq8d6B5jngqnHtl5VowwXeGADt7YBjKCNueksdBJkihdXPuWisnR+CU5zdzYVzEZtTOifOwc0LMgB/3vWinfrIeFTdbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111398; c=relaxed/simple;
	bh=JJ1HY/Ltc8hGB7vKZfHEwlnSTECpXMFUOMM9dPtujMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aE2EoaOSRTqKyRJ13c5MBEN2At2Zotx+bf9inr66CWQD74KyPueq57CwAMso9r+ZTxbEXp8loNQ7B9LScrV0Jf+pc6UjqdWeEdQ3sic3u+xKp3iGDpws2I9LhpmsQyfYUzzf5QxmfOV7UdczGagQt2M87cuwUqa9KeBZVUXQrdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWawDmU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWawDmU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC80C4CEEB;
	Tue,  8 Apr 2025 11:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111397;
	bh=JJ1HY/Ltc8hGB7vKZfHEwlnSTECpXMFUOMM9dPtujMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWawDmU1GBUIXDChrz3/WZSV9pdAyAejoYmzFZeI92iNUn8FCxHUoywX0pYLuZGWo
	 IcFkGgkGewF/yT9nh6HiZ3Sgoc9uguxdHRikxazRt+Aw0xAhe1yNlpPJTj4osJ3nBv
	 Ta1TyAxwuEVX3BjtSSUI+cXo/nASqZVB7m7LtEIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 417/731] crypto: api - Call crypto_alg_put in crypto_unregister_alg
Date: Tue,  8 Apr 2025 12:45:14 +0200
Message-ID: <20250408104923.973191024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 27b13425349e94ad77b174b032674097cab241c8 ]

Instead of calling cra_destroy by hand, call it through
crypto_alg_put so that the correct unwinding functions are called
through crypto_destroy_alg.

Fixes: 3d6979bf3bd5 ("crypto: api - Add cra_type->destroy hook")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algapi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5318c214debb0..6120329eadada 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -464,8 +464,7 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN_ON(refcount_read(&alg->cra_refcnt) != 1))
 		return;
 
-	if (alg->cra_destroy)
-		alg->cra_destroy(alg);
+	crypto_alg_put(alg);
 
 	crypto_remove_final(&list);
 }
-- 
2.39.5



