Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977B61A2FA1;
	Thu,  6 Jun 2024 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683210; cv=none; b=qOncKfHkTfjdF6CHLECP0fPS9RIklhPdvSGWMYaXjJNfOki95Q1QmUXZkTspwSVSHHN3EUwvrqSRmChb369Iw5R1cip23nvy8Nn/3I1e0rhkGOlMXHSZf4iYdFEKh2JXEXcBteJaytnqpQ/nOsK2KNi3F0REmmWfMJDE5//q1aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683210; c=relaxed/simple;
	bh=FRZG1UHQZSG36m7BNOMMqTB9A8/OnBhdVykJvx9qyjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYFW7kryvXxjeOb+LW2mHj8Bbra+MdGlR1I1yQ/OWXqqFSudNW17aEXZkjLYezJeLsOOIVf/Gz6SYeZCpN9sJJWWuzn1kXhdzLQlwRiYaGLxhRKbzvgVBIJVxgDRqSvUFuhdMavniIyNkX2R6A1SfUX0WTGNAWzyhLNEp1Tu054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDCieT3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDCieT3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76608C2BD10;
	Thu,  6 Jun 2024 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683210;
	bh=FRZG1UHQZSG36m7BNOMMqTB9A8/OnBhdVykJvx9qyjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDCieT3AADxXjRTlfb7Lbm8sqpZN5GnhsjqfvjGZUd0gkgVBN3HclgK9HZVHk14Kh
	 JcWsKhKJPiOLYhgiSIxoH1CnlZKw1IVVYtYSLB8Azb5mntywMzvyQuEE69ViqKpGrS
	 eyXv48vdm/lBNyXK6ZIQX2vf9Xp1Ve9p//csWnzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/473] crypto: x86/nh-avx2 - add missing vzeroupper
Date: Thu,  6 Jun 2024 16:00:03 +0200
Message-ID: <20240606131702.348673870@linuxfoundation.org>
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

[ Upstream commit 4ad096cca942959871d8ff73826d30f81f856f6e ]

Since nh_avx2() uses ymm registers, execute vzeroupper before returning
from it.  This is necessary to avoid reducing the performance of SSE
code.

Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/nh-avx2-x86_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/nh-avx2-x86_64.S b/arch/x86/crypto/nh-avx2-x86_64.S
index 6a0b15e7196a8..54c0ee41209d5 100644
--- a/arch/x86/crypto/nh-avx2-x86_64.S
+++ b/arch/x86/crypto/nh-avx2-x86_64.S
@@ -153,5 +153,6 @@ SYM_FUNC_START(nh_avx2)
 	vpaddq		T1, T0, T0
 	vpaddq		T4, T0, T0
 	vmovdqu		T0, (HASH)
+	vzeroupper
 	RET
 SYM_FUNC_END(nh_avx2)
-- 
2.43.0



