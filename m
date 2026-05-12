Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B23EDE4A;
	Tue, 12 May 2026 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608928; cv=none; b=mBLBPmZAQLJ9qeN2jg1+O6NKjOSbLsmvThik7V9XUn1QQq87Kuo73H/dWKO6IhVQLiaafpaRFGZV1nR2wwR1HGuJeh3zYGxrrXQqoP1NtcrTp7sYUNOqYOe000tJyL1rvSGY5uIIbPn0Q+c6/nk3kH95UIfz/ZZz13vcs8YATIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608928; c=relaxed/simple;
	bh=8acYsDMAZieVLRgHkYnWwRGEyztAvgrx7BJnhXa2UnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm4Ps2/iaMaxEYSwFHrst7q5rgjo0d5mtveIekON7HNYkpvcdRhpreobO3mMcTes0HkdRF/kC3T82W9N4yCiH+lb+MOcFYtEDe2N/gYwjx4qbOswHA/auYVlA0y27+eafUWhINu/lBbKhMaceFmFEZdJ9ShqXIsKqWVYXdSB1Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L07wk1BR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L07wk1BR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982D7C2BCB0;
	Tue, 12 May 2026 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608927;
	bh=8acYsDMAZieVLRgHkYnWwRGEyztAvgrx7BJnhXa2UnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L07wk1BRNSLD8VF+b6Ya/Rm/xUCoF+6fVLkuOt9ym6lQlOZSIqjj7PEhJQXEoRUHg
	 rDLYw798SJT0WmVblEXcPR5hJY05Ngtb7q6dUdueSvWvknxF1b7zXu2GKC8MLKIzsK
	 NYNKwUb06gvJonVCKSlmlZz7y+ZF9rxxCbAilQCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathyushi Nangia <prathyushi.nangia@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.18 270/270] x86/CPU/AMD: Prevent improper isolation of shared resources in Zen2s op cache
Date: Tue, 12 May 2026 19:41:11 +0200
Message-ID: <20260512173944.135570732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathyushi Nangia <prathyushi.nangia@amd.com>

commit c21b90f77687075115d989e53a8ec5e2bb427ab1 upstream.

Make sure resources are not improperly shared in the op cache and
cause instruction corruption this way.

Signed-off-by: Prathyushi Nangia <prathyushi.nangia@amd.com>
Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h       |    3 ++-
 arch/x86/kernel/cpu/amd.c              |    3 +++
 tools/arch/x86/include/asm/msr-index.h |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -767,9 +767,10 @@
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
@@ -994,6 +994,9 @@ static void init_amd_zen2(struct cpuinfo
 
 	/* Correct misconfigured CPUID on some clients. */
 	clear_cpu_cap(c, X86_FEATURE_INVLPGB);
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
+		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN2_BP_CFG_BUG_FIX_BIT);
 }
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -761,9 +761,10 @@
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
 /* Zen4 */
-#define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG			0xc001102e
 #define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
+#define MSR_ZEN2_BP_CFG_BUG_FIX_BIT	33
 
 /* Fam 19h MSRs */
 #define MSR_F19H_UMC_PERF_CTL           0xc0010800


