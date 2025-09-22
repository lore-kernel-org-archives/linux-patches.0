Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE91191F66;
	Mon, 22 Sep 2025 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569706; cv=none; b=d1AFp9p7nnVo9oSW+1cY9hBBprOnN6qIHFR82gy2vOK6B7fhkLF75epRo9QSOq3pn8kJpnBJYdwGuMfdjUT5qQ2ezSdJYPVK1/B8NjLaArOlNt6PWC5LlselE77FUwYs4KIM1MbrW6Vxdi4jkTRtg8I2I2Is0ibUC1+S+rHq7Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569706; c=relaxed/simple;
	bh=7zeZlM939qvrgRATpOfh+6GEzlGEanXNH6mgG4eYW7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW5nv6LH44am+wnAPIvkF+EoBk5bD2ha+SgtqoZc//TgyoGaickIYHk68ggmiC8iQpx2vEhDo0QO8mvn1ozOALMBm6JG7XdBuvEpwORZg6QGuui0o+g4e15Ajulj3TpuFbzld9N4GkxOrf1WKHBh+TqVdm8BrDjCyS0Y8P5C3tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMgZkY9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMgZkY9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD66C4CEF0;
	Mon, 22 Sep 2025 19:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569706;
	bh=7zeZlM939qvrgRATpOfh+6GEzlGEanXNH6mgG4eYW7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMgZkY9HSF/kZ9+ma3xenleeLTIzhzJ1ah6CiSyql206MU+RS96BChvwtOfIqlK9P
	 U3jdJhlL3TYNKCTsyL2yCh/UrbggNlp/ynFHGzdGKiAvcibceytTtZvezChQYQLJ1b
	 FhTXbIssfI2cCnEsgPhAVkP9xPYeIIf+5fEjtgas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 29/70] crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg
Date: Mon, 22 Sep 2025 21:29:29 +0200
Message-ID: <20250922192405.367140476@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 1b34cbbf4f011a121ef7b2d7d6e6920a036d5285 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c         |    7 +++++++
 include/crypto/if_alg.h |   10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -969,6 +969,12 @@ int af_alg_sendmsg(struct socket *sock,
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
@@ -1103,6 +1109,7 @@ int af_alg_sendmsg(struct socket *sock,
 
 unlock:
 	af_alg_data_wakeup(sk);
+	ctx->write = false;
 	release_sock(sk);
 
 	return copied ?: err;
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -134,6 +134,7 @@ struct af_alg_async_req {
  *			SG?
  * @enc:		Cryptographic operation to be performed when
  *			recvmsg is invoked.
+ * @write:		True if we are in the middle of a write.
  * @init:		True if metadata has been sent.
  * @len:		Length of memory allocated for this data structure.
  * @inflight:		Non-zero when AIO requests are in flight.
@@ -149,10 +150,11 @@ struct af_alg_ctx {
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
 


