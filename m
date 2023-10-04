Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B471F5F0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOcZ+0v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A506C433C8;
	Wed,  4 Oct 2023 18:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444281;
	bh=XrssedNzEbhBZYjh0uZlC+sNIe9S1XtC1QTeEmETMmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOcZ+0v4Njmdle5DVjOacU9pxwXajuShkOBteKVnhOZjuCYqhRzI9pgkfvpFkngyF
	 xF3tIgo/xp7uB3sKq2kx52ZIjDfWFXbHJ/r5EKl/cyn+21eiTdjZ1xR/xelEHpofL4
	 oxOpQwsACabD24K9f/JafvZXgWAQS/A5De7t/LJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 195/321] objtool: Fix _THIS_IP_ detection for cold functions
Date: Wed,  4 Oct 2023 19:55:40 +0200
Message-ID: <20231004175238.260028307@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 72178d5d1a38dd185d1db15f177f2d122ef10d9b ]

Cold functions and their non-cold counterparts can use _THIS_IP_ to
reference each other.  Don't warn about !ENDBR in that case.

Note that for GCC this is currently irrelevant in light of the following
commit

  c27cd083cfb9 ("Compiler attributes: GCC cold function alignment workarounds")

which disabled cold functions in the kernel.  However this may still be
possible with Clang.

Fixes several warnings like the following:

  drivers/scsi/bnx2i/bnx2i.prelink.o: warning: objtool: bnx2i_hw_ep_disconnect+0x19d: relocation to !ENDBR: bnx2i_hw_ep_disconnect.cold+0x0
  drivers/net/ipvlan/ipvlan.prelink.o: warning: objtool: ipvlan_addr4_event.cold+0x28: relocation to !ENDBR: ipvlan_addr4_event+0xda
  drivers/net/ipvlan/ipvlan.prelink.o: warning: objtool: ipvlan_addr6_event.cold+0x26: relocation to !ENDBR: ipvlan_addr6_event+0xb7
  drivers/net/ethernet/broadcom/tg3.prelink.o: warning: objtool: tg3_set_ringparam.cold+0x17: relocation to !ENDBR: tg3_set_ringparam+0x115
  drivers/net/ethernet/broadcom/tg3.prelink.o: warning: objtool: tg3_self_test.cold+0x17: relocation to !ENDBR: tg3_self_test+0x2e1
  drivers/target/iscsi/cxgbit/cxgbit.prelink.o: warning: objtool: __cxgbit_free_conn.cold+0x24: relocation to !ENDBR: __cxgbit_free_conn+0xfb
  net/can/can.prelink.o: warning: objtool: can_rx_unregister.cold+0x2c: relocation to !ENDBR: can_rx_unregister+0x11b
  drivers/net/ethernet/qlogic/qed/qed.prelink.o: warning: objtool: qed_spq_post+0xc0: relocation to !ENDBR: qed_spq_post.cold+0x9a
  drivers/net/ethernet/qlogic/qed/qed.prelink.o: warning: objtool: qed_iwarp_ll2_comp_syn_pkt.cold+0x12f: relocation to !ENDBR: qed_iwarp_ll2_comp_syn_pkt+0x34b
  net/tipc/tipc.prelink.o: warning: objtool: tipc_nametbl_publish.cold+0x21: relocation to !ENDBR: tipc_nametbl_publish+0xa6

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/d8f1ab6a23a6105bc023c132b105f245c7976be6.1694476559.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 1384090530dbe..e308d1ba664ef 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4333,7 +4333,8 @@ static int validate_ibt_insn(struct objtool_file *file, struct instruction *insn
 			continue;
 		}
 
-		if (insn_func(dest) && insn_func(dest) == insn_func(insn)) {
+		if (insn_func(dest) && insn_func(insn) &&
+		    insn_func(dest)->pfunc == insn_func(insn)->pfunc) {
 			/*
 			 * Anything from->to self is either _THIS_IP_ or
 			 * IRET-to-self.
-- 
2.40.1



