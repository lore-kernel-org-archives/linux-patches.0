Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C05336888;
	Tue, 21 Jul 2026 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653648; cv=none; b=IcUtEEn6fXjSMpZakeAs8W7uBL/5JsBSATFlLaCzzl6+KNKJrSjp3CTSnImoLp9i3viNb71ksq3jzPb5pDM5SvnvMLtsVKD+OaazcH0fAdF3opkwPNxu2eAXIH5PZ1BOXZHjIMYYiWtJT78EgGqCJgUyEckEyA4I9xBj+ai58BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653648; c=relaxed/simple;
	bh=JlcYEW+WQXUQ/M14MFVyF6E+86FU+7r/E6e0m2dYCbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4fobFoH+0crgRp5G3PavgPBOiiPv7WRK+Q5JWni+m50JzoeztNbvedcyYIDWDuob3fMiN6CyDR6y1hHVgw36SG8n+O0qpDpd18bwTAFxs5K81Pxe4mhe8hc1AQcFCcgGH8UNtoRsswVEl6KAofgw1Qij2TBQBnyS3jWknNy9qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf/Xq5EC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf/Xq5EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034441F000E9;
	Tue, 21 Jul 2026 17:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653647;
	bh=G+6wZ2AtY4Q88NcJk84BITQO4mjEcYZ//m8SAxSqS5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bf/Xq5EC0/wx1pzFj1xy+wEeN/eBqX8RSusi3QGLqmGrLRDpOLgiaizP3oprixrMm
	 EJ7Oh+4h8VCBO8upNQ0fG7Lf3wPAbVj+TXZDfnz7++C6THIIrQxYYwQMImrG2iHv7J
	 /EmpJ5fcvzKUW9DBBXQxisjNCkskFJ5Bi7uqs+Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1406/2077] x86/uprobes: Keep shadow stack in sync for emulated CALLs
Date: Tue, 21 Jul 2026 17:17:59 +0200
Message-ID: <20260721152625.971305914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Windsor <dwindsor@gmail.com>

[ Upstream commit abf08854d224085e2ebb3ba660e7995909f47d6a ]

Uprobe CALL emulation updates the normal user stack, but not the CET user
shadow stack. The subsequent RET then sees a stale shadow stack entry and
raises #CP.

Update the relative CALL emulation and XOL CALL fixup paths to keep the
shadow stack in sync.

Fixes: 488af8ea7131 ("x86/shstk: Wire in shadow stack interface")
Signed-off-by: David Windsor <dwindsor@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Jiri Olsa <jolsa@kernel.org>
Link: https://patch.msgid.link/8b5b1c7407b98f31664ad7b6a6faf20d2d4a6cad.1782777969.git.dwindsor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/uprobes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index ebb1baf1eb1d02..d74bb54543b608 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1246,9 +1246,15 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 		long correction = utask->vaddr - utask->xol_vaddr;
 		regs->ip += correction;
 	} else if (auprobe->defparam.fixups & UPROBE_FIX_CALL) {
+		unsigned long retaddr = utask->vaddr + auprobe->defparam.ilen;
+		int err;
+
 		regs->sp += sizeof_long(regs); /* Pop incorrect return address */
-		if (emulate_push_stack(regs, utask->vaddr + auprobe->defparam.ilen))
+		if (emulate_push_stack(regs, retaddr))
 			return -ERESTART;
+		err = shstk_update_last_frame(retaddr);
+		if (err)
+			return err;
 	}
 	/* popf; tell the caller to not touch TF */
 	if (auprobe->defparam.fixups & UPROBE_FIX_SETF)
@@ -1338,6 +1344,10 @@ static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		 */
 		if (emulate_push_stack(regs, new_ip))
 			return false;
+		if (shstk_push(new_ip) == -EFAULT) {
+			regs->sp += sizeof_long(regs);
+			return false;
+		}
 	} else if (!check_jmp_cond(auprobe, regs)) {
 		offs = 0;
 	}
-- 
2.53.0



