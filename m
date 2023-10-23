Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47D415E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+zRSMgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C00C433C9;
	Mon, 23 Oct 2023 11:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061040;
	bh=dbNxpTiaycmt+9SX9nAsTYyKInsEnDsi2fnM8IUVoms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+zRSMgKPDskRTdsmxGRfkHBWEy5+3FaEa/E4+JhC3sKTpgYFsiCNNf3Rb8lOx693
	 rtz4p6mof/kEl+a5Ob4j7XO9yAJoVAxoZW7ZmFSOwbqmxkwzo5A2exZyyGdhUMzMty
	 l04Ck/BhyHyjSFz8CHr5aj7lryGZBhVbCNbq77FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Dohrmann <erbse.13@gmx.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 5.15 015/137] x86/sev: Disable MMIO emulation from user mode
Date: Mon, 23 Oct 2023 12:56:12 +0200
Message-ID: <20231023104821.451137647@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Upstream commit: a37cd2a59d0cb270b1bba568fd3a3b8668b9d3ba

A virt scenario can be constructed where MMIO memory can be user memory.
When that happens, a race condition opens between when the hardware
raises the #VC and when the #VC handler gets to emulate the instruction.

If the MOVS is replaced with a MOVS accessing kernel memory in that
small race window, then write to kernel memory happens as the access
checks are not done at emulation time.

Disable MMIO emulation in user mode temporarily until a sensible use
case appears and justifies properly handling the race window.

Fixes: 0118b604c2c9 ("x86/sev-es: Handle MMIO String Instructions")
Reported-by: Tom Dohrmann <erbse.13@gmx.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tom Dohrmann <erbse.13@gmx.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1004,6 +1004,9 @@ static enum es_result vc_handle_mmio(str
 	enum es_result ret;
 	long *reg_data;
 
+	if (user_mode(ctxt->regs))
+		return ES_UNSUPPORTED;
+
 	switch (insn->opcode.bytes[0]) {
 	/* MMIO Write */
 	case 0x88:


