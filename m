Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2783BB10B;
	Tue, 12 May 2026 17:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608229; cv=none; b=DKFKtYU5nYLhc+B2ebflqLsIf9UkzytqcDuRYVAUwnL9XrQfDKZ1lZbcRbh+IqEuqMD2tzO2MKlvyKB856g/CtQeiKkVbUDCdw3phW5kNYg4N0WtNfgN+I0OqhKjSeflAC6XsadPXYLZR7DFPD/rm9ddzqKXJKMEpLHZfcJkJ20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608229; c=relaxed/simple;
	bh=LXvFFfxicwJyw0++38sQ0U//auBkCkDo3rF1P2pdCsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+tFnONDqLGOHhvPfSR/6gBK9+UmuMhb8CxBj80tR45XCF6aAAII1NamPlntHHHs+x3W3lvc6KJ6FMLbHEJZEFyUhpS28+dF4vqPWNXBD6n17KZZwaAvKOoy8cr8FmBz3jBJc69CWIS3Q1brNxAJr0wh78utbDEmGxj/Xgiowb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lh0gXpRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lh0gXpRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327FEC2BCB0;
	Tue, 12 May 2026 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608229;
	bh=LXvFFfxicwJyw0++38sQ0U//auBkCkDo3rF1P2pdCsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lh0gXpRbY1/L+ldN6lZRwd4wfVHQrAZeIKkud9EKs9LsSAUovtqGHa6SLw1qpVZOH
	 G0EefVlMotVXCztRFywFX5EL1Psh0sWGryPFiH6E2kco5jwbNcy2lW2iBpUOh54n5S
	 uCi2kq84X/nHlcU8amo3rC75DSq4zSnJIx49FD6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathyushi Nangia <prathyushi.nangia@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 206/206] x86/CPU/AMD: Prevent improper isolation of shared resources in Zen2s op cache
Date: Tue, 12 May 2026 19:40:58 +0200
Message-ID: <20260512173937.238604028@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathyushi Nangia <prathyushi.nangia@amd.com>

commit c21b90f77687075115d989e53a8ec5e2bb427ab1 upstream.

Make sure resources are not improperly shared in the op cache and
cause instruction corruption this way.

Signed-off-by: Prathyushi Nangia <prathyushi.nangia@amd.com>
Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h       |    3 ++-
 arch/x86/kernel/cpu/amd.c              |    3 +++
 tools/arch/x86/include/asm/msr-index.h |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -734,9 +734,10 @@
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
 /* Zen4 */
-#define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG			0xc001102e
 #define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
+#define MSR_ZEN2_BP_CFG_BUG_FIX_BIT	33
 
 /* Fam 19h MSRs */
 #define MSR_F19H_UMC_PERF_CTL           0xc0010800
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -989,6 +989,9 @@ static void init_amd_zen2(struct cpuinfo
 		msr_clear_bit(MSR_AMD64_CPUID_FN_7, 18);
 		pr_emerg("RDSEED is not reliable on this platform; disabling.\n");
 	}
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN2_BP_CFG_BUG_FIX_BIT);
 }
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -717,8 +717,9 @@
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
 /* Zen4 */
-#define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG			0xc001102e
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
+#define MSR_ZEN2_BP_CFG_BUG_FIX_BIT	33
 
 /* Fam 19h MSRs */
 #define MSR_F19H_UMC_PERF_CTL           0xc0010800


