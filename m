Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC11C280314;
	Tue, 27 May 2025 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368484; cv=none; b=UOi2kgoV/SRQ6951WklSboTX+hkLKzI476/sUj61AI3eZHw+queqr5w9NlVESkzsfRNzvA0L/SyAoadQWSuY1igy46bf8vD/t7atL6zMweo+BVIrXHFFxM+JSMlhBoqtwvtcp9xgwAz8yGnAvlgsRRIqnBL0NCEwTXU0lIt9e8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368484; c=relaxed/simple;
	bh=BPxz0Emg38iV5iYwCHElLoUhUO3vFOX9grSUqaYxoRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB+unkifhIJkp5yLUciOS5O1lweaox4KJGOfxNSrCGOpVZJZqMHPlBxKoNlv9ddihielPA6XCjySWTDiKkKopX/439w9/BdtGl/RZjn5cILbZZ1UanVxKX7bNfHXeFraFWkF50w8Dn06vuuMqhcKhtuJfB1u31pIaGqA7FwkCMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6bzjoW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6bzjoW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445A0C4CEEB;
	Tue, 27 May 2025 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368484;
	bh=BPxz0Emg38iV5iYwCHElLoUhUO3vFOX9grSUqaYxoRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6bzjoW6MV0XfYB5Faj8hpEryYd9rwl8lHMyVfJFe2KkIwrj/0LYarM70EQsJTDlz
	 +tMVTDR3y9o4f66547v1j5OKNnPQdIf8zKaPC/c14TOoYtVsF84GbsSAouI2BRmp0g
	 lp2DB87j86SZ7eTZWK0u5z65/DpHLm8y9mTEC1Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.14 722/783] crypto: algif_hash - fix double free in hash_accept
Date: Tue, 27 May 2025 18:28:39 +0200
Message-ID: <20250527162542.512690367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Ivan Pravdin <ipravdin.official@gmail.com>

commit b2df03ed4052e97126267e8c13ad4204ea6ba9b6 upstream.

If accept(2) is called on socket type algif_hash with
MSG_MORE flag set and crypto_ahash_import fails,
sk2 is freed. However, it is also freed in af_alg_release,
leading to slab-use-after-free error.

Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algif_hash.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -265,10 +265,6 @@ static int hash_accept(struct socket *so
 		goto out_free_state;
 
 	err = crypto_ahash_import(&ctx2->req, state);
-	if (err) {
-		sock_orphan(sk2);
-		sock_put(sk2);
-	}
 
 out_free_state:
 	kfree_sensitive(state);


