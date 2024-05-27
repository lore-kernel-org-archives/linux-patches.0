Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2F21667D2;
	Mon, 27 May 2024 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836544; cv=none; b=Hv7vFv/DQkMm8NcqpymtxSUMRCHNCI1ktH0QyUbkKaGB6ew8lJn1yonkukQj+xXvc8H1pfUf2nZ6a5baCDtD4J5AqlLv6RYZCz73E2+0OTIOlz9z1NNpDVvaL/4hvqTQnP/2YJWgin/S3xsgxpIwz6vuG/3K5A9lFcCj6Z8ib70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836544; c=relaxed/simple;
	bh=0CFu4OaR/decLe8iUNh8DS4Gy6Sdo3gVMbx6eEJUiBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKXjLntkqOnCBovOLtUTX3VjlHjdvuA+neSMyfnxc66N9dVdt4wZ5Auwwc37w1x40aQ0Vs4Bra/R0RZenLNRJL7FIQIfizCyqK92O6mrrIfMGFx6z3cq3zjirPfyWBH9He4VTZjwK/YImbiAXTjDc1xwJv87ogtaaNJdDVqXy8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0STVc4SJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0STVc4SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF198C32782;
	Mon, 27 May 2024 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836544;
	bh=0CFu4OaR/decLe8iUNh8DS4Gy6Sdo3gVMbx6eEJUiBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0STVc4SJSDhoNE9Ws5yAxD5vbDlqhWkJ7UYPH8bFG36Vwc1UEJ34tiMp8AvCC+Eys
	 mdujcJ0yaROTAmmad2XoBQUKU/CcakvCKkgI0zm5kyBoNtQSukzSqZn0tD54d4is5n
	 hFbheYZBgMKx/tDjBYI5+aPJITWUucmFn/HjC+M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 053/427] crypto: x86/sha256-avx2 - add missing vzeroupper
Date: Mon, 27 May 2024 20:51:40 +0200
Message-ID: <20240527185606.683637381@linuxfoundation.org>
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



