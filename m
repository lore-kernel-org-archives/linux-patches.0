Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4585740963A;
	Mon, 31 Aug 2026 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183610; cv=none; b=lgMWnhC+7pvkdrfu2rm2DCZpQ8GlG8sKfxwc9xZIQfcdK30FUFRpFK9a22hnSTiBhFXBveGhrUWIcbJPwh+dZ9jm0hclVZwpVx0nVNeR8A/Vv3XfZYPMaObWsATxMCZ/CkftpH6hrtKsvfi/o7r9YJ884keAmJWAl+MqsxECNno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183610; c=relaxed/simple;
	bh=AD8fka54vAKshgq92n2G4uKHEzUVfuyGoPhOdWUqD9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FHjie1dxDnpv0zFhuEasXri6svTrB1B1v6RQ4ZF7UXxLrYOKuyEPJujceVKZRga9P0WHcXdHIZjk0wKAP54+SSgZ1sTLkgMILqnCBVq0xB9sSkFmqTdv4FJZ1xfnmWJ39oltcGjBL12AYc4Vvw9GoQG7gapwu+5VBPh7/iPaN7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEiFpcHn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEiFpcHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825D61F00A3F;
	Mon, 31 Aug 2026 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183609;
	bh=0V/aw/ynaIoNZ0z/K6JGdDk1RwQmRxLTECfuTnfEaaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEiFpcHnWt+hjm/ej4srWvWxOOrLOtgov2OIGVe5TeYavvnXRmBfz1r+eBzOUwt+z
	 OPyA1ltVqVj7/F5jo67jeehhsExnrDJTyJCIF8erFV1OrqgYBCpm8Ha8v94cO8YwuF
	 +N7gI69amd+UT2hP0rHVS/Rwp04dWXhrFX5UF3A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 56/71] crypto: krb5 - use kfree_sensitive() for derived key buffers
Date: Mon, 31 Aug 2026 15:34:21 +0200
Message-ID: <20260831133402.140162918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


