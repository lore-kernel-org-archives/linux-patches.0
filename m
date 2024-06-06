Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016FD1A0B0A;
	Thu,  6 Jun 2024 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683159; cv=none; b=GQpbrTC2YOPT/CBCROKAITslt3XQM2mjPECjjEOKdo+YC4IOpRBeZ5fK/VY6deFvM9zSHeP/I6JGWfGLNgNYbKLE4gczfJnXGwv5IW33yvoqVpunop0RPwdHJv0bd5O+3TEs94nOx9t+/H4ATs4XYSnNcY6L3W36WjxUg/rvglo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683159; c=relaxed/simple;
	bh=9TO7WriRBMr/uceQYHVobMSRy4zZJ3WfVSLku+oXu2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBM4LXkiUQs4bo+lQ2hWvQOKahfZso6qSOVdxcxkbQG8dGcEAixcoZ0Ccz4iMsyU+toZVhZIqP7u5sWi778Qn1dqDMWr8Q/BN1AF7zendZNMFvIZ0I+qVjmCJLLdtOGvo2hzpTrnVKnAMs7Bt09fs/SOMRVb7Kk8slY4fIg42fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kogHdKQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kogHdKQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D8CC32781;
	Thu,  6 Jun 2024 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683158;
	bh=9TO7WriRBMr/uceQYHVobMSRy4zZJ3WfVSLku+oXu2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kogHdKQl/v1Gh85BIKFTezny0EIgVgyejafSlt73DEAziWtVHQAIqhbxVnES4MdgO
	 HZy+DNU0Gh6umnvVp3EecveFBEG+RS0A+oPgHPM9Nra/QgUK3QGm8ZrUZZoTA7JqbB
	 WibKSv2v8DWY+DWxn3kIp3Ghpb23kd+UZkuGibvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/744] crypto: x86/sha512-avx2 - add missing vzeroupper
Date: Thu,  6 Jun 2024 15:56:15 +0200
Message-ID: <20240606131735.702166936@linuxfoundation.org>
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



