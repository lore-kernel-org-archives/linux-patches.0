Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0544C261B9E;
	Sat, 30 May 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163330; cv=none; b=IgbOWYl+GQj5xt0zdnGDmkF4c7tbdNfi1JGqrcu8q89PN3x30GOxFWTm337gcP7q8l5W3KdEIUmmgbAD2gVhP2uiQ3rBGu0ly/XUqbpbQfsqReCnufrYe3DBRBW5UGJobxJPuU/c7TR3bER7yxwh+RdgXTuWSc4LYIKVNHd/4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163330; c=relaxed/simple;
	bh=iQaCgu338TuRoYw2QvvCpeljyxBXCAYep4JS12vp83Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5TeoypGa74nR9K18o1ZoQNeBpZNz6lLSMkgkAMAYk4kP2J1SLLRs7DRoXe8khNAvEq1nOxRgmkSskpNqz4YbwcwSTmXQqwLJJZlJcZ33SuPd16o3Cd4VSyQpem6Qoq2P8Cvjp1IquyHTNWS0TDDBy7UqBFtdzcwhyN/yrt5jaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebxsCp7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebxsCp7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499581F00893;
	Sat, 30 May 2026 17:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163329;
	bh=M1dKRaDbd3sMl8B+0IH5O2jrVK8Gz8C1mBAj3FPPrtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebxsCp7kWz6Vh6MspdUuBBuj8nDGhkhgXfrPNZ3NzVGzG4yN0S3ljM1+7V7xgqs0n
	 h3g5f4eD3AmqLaebMd/HI67q7Ku62Kz1XooJK8lFMx5NviaO6CWUdjR7E2kPxgupEe
	 Px877aPrQrs8m1wCeK0MzfSXjfSKsZPsgWQZhXhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 198/776] crypto: pcrypt - Fix handling of MAY_BACKLOG requests
Date: Sat, 30 May 2026 17:58:32 +0200
Message-ID: <20260530160245.625586794@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


