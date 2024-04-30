Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3800812CD9B;
	Tue, 30 Apr 2024 11:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476104; cv=none; b=q9L1dQ3MZV6c9mbNHUYAtIQHmVqlmuyeBWS30neKguyVFkt4FMD6645CaD2uUUOOhAdEyqpYLxw7RVODGic0DQfeWf232+0e/IcEAWsyuCXVtU4Jc1b9lYFvTkr78yCwt9qZivCZmaJWSiOG0zqp9J93y5cwyFTKOLMgGKOQb5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476104; c=relaxed/simple;
	bh=FrCVIzmXmNWq9KY40yo3A1gHDkRZXFdY6F59MbQ9mWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXkyXSLkbFwW/89vHgsTJltVZN0jlIQGr4ykCn4FghGjRlRG6icqi7Yune8M2Cr05WX/roOp12PjodYI+EaaH+0PyvtFVsPs0gThOTUeIJVC8Q3X0ywk/2BS/GbVhZZumj7f6WUjGa2TsQjsLDYFtFym4k9orAcW/uacnNxQj1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5YsSfCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5YsSfCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83C9C2BBFC;
	Tue, 30 Apr 2024 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476104;
	bh=FrCVIzmXmNWq9KY40yo3A1gHDkRZXFdY6F59MbQ9mWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5YsSfCumR0Oyrp+qK4oj0wqyvtTi2bHP4CC20EzRnu2aYYOJv47niVxQ4PedG3LO
	 DDWNwQDixLvHF6/4kTejxOvqztvrB9DxGOUs8CPQes+SQZEsz42NhneE6YCIMzJMZl
	 LMJsEEMi3UuIy1lK7AHt4hhbjn/8SDXdBmMUmyVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/107] x86/cpufeatures: Fix dependencies for GFNI, VAES, and VPCLMULQDQ
Date: Tue, 30 Apr 2024 12:39:54 +0200
Message-ID: <20240430103045.667964700@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 9543f6e26634537997b6e909c20911b7bf4876de ]

Fix cpuid_deps[] to list the correct dependencies for GFNI, VAES, and
VPCLMULQDQ.  These features don't depend on AVX512, and there exist CPUs
that support these features but not AVX512.  GFNI actually doesn't even
depend on AVX.

This prevents GFNI from being unnecessarily disabled if AVX is disabled
to mitigate the GDS vulnerability.

This also prevents all three features from being unnecessarily disabled
if AVX512VL (or its dependency AVX512F) were to be disabled, but it
looks like there isn't any case where this happens anyway.

Fixes: c128dbfa0f87 ("x86/cpufeatures: Enable new SSE/AVX/AVX512 CPU features")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20240417060434.47101-1-ebiggers@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/cpuid-deps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 3cbe24ca80abd..f50d4422c7b5b 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -44,7 +44,10 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_F16C,			X86_FEATURE_XMM2,     },
 	{ X86_FEATURE_AES,			X86_FEATURE_XMM2      },
 	{ X86_FEATURE_SHA_NI,			X86_FEATURE_XMM2      },
+	{ X86_FEATURE_GFNI,			X86_FEATURE_XMM2      },
 	{ X86_FEATURE_FMA,			X86_FEATURE_AVX       },
+	{ X86_FEATURE_VAES,			X86_FEATURE_AVX       },
+	{ X86_FEATURE_VPCLMULQDQ,		X86_FEATURE_AVX       },
 	{ X86_FEATURE_AVX2,			X86_FEATURE_AVX,      },
 	{ X86_FEATURE_AVX512F,			X86_FEATURE_AVX,      },
 	{ X86_FEATURE_AVX512IFMA,		X86_FEATURE_AVX512F   },
@@ -56,9 +59,6 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512VL,			X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512VBMI,		X86_FEATURE_AVX512F   },
 	{ X86_FEATURE_AVX512_VBMI2,		X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_GFNI,			X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_VAES,			X86_FEATURE_AVX512VL  },
-	{ X86_FEATURE_VPCLMULQDQ,		X86_FEATURE_AVX512VL  },
 	{ X86_FEATURE_AVX512_VNNI,		X86_FEATURE_AVX512VL  },
 	{ X86_FEATURE_AVX512_BITALG,		X86_FEATURE_AVX512VL  },
 	{ X86_FEATURE_AVX512_4VNNIW,		X86_FEATURE_AVX512F   },
-- 
2.43.0



