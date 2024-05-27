Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9D8168C4;
	Mon, 27 May 2024 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837724; cv=none; b=A2fzPHe0GP6cu4eyXjS8YsYNmuUPi1TyInf/uQNmr4UNC96nhn0RB7Xzv93DxNST1/QtPZLdcQCR6ImxOkbbQ6Wo4qSBVdhb039JBmbKaA5drkvDKH22SIVLNg2iXtxdRsF9B+e2fhs1WCq0zshYg5OKWNpBzK4qCcZpdfQ+pj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837724; c=relaxed/simple;
	bh=EzTl35ojTe0aklXUxA4jinrU4iwnc3qvddSoT4cRz7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpRojzUggJGubCIpVewOdlwjS0ldUu2mOqahhTvjwgdE8v53eENSMOAdaxMkK1SpAno0kLW526DcbxPz+AEXW13CodNM0r2eMJ/lf6R52Jf5mPEPWWNjKaAxTERhchn7UVkXEeF/iB6mUuYhUd9AIFj5DxRLxc3wJzFIkZNqUkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgOEbaXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgOEbaXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663CAC2BBFC;
	Mon, 27 May 2024 19:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837724;
	bh=EzTl35ojTe0aklXUxA4jinrU4iwnc3qvddSoT4cRz7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgOEbaXMykkV0PS5wItveqvOLgnAtq90vkTZ1dy/srLawGYyRMf2/SDxh+pnNCC4E
	 KtKI/pKTSKJnimu6FHVlQkpQ17KxY/Od2G5qtIa2K6BGO9ALKGPicy+b3tm4JFaT1K
	 Tlrh2/KtrahF6t0FdOqahN0Z/uREEvNJdWc1y3QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 119/493] crypto: x86/nh-avx2 - add missing vzeroupper
Date: Mon, 27 May 2024 20:52:01 +0200
Message-ID: <20240527185634.395831535@linuxfoundation.org>
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
index ef73a3ab87263..791386d9a83aa 100644
--- a/arch/x86/crypto/nh-avx2-x86_64.S
+++ b/arch/x86/crypto/nh-avx2-x86_64.S
@@ -154,5 +154,6 @@ SYM_TYPED_FUNC_START(nh_avx2)
 	vpaddq		T1, T0, T0
 	vpaddq		T4, T0, T0
 	vmovdqu		T0, (HASH)
+	vzeroupper
 	RET
 SYM_FUNC_END(nh_avx2)
-- 
2.43.0



