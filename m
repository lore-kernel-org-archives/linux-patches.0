Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32C66FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41936C433EF;
	Mon, 16 Jan 2023 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888572;
	bh=h8pDvffm1ThMZSWyaD4PozsEeeL+yOn9IWSq5Y22olo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4T2Fd3sAakZByIU0/f9x/d7HBSN5X+rLUYyv36kNCS4I1uSGq8XxhLsjsIvWn6FM
	 6MYgA3RZlxCgpGwLAOlFfxp0O6UqtZto+buqQhjFCqghkjgV9AsfUeDvoXOBtbCT3D
	 7IsDSX/zNdBTGhPuSO6EJ9wcAfBCkShJxng4FLck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Nishikawa <snishika@redhat.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 057/338] uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix
Date: Mon, 16 Jan 2023 16:48:50 +0100
Message-Id: <20230116154823.307097609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit cefa72129e45313655d53a065b8055aaeb01a0c9 ]

Intel ICC -hotpatch inserts 2-byte "0x66 0x90" NOP at the start of each
function to reserve extra space for hot-patching, and currently it is not
possible to probe these functions because branch_setup_xol_ops() wrongly
rejects NOP with REP prefix as it treats them like word-sized branch
instructions.

Fixes: 250bbd12c2fe ("uprobes/x86: Refuse to attach uprobe to "word-sized" branch insns")
Reported-by: Seiji Nishikawa <snishika@redhat.com>
Suggested-by: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20221204173933.GA31544@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/uprobes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 52bb7413f352..953ed5b5a218 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -718,8 +718,9 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	switch (opc1) {
 	case 0xeb:	/* jmp 8 */
 	case 0xe9:	/* jmp 32 */
-	case 0x90:	/* prefix* + nop; same as jmp with .offs = 0 */
 		break;
+	case 0x90:	/* prefix* + nop; same as jmp with .offs = 0 */
+		goto setup;
 
 	case 0xe8:	/* call relative */
 		branch_clear_offset(auprobe, insn);
@@ -748,6 +749,7 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 			return -ENOTSUPP;
 	}
 
+setup:
 	auprobe->branch.opc1 = opc1;
 	auprobe->branch.ilen = insn->length;
 	auprobe->branch.offs = insn->immediate.value;
-- 
2.35.1



