Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78583043A1;
	Tue, 30 Sep 2025 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244236; cv=none; b=gUJd3XQQ0clQFW+E4atyJd/Vj551tGGXNFw1cKBNhAv2pK0axbp4r+iyBvYYvXSB1+0wqkcQduN3Pyjuiw9pw+CX4pVKCcJGJFu4q5/PkHAPH9w02wMjjrFlLTB2tnuPBjpcBD7vvOF9YY93DoyUBu+8nyEGKKSgnU00Vu1WdY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244236; c=relaxed/simple;
	bh=vWE47KaveSguapjj4gr9z5Csp1hkzpHT4hgRKj9kVH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B12uFIrevlWPGC52Tm5aRJBiqSvKS5xhcfmc0kN2k7aKMF7exj/HNmcZ03XsxDOhvUDm4sX9eBvGiMuOhZYb7Pg6L/lnXPCb5/6fzYmwTg5r5HmBpgg45wCSkb4zcBF8eaSupyr3x3CFm0QbnwRgcS9pX+EPDcFjhJG6MaC+qQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqbKSjHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqbKSjHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B33C4CEF0;
	Tue, 30 Sep 2025 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244236;
	bh=vWE47KaveSguapjj4gr9z5Csp1hkzpHT4hgRKj9kVH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqbKSjHbRnbExzIVv2/0zP26w8B/BCJQKfK6/IPVdjIiDFNiXfQlKYX4XLpMH545A
	 zptsdVwL+UPEp0QvjkzBF0sUy8LWWs3UcpGiVcHGSeQN8ij0b1ucYo2jqK09rN1wns
	 kHb1jF0o5tob4CKSf9qIcOU/KuvQf/E+fOXbso28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/122] crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg
Date: Tue, 30 Sep 2025 16:46:39 +0200
Message-ID: <20250930143825.786356827@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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
---
 crypto/af_alg.c         |  7 +++++++
 include/crypto/if_alg.h | 10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 755e6caf18d28..25cf2fa3dde75 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -862,6 +862,12 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
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
@@ -969,6 +975,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 unlock:
 	af_alg_data_wakeup(sk);
+	ctx->write = false;
 	release_sock(sk);
 
 	return copied ?: err;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index a406e281ae571..1424200fe88cf 100644
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
 
-- 
2.51.0



