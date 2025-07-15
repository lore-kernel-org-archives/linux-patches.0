Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB2C2E6136;
	Tue, 15 Jul 2025 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586963; cv=none; b=okvkvRK13nJj1elyHbu3y80zeot/gt3C1kvpMpdmFqpMqBPwHFMiziE3v3ZOfLhgSUn3Q3SQ7+lMCDMBT7iStgpx10tAq13b/twC+2wA1BEsdKenTjn//Czz7HQjC1o1reiGDKjzZXsZQUWY2ryQ9LuIosc7i8y3dMeam1/5HiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586963; c=relaxed/simple;
	bh=h+KliwEo/dXpQ88C7yIJfvZdcpR2pDWwfbn3aTR1r8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSAPIZUWV2bcRDNaf4oIRCj2M3v6uCfjd6x7Uy+yXdxic3BiJjAMoMchX0L1QP5nYC7ff50CMGtQs5ZIDi6nhBuuIFmkGj3UoDAg1adi+QiPFnhCEE4AVipx6Ol/W2vHAF7qmyh5U0hCfLNKZ6jh19PjvP2tAsYQhcKTsVhF+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+RVL5Vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+RVL5Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B19C4CEE3;
	Tue, 15 Jul 2025 13:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586963;
	bh=h+KliwEo/dXpQ88C7yIJfvZdcpR2pDWwfbn3aTR1r8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+RVL5VgkMLFKBpTc/es0X+6PXPw2MO7SjVwb07tPMxIHrV5epA+pk8nNJ+TF/BzY
	 hrVzfRWLXD/Rx9qbnLNIfl/Kj2GymtW49ITwK71YNrhu+zuQs5J16atVA/d3+TBORp
	 LFdBmKUgfeRMuJ9qx7VniE6VfCpT2Q+t+Dxi4Nk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Paulyshka <me@mixaill.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.15 114/192] x86/rdrand: Disable RDSEED on AMD Cyan Skillfish
Date: Tue, 15 Jul 2025 15:13:29 +0200
Message-ID: <20250715130819.461718765@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Paulyshka <me@mixaill.net>

commit 5b937a1ed64ebeba8876e398110a5790ad77407c upstream.

AMD Cyan Skillfish (Family 17h, Model 47h, Stepping 0h) has an error that
causes RDSEED to always return 0xffffffff, while RDRAND works correctly.

Mask the RDSEED cap for this CPU so that both /proc/cpuinfo and direct CPUID
read report RDSEED as unavailable.

  [ bp: Move to amd.c, massage. ]

Signed-off-by: Mikhail Paulyshka <me@mixaill.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/20250524145319.209075-1-me@mixaill.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h       |    1 +
 arch/x86/kernel/cpu/amd.c              |    7 +++++++
 tools/arch/x86/include/asm/msr-index.h |    1 +
 3 files changed, 9 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -624,6 +624,7 @@
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
 #define MSR_AMD_PPIN			0xc00102f1
+#define MSR_AMD64_CPUID_FN_7		0xc0011002
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -972,6 +972,13 @@ static void init_amd_zen2(struct cpuinfo
 	init_spectral_chicken(c);
 	fix_erratum_1386(c);
 	zen2_zenbleed_check(c);
+
+	/* Disable RDSEED on AMD Cyan Skillfish because of an error. */
+	if (c->x86_model == 0x47 && c->x86_stepping == 0x0) {
+		clear_cpu_cap(c, X86_FEATURE_RDSEED);
+		msr_clear_bit(MSR_AMD64_CPUID_FN_7, 18);
+		pr_emerg("RDSEED is not reliable on this platform; disabling.\n");
+	}
 }
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -616,6 +616,7 @@
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
 #define MSR_AMD_PPIN			0xc00102f1
+#define MSR_AMD64_CPUID_FN_7		0xc0011002
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022


