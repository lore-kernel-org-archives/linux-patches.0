Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7804521238;
	Mon, 31 Aug 2026 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183849; cv=none; b=kKzER6FkZXpbMp4eWhjrrKndYcP58cPBY0R4rN+xPug58Vx0pSVI7R03APN4OqsLkxfq6khUUAj+Wzw8f6Ih2XGkNXKFqgiwbnn2zl2yBPdaTqeVYe/rOVWC3q0pse584ZoGUimXWlhNIFEzgAIfryVTiseeksVh0RMRqtjqFE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183849; c=relaxed/simple;
	bh=i4D7G3mqOCUD/fUIMXlOgabWLejYyYWCdCLy5+mScro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mrgjaJk0ChUQHdnZSylCRZLqjPCVxqYxyPtKALlSPQPRFRbEB/B8lNpIL717LU0sezmopTgDZQ2D7ZRyCgWNL7dzWdtAXkDanzbq3vYxnqs6ywcpjYiF2rKgoA6b5f+kaSZBNL3In48tBGR6d2NsY6wTo8ZqWvv2z1tws2mX3o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkZGojDz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkZGojDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E10C1F00ADF;
	Mon, 31 Aug 2026 13:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183847;
	bh=feGXGYgJnD42eNQo5jPxHzItcDxmFCFEDVFUOFVx9+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkZGojDzAFHFl07VJiEfKTVgW3qfWOEqvkzxTzMqlE3XKGsHkKRMl0zzk2KHoP7Qo
	 mbob/qrFBOFtY2U518J9BiJeyZAfOBV4+odNKUQZmFp/H7PUcYjiF9okV0D9nxBKeL
	 YenNx4N3ivOYlxT5Fa/TdvLTsMpqfeua7ii5/w0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 61/76] crypto: krb5 - use kfree_sensitive() for derived key buffers
Date: Mon, 31 Aug 2026 15:34:33 +0200
Message-ID: <20260831133402.608108263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


