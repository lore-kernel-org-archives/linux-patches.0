Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2535143C75;
	Tue, 23 Apr 2024 21:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908521; cv=none; b=ooqZJjYrACb0tWBJGyBIc+my3j9GSPHsibpfLAwVLavlhOPh5lP9C3/2NbWo7ykkq3zNiUdRyLyDq4QeNvSkpIT9nklV6qXtXZDuFCT1kZdUeHeTwQyORc5GeIIIxmRjn0xLaZHRdfmmOaspJWOmh4D4H7gsZ7hIsSVPE/zWhIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908521; c=relaxed/simple;
	bh=77YS7CTjad9YeYH2HBm+wMaaPgoDiIYi1LEuYh9mXMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgYC2J+iMk+WnK7lEPmCH5CC0btV4mscPI6yPjQIwrKvK9+mXIguuW6WTZiErK5CFSEbjTHpUazgg813vmwhSNxTUDTsWhHOimckA7XpT2kDxBWWIwa/3T8ON2fCh24MuIbyYo8yDxg39h7qMswG3hFDgHbqpjcSd8m7cLKPeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouCZr327; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouCZr327"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8603CC116B1;
	Tue, 23 Apr 2024 21:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908521;
	bh=77YS7CTjad9YeYH2HBm+wMaaPgoDiIYi1LEuYh9mXMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouCZr327NcS1G5lcm00l0vwMIENzEFq88ocXrEUewaHjp98e3W5Kzb8ukYrPya/Vk
	 l/5EXKVOplbMONeWk4wXzognpeIdYRUhYGr+u/50bBMN2CSM1Y1z9yYx6m/W1BUaTe
	 OC9PsJTFjjpAMc1xG6Z52VFxpuH0EtQsg8bEg4wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 086/158] x86/cpufeatures: Fix dependencies for GFNI, VAES, and VPCLMULQDQ
Date: Tue, 23 Apr 2024 14:38:28 -0700
Message-ID: <20240423213858.737006459@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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



