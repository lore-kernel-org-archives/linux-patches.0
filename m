Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE0323777
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hk1HX3AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D21C433C8;
	Mon,  6 Nov 2023 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699278289;
	bh=CL+ZUHlmu3+tefPiatLvmbyQ6rwnXsEKS9GWzrm7TiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hk1HX3ACyiljB1D2eV0BOKB7Ey8FbAypnE/2gS9qKY8JTG1Z2x2JUF2uJt/S0TK8J
	 YkP09Z4bWVpYmXEsZSKdl0K61SXXunrU7MjpdLhY0bXkRaI0KnDXjo7LJqbT4tdQ4m
	 H+CZK/k0UKBM+pwkAFnF1oto2Hlvq0LozGaFqiUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	stable@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 4.19 27/61] arm64: fix a concurrency issue in emulation_proc_handler()
Date: Mon,  6 Nov 2023 14:03:23 +0100
Message-ID: <20231106130300.548984031@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

In linux-6.1, the related code is refactored in commit 124c49b1b5d9
("arm64: armv8_deprecated: rework deprected instruction handling") and this
issue was incidentally fixed. I have adapted the patch set to linux stable
5.10. However, 4.19 and 5.10 are too different and the patch set is
hard to adapt to 4.19.

This patch is to solve the problem of repeated addition of linked lists
described below with few changes.

How to reproduce:
CONFIG_ARMV8_DEPRECATED=y, CONFIG_SWP_EMULATION=y, and CONFIG_DEBUG_LIST=y,
then launch two shell executions:
       #!/bin/bash
       while [ 1 ];
       do
           echo 1 > /proc/sys/abi/swp
       done

or "echo 1 > /proc/sys/abi/swp" and then aunch two shell executions:
       #!/bin/bash
       while [ 1 ];
       do
           echo 0 > /proc/sys/abi/swp
       done

In emulation_proc_handler(), read and write operations are performed on
insn->current_mode. In the concurrency scenario, mutex only protects
writing insn->current_mode, and not protects the read. Suppose there are
two concurrent tasks, task1 updates insn->current_mode to INSN_EMULATE
in the critical section, the prev_mode of task2 is still the old data
INSN_UNDEF of insn->current_mode. As a result, two tasks call
update_insn_emulation_mode twice with prev_mode = INSN_UNDEF and
current_mode = INSN_EMULATE, then call register_emulation_hooks twice,
resulting in a list_add double problem.

After applying this patch, the following list add or list del double
warnings never occur.

Call trace:
 __list_add_valid+0xd8/0xe4
 register_undef_hook+0x94/0x13c
 update_insn_emulation_mode+0xd0/0x12c
 emulation_proc_handler+0xd8/0xf4
 proc_sys_call_handler+0x140/0x250
 proc_sys_write+0x1c/0x2c
 new_sync_write+0xec/0x18c
 vfs_write+0x214/0x2ac
 ksys_write+0x70/0xfc
 __arm64_sys_write+0x24/0x30
 el0_svc_common.constprop.0+0x7c/0x1bc
 do_el0_svc+0x2c/0x94
 el0_svc+0x20/0x30
 el0_sync_handler+0xb0/0xb4
 el0_sync+0x160/0x180

Call trace:
 __list_del_entry_valid+0xac/0x110
 unregister_undef_hook+0x34/0x80
 update_insn_emulation_mode+0xf0/0x180
 emulation_proc_handler+0x8c/0xd8
 proc_sys_call_handler+0x1d8/0x208
 proc_sys_write+0x14/0x20
 new_sync_write+0xf0/0x190
 vfs_write+0x304/0x388
 ksys_write+0x6c/0x100
 __arm64_sys_write+0x1c/0x28
 el0_svc_common.constprop.4+0x68/0x188
 do_el0_svc+0x24/0xa0
 el0_svc+0x14/0x20
 el0_sync_handler+0x90/0xb8
 el0_sync+0x160/0x180

Fixes: af483947d472 ("arm64: fix oops in concurrently setting insn_emulation sysctls")
Cc: stable@vger.kernel.org#4.19.x
Cc: gregkh@linuxfoundation.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/armv8_deprecated.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -211,10 +211,12 @@ static int emulation_proc_handler(struct
 				  loff_t *ppos)
 {
 	int ret = 0;
-	struct insn_emulation *insn = container_of(table->data, struct insn_emulation, current_mode);
-	enum insn_emulation_mode prev_mode = insn->current_mode;
+	struct insn_emulation *insn;
+	enum insn_emulation_mode prev_mode;
 
 	mutex_lock(&insn_emulation_mutex);
+	insn = container_of(table->data, struct insn_emulation, current_mode);
+	prev_mode = insn->current_mode;
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (ret || !write || prev_mode == insn->current_mode)


