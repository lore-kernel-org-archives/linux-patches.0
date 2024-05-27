Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED9B168C4;
	Mon, 27 May 2024 19:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837727; cv=none; b=HhuiIpOkQLz9WgEwWNRUrVCORwKmcIUnY25/PSiIPa1wzbSEx+QnDGdT5rs5YLL5EuyDFKQ+fzDYTIcBmCGy+04yN2VuC0L4u3wp2MlaAVg9EbGHgEQ6vGG1FerfDBHiMJTziLbYmQyKQ3ihEqITaGbWBrLkpycwMlSqo+ZZeUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837727; c=relaxed/simple;
	bh=FMLN/mV+dBFhcsKSOqif4/ouU/yB8/rmB/umYd30JfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mANUs6v2c2CCFV/p2u3n5MlCyGC0bMYv3g0+bdKoucajXaO+a2eh0g5xagvwdoAVT7Dd9D+glto21bSZud4NrJAW/lIkqLjBY3mtPe3ZRZyRcgKg9AJ8cE4ZrTZd8DN2tuB64/pOywO5Oc5cV/ZCoV6dmuuFHf9ib8YZahnNylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtlatPe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtlatPe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02818C2BBFC;
	Mon, 27 May 2024 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837727;
	bh=FMLN/mV+dBFhcsKSOqif4/ouU/yB8/rmB/umYd30JfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtlatPe32yjI8eXOBqcAVPp5cO9CGl3K39m9AR6Xp7OAH+L4tAI/3Gu6f1kxLfmhA
	 PdlHVi16ZJBm6pK+TvpMBfvl2x53FlnA/TQ3gj1lGFZ9xIEUNLtu9Czn2MuYityKxX
	 O5fFpyIJpCEy2b+3VlzTc2Yy6OJx+G2e6pmjhPwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 120/493] crypto: x86/sha256-avx2 - add missing vzeroupper
Date: Mon, 27 May 2024 20:52:02 +0200
Message-ID: <20240527185634.427209979@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 57ce8a4e162599cf9adafef1f29763160a8e5564 ]

Since sha256_transform_rorx() uses ymm registers, execute vzeroupper
before returning from it.  This is necessary to avoid reducing the
performance of SSE code.

Fixes: d34a460092d8 ("crypto: sha256 - Optimized sha256 x86_64 routine using AVX2's RORX instructions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha256-avx2-asm.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 9918212faf914..0ffb072be9561 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -716,6 +716,7 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	popq	%r13
 	popq	%r12
 	popq	%rbx
+	vzeroupper
 	RET
 SYM_FUNC_END(sha256_transform_rorx)
 
-- 
2.43.0



