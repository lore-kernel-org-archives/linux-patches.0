Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BB58F58;
	Mon,  4 Mar 2024 21:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588389; cv=none; b=ZPovVeiZX+XRVwLzbUih6QdslnurhC3j/pARTiNUnhYVyQzVdF7v4fozzKgkbKMFDDbaa3BQlyv17pnJRSRvAPnP3xKv7sZY39swr3bKyelVlHvx+gpg+AjsVaC+vzn7od6jXwAnDwZgrxTiV6UYKe/rpR1Z2bpTFtcBMhvNfVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588389; c=relaxed/simple;
	bh=G5lPFO4xYhoo52DPIxijUGsOtYUj002Tc4JfdS34kXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixa3bSzkjMIImn7IMYB68U5CMaE143oQi9YDjG4lTEG9Yq3yZ6Eq/82Pvqi3My6NLUV97s08aA+illjY4N9iEzGFN575QmLCRZlmy4SRTdNDYlgQh1z4SjN84iEYpfIIPSLhgWfsy79htUBdhlbHPkrWGzNyVDwQorQ9a7v4dNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIF9+RzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIF9+RzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48381C433C7;
	Mon,  4 Mar 2024 21:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588389;
	bh=G5lPFO4xYhoo52DPIxijUGsOtYUj002Tc4JfdS34kXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIF9+RzZrei/tBHljN1AwGT7SSNPJbOG46HAcFmxYQ2vhmYXXGJIdUzhe0GykgIkO
	 zInLmwjBp5P6awefZdfTaKBaG4u//H3DWKdeStyWv0Se44b8/LBPhX6GSJzQCH6Lzx
	 R3o9ZNrNsjFd9SkgeUbCO0LjNewenar7cjifaR4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 089/143] crypto: arm64/neonbs - fix out-of-bounds access on short input
Date: Mon,  4 Mar 2024 21:23:29 +0000
Message-ID: <20240304211552.768326644@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


