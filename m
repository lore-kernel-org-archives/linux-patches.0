Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFA814A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpgm5r/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C2EC433C7;
	Mon, 23 Oct 2023 11:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058960;
	bh=ryLnOMc2Vf+xbT9dhk4gNE0e74JhcSF5vs1FBrZrmys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpgm5r/fLOcFzjKyORGvIOK2S0uJgfyPc+pn0LP1kHKYbQ8AdpqG3XbP5lGL+mT5z
	 MTav5THiKFmKhM7sDY7PGY0Iipe+AknguAHnySC0Edlif8Gi7OZui83XymWqiIF5JZ
	 53KeJuWvgvukSbuq7T3KZ7rkbNwiHZv9P4MifxSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Dohrmann <erbse.13@gmx.de>,
	Joerg Roedel <jroedel@suse.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.5 017/241] x86/sev: Check IOBM for IOIO exceptions from user-space
Date: Mon, 23 Oct 2023 12:53:23 +0200
Message-ID: <20231023104834.343059094@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <jroedel@suse.de>

Upstream commit: b9cb9c45583b911e0db71d09caa6b56469eb2bdf

Check the IO permission bitmap (if present) before emulating IOIO #VC
exceptions for user-space. These permissions are checked by hardware
already before the #VC is raised, but due to the VC-handler decoding
race it needs to be checked again in software.

Fixes: 25189d08e516 ("x86/sev-es: Add support for handling IOIO exceptions")
Reported-by: Tom Dohrmann <erbse.13@gmx.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tom Dohrmann <erbse.13@gmx.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/sev.c |    5 +++++
 arch/x86/kernel/sev-shared.c   |   22 +++++++++++++++-------
 arch/x86/kernel/sev.c          |   27 +++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 7 deletions(-)

--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -103,6 +103,11 @@ static enum es_result vc_read_mem(struct
 	return ES_OK;
 }
 
+static enum es_result vc_ioio_check(struct es_em_ctxt *ctxt, u16 port, size_t size)
+{
+	return ES_OK;
+}
+
 #undef __init
 #define __init
 
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -696,6 +696,9 @@ static enum es_result vc_insn_string_wri
 static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 {
 	struct insn *insn = &ctxt->insn;
+	size_t size;
+	u64 port;
+
 	*exitinfo = 0;
 
 	switch (insn->opcode.bytes[0]) {
@@ -704,7 +707,7 @@ static enum es_result vc_ioio_exitinfo(s
 	case 0x6d:
 		*exitinfo |= IOIO_TYPE_INS;
 		*exitinfo |= IOIO_SEG_ES;
-		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
+		port	   = ctxt->regs->dx & 0xffff;
 		break;
 
 	/* OUTS opcodes */
@@ -712,41 +715,43 @@ static enum es_result vc_ioio_exitinfo(s
 	case 0x6f:
 		*exitinfo |= IOIO_TYPE_OUTS;
 		*exitinfo |= IOIO_SEG_DS;
-		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
+		port	   = ctxt->regs->dx & 0xffff;
 		break;
 
 	/* IN immediate opcodes */
 	case 0xe4:
 	case 0xe5:
 		*exitinfo |= IOIO_TYPE_IN;
-		*exitinfo |= (u8)insn->immediate.value << 16;
+		port	   = (u8)insn->immediate.value & 0xffff;
 		break;
 
 	/* OUT immediate opcodes */
 	case 0xe6:
 	case 0xe7:
 		*exitinfo |= IOIO_TYPE_OUT;
-		*exitinfo |= (u8)insn->immediate.value << 16;
+		port	   = (u8)insn->immediate.value & 0xffff;
 		break;
 
 	/* IN register opcodes */
 	case 0xec:
 	case 0xed:
 		*exitinfo |= IOIO_TYPE_IN;
-		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
+		port	   = ctxt->regs->dx & 0xffff;
 		break;
 
 	/* OUT register opcodes */
 	case 0xee:
 	case 0xef:
 		*exitinfo |= IOIO_TYPE_OUT;
-		*exitinfo |= (ctxt->regs->dx & 0xffff) << 16;
+		port	   = ctxt->regs->dx & 0xffff;
 		break;
 
 	default:
 		return ES_DECODE_FAILED;
 	}
 
+	*exitinfo |= port << 16;
+
 	switch (insn->opcode.bytes[0]) {
 	case 0x6c:
 	case 0x6e:
@@ -756,12 +761,15 @@ static enum es_result vc_ioio_exitinfo(s
 	case 0xee:
 		/* Single byte opcodes */
 		*exitinfo |= IOIO_DATA_8;
+		size       = 1;
 		break;
 	default:
 		/* Length determined by instruction parsing */
 		*exitinfo |= (insn->opnd_bytes == 2) ? IOIO_DATA_16
 						     : IOIO_DATA_32;
+		size       = (insn->opnd_bytes == 2) ? 2 : 4;
 	}
+
 	switch (insn->addr_bytes) {
 	case 2:
 		*exitinfo |= IOIO_ADDR_16;
@@ -777,7 +785,7 @@ static enum es_result vc_ioio_exitinfo(s
 	if (insn_has_rep_prefix(insn))
 		*exitinfo |= IOIO_REP;
 
-	return ES_OK;
+	return vc_ioio_check(ctxt, (u16)port, size);
 }
 
 static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -524,6 +524,33 @@ static enum es_result vc_slow_virt_to_ph
 	return ES_OK;
 }
 
+static enum es_result vc_ioio_check(struct es_em_ctxt *ctxt, u16 port, size_t size)
+{
+	BUG_ON(size > 4);
+
+	if (user_mode(ctxt->regs)) {
+		struct thread_struct *t = &current->thread;
+		struct io_bitmap *iobm = t->io_bitmap;
+		size_t idx;
+
+		if (!iobm)
+			goto fault;
+
+		for (idx = port; idx < port + size; ++idx) {
+			if (test_bit(idx, iobm->bitmap))
+				goto fault;
+		}
+	}
+
+	return ES_OK;
+
+fault:
+	ctxt->fi.vector = X86_TRAP_GP;
+	ctxt->fi.error_code = 0;
+
+	return ES_EXCEPTION;
+}
+
 /* Include code shared with pre-decompression boot stage */
 #include "sev-shared.c"
 


