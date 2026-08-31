Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC72146EC76;
	Mon, 31 Aug 2026 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184096; cv=none; b=P9Zl1KvS5+vBL/TYbstAoKhf6FJifh2UsVhcfNB5qhhc+CUx/lP018ahyzhvZcJ+o+Y/UR2rkw+sNpLZUURyI3xLJitIHtnsb1BkUOgM20y8k+gouO5+Z9J+ZkZ+L50DsEjKAvQ+CO5ZaUXoQ/sP4z86GlqHntYTrQKA4szwYU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184096; c=relaxed/simple;
	bh=ntb7uKps1Y5HbU62LNWwNYsLyZK65xeuSchfWr8sTYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wps9SpBTzxPeulW6QVrJkzW81tkE1b7IAc0uXlfBf4RYSWKiDhThix2wdHOS8rm7mvB5IDbMsuamXL1nd+PFmk1rbuUaBtf0lEDaamZWDQa0g7xXgeibu4tjTvpVo4zorra/ffjTiNrDnY7SS7NiA+xbN4nR3qgXugR1e6VNnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSGW/V+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSGW/V+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8131F00A3D;
	Mon, 31 Aug 2026 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184093;
	bh=NS+jtC95GnvFQ3QflL5gRA7yXrd6qNVYNtJe8cGk5oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSGW/V+rdFWjU+Mbcr5RQ4x+SWNbNnASZEy86rqATqNC3vmrQ0XX7BrQP0U8tSEA2
	 VPyjsjpTL9x2afr8tuwj4UHbywXKDWVYbZQb1hLb86G22RLnU5RFwy07Yf24+SrtQz
	 0Dk+qQYuV1fH0W7sNoHiFvyVvPHZTeOAr/kXlpZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 70/83] crypto: krb5 - use kfree_sensitive() for derived key buffers
Date: Mon, 31 Aug 2026 15:34:46 +0200
Message-ID: <20260831133403.054842459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Sebastian Götte <linux@jaseg.de>

commit f7d53dd3f267e46a784f219a75072f2f400d42b9 upstream.

crypto_krb5_prepare_encryption() and crypto_krb5_prepare_checksum()
free the buffer holding the freshly derived keys with plain kfree(),
leaving the key material behind in the freed slab object.

Fixes: 3936f02bf2d3 ("crypto/krb5: Implement Kerberos crypto core")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/krb5/krb5_api.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/crypto/krb5/krb5_api.c
+++ b/crypto/krb5/krb5_api.c
@@ -263,10 +263,10 @@ struct crypto_aead *crypto_krb5_prepare_
 		goto err;
 	}
 
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ci;
 err:
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(crypto_krb5_prepare_encryption);
@@ -333,10 +333,10 @@ struct crypto_shash *crypto_krb5_prepare
 		goto err;
 	}
 
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ci;
 err:
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(crypto_krb5_prepare_checksum);


