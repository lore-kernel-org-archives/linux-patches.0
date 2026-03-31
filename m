Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD13425CEE;
	Tue, 31 Mar 2026 16:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975298; cv=none; b=UdvpZMR90QuBlVjMqAN0EClDGHbMdnXIEwqZPnqCTLJTrdHXDvdHhMLiHC+bOZyfQrL64oDf2Sw42EDZCFTK30Ani8wgfL//pM2Pd64eJarDuomEoN2R7ZpMmpGNXIijd1ZZkOAedxqumH+VUbFe2Vh4DizGL0qYjg0QTxR8KPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975298; c=relaxed/simple;
	bh=cBd3BFH4HSHhYij5vwvd3bfZG/MaIEiTokb0P9dwBJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8MkKlIji08or4qvHhmxRB/GE/CsjypzpzuD/GoP5PBAFBFEtRo/VmYlahLG0ONHgLN8o+22FFkhgRLPYW4PSc3O8KXWe4ehYHr0CTthlShQH0cSaZkNygL5DSwwArIsemoWuvMdgUJfsE6q6c/rZFuC9zj8EmZq55dfPY3F5Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Fg+sBva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Fg+sBva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E11C19424;
	Tue, 31 Mar 2026 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975298;
	bh=cBd3BFH4HSHhYij5vwvd3bfZG/MaIEiTokb0P9dwBJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Fg+sBvaR59iP7tzqdAOOBD3vQRCW8HbSkT6nIoCqOMEMkjVyfhlay2qNfPha74Dh
	 9NlSL0p8LEALYHH3rAOL8WqF4T5TBMhTw9ahH5F2/m9V/1MJFLaRoLyihuKRVvvFZX
	 1XMN6gqAcn5w7/42lZj5TifOHlcDfYWrPetobwMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.19 241/342] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Date: Tue, 31 Mar 2026 18:21:14 +0200
Message-ID: <20260331161807.831705972@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikunj A Dadhania <nikunj@amd.com>

commit 3645eb7e3915990a149460c151a00894cb586253 upstream.

FRED-enabled SEV-(ES,SNP) guests fail to boot due to the following issues
in the early boot sequence:

* FRED does not have a #VC exception handler in the dispatch logic

* Early FRED #VC exceptions attempt to use uninitialized per-CPU GHCBs
  instead of boot_ghcb

Add X86_TRAP_VC case to fred_hwexc() with a new exc_vmm_communication()
function that provides the unified entry point FRED requires, dispatching
to existing user/kernel handlers based on privilege level. The function is
already declared via DECLARE_IDTENTRY_VC().

Fix early GHCB access by falling back to boot_ghcb in
__sev_{get,put}_ghcb() when per-CPU GHCBs are not yet initialized.

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>  # 6.12+
Link: https://patch.msgid.link/20260318075654.1792916-4-nikunj@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/sev/noinstr.c |    6 ++++++
 arch/x86/entry/entry_fred.c |   14 ++++++++++++++
 2 files changed, 20 insertions(+)

--- a/arch/x86/coco/sev/noinstr.c
+++ b/arch/x86/coco/sev/noinstr.c
@@ -120,6 +120,9 @@ noinstr struct ghcb *__sev_get_ghcb(stru
 
 	WARN_ON(!irqs_disabled());
 
+	if (!sev_cfg.ghcbs_initialized)
+		return boot_ghcb;
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
@@ -163,6 +166,9 @@ noinstr void __sev_put_ghcb(struct ghcb_
 
 	WARN_ON(!irqs_disabled());
 
+	if (!sev_cfg.ghcbs_initialized)
+		return;
+
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
 
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -176,6 +176,16 @@ static noinstr void fred_extint(struct p
 	}
 }
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+noinstr void exc_vmm_communication(struct pt_regs *regs, unsigned long error_code)
+{
+	if (user_mode(regs))
+		return user_exc_vmm_communication(regs, error_code);
+	else
+		return kernel_exc_vmm_communication(regs, error_code);
+}
+#endif
+
 static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
 {
 	/* Optimize for #PF. That's the only exception which matters performance wise */
@@ -206,6 +216,10 @@ static noinstr void fred_hwexc(struct pt
 #ifdef CONFIG_X86_CET
 	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
 #endif
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	case X86_TRAP_VC: return exc_vmm_communication(regs, error_code);
+#endif
+
 	default: return fred_bad_type(regs, error_code);
 	}
 


