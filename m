Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE7160787;
	Mon, 27 May 2024 19:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836436; cv=none; b=RKTCUQ9vOCgDvcq/ww6cengHMebAC9hRhTqAzM82jC5551BSy8daz4eLIr1H/+N3yrrmNPQBb44W1gO/RhUvljzuFh0xqDgT60MWToXeUWMbgp9Ma8xkKmDlciQsNmm2qMD76dbXIJ8xgk860zWgqGEglr68zKlG7KxoDb385sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836436; c=relaxed/simple;
	bh=AVhKPBZKUOWDjAZipbkTgFlv08o8/bnZ+A7p+/hfXrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4LcOwevQtj9grkO2U89iez7j0KmSp6Ll1DnUvdehrs9VlthCJx1twVh2azSL1PAS+bSKcu/mJsytU2I+GyPl8ZAFs7HtF6RZoreP4A5eNwAkVIvUs/fzL/tQWft6F26xbE9E5Ed+EtA5Tnb+Srrl7t2j1jmNWY99j0Am3FCWNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnhERFuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnhERFuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65880C2BBFC;
	Mon, 27 May 2024 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836436;
	bh=AVhKPBZKUOWDjAZipbkTgFlv08o8/bnZ+A7p+/hfXrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnhERFuI0YuG5xY55dzCekNJgHUyuFc4IHK5SfKmAlbdX29jXh0wEIEtF4UFlAl2A
	 gGZXqXw6oXq2lZf2WHThU+y8Al2G9CJYqFZf2aUMFIfuchC5A6d9Xc8C2X3hNrlHdI
	 OFQq1CdfCUOfWe8wrjGD9+3TeBnOYHYzOLYQvH0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 054/427] crypto: x86/sha512-avx2 - add missing vzeroupper
Date: Mon, 27 May 2024 20:51:41 +0200
Message-ID: <20240527185606.821659988@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index f08496cd68708..24973f42c43ff 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -680,6 +680,7 @@ SYM_TYPED_FUNC_START(sha512_transform_rorx)
 	pop	%r12
 	pop	%rbx
 
+	vzeroupper
 	RET
 SYM_FUNC_END(sha512_transform_rorx)
 
-- 
2.43.0



