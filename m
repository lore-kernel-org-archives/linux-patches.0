Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287EC2E11D3;
	Tue, 15 Jul 2025 13:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585586; cv=none; b=qMv41lZzpGg2gQlQgAdqWevVQQssRpuPCJVVl4BGLsr6FodmBO9HcBxLLYnSmiMz3NdRh+yLbaPewA8AALYjA8JV8uKaTQayYo+zU7Ur/KIb4yzLW+5xZ5pjZZnx6K26mlN5PYoJlZ9/0NLd5H+EXQNKFDleyl+ybzBFyE3hFuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585586; c=relaxed/simple;
	bh=lVkYEgGHvjV+nCe0ndlPN1TJQ4v5quCmEgQzjDj2y5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCwl/ncVifSOkQAmU6i+xGebgapDgqhy8rDxPugYjIgZ74JkehBUgJVaZzlMLZz7SCtHuszlw81C5LfyR/9S3DKOeR2LUpnXVa6dRoJEEot29RfMw2bSziIZqHrRIVVh743OQXMPpdLkTPUhvaXYpPcxq80h88fq7b/Ems+jLLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpL6hRrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpL6hRrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7854FC4CEE3;
	Tue, 15 Jul 2025 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585585;
	bh=lVkYEgGHvjV+nCe0ndlPN1TJQ4v5quCmEgQzjDj2y5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpL6hRrxkwABzODfbEITxWISJUMfmPZB/h6pbY8sxKGnp2Sm5F6s3beYt/O9pcK8S
	 eFZj5uOAW5ZxaCq+ijv/Wj2asYnKkOJDPIHgYfcjFIgMRiDC0kZMIU552Red5485Dk
	 FLPRMSR4xYp2mijYsD6yH2hpI8h2pIFsg9WtU+ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Paulyshka <me@mixaill.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 096/163] x86/rdrand: Disable RDSEED on AMD Cyan Skillfish
Date: Tue, 15 Jul 2025 15:12:44 +0200
Message-ID: <20250715130812.718506640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,6 +621,7 @@
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
 #define MSR_AMD_PPIN			0xc00102f1
+#define MSR_AMD64_CPUID_FN_7		0xc0011002
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -977,6 +977,13 @@ static void init_amd_zen2(struct cpuinfo
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
@@ -612,6 +612,7 @@
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
 #define MSR_AMD_PPIN			0xc00102f1
+#define MSR_AMD64_CPUID_FN_7		0xc0011002
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022


