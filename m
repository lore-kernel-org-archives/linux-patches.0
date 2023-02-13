Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC1A8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C85C4339B;
	Mon, 13 Feb 2023 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300181;
	bh=ATwIOMAYVbROdI9bkipJLxDjjO9PLwqcxdRryjI3z0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRuWUIKGvMhzhI80AmUEOOZCKdgDu6wdk9lmMbhySxpHx6/CvibyHKpIrwEkwIynP
	 SvZWAcDSPzbmGOVYLSxJwbOn+uEDly+HGosXEQt2bgr+sD+IAkhXeZhvqqAeQ+3qS6
	 DLJrOwBZy6l6TRkDG0aq/GtkLt9TplOeQ9ZKo79U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Bjorn Topel <bjorn.topel@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 095/114] riscv: kprobe: Fixup misaligned load text
Date: Mon, 13 Feb 2023 15:48:50 +0100
Message-Id: <20230213144747.083569434@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

commit eb7423273cc9922ee2d05bf660c034d7d515bb91 upstream.

The current kprobe would cause a misaligned load for the probe point.
This patch fixup it with two half-word loads instead.

Fixes: c22b0bcb1dd0 ("riscv: Add kprobes supported")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/linux-riscv/878rhig9zj.fsf@all.your.base.are.belong.to.us/
Reported-by: Bjorn Topel <bjorn.topel@gmail.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20230204063531.740220-1-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/kprobes.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -65,16 +65,18 @@ static bool __kprobes arch_check_kprobe(
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
-	unsigned long probe_addr = (unsigned long)p->addr;
+	u16 *insn = (u16 *)p->addr;
 
-	if (probe_addr & 0x1)
+	if ((unsigned long)insn & 0x1)
 		return -EILSEQ;
 
 	if (!arch_check_kprobe(p))
 		return -EILSEQ;
 
 	/* copy instruction */
-	p->opcode = *p->addr;
+	p->opcode = (kprobe_opcode_t)(*insn++);
+	if (GET_INSN_LENGTH(p->opcode) == 4)
+		p->opcode |= (kprobe_opcode_t)(*insn) << 16;
 
 	/* decode instruction */
 	switch (riscv_probe_decode_insn(p->addr, &p->ainsn.api)) {


