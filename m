Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787832E2F0E;
	Mon,  4 May 2026 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902948; cv=none; b=dknhKapBNKGQy4T7py+SGIm73hjtwsf49KWfydP/nKJspM9t3K6vG0CWOokkNK4Tcz5EZFVK6IPElYSfy/7wSJ5CpP6SjVLRKqqZ83THEHMvfvZyenRVid83Cds4vcBseJhv0wuIGWlViwA21tXvOUZXka+9v77JARN6+aX9wlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902948; c=relaxed/simple;
	bh=RpEw8S7t+vLYWsVUQrpZapYEWc4AK7xiwY8/Y668KB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvkJxk7t7GMz28GHfV9R6kkve6aqOpeHvAskixU3oT+cpVwajWnkOIhWktilnw59TXJab/Fg0uGvmuR0BwMFG1K9tqERQ/E1vYXzzv+heuZPcYd3ixoOV7nJ2tWXJrwYslSEMypC+ElqoX9hnjXLSJa4CyCgI/ccZLorHK4QsR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk9WHjTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk9WHjTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDDDC2BCB8;
	Mon,  4 May 2026 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902948;
	bh=RpEw8S7t+vLYWsVUQrpZapYEWc4AK7xiwY8/Y668KB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk9WHjTs4ie9+Vb8W73xidgM7tDK19mg0+deb1dJ1cfhS1KK7Vb45ambYLMZuWEJR
	 1UPhRXM6aXU3yZdAVa4tmwDcMl4PDnQG1pKQQWu5Z9Yl64DS25nAvXOJZprFIuTJfl
	 /XnoMI+W53BCD5n55Lir1cw4gVJaxSeaFOfrz0rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.0 045/307] crypto: pcrypt - Fix handling of MAY_BACKLOG requests
Date: Mon,  4 May 2026 15:48:50 +0200
Message-ID: <20260504135144.529282560@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 915b692e6cb723aac658c25eb82c58fd81235110 upstream.

MAY_BACKLOG requests can return EBUSY.  Handle them by checking
for that value and filtering out EINPROGRESS notifications.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 5a1436beec57 ("crypto: pcrypt - call the complete function on error")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/pcrypt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -69,6 +69,9 @@ static void pcrypt_aead_done(void *data,
 	struct pcrypt_request *preq = aead_request_ctx(req);
 	struct padata_priv *padata = pcrypt_request_padata(preq);
 
+	if (err == -EINPROGRESS)
+		return;
+
 	padata->info = err;
 
 	padata_do_serial(padata);
@@ -82,7 +85,7 @@ static void pcrypt_aead_enc(struct padat
 
 	ret = crypto_aead_encrypt(req);
 
-	if (ret == -EINPROGRESS)
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return;
 
 	padata->info = ret;
@@ -133,7 +136,7 @@ static void pcrypt_aead_dec(struct padat
 
 	ret = crypto_aead_decrypt(req);
 
-	if (ret == -EINPROGRESS)
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return;
 
 	padata->info = ret;


