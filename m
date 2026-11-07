Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063199;
	b=vjt+H5AKKvYF1mGWSXpMEirWCieM/mOTBftXLaI92+BrPZMmyDEwVNAzv8OD1pc5j6/c
	 l5Btv/TUz6BT8uvPVlxu8aJYHVaZ+M5Oy9con0CzKYOKU//lrB/MDGtCSxFcGZf0fW9KW
	 Km0xttEZ+8Ls2Y9CQ0QOvopBi09326qrzqeJtQJF89I9fSfLjc7ozv5hE33e0NZ2GVOqF
	 NO8uGxw1K4s9n+h7f4lkyV+iE0/ssdpmBjiRcsOUD0k17bubxtuXskPQKwc6/ke9YbNld
	 EmB0e2g8RncOaT5a/bueNr07YzL4wRqnC7LzBWZrL1WnpCjN89mdqJrfxdirMuu7xww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MezpFQZg4pwp+JFqmrv6LEE2clIOw9PCpZraoH9kcRU=;
	b=Khykiz87CNj8PpPYaAYcXiEhxjD7BUDnnK3ZPfc/tFCxX4uJaVc3Qed9sWg53w1PE5e9
	 lipjYP/LQIMZRVS3pMDJTPF8e3UvG7QhYT9qqrA1aDBtOBeQRNrD/3S2qXdfYIbaC3DYz
	 PH5s8NW69m1y4e6C4ryTDfsJ2rnfqSx0MgkAnlzvtdkLT3e3MEiICgqxM/12Lc0fqlQjG
	 Ym/zEkYs3b7gWDZFHr3o0DKoeo9cJ7zQokOwDj1DG85ISgDWfmMkhUKpD1+Vq0Xiw2Yec
	 3nhqHg13nXjjqbqKRUjqQc2etEzUme+fIj9PMLfx1FS0Mn0oG8k88dBYdrkZnaY8oWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMAw71mm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66E606A33B;
	Sat,  7 Nov 2026 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMAw71mm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1461F0089F;
	Sat,  7 Nov 2026 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063198;
	bh=MezpFQZg4pwp+JFqmrv6LEE2clIOw9PCpZraoH9kcRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMAw71mmabGs8Z7zBtnBMabXr7hb/wDWLmvpkAHBZee0XGwbYkD9yTHuL5C0U3i3I
	 XrACmvPpco0Q8jDy8EFnZv+Z7WxDXTO2roar97g6KnAmgSVMIXJtpCeww2vVppW8mS
	 Enu7XKz/8cdSsuBKqExDMAxa085LZ51885JMNksY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 412/869] crypto: algif_skcipher - rewind rounded output bytes
Date: Sat,  7 Nov 2026 08:51:34 -0500
Message-ID: <20261107134907.311711710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 2f90facc7b94934653eb7ebfadcc25d503b89196 ]

af_alg_get_rsgl() advances the receive iterator by the unrounded RX
scatterlist length.  For a continuing skcipher request,
_skcipher_recvmsg() then rounds its local length down to a whole chunksize
without restoring the iterator.

A later chunk starts after bytes which the provider never wrote, while the
syscall returns only the processed length.  When copy_splice_read()
supplies non-zeroed pages and publishes that return as a dense prefix, the
gap exposes stale bytes from a previous page lifetime.

With unprivileged xts(aes), a 31-byte MSG_MORE request followed by one
final byte advances a 47-byte destination while returning 32 bytes.  A
hardened v7.2-rc5 image retained all 15 seeded stale bytes in 4,829 of
4,829 records.  With init_on_alloc enabled, all 72,345 gap bytes observed
were zero.

Rewind the iterator by the tail excluded during rounding, before rejecting
a zero processed length.  The crypto request uses only the rounded length;
af_alg_free_resources() releases the entire RX list before another receive
iteration.

The fixed target-like kernel returned byte-identical dense 48-byte output
in 4,771 of 4,771 rounds.  The unmodified kernel returned the vulnerable
32-byte short record in 2,409 of 2,409 rounds.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 35ebc3e0201b0..b245d37db76b7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -116,12 +116,16 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
-		if (len < bs) {
+		size_t excess = len % bs;
+
+		len -= excess;
+		iov_iter_revert(&msg->msg_iter, excess);
+
+		if (!len) {
 			err = -EINVAL;
 			goto free;
 		}
 
-		len -= len % bs;
 		cflags |= CRYPTO_SKCIPHER_REQ_NOTFINAL;
 	}
 
-- 
2.53.0



