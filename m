Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1237B33F5A3;
	Sat, 30 May 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159871; cv=none; b=CKcKlPZEDG2rC2Q+Nh5nRxnB9VnGd74klqoxj0reP3Mwu1cKSWzr4W95jHYRmkgkrpkSHlDdtXkHZUGhzvGunKJrQggL5wM3dntuwtT4hdUuvG+36xucWSgf4sF4xvTSUeu2qs6KmlO4evUQzBAMHeJAfDs2ukyYAm98/y0VX68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159871; c=relaxed/simple;
	bh=xDB/74RosMhiLsM3d2Bn9g8dZlfW0snTP1y/fR+k9Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhfUMoqXa6ZjjTw83wb8/C5ilM2CE/4MJq0n1iPc4nb6agTz22tLIOevfKA+ga0BsZORPevuKheJ3MpOZI1MEfly66EUlzY3SoEYiCPkjFzeTWSnKb4Kx+5kkgKa8XF27xU5nB7+cSrBXicJYigWyNq6TtG6qiixcYFOUMSjc+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBB3rgw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBB3rgw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0C21F00898;
	Sat, 30 May 2026 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159870;
	bh=ZNmlmXOQjq6iDIIEnjv6rWB7ZptFc8VIY+PZwnk6k/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBB3rgw8aWDdyYE1p/RFhOVun0OsJpZFdnpDMwZNSrfTVS8zpKL3d5lE7sK1NBuu+
	 0KPyvZFwzQYHmylZrSMpcJacuQ+2snAJl2tilUW6lCMU1l+C6bnNG1OwAiHLsmQtuu
	 c44sdsHyE4YW5aNrNt8YWU/wSLW4jGbhhSTrYy6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 183/969] crypto: pcrypt - Fix handling of MAY_BACKLOG requests
Date: Sat, 30 May 2026 17:55:07 +0200
Message-ID: <20260530160305.541864246@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,6 +69,9 @@ static void pcrypt_aead_done(struct cryp
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


