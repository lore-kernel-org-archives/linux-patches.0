Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1169E17F3
	for <patches@lists.linux.dev>; Mon, 31 Oct 2022 07:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822ADC433C1;
	Mon, 31 Oct 2022 07:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667199842;
	bh=GDz12mumsYmjJ9UX17FjpPtb/D22Kn8YUXN193WaUR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VE2YNAhKZq6UtQ5V0eIApFZjDYicCKKzswLBrm7/5zwk8qq5Sc+CEUa7kboq++T3G
	 P/R/gSk639cXzqP9tWA3CTmx9TuaSZB3mwh1iHnxBCw+Lop0881rvxkpmx57DEocYU
	 3RrIJLXM3yBwTBSBkQrkjYUAsZ75ZHJkS0FVoFzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 33/34] x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts
Date: Mon, 31 Oct 2022 08:03:06 +0100
Message-Id: <20221031070140.890958034@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit eb23b5ef9131e6d65011de349a4d25ef1b3d4314 upstream.

IBRS mitigation for spectre_v2 forces write to MSR_IA32_SPEC_CTRL at
every kernel entry/exit. On Enhanced IBRS parts setting
MSR_IA32_SPEC_CTRL[IBRS] only once at boot is sufficient. MSR writes at
every kernel entry/exit incur unnecessary performance loss.

When Enhanced IBRS feature is present, print a warning about this
unnecessary performance loss.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -849,6 +849,7 @@ static inline const char *spectre_v2_mod
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
 
 #ifdef CONFIG_BPF_SYSCALL
 void unpriv_ebpf_notify(int new_state)
@@ -1275,6 +1276,8 @@ static void __init spectre_v2_select_mit
 
 	case SPECTRE_V2_IBRS:
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
 		break;
 
 	case SPECTRE_V2_LFENCE:


