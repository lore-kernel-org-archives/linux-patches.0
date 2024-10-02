Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AD125771;
	Wed,  2 Oct 2024 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875263; cv=none; b=LTxjoAdSlP3rcDPYkCqJqdHH8o0jMfztIQof1+93ZBlBZuvuTiSUsibw8N7PhLAUsqWhEhSp1BI5flHx83yXC2IaOHSHQrjjF7icVyhCfx20RMxOjPtpI8aOG1Jqu/TV0ohq47ukclyEbEXrOPbn082ZCDVABjWS69yjkv9jaiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875263; c=relaxed/simple;
	bh=JQfmt4UGtv1c+IdFr8BCgjq8Ye/7zcIMSIrUYrkgYvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAIVrddeIAKJG0MSvdoytPMhnoq1TcDc5wfzXtlDlIE/sfSaePuxM5+TjXvv1o0ROE9bfu0SSetfeGP8PGpKjEA5j+z8vasGJ0r3L5neytXQNRpbedFFcmZkKFa5xfBbzCCbapySYgG8yYtfJCMfEES5/d46eLHbIPkyNLovOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPyNY+yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPyNY+yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3B2C4CEC5;
	Wed,  2 Oct 2024 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875263;
	bh=JQfmt4UGtv1c+IdFr8BCgjq8Ye/7zcIMSIrUYrkgYvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPyNY+yiVV1/QJCQ2SyW/UMQVmoQIY11MkFYxKP5O8JHvItqeVQ0rh86oHIplVUWQ
	 n6DTkiPkpm5Mk42QH6X1VoX095hfFhF2F/OfvmgTOT84FG5nmxh6r9OWdPGPLm6lzb
	 m/g63A1nUwUXifJR9nFg9PxmVvh/jYiKyQZ9GHzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 017/695] crypto: x86/aes-gcm - fix PREEMPT_RT issue in gcm_crypt()
Date: Wed,  2 Oct 2024 14:50:15 +0200
Message-ID: <20241002125823.180109943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 001412493e74d89166d2441b622eeaea00511bdc ]

On PREEMPT_RT, kfree() takes sleeping locks and must not be called with
preemption disabled.  Therefore, on PREEMPT_RT skcipher_walk_done() must
not be called from within a kernel_fpu_{begin,end}() pair, even when
it's the last call which is guaranteed to not allocate memory.

Therefore, move the last skcipher_walk_done() in gcm_crypt() to the end
of the function so that it goes after the kernel_fpu_end().  To make
this work cleanly, rework the data processing loop to handle only
non-last data segments.

Fixes: b06affb1cb58 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-crypto/20240802102333.itejxOsJ@linutronix.de
Signed-off-by: Eric Biggers <ebiggers@google.com>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 59 ++++++++++++++----------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index cd37de5ec4046..d63ba9eaba3e4 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1366,6 +1366,8 @@ gcm_crypt(struct aead_request *req, int flags)
 		err = skcipher_walk_aead_encrypt(&walk, req, false);
 	else
 		err = skcipher_walk_aead_decrypt(&walk, req, false);
+	if (err)
+		return err;
 
 	/*
 	 * Since the AES-GCM assembly code requires that at least three assembly
@@ -1381,37 +1383,31 @@ gcm_crypt(struct aead_request *req, int flags)
 	gcm_process_assoc(key, ghash_acc, req->src, assoclen, flags);
 
 	/* En/decrypt the data and pass the ciphertext through GHASH. */
-	while ((nbytes = walk.nbytes) != 0) {
-		if (unlikely(nbytes < walk.total)) {
-			/*
-			 * Non-last segment.  In this case, the assembly
-			 * function requires that the length be a multiple of 16
-			 * (AES_BLOCK_SIZE) bytes.  The needed buffering of up
-			 * to 16 bytes is handled by the skcipher_walk.  Here we
-			 * just need to round down to a multiple of 16.
-			 */
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-			aes_gcm_update(key, le_ctr, ghash_acc,
-				       walk.src.virt.addr, walk.dst.virt.addr,
-				       nbytes, flags);
-			le_ctr[0] += nbytes / AES_BLOCK_SIZE;
-			kernel_fpu_end();
-			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-			kernel_fpu_begin();
-		} else {
-			/* Last segment: process all remaining data. */
-			aes_gcm_update(key, le_ctr, ghash_acc,
-				       walk.src.virt.addr, walk.dst.virt.addr,
-				       nbytes, flags);
-			err = skcipher_walk_done(&walk, 0);
-			/*
-			 * The low word of the counter isn't used by the
-			 * finalize, so there's no need to increment it here.
-			 */
-		}
+	while (unlikely((nbytes = walk.nbytes) < walk.total)) {
+		/*
+		 * Non-last segment.  In this case, the assembly function
+		 * requires that the length be a multiple of 16 (AES_BLOCK_SIZE)
+		 * bytes.  The needed buffering of up to 16 bytes is handled by
+		 * the skcipher_walk.  Here we just need to round down to a
+		 * multiple of 16.
+		 */
+		nbytes = round_down(nbytes, AES_BLOCK_SIZE);
+		aes_gcm_update(key, le_ctr, ghash_acc, walk.src.virt.addr,
+			       walk.dst.virt.addr, nbytes, flags);
+		le_ctr[0] += nbytes / AES_BLOCK_SIZE;
+		kernel_fpu_end();
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+		if (err)
+			return err;
+		kernel_fpu_begin();
 	}
-	if (err)
-		goto out;
+	/* Last segment: process all remaining data. */
+	aes_gcm_update(key, le_ctr, ghash_acc, walk.src.virt.addr,
+		       walk.dst.virt.addr, nbytes, flags);
+	/*
+	 * The low word of the counter isn't used by the finalize, so there's no
+	 * need to increment it here.
+	 */
 
 	/* Finalize */
 	taglen = crypto_aead_authsize(tfm);
@@ -1439,8 +1435,9 @@ gcm_crypt(struct aead_request *req, int flags)
 				       datalen, tag, taglen, flags))
 			err = -EBADMSG;
 	}
-out:
 	kernel_fpu_end();
+	if (nbytes)
+		skcipher_walk_done(&walk, 0);
 	return err;
 }
 
-- 
2.43.0



