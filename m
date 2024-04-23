Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C840B14389D;
	Tue, 23 Apr 2024 21:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908623; cv=none; b=jH+6NZud6vNMbxMeSi83LMPrUh1AkoLn2PXKDFFy4RE79ZcONt7oOSHr/JoU8XeIYLY2oWmG4tfElR4c/90V/nYIy3imTnaPICGlcGavD+gyNyAHJZ0vQjdY+KieH9vl1lIsGVGtv2Dfh7NCbEQWKUJ5A0X8hgNNfAU91g2ZtA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908623; c=relaxed/simple;
	bh=PtMkC3xbRL6yHfbMo+jEwjHgsHfsm9UBD0wnRrQ8WuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJysXajhWjCBJvqcfEnMW6hyqaC1YpbVFSyYyxbpPcmW2cF8qe8ACfn74fVHhx9TaVKOKEzZfxhzc4ez4nhIciSmn1nB5d6DLWa1e2KFR8glxuUukTQDXJ5c+fYV7xEBUYSthd/FcrV9sI/pP4wNDKoZuR0N1jymCMG+KMwzLyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2efvW9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2efvW9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5358AC116B1;
	Tue, 23 Apr 2024 21:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908623;
	bh=PtMkC3xbRL6yHfbMo+jEwjHgsHfsm9UBD0wnRrQ8WuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2efvW9FiypJ6JHNbvTVwrkM0BCLGO0A1TmjnoHBMQODDdTvwbRkzKSiSyyDgsm/u
	 Usd8eeKwzBnlKXbc2+MScuOXdau0Zce/CDKe3NhUme77jHoxOhiawrD9G9StSX4eAO
	 YWYDLFNTPeJJ56jxg6SCfXWjbcKEq07FFho1oKwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/158] x86/cpufeatures: Fix dependencies for GFNI, VAES, and VPCLMULQDQ
Date: Tue, 23 Apr 2024 14:38:55 -0700
Message-ID: <20240423213858.932509387@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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
index e462c1d3800a6..6fb6d8a57ceca 100644
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



