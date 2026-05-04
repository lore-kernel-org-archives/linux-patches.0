Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428583DE44F;
	Mon,  4 May 2026 14:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904517; cv=none; b=F7+zzBFDvp24afUh7yYzvUhHs0PaTuomh4MGEMS0Ui5kor3dKWYHpdWt4lPjt7pD3AT9yJzvOeW4bp8Ni12N09f0VrmelAw2fxU4Am1BbZANjdk6HKRFpGnxkBgbWDDIns5whwoiyn5IYO6Cy5h/VkgQ4es/ZQLgaJnaWIpNmWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904517; c=relaxed/simple;
	bh=jj5DOxvbKSbGppUjzauK0MbqwYtPIP16XWARp7k9ol0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcfG3yxYBhsF8j5HmkTLOYMYoEoFDqmUyn/y/k6YACOAU61yl2+pEb0gMVdU21dfbm7Q9u7CyNkVykGwOQqzEkagYSWMTTgygCn34Gzx5fn5Yr0msdzgTS9iqZZ1fNQZRdn1AhE6oSoLLExI0Qe/u3txZ7KVKzUrPd/ahl8VO5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayPby91B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayPby91B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE372C2BCC4;
	Mon,  4 May 2026 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904517;
	bh=jj5DOxvbKSbGppUjzauK0MbqwYtPIP16XWARp7k9ol0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayPby91BGAvqvK5GW1MkLR9nfYQ2KS3ifnzW18t7IfB+FgBD1Nu1Dnv7+TLNA6GTk
	 Qz/WLfVtNiGi3X8mbs9yaQCdozb3AvaDYraq0ykvIc9n3p+gI6WIT90hkFt7pKiA+V
	 PUTQ61lRK5brrNgvGjzW6UpdMCkJtxgvvtpXgj7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 036/215] crypto: pcrypt - Fix handling of MAY_BACKLOG requests
Date: Mon,  4 May 2026 15:50:55 +0200
Message-ID: <20260504135131.496711528@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


