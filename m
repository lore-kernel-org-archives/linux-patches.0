Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6A8415F09;
	Tue, 21 Jul 2026 18:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658236; cv=none; b=iCLyJBnMLVFy8w9CXoYrWzqa5mVKMge/8i4K2uhC/CnVov8Q6uPuVGej3R1HjAw5zcRvR0Og2go1Wkg8BN9Js8ZDAo3m1M7H2xNil+29A0aolG4qtcXMdWzdLYvX/fgswLkfpDqWd3NqvpfOfsN2TBG5JNw6c9GIVvziQiQ4haA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658236; c=relaxed/simple;
	bh=UmWUsgfiZAqzUCW4NqGBQjQLr+H6Bi+rHH6npl778to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVRL+2FfOkm3PtZosdbZ8GKa5nXUCnCW8o7ZwrItPROzLOfBdwHrv53Q0yYqihIanCcgbdG6htAiW9YJgso3gnk3G00bJ9hNCHg2G/Mn0vQeDo+zfbEzBZeZZVQBtY7UOxsg/CyoKgaw4kHGuic/1KMy9n/0RAZDEDqzaYwZHT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9WYcb+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9WYcb+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F4E1F000E9;
	Tue, 21 Jul 2026 18:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658235;
	bh=RpLuM13/3VHYuljIML4HesViYszQk1i/XWH6gqKWGy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9WYcb+m8B8uAPk/ILDfZCGHsigFxksmtou2N7rJDc41rW6gZINziJ0dJCDnKNA/5
	 YuxeFShqKBk6A5UERG5iIYvweUMCqMjE0M5ZY78YVdkh4kCJH2ieWYJ/frxmapdPb/
	 DfKYWR6gK0cUlidJvFJI4kFd06USs6h5RwvlJBik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Windsor <dwindsor@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1024/1611] x86/uprobes: Keep shadow stack in sync for emulated CALLs
Date: Tue, 21 Jul 2026 17:19:00 +0200
Message-ID: <20260721152538.423098046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 46aed82243964d..852d54b2e41372 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1269,9 +1269,15 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
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
@@ -1361,6 +1367,10 @@ static bool branch_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
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



