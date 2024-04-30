Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D6E12C462;
	Tue, 30 Apr 2024 11:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474833; cv=none; b=HFTllZyfb9onxsj9gk2IesRy8jYB/bT9T4q3Ni7WEcaNe102vWhoCO+f4af3WvaYbvN7dRUmSuELGNrm8JfmPxXhWsARs0RH68N9z46mfwDyYUENKg4nvJTy9tM2Ca3WzhMjAX1djHw5T8nP3SZMon7gKQRQZOyOPDbY5Na9XYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474833; c=relaxed/simple;
	bh=SYB/Ec5RlhKqf15G7r/G2opjNi4BPh/zeTMntPSCQaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR9eaDBz/4F/8wr0ti1lioTCnHYh/UoaWCCwMX1IbNc8hyIn4K0gPNqQTdKRh6T8M7+Kq1aB8+x7dET8xB9VqeKIYX2MYo33kEyrbPf2ZGvfnN6fz5df7yJ5bpQIpMYmvkoGFjId23RXyAOUzUBSChbkRqpDiCcI1UYJ7iwq89k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j55HrT+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j55HrT+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B15C2BBFC;
	Tue, 30 Apr 2024 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474833;
	bh=SYB/Ec5RlhKqf15G7r/G2opjNi4BPh/zeTMntPSCQaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j55HrT+zn4pxgKJl7MiyYQ9nKU/y91oe1EAGatUfsNMTaqbe53Cya8M2vW4sZ3ZHy
	 rKWqMuGYIc5NKnjHrw9D5Qk6NyfJeqw6KsmVv2kfxB8M3xHg0bTwEZh9RnRD6ZretU
	 XWCq0yUCAy20n2YPjptNDaYQAiPLORw8yqW3sv6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/138] x86/cpufeatures: Fix dependencies for GFNI, VAES, and VPCLMULQDQ
Date: Tue, 30 Apr 2024 12:38:55 +0200
Message-ID: <20240430103050.901120108@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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
index d502241995a39..24fca3d56c7f3 100644
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



