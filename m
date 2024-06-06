Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155881A0B04;
	Thu,  6 Jun 2024 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683158; cv=none; b=Kz+6fSmt8/BhoWlU3ARnqLaehNapjwsrGCukTFwvqCMlZCIg3yQGexh+0/X4PyBSz0sGxYFk9KQwKEGRvLhXcbxozE8B/LMNc16xp2y4dlu5dmLDrBLI4l+prQTEGuzTxkCMEm5s/bn154DJSWahKRgLVeDkmbCB79lgtcibK8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683158; c=relaxed/simple;
	bh=OyOtW5kN1n4AdX5JQEdvHz7kkX9swJaBKVixeaYGqO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyZmCS34g/js3VKOXL+J3grjs8kUGvkon4Kd4C6g2fo7kJ0uAm38ufROdaZzthoZ4+aPXYSDdlQNFLA6Lz2QI0eCjTqfLzplJ85yB9h8vfIIUsw7f3G0+MaVXrhEpYggPeBqhCSd+r9fSzmrSr9EjhJjCkb7OiT2nEz919OhBXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWIPdDJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWIPdDJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E95C32781;
	Thu,  6 Jun 2024 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683158;
	bh=OyOtW5kN1n4AdX5JQEdvHz7kkX9swJaBKVixeaYGqO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWIPdDJLgMt2pFF6cPBA8Fa95vLZcy/QeBbxzwEIdIPy/4sY9HP167z2JaSYGEx0o
	 h7FhVdmB0XshpjKq2kwoCWACyGbI0d5daS+9exEYB5DAj4YpOTPF6JZSxBDXYsnHY/
	 Otvf3S0uaEXcWQc2UHQCbq60ZpvkuD0W9kJQPZYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/744] crypto: x86/sha256-avx2 - add missing vzeroupper
Date: Thu,  6 Jun 2024 15:56:14 +0200
Message-ID: <20240606131735.673166729@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



