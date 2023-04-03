Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03635683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265A8C433D2;
	Mon,  3 Apr 2023 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531129;
	bh=26Y/ITEHPD8UFn8hEpEzsEFYiG8MOno/GFQpeNSP190=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYYOXGtBkVRQqsITBiMWIhPz2oBVMaXotbp8r98fno+GXi190EsqGFWm9p7jpo3El
	 THQjX4qjaR29H8nQccZ9wbC/U9HEgyjAKBN+l+/yf/VrPg8pSDRMEcxay7KAcsTnhu
	 9AOKgE8sej3En2g2dD53N68MRPG5jR6u+wSZTK7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Rich Felker <dalias@libc.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/66] sh: sanitize the flags on sigreturn
Date: Mon,  3 Apr 2023 16:08:38 +0200
Message-Id: <20230403140352.974721431@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 573b22ccb7ce9ab7f0539a2e11a9d3609a8783f5 ]

We fetch %SR value from sigframe; it might have been modified by signal
handler, so we can't trust it with any bits that are not modifiable in
user mode.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/asm/processor_32.h |    1 +
 arch/sh/kernel/signal_32.c         |    3 +++
 2 files changed, 4 insertions(+)

--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -57,6 +57,7 @@
 #define SR_FD		0x00008000
 #define SR_MD		0x40000000
 
+#define SR_USER_MASK	0x00000303	// M, Q, S, T bits
 /*
  * DSP structure and data
  */
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -116,6 +116,7 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p)
 {
 	unsigned int err = 0;
+	unsigned int sr = regs->sr & ~SR_USER_MASK;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 			COPY(regs[1]);
@@ -131,6 +132,8 @@ restore_sigcontext(struct pt_regs *regs,
 	COPY(sr);	COPY(pc);
 #undef COPY
 
+	regs->sr = (regs->sr & SR_USER_MASK) | sr;
+
 #ifdef CONFIG_SH_FPU
 	if (boot_cpu_data.flags & CPU_HAS_FPU) {
 		int owned_fp;


