Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A9D17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE5AC433C8;
	Wed,  9 Aug 2023 11:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581224;
	bh=fZAj6kHqRhjylCF05G6BmiRfN2FDZ4H8z8vbS0p/zR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVHLrU49cLPvg17tzw8l2qE5/hXyH6BXwXe7/Elu5HX1ZzEFL7EQj2Tn6H2sIM9Ol
	 HG/pS1SsJnpnfb0IVA7L/mCe0snCgQXM2Jn54x9gBgzmUptujfBAMa8RD3CVqwY7Nu
	 No1/01SLbSBBG73FXX7MxGrSsnzmgJKQBWWuuPA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 5.10 120/201] x86/kprobes: Update kcb status flag after singlestepping
Date: Wed,  9 Aug 2023 12:42:02 +0200
Message-ID: <20230809103647.778302502@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit dec8784c9088b131a1523f582c2194cfc8107dc0 ]

Fix kprobes to update kcb (kprobes control block) status flag to
KPROBE_HIT_SSDONE even if the kp->post_handler is not set.

This bug may cause a kernel panic if another INT3 user runs right
after kprobes because kprobe_int3_handler() misunderstands the
INT3 is kprobe's single stepping INT3.

Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
Reported-by: Daniel Müller <deso@posteo.net>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Daniel Müller <deso@posteo.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20220727210136.jjgc3lpqeq42yr3m@muellerd-fedora-PC2BDTX9
Link: https://lore.kernel.org/r/165942025658.342061.12452378391879093249.stgit@devnote2
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -826,16 +826,20 @@ NOKPROBE_SYMBOL(arch_prepare_kretprobe);
 static void kprobe_post_process(struct kprobe *cur, struct pt_regs *regs,
 			       struct kprobe_ctlblk *kcb)
 {
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
 	/* Restore back the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER)
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		/* This will restore both kcb and current_kprobe */
 		restore_previous_kprobe(kcb);
-	else
+	} else {
+		/*
+		 * Always update the kcb status because
+		 * reset_curent_kprobe() doesn't update kcb.
+		 */
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		if (cur->post_handler)
+			cur->post_handler(cur, regs, 0);
 		reset_current_kprobe();
+	}
 }
 NOKPROBE_SYMBOL(kprobe_post_process);
 


