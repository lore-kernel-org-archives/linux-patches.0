Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDFE61675;
	Mon,  4 Mar 2024 21:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588756; cv=none; b=uICaEi3Vd7dtNtLtg9ulDW38UeIybxkJx/Tu0vnyDBfjXMyhyuKgrt+qnxN50gM2rz9un4f46qGNGm/8stNTzjXUs7enqExE0+SE6L131+CWLLup68uzlV3Vn1YGdhIgh35NZRUfTn2foK5wrzIK3adPXB+AScePsqTQcI8l2S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588756; c=relaxed/simple;
	bh=02dJzPRRVSZIRB35An+I9iOMJAUUE7Q1NCwunupLEGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFrZSYKQMY2dK+Eio+VsMVNbA8qRFe+KYyU3jGNx3235rEU6eAkVAqyVr6Ku9iYcn1rT120sl1I3mJG4QDNqNypT1SfGGuJC/RDkp7CXe7MNpzIEq/TDnqC7+zjhibId+9bG0IPqIO9v8Vun/Osi4a/4xyPFvLwj0aPxMY58fJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDo4Ci8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDo4Ci8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EE9C433F1;
	Mon,  4 Mar 2024 21:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588756;
	bh=02dJzPRRVSZIRB35An+I9iOMJAUUE7Q1NCwunupLEGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDo4Ci8npIxDMjOVUKCy8YB9/C4U1ohQxs3YEo6r9N9rD+2GfkW2YvYS6U+T8Lozt
	 ChdEbCEqmwdH7VcbXC2fJlK2bqzVZaUOWaB9O8yvOoXSIm++vVdEgGMu39y0YeXevg
	 soKQ1bAf1usCAfJ3VMuQfNu9eBrmfCQxBvZev86k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 085/215] crypto: arm64/neonbs - fix out-of-bounds access on short input
Date: Mon,  4 Mar 2024 21:22:28 +0000
Message-ID: <20240304211559.695521774@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


