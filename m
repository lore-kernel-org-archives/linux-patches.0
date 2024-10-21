Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170951E5718;
	Mon, 21 Oct 2024 10:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507736; cv=none; b=sO3pMp9tmT/LWKN+8G1ZNAPDBgTlqAgkbvWH0aWxa+aH91UxufF0W+YkJeHTrea/SiBlo93BfFMalUW+AinOuEUYQfUXNoBrPutcoM43b5aX269LTzIPdpVv4IcX/vhRilOmU2Tu1dPbfSQRt8XrjITW/FirwhS3jkKsmN5hHh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507736; c=relaxed/simple;
	bh=6RaaTiAiAkS3SyAoluwCtyK2OI+2XgEUI/yGuQrZWSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ep7yQYJf9Jl8SzQhUHtdsR+CpNFyhq+7zK9Vj8n+zhloN18D0fIrU9tKfLxe0F6g/orCwaqlHzAldYtep31/LVsY00TYSGcNI0xWYKC3M39jJitsFPV1JkWSTR26Hx379HRMNjwq4jwVKEPqn1yPxJ4jlg8F1NWsxRHxF7YwusA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMeq0ZYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMeq0ZYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61447C4CEC7;
	Mon, 21 Oct 2024 10:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507735;
	bh=6RaaTiAiAkS3SyAoluwCtyK2OI+2XgEUI/yGuQrZWSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMeq0ZYXDHBni3yRAJWM2/2/2dgwFX06pbNUCDfDz+k610s859bTkCV0W9b5uE73l
	 XNtO19EkdZqwbT1xcOSf8IweQ0koZKPdLix+zxF8K9rZrVy42LF87hcuqS7Q6aZkLn
	 2vXThB5Br9EjUUEuhTDpzAFZPQ+LZfZcHynIx7AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.15 43/82] x86/cpufeatures: Add a IBPB_NO_RET BUG flag
Date: Mon, 21 Oct 2024 12:25:24 +0200
Message-ID: <20241021102248.943420633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

From: Johannes Wikner <kwikner@ethz.ch>

commit 3ea87dfa31a7b0bb0ff1675e67b9e54883013074 upstream.

Set this flag if the CPU has an IBPB implementation that does not
invalidate return target predictions. Zen generations < 4 do not flush
the RSB when executing an IBPB and this bug flag denotes that.

  [ bp: Massage. ]

Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/common.c       |    3 +++
 2 files changed, 4 insertions(+)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -481,4 +481,5 @@
 #define X86_BUG_DIV0			X86_BUG(1*32 + 1) /* AMD DIV0 speculation bug */
 #define X86_BUG_RFDS			X86_BUG(1*32 + 2) /* CPU is vulnerable to Register File Data Sampling */
 #define X86_BUG_BHI			X86_BUG(1*32 + 3) /* CPU is affected by Branch History Injection */
+#define X86_BUG_IBPB_NO_RET		X86_BUG(1*32 + 4) /* "ibpb_no_ret" IBPB omits return target predictions */
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1352,6 +1352,9 @@ static void __init cpu_set_bug_bits(stru
 	     boot_cpu_has(X86_FEATURE_HYPERVISOR)))
 		setup_force_cpu_bug(X86_BUG_BHI);
 
+	if (cpu_has(c, X86_FEATURE_AMD_IBPB) && !cpu_has(c, X86_FEATURE_AMD_IBPB_RET))
+		setup_force_cpu_bug(X86_BUG_IBPB_NO_RET);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 


