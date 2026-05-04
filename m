Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741271ADC83;
	Mon,  4 May 2026 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903732; cv=none; b=YAqtfo76/wiKA6l+KpQDN2DQgLA8gxmhf5o6cHCbqt1yk6bfRdPKKL5x2Lo9qFCeWcCe6EsjVHTIaTeFrglgpfGvhV283SPZwPUld6WOeRL3BN8zWdYlljwxEeO4tcbdQLh8D38S28M5iBO5YNkja5+6Ex92CKfqDCk8PS2UEbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903732; c=relaxed/simple;
	bh=fXCsgON6y0c2Iy/sgyKbZaDRfkLkNoOty+EmV2Dbo4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZvyv4IS9r8VCapRu62+1JjR/lZ7so2Q3DkaK9Du7Hrr301Ab0ijDKgAG7oa2r/AsVyaOfG2Jp5d6tdMSCLAwnQVY4lkBmlp0Nk8TSyHzu+WyMF8f7e5s4yQ3/d3FgOt5EzbNAEyZ1wSjIgMnYyryDwzxb6cfjaGadqY1gmH6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIvUmOZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIvUmOZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2752C2BCB8;
	Mon,  4 May 2026 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903732;
	bh=fXCsgON6y0c2Iy/sgyKbZaDRfkLkNoOty+EmV2Dbo4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIvUmOZyFY/pJplpZayGkkGA1YrfRRv6xyUVr1Wp3wIw2Ti6GAF2GCmlknH7ktJIZ
	 GDohiw1DXljwZNZLtagZHN6vf8HUi1pUZyVI9YunpoI7ykEGZZ0qd5AFHW1aeJHt4R
	 4swd2mBL6MGnDHykyqmSbCUNKlgd5AnRPJzDOKpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 040/275] crypto: pcrypt - Fix handling of MAY_BACKLOG requests
Date: Mon,  4 May 2026 15:49:40 +0200
Message-ID: <20260504135144.428906739@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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


