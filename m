Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21ED1A38E6;
	Thu,  6 Jun 2024 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683227; cv=none; b=QAWQ5KA9FEoqTJg/+HJhNtQ2V0PiOJhCp4JsDH5MZZW8Ag2ULxV5tOpjMTdhHfz6e/wxCCvfycOlH52kzZh15AM8fz+aICwJU6OXb3i2jY2rCoyxl4MauXZWMEke9gGl6jACwNg7esqwXQ3jQtVYCrOrLCHZi/rUjZsByn7E8iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683227; c=relaxed/simple;
	bh=nnzPwEiFViQFNWqh2+amo03pFwZ1qZKgGF54JggvLyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOr1VAck6BuRLjFA4Q2Rl3F50hiqxCmYJahqaw5JpvysryQJ0oxMPcY3yPOMXuPJ1nvAvQR4iOi4a3uFom8lmhCkuWXfytaCTb5z2WXce1G9fTZNCfVVXkOnfhIMDXUvkO7X79W4Y3ll1FThOrjydb38iPMw0odt5iSpq5LUcvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8f8DMom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8f8DMom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF7EC32786;
	Thu,  6 Jun 2024 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683226;
	bh=nnzPwEiFViQFNWqh2+amo03pFwZ1qZKgGF54JggvLyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8f8DMomnOgfkkbx2S9HFgLMttpPKSBws17/DeDN1U40JSRUo8fgQL6jyOUpGxFe1
	 +UyphurKfsjiYG2ebov+VbVVpXW9ejF6c884PBmsEJH6R2IKU7nlCaKQZf3oLGbOMs
	 tFq+3L4xcwiCwgnqxyGJy028UEwEhua3xxH1xWCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/473] crypto: x86/sha512-avx2 - add missing vzeroupper
Date: Thu,  6 Jun 2024 16:00:05 +0200
Message-ID: <20240606131702.428715136@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 6a24fdfe1edbafacdacd53516654d99068f20eec ]

Since sha512_transform_rorx() uses ymm registers, execute vzeroupper
before returning from it.  This is necessary to avoid reducing the
performance of SSE code.

Fixes: e01d69cb0195 ("crypto: sha512 - Optimized SHA512 x86_64 assembly routine using AVX instructions.")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha512-avx2-asm.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index b1ca99055ef99..17d6c756b5414 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -680,6 +680,7 @@ done_hash:
 	pop	%r12
 	pop	%rbx
 
+	vzeroupper
 	RET
 SYM_FUNC_END(sha512_transform_rorx)
 
-- 
2.43.0



