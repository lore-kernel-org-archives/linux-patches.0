Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D02215CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B84C433D6;
	Tue,  8 Nov 2022 13:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667914925;
	bh=C1djr4j1Zbx1r09lyA1R611zm7zyxz6YTKXLXUgJHwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHuFXOBezEa+yKp847OWvc9n3jCjQd4IC3KBQt7p5Baa4ymLaL6kjxan5EWqs75XT
	 bldt3K+6wFWeD3JP0TEPq9Xh6grEXMhvRdqT2ICXHGoHDt5NFNjFT3ClQaf/fWpJpr
	 QFsCCqAZueCjpbwWT9RypPUj48pCcnN686GA0Xkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 29/30] KVM: x86: emulator: update the emulation mode after CR0 write
Date: Tue,  8 Nov 2022 14:39:17 +0100
Message-Id: <20221108133327.808012937@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Levitsky <mlevitsk@redhat.com>

commit ad8f9e69942c7db90758d9d774157e53bce94840 upstream.

Update the emulation mode when handling writes to CR0, because
toggling CR0.PE switches between Real and Protected Mode, and toggling
CR0.PG when EFER.LME=1 switches between Long and Protected Mode.

This is likely a benign bug because there is no writeback of state,
other than the RIP increment, and when toggling CR0.PE, the CPU has
to execute code from a very low memory address.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-14-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3643,11 +3643,25 @@ static int em_movbe(struct x86_emulate_c
 
 static int em_cr_write(struct x86_emulate_ctxt *ctxt)
 {
-	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
+	int cr_num = ctxt->modrm_reg;
+	int r;
+
+	if (ctxt->ops->set_cr(ctxt, cr_num, ctxt->src.val))
 		return emulate_gp(ctxt, 0);
 
 	/* Disable writeback. */
 	ctxt->dst.type = OP_NONE;
+
+	if (cr_num == 0) {
+		/*
+		 * CR0 write might have updated CR0.PE and/or CR0.PG
+		 * which can affect the cpu's execution mode.
+		 */
+		r = emulator_recalc_and_set_mode(ctxt);
+		if (r != X86EMUL_CONTINUE)
+			return r;
+	}
+
 	return X86EMUL_CONTINUE;
 }
 


