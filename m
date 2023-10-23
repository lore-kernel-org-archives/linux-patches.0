Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF2115E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xy0rMWMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1B4C433C9;
	Mon, 23 Oct 2023 11:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060984;
	bh=4LF9tOSLzXCLUF9hdVgXMBkuH8CjGRISJc/YWkymsro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xy0rMWMsRlilMjc/gmUlBDNJgYhhB9SdSfcaj3KNdMJZpt2naDrwAv4F6bnW+ZJ8T
	 NYW5kIIAjD2RvDcO58Bg6E1sb6x4CjthR1y1jugOUZmB/INBahk59AKKUBwtPvg1At
	 hGqXAW7E3p5kAiAsMvIWqf45X8yGu7Rhd/uZObPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Dohrmann <erbse.13@gmx.de>,
	Joerg Roedel <jroedel@suse.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.15 017/137] x86/sev: Check for user-space IOIO pointing to kernel space
Date: Mon, 23 Oct 2023 12:56:14 +0200
Message-ID: <20231023104821.524048898@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

From: Joerg Roedel <jroedel@suse.de>

Upstream commit: 63e44bc52047f182601e7817da969a105aa1f721

Check the memory operand of INS/OUTS before emulating the instruction.
The #VC exception can get raised from user-space, but the memory operand
can be manipulated to access kernel memory before the emulation actually
begins and after the exception handler has run.

  [ bp: Massage commit message. ]

Fixes: 597cfe48212a ("x86/boot/compressed/64: Setup a GHCB-based VC Exception handler")
Reported-by: Tom Dohrmann <erbse.13@gmx.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/sev.c |    5 +++++
 arch/x86/kernel/sev-shared.c   |   31 +++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -110,6 +110,11 @@ static enum es_result vc_ioio_check(stru
 	return ES_OK;
 }
 
+static bool fault_in_kernel_space(unsigned long address)
+{
+	return false;
+}
+
 #undef __init
 #undef __pa
 #define __init
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -213,6 +213,23 @@ fail:
 	sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
 }
 
+static enum es_result vc_insn_string_check(struct es_em_ctxt *ctxt,
+					   unsigned long address,
+					   bool write)
+{
+	if (user_mode(ctxt->regs) && fault_in_kernel_space(address)) {
+		ctxt->fi.vector     = X86_TRAP_PF;
+		ctxt->fi.error_code = X86_PF_USER;
+		ctxt->fi.cr2        = address;
+		if (write)
+			ctxt->fi.error_code |= X86_PF_WRITE;
+
+		return ES_EXCEPTION;
+	}
+
+	return ES_OK;
+}
+
 static enum es_result vc_insn_string_read(struct es_em_ctxt *ctxt,
 					  void *src, char *buf,
 					  unsigned int data_size,
@@ -220,7 +237,12 @@ static enum es_result vc_insn_string_rea
 					  bool backwards)
 {
 	int i, b = backwards ? -1 : 1;
-	enum es_result ret = ES_OK;
+	unsigned long address = (unsigned long)src;
+	enum es_result ret;
+
+	ret = vc_insn_string_check(ctxt, address, false);
+	if (ret != ES_OK)
+		return ret;
 
 	for (i = 0; i < count; i++) {
 		void *s = src + (i * data_size * b);
@@ -241,7 +263,12 @@ static enum es_result vc_insn_string_wri
 					   bool backwards)
 {
 	int i, s = backwards ? -1 : 1;
-	enum es_result ret = ES_OK;
+	unsigned long address = (unsigned long)dst;
+	enum es_result ret;
+
+	ret = vc_insn_string_check(ctxt, address, true);
+	if (ret != ES_OK)
+		return ret;
 
 	for (i = 0; i < count; i++) {
 		void *d = dst + (i * data_size * s);


