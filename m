Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F782C76;
	Thu, 13 Jun 2024 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281757; cv=none; b=hBbb0qdfp/0UfMHTxPc1Oay4BifW2pQjHjqFouJ8imW9bquVfbfpMpfqRq+VWWgcmGFzTLGNGf3gxQgpKWMHIxSv/pIzDbSUvf57d01ksxopHnOo/T3PeagRc4YEhiNALlfxvRBQJctvHIGqF57DjYLLdoXDnQfK0CfVE1TBIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281757; c=relaxed/simple;
	bh=8viOR08i/vl86klTZIZNZltkC9I5SDcDOJiEIKJCoDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddj9pbhQQC/smwPeJ1JkroJnm4go7p1RkGFyp76FDFnuJf5RGjo8kz1pMMsnKNVIqsmJuruZ2q1i0B50DnfUWLhp+ooMrpLceib49fykllIAFd6hzdxEat9ZlM0aalmbdgIy4GaJNSz8ztTmDY92t/pGWPdnT8OwKMHiJqcfcl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nt+QHjC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nt+QHjC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A696AC2BBFC;
	Thu, 13 Jun 2024 12:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281757;
	bh=8viOR08i/vl86klTZIZNZltkC9I5SDcDOJiEIKJCoDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nt+QHjC6zYGoe4zHYcvng2eQlGGWty377Ll/SJhNLUDajnmePV4dtKBpVYluva9uu
	 puE6ykznx2K0hlJlIBGHkz4jniPpOz/QrEQvEkxElCAdvvEdLzmpgvcvzjU7HJz5eY
	 c7/Qsb6bCiybE417phM64qCn395Y6BUwQMZG37p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/402] crypto: x86/nh-avx2 - add missing vzeroupper
Date: Thu, 13 Jun 2024 13:30:01 +0200
Message-ID: <20240613113303.856415465@linuxfoundation.org>
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



