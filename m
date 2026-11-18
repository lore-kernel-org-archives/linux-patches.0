Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037989;
	b=eBXPyNxVrx5JqMVJgHo/dW/AWyd8KWz851gwhMsOI55YIE32AjZWDM3+dEa2fJMxZQzw
	 h300rDx3Te0totq7ELmO2cYHNgnLc6C98+arPyZzFEMGqYCrNobmURe1F7YtMgNfy8KhI
	 8V1o1Z95FmbkbIUfJnh1w7iNhojtbSlvZMRGgGAidbCBqJKz4yKpQ79YcNpHt58SieBAw
	 L52gsYeXPOyqGDCwJ6P0zOkh4jo1hJk1s5LuVhTtuuHVW5LvbjWh6LBbUt+b352LJp4ys
	 Z1PBqp89+Txzuf60GJTYF90oTSdriuCYgyj0SXwzXS1m7XYzinYFanPOXTCLhxvmbaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fSOhYya2nw3FDw3THGY9saEgavLSm7qsJqTrFVEY1Wo=;
	b=A9cBOcSjMISZbco+VTpgAJaQ9LJmhgtvwqoHc1UNL6AeNjUTa23O8Ezq2NQYypKymCHs
	 YPFCVXJiqN3cippnLB1EW+eN8ZO0q/Xf6GZCQ++80Tvr/TljDiWsjs11e6VEO/wal+YnC
	 x2twmmMhtOBRS9mQ9THnMJmIAFSnQnzx4mgis33qyTgPS6fXAp8ZB6Eba14iO+kc426jm
	 K4Nd+Qij+2ePi0XRP2tyXPTWoVS1nzfy5YZtEWdXU19yXr1ZbBm9vVB4eOgxkfIBX3K6L
	 TM9o3iaqJjL7+v3VL8CTlY+u8bJDjFA/AZaYk9tS2TQ4a9XDay5xlBALjY9tuJNxYRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1CiqtQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB398606A325;
	Wed, 18 Nov 2026 21:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1CiqtQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079D81F000C5;
	Wed, 18 Nov 2026 21:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037989;
	bh=fSOhYya2nw3FDw3THGY9saEgavLSm7qsJqTrFVEY1Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1CiqtQWv+IK9Ck2sbPNVGk2ZRdBxoyEl8uGNBq3lzMSJar/ka2fvGOSEOhmsYjyu
	 WQ9PmMcQ8gtDLWCLn2guulergGbj0wZg+3e4UIxufNvlmamdmAZpqktOSpbMGUCQa4
	 etiUoDBxkzGZqjDiZO8dfbqh9cKL60t4JpdBxENA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1587/3318] crypto: algif_skcipher - rewind rounded output bytes
Date: Wed, 18 Nov 2026 15:36:49 +0100
Message-ID: <20261118150408.743264091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted patch context for the absent CRYPTO_SKCIPHER_REQ_NOTFINAL flag statement. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/algif_skcipher.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 8729ef268d9d8..4fc077f31aa48 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -83,12 +83,15 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
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
-
-		len -= len % bs;
 	}
 
 	/*
-- 
2.53.0



