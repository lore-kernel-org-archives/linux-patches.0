Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782BA14388A;
	Tue, 23 Apr 2024 21:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908789; cv=none; b=oajNrTJL5BrMh/vOpbv4ePgeNgME6eQblY5XYt1ITKDYQ40jjtchhv7V7lnsazNC8Rf88ghkHxmCySHlnIS74+TFtxFixU1/YlonCEcHWzqFeZ8CZcyJ978hUPGv76/kn3lBfNXvmgqpOIkySYVsFrzN4TYkZDC2x2gyXkiYpZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908789; c=relaxed/simple;
	bh=DxMUdfziBEHZGcttcFz2/Dzir3ppkMbk58HCgQn1KGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnHgNBza1XPAJiweyWat8eaCldLMs3ZB9fxXwKZDyTOUZuyqtOQCJbnvyx7Tq2L9pcZhnNuBcCVND0uz1CbzC00LCZM1FW19DrfgJs980X0kfeW69sj4nTt854KRrLKPST+dTyp2xa/3e1VNxLJbeNnB+kLFOIojfAzzi59PjLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSNfqTla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSNfqTla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6D9C3277B;
	Tue, 23 Apr 2024 21:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908789;
	bh=DxMUdfziBEHZGcttcFz2/Dzir3ppkMbk58HCgQn1KGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSNfqTlaj3A+AZ0daSQNH58xYwicOYg5iVhf8/k8QZQjaShuRTiNDlXI/PClmOcHB
	 fAamGauOCHqtMWOONj/xn5GAVLMkzeZPjtRWkSbDZ3F/LTWi/vdb7Ai0XpzLWjyO0w
	 XfKUVfeBhp99wV+f/rrIAnz5ZlLpQxlxIs9GD2N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/71] x86/cpufeatures: Fix dependencies for GFNI, VAES, and VPCLMULQDQ
Date: Tue, 23 Apr 2024 14:39:54 -0700
Message-ID: <20240423213845.557301125@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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
index defda61f372df..2161676577f2b 100644
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



