Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E1A3BD646;
	Sat, 30 May 2026 18:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165681; cv=none; b=IvsZDjHhbB+er9QDmTVzytrXvCfbf9gFO19v6Gb3ePkxCX1m7uzOBJfjFHvxFFgx+f40T9NSdSnOsL9J9oH2y34Dehaoa4n5G+Kd2LEbfThIenlLfoCh28PwCf+fJdUWrieYuazF2aZqqH6J+aI1OmPAxgOgEXqhEC097Towyjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165681; c=relaxed/simple;
	bh=wdz7CEjYReSXD5wjXDo/Lq+jQXKk2VFd4CZY7lXm44c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoL8iNV0agOj9fZky7f2VnIq57xkDNigZfDMF8ZE6kxD57T7tHimdFuOVVngYKLK02g9Lo+bMgVrBdk0bQQeU9b9xizfOcSTRK81gq0zeDrpM2ciLby+hf+2pc/tjHEipDJfAgJDs3p81YX3AYrsLYrHHu1Vpi7o4BFgp0IMtZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mr62PYIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mr62PYIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E47D1F00893;
	Sat, 30 May 2026 18:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165680;
	bh=whM5ghCbd01WmUtcyWzqqEapZZYVfsSh3cOK+1DVfB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mr62PYIkPoZ/h3DDGR8gDfgskWvTuEYFfhWd/uZGYiH2VcF9Hjs5uVdpukEjkui6C
	 4AY1bxDdE7PERCBBzYUBatbIfg8z1mKK6J78H248Euyz9VfD/1PpFGirV94+/fCnvp
	 boIjrTn4xTQkzY9HK1Mrbld+swvW8pX3wA0G24lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 151/589] crypto: pcrypt - Fix handling of MAY_BACKLOG requests
Date: Sat, 30 May 2026 18:00:32 +0200
Message-ID: <20260530160228.755696757@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


