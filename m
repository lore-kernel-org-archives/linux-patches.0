Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924BA1FDA89;
	Mon, 22 Sep 2025 19:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569631; cv=none; b=rHf6lIjZksiv5ULaGF+964FBeFadio0IczT5oOTdrExAN8E6UVjoHh/5QSCRoWyhH/+PkhJxvcl2pd6gwpcm0kLy712OXHzByXofYPZNHgpYCXxxLMKOdm3yD5rJtwLyrOOvn3qFn2fO+BSI7s2iETCfiMdYZDJPlUG2ydHIlPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569631; c=relaxed/simple;
	bh=AoGOgp240CXNEvXRz/uCs1AI6Co2G1BFzB2UdHly7m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXsOx87toJJQSFiR6RscvTIlWFv5D9lzw0sjzP5oHoBNessumahqm9hTacbglvPjxVpwfUevTFYoQ9Kc5VOAGeuICQZTabviu3NPBd9zg/s5Jf52KXvL1+fmxzJBGDR0R7HmC3fUoYTJpKfstS/1FYXxwEMl4SMlAAo1n0Wyoeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kuh2loti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kuh2loti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B5BC4CEF0;
	Mon, 22 Sep 2025 19:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569631;
	bh=AoGOgp240CXNEvXRz/uCs1AI6Co2G1BFzB2UdHly7m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kuh2lotiLeswCviBqKqWdLCNqS4ePwGcXR64L2uLN4QwRTNOfKUV7EUEyDt0OhM0o
	 FuV725FflFOmzBIuie61kYuudVJXkWMqIlhC7NpCiVfrW/sTFxvG1JgYJ5dI2qzXtF
	 +Wl6sgOTGBf3OS1+hvCrP1FnEKZ9NC2KrgdgEjQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/61] crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg
Date: Mon, 22 Sep 2025 21:29:54 +0200
Message-ID: <20250922192405.324997225@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 1b34cbbf4f011a121ef7b2d7d6e6920a036d5285 ]

Issuing two writes to the same af_alg socket is bogus as the
data will be interleaved in an unpredictable fashion.  Furthermore,
concurrent writes may create inconsistencies in the internal
socket state.

Disallow this by adding a new ctx->write field that indiciates
exclusive ownership for writing.

Fixes: 8ff590903d5 ("crypto: algif_skcipher - User-space interface for skcipher operations")
Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c         |    7 +++++++
 include/crypto/if_alg.h |   10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -859,6 +859,12 @@ int af_alg_sendmsg(struct socket *sock,
 	}
 
 	lock_sock(sk);
+	if (ctx->write) {
+		release_sock(sk);
+		return -EBUSY;
+	}
+	ctx->write = true;
+
 	if (ctx->init && !ctx->more) {
 		if (ctx->used) {
 			err = -EINVAL;
@@ -974,6 +980,7 @@ int af_alg_sendmsg(struct socket *sock,
 
 unlock:
 	af_alg_data_wakeup(sk);
+	ctx->write = false;
 	release_sock(sk);
 
 	return copied ?: err;
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -136,6 +136,7 @@ struct af_alg_async_req {
  *			SG?
  * @enc:		Cryptographic operation to be performed when
  *			recvmsg is invoked.
+ * @write:		True if we are in the middle of a write.
  * @init:		True if metadata has been sent.
  * @len:		Length of memory allocated for this data structure.
  * @inflight:		Non-zero when AIO requests are in flight.
@@ -151,10 +152,11 @@ struct af_alg_ctx {
 	size_t used;
 	atomic_t rcvused;
 
-	bool more;
-	bool merge;
-	bool enc;
-	bool init;
+	u32		more:1,
+			merge:1,
+			enc:1,
+			write:1,
+			init:1;
 
 	unsigned int len;
 


