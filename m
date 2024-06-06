Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D3F1A2FB4;
	Thu,  6 Jun 2024 14:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683216; cv=none; b=CKoZ8aQZBxFkHpJY8wLIbkUkFwGq96P7NYoEkvU78tX+cLVvXK8b0dHr2rRz5gJAfg6VKUjUoY2yAiFIDczEhSDLX/0oC7hQlDOnVaxaJf/q08ejQEhdBfz6Do9mvCJJ73mYKgonLo7tALKOi05xCYsJ/DcOZMok0Qkb8JD8WcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683216; c=relaxed/simple;
	bh=asZf9czqelEdoEaYpwP09dxhgbDVQyhUclXVq+e2zHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIkiE65AsCmMiBubc+sVvG2m1P+rzUwIuAG+ftD0vDbEoJlY8hX/1AkqJQQ/sJV8RLsqYX5HAj3zh0LnI73H4J+51JGaESs8aTcq9ZEnmxI0HlnhCCqljqPwa2rfKM2YAMrWqzbnUt3Dw16CuaG01340MZSxC6pZ00CBnMZtaxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7WGyD6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7WGyD6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E3BC2BD10;
	Thu,  6 Jun 2024 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683216;
	bh=asZf9czqelEdoEaYpwP09dxhgbDVQyhUclXVq+e2zHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7WGyD6wZ/BgKkFWSlqk5Ylsj7CtZVRVztPZCA32Gb1QqeqLNAAz8AX5cEex3Jfvl
	 15z7yjifPatpzTac6IsOtUSJkuZARR6SV2WuAys5uJPyFNjhR7l+Xm3DAwgM3sThtO
	 jpEmbILhQZND9igHesJ/ZBTI+vRkqVmGiKeUIY9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/473] crypto: x86/sha256-avx2 - add missing vzeroupper
Date: Thu,  6 Jun 2024 16:00:04 +0200
Message-ID: <20240606131702.397090380@linuxfoundation.org>
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
index 2d2be531a11ed..eaa093f973cc3 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -711,6 +711,7 @@ done_hash:
 	popq	%r13
 	popq	%r12
 	popq	%rbx
+	vzeroupper
 	RET
 SYM_FUNC_END(sha256_transform_rorx)
 
-- 
2.43.0



