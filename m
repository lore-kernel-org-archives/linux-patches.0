Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D48145B18;
	Thu, 13 Jun 2024 12:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280768; cv=none; b=KCm/vv7ESb98t60MLB0POeqVGGP/nKFgiNQIIYoobHPZLxXrBqoTHRnfFn1Gy1H1XB9tdRhrUKQCE2Hqqq63A97D3rGn7hnXtUURHjNk8u/D3dU/Fv1xswcFBLPqDo744X0GAabahBmE0/HDYYctxvoald8nDnLQI9haXWduio0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280768; c=relaxed/simple;
	bh=LBAFaDjGuu0KZYqFJqMv14XZoVNLhS9EQvHu2Wp3hJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QftT2qjtIGUT27boTmgiCrGDlChsAVtV0QzyET4xl8jxtEGYipO4vbrDO13EO9DpHrqa/B849vfzdyCUUsyJ5AMEPuSB9skTYaI8YoLl1IINXE0lBYfOB3Jo3Ax9bdSOEtpBPUKAm8AvX6vOMzn4XoM5Kp77LFm03NowrFFf85I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZf3Mojf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZf3Mojf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F08C2BBFC;
	Thu, 13 Jun 2024 12:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280767;
	bh=LBAFaDjGuu0KZYqFJqMv14XZoVNLhS9EQvHu2Wp3hJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZf3MojfPIBS2uYQKRJ7/xAlm0gufgYwed2Qf2iRLJ5XEUGDAHdDS05p7+Ydtthxm
	 QjWpqo4Y1x6sFulYHpU6cgmrw34CsFSULlAXCgezH6GYSe6dIXJm2TOBzh3AyJ3aEk
	 OXVCHpyVm+FKwVna8pRBAZ5Tr+cAGt/4bXNb26Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/317] crypto: x86/nh-avx2 - add missing vzeroupper
Date: Thu, 13 Jun 2024 13:30:45 +0200
Message-ID: <20240613113248.590952606@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



