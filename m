Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844321FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBACBC433EF;
	Fri,  3 Feb 2023 10:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419797;
	bh=kDp6C65pVdVqhY4qD81CaQMBTLjF4OYidp1jbJSNjkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXv2Ode6pLPlbVowOVbZD7PA2CGcA3UycjZ7k1tvcKMQUrm3/Rmrrnh+jDt8HqcAF
	 F+itqiDzJqnnIp1mTuue0MN/p37XQpe5xQujJ8DM174QbUg7rn97Rc261lXanldFeg
	 ta+VjyqDFilxni4xHMLe5m2wtAuqfbjuA8e+0SM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 4/9] bpf: Skip task with pid=1 in send_signal_common()
Date: Fri,  3 Feb 2023 11:13:33 +0100
Message-Id: <20230203101006.615032192@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
References: <20230203101006.422534094@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit a3d81bc1eaef48e34dd0b9b48eefed9e02a06451 ]

The following kernel panic can be triggered when a task with pid=1 attaches
a prog that attempts to send killing signal to itself, also see [1] for more
details:

  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
  CPU: 3 PID: 1 Comm: systemd Not tainted 6.1.0-09652-g59fe41b5255f #148
  Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x100/0x178 lib/dump_stack.c:106
  panic+0x2c4/0x60f kernel/panic.c:275
  do_exit.cold+0x63/0xe4 kernel/exit.c:789
  do_group_exit+0xd4/0x2a0 kernel/exit.c:950
  get_signal+0x2460/0x2600 kernel/signal.c:2858
  arch_do_signal_or_restart+0x78/0x5d0 arch/x86/kernel/signal.c:306
  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
  exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
  __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
  do_syscall_64+0x44/0xb0 arch/x86/entry/common.c:86
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

So skip task with pid=1 in bpf_send_signal_common() to avoid the panic.

  [1] https://lore.kernel.org/bpf/20221222043507.33037-1-sunhao.th@gmail.com

Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20230106084838.12690-1-sunhao.th@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a9e074769881..ab4f51716645 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1072,6 +1072,9 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
+	/* Task should not be pid=1 to avoid kernel panic. */
+	if (unlikely(is_global_init(current)))
+		return -EPERM;
 
 	if (irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
-- 
2.39.0



