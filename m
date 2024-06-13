Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E53344C6F;
	Thu, 13 Jun 2024 12:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281763; cv=none; b=j7zAcAKLQdPPtusMnfgXOOQsJ54UFaBhTgM2oEFk6K5KZCyB1ZY9gBnc9cQo0tpD9p2pJsqoU66liS8BF1Q1DIRSgf+s+7xcKG0CcozxnmcsAB874GSDKGWHtujS/lppmvsj3FYl2iQdbWO3otpHiJ3JBGmtwhWjRlf/CTky0Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281763; c=relaxed/simple;
	bh=ahGgZqp/xqADDfsVrfapp+M+iTTYflmwtLR7UQhaP5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqpAO5VK/40xUFZrcR6a5uZqR6Cl0JCIS2XtQXOjQnLRJU8OfiSnP5dy/u9HoeBAOpFSMaBp0F9+uyCdtjHClOeO4OVHW7wfXsd7Ivsd+Ce7oIZ9O692Vz4SUd+TMs4ehlL25KMwsq+4KiEQ5lzHYVid8cFaDAccdyb8iF0a/5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wePALaoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wePALaoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ED5C32786;
	Thu, 13 Jun 2024 12:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281762;
	bh=ahGgZqp/xqADDfsVrfapp+M+iTTYflmwtLR7UQhaP5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wePALaoci8xvzNq0PLuOuVBc1GuISW+/Bn68qBnfeo4f05tgAiRhpUjc6zD8RsbXH
	 ZY6C8KdvcliKUtYsseIoxoEDzy36fV+Xff2XE5tm/MGNKrWELtVwfwdFgpZo9AtGOA
	 whaMyprfo6YaPwzWxIFp2NPt4o00htLjOPjVF/iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/402] crypto: x86/sha512-avx2 - add missing vzeroupper
Date: Thu, 13 Jun 2024 13:30:03 +0200
Message-ID: <20240613113303.933602761@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5cdaab7d69015..1c4e5d88e167e 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -679,6 +679,7 @@ done_hash:
 	pop	%r12
 	pop	%rbx
 
+	vzeroupper
 	RET
 SYM_FUNC_END(sha512_transform_rorx)
 
-- 
2.43.0



