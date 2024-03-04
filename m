Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665B37C082;
	Mon,  4 Mar 2024 21:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587868; cv=none; b=Ad+1ELfzP7mfFk7p9astBrkkYHgeq9PWFHfPvm1fWjNgpu2tUAJSwq9FwbGlHpXP3AFd7q0FuQgnKe9+70mfjZCakFX3p09V4ilHcX4HA9ZaYoohwcs1W2Qig3KgsdUVXayeiHvF7LRv0lbJcMajXvhEj+4DqNL/j6eK0qkpQEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587868; c=relaxed/simple;
	bh=HzW3cvsD1LllZ/81BdyWAI5b662q2UYbUHEj/B4aRBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIthnMe/fe/9wtTGTu9iZl4Ea74GMa7LczNUy37lH1/1hJG8h8OM+k/LePrbfbjnOZHGqw+LxaN2LrJxqvfI8U1MmOKASP2SgwI4wJ+eQODttL8luFDbpc25UxCYZR9dqOK7Wwdf4VxDgZaiorDBfaY4QMjPTeUgkwDOATeElOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hV7Qryep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hV7Qryep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C12C433F1;
	Mon,  4 Mar 2024 21:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587868;
	bh=HzW3cvsD1LllZ/81BdyWAI5b662q2UYbUHEj/B4aRBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV7Qryep3y+oWd7lI87T5crwTAyq8EnKYeRMGT0mQkJXZovFjGszIvWZmmHWg4nV4
	 cMOg3MxCCyHkQDVwR7VW8VC9PfQAFybI3BP0LjzfOZ1X+IugKjlA4DRB+GvGv9K0wU
	 /GffK+j3ZSmMsZR1nXYMYFapj8LDf5WXfWWWwtss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.7 096/162] crypto: arm64/neonbs - fix out-of-bounds access on short input
Date: Mon,  4 Mar 2024 21:22:41 +0000
Message-ID: <20240304211554.913615595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 1c0cf6d19690141002889d72622b90fc01562ce4 upstream.

The bit-sliced implementation of AES-CTR operates on blocks of 128
bytes, and will fall back to the plain NEON version for tail blocks or
inputs that are shorter than 128 bytes to begin with.

It will call straight into the plain NEON asm helper, which performs all
memory accesses in granules of 16 bytes (the size of a NEON register).
For this reason, the associated plain NEON glue code will copy inputs
shorter than 16 bytes into a temporary buffer, given that this is a rare
occurrence and it is not worth the effort to work around this in the asm
code.

The fallback from the bit-sliced NEON version fails to take this into
account, potentially resulting in out-of-bounds accesses. So clone the
same workaround, and use a temp buffer for short in/outputs.

Fixes: fc074e130051 ("crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk")
Cc: <stable@vger.kernel.org>
Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/crypto/aes-neonbs-glue.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -227,8 +227,19 @@ static int ctr_encrypt(struct skcipher_r
 			src += blocks * AES_BLOCK_SIZE;
 		}
 		if (nbytes && walk.nbytes == walk.total) {
+			u8 buf[AES_BLOCK_SIZE];
+			u8 *d = dst;
+
+			if (unlikely(nbytes < AES_BLOCK_SIZE))
+				src = dst = memcpy(buf + sizeof(buf) - nbytes,
+						   src, nbytes);
+
 			neon_aes_ctr_encrypt(dst, src, ctx->enc, ctx->key.rounds,
 					     nbytes, walk.iv);
+
+			if (unlikely(nbytes < AES_BLOCK_SIZE))
+				memcpy(d, dst, nbytes);
+
 			nbytes = 0;
 		}
 		kernel_neon_end();


