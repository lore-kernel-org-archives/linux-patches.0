Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324AA3F822B;
	Thu, 16 Jul 2026 14:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210765; cv=none; b=nNNOilvCdz4ttSy8TwC0f8MnOU3wkpu7wpAfC4iysI5xcbo7b0WfArs8567xWnMaF2R1VSXya6zFFwmU7eLNi6VZyMmnP/1ckeQRmqxuzgU4yGVoq9I3kz+BTz26gVZtily/nlAbWQiLx2HbExJnMaqHQdhuugG1HNxm7A6/TO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210765; c=relaxed/simple;
	bh=uMFygVSznNbERzPJBSqw45uxD+M1PVstiVdQg5BlhMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZwEFltrXFxcrWuhZT7Sv64yiu7nHhd0rdnoHoNafot7EViccOzGoLFY62aT39kUBOvHK3ViZDrB67+anNIgS67MzIAER6SF4ifHH2wsmReBvoxQ5iYe2bnvfNYHpqWqtFwbe3T50EsLiSJCMYv2Yh9E81zRNi1ekoXMuy138Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qo1hmbcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo1hmbcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05E21F000E9;
	Thu, 16 Jul 2026 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210763;
	bh=25Ls++YWsUCtq/aXmQu8UouBMVmEoLK0KsYty9+21aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qo1hmbcHcN6/jLbDKvRPdxFvOBhuEC4vX+pEbNTQN7gm8iVWSMRkbKJ6wXnuwkjhG
	 y21hBrhVxE9mSU4ht7Q1v5BmtZsHGNh25D4Lors7tHBm7v51XLXR6K5SroZlmP+PsH
	 UY8mzZvsWVw3hs9OULeMGP6bos4I/hYL+VYVgrog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michael Bommarito <michael.bommarito@gmail.com>
Subject: [PATCH 6.18 170/480] crypto: krb5 - filter out async aead implementations at alloc
Date: Thu, 16 Jul 2026 15:28:37 +0200
Message-ID: <20260716133048.386942616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 6c9dddeb582fde005360f4fe02c760d45ca05fb5 upstream.

krb5_aead_encrypt(), krb5_aead_decrypt() in rfc3961_simplified.c and
rfc8009_encrypt(), rfc8009_decrypt() in rfc8009_aes2.c set a NULL
completion callback and treat any negative return from
crypto_aead_{encrypt,decrypt}() as terminal, falling through to
kfree_sensitive(buffer).  When the encrypt_name resolves to an
async AEAD instance the request returns -EINPROGRESS, the buffer
is freed while the backend's worker still holds a pointer, and the
worker dereferences the freed slab on completion.

KASAN report under UML+SLUB with a synthetic async aead backend
bound to krb5->encrypt_name:

  BUG: KASAN: slab-use-after-free in t5_stub_complete+0x7d/0xc7

The helpers were written synchronously, so filter the async
instances out at allocation time instead of plumbing
crypto_wait_req() through every call site.

Reachable via net/rxrpc/rxgk.c, fs/afs/cm_security.c and
net/ceph/crypto.c on systems with an async AEAD provider bound to
the krb5 enctype name.

Fixes: 00244da40f78 ("crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt functions")
Fixes: 6c3c0e86c2ac ("crypto/krb5: Implement the AES enctypes from rfc8009")
Cc: stable@vger.kernel.org
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/krb5/krb5_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/krb5/krb5_api.c
+++ b/crypto/krb5/krb5_api.c
@@ -207,7 +207,7 @@ struct crypto_aead *krb5_prepare_encrypt
 	struct crypto_aead *ci = NULL;
 	int ret = -ENOMEM;
 
-	ci = crypto_alloc_aead(krb5->encrypt_name, 0, 0);
+	ci = crypto_alloc_aead(krb5->encrypt_name, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(ci)) {
 		ret = PTR_ERR(ci);
 		if (ret == -ENOENT)


