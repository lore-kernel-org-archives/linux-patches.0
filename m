Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062242;
	b=Fvyz7FRCxbB8e1Fw72lIqufKf9aYxqgDroBWZzgIqq0Ewuh8YozakXIkbQ4TZQhkvqLc
	 yLsEVBTXi99EqF4WuOd+V0HfunsC91WerddWvNpEmqi6cKA1ds5bo903h3NZy+9x5KY7T
	 H4J+e19nzQTwBqSBP5etKi+eeV/JYwe93RzRlVwbHqozky23eWW4V1vjoFuv0pnvYHM4I
	 QTHvtacM/7tbQ2/a2CrlqI266r8VOUj6a67FYMzezE7zFsMMuRpMz+5OG47hcf88qRwIT
	 /qzrjYmWSbiBFIbwddMWXRWsFx9pI/l8wQVOQlSQsZsH0zuAbM9g+5/xpxJdmYH07Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yafi4st1B+Vue97HfLC6XJcVCcwZh4g4PaSudlW5Sb4=;
	b=J6CDx6hJTtb5hxY9G2Hp46Mgsewk5aJ/sENdWuBFxbMIzozeNTbH/xcMKkXdG9joj88m
	 57/xFW/ihn/aA/rSQd7/FOZ/y2Httx2Vgp33vxeZhf81QDe6KzQEqzEaMqvXiEWIMshdb
	 YfNH5djwiV6xU9ro7J3omV3lqhc+LjqR7p4LeiKEyNEn8+Ayg4r5YAvCKEEem570xAa1Z
	 CqU0e+kFsT3KyQ+jKqqYe+6XQNft5bqVU+O2s3LHdEaLmIHnFKzvnI6snlOl4aOKN71sg
	 CQ2lwtqOGRPjTSsPjvvWkjhB0qR/yaumvum+Esk9SsfNsWndt/MV+mPPkSlU+fN9YKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rrd2wd5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7165A606D827;
	Sat,  7 Nov 2026 14:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rrd2wd5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF801F0089F;
	Sat,  7 Nov 2026 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062242;
	bh=Yafi4st1B+Vue97HfLC6XJcVCcwZh4g4PaSudlW5Sb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rrd2wd5ZIFnATwgXK0fwK3d33ILZ/aFTh2+ldRBwXbHGEoY6CXI7AUcv1pbRztQPR
	 oQN1KRZxW4cTAyEv72aNTZwMIofowbHKrR6931Lwg8Akn1afQ6PXZpb0lehpIcjr9j
	 +q/ajR2rbLRs3+hUN2AuwXTyvJ5x8Oc7HK/GPsms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1190/1536] crypto: algif_skcipher - rewind rounded output bytes
Date: Sat,  7 Nov 2026 08:53:26 -0500
Message-ID: <20261107135031.169387635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



