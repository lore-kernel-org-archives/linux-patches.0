Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F221741C0;
	Wed,  3 Jul 2024 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004720; cv=none; b=Iazbb8YcTXAI3KyBfEuuM97wqPt4h0HWSY9xNRdyjW8LbYx6pRgvWNl9ilbQIEsWGKE8byhRvcq13D4fSc496wLpB9n7A/FnvSFoOweIkDvyJy67HEs2ko21yo1or2ymJ9octW6Of0FDVYJ6YDWpTlIap21FRU9Ozq1EV62cCQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004720; c=relaxed/simple;
	bh=hOpgg7kN7FqVw6L3fYbFn4K74IuxsAKBElh9FPiKWgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwW0pWzHfAvNoEg8Mqgpp1v2MY3w+M1ydBm+67exrxle3pa4lsrcGdPJ3hd4VQSCbc1NbvuR7D9aiu/DwxsVy1a6gBSXADgTP+ETKUVdNSAEQSPKIfa/PNkK0QrMX0GQk0zm1iBeMjSAwf45G7KfbNVfhxx/w0bIYg6k8aTEOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjkmK2Yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjkmK2Yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D75C2BD10;
	Wed,  3 Jul 2024 11:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004720;
	bh=hOpgg7kN7FqVw6L3fYbFn4K74IuxsAKBElh9FPiKWgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjkmK2Yqz1lPaM92kc8WC6yiep0X02TfuJ6rMf8eQfdblOAP1SaE40vwG4CHNa/c2
	 10bniH/M1bnluPS34xiGgVOBcJbGeJfDIBNd1stchIbZ1y9zk+bvFkjYSxf6jLn0SJ
	 alEm/zLx05TNFz49lHzadbj6P1eCgx3gL6g2jW4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/290] tracing: Build event generation tests only as modules
Date: Wed,  3 Jul 2024 12:38:38 +0200
Message-ID: <20240703102909.361176381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 3572bd5689b0812b161b40279e39ca5b66d73e88 ]

The kprobes and synth event generation test modules add events and lock
(get a reference) those event file reference in module init function,
and unlock and delete it in module exit function. This is because those
are designed for playing as modules.

If we make those modules as built-in, those events are left locked in the
kernel, and never be removed. This causes kprobe event self-test failure
as below.

[   97.349708] ------------[ cut here ]------------
[   97.353453] WARNING: CPU: 3 PID: 1 at kernel/trace/trace_kprobe.c:2133 kprobe_trace_self_tests_init+0x3f1/0x480
[   97.357106] Modules linked in:
[   97.358488] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 6.9.0-g699646734ab5-dirty #14
[   97.361556] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   97.363880] RIP: 0010:kprobe_trace_self_tests_init+0x3f1/0x480
[   97.365538] Code: a8 24 08 82 e9 ae fd ff ff 90 0f 0b 90 48 c7 c7 e5 aa 0b 82 e9 ee fc ff ff 90 0f 0b 90 48 c7 c7 2d 61 06 82 e9 8e fd ff ff 90 <0f> 0b 90 48 c7 c7 33 0b 0c 82 89 c6 e8 6e 03 1f ff 41 ff c7 e9 90
[   97.370429] RSP: 0000:ffffc90000013b50 EFLAGS: 00010286
[   97.371852] RAX: 00000000fffffff0 RBX: ffff888005919c00 RCX: 0000000000000000
[   97.373829] RDX: ffff888003f40000 RSI: ffffffff8236a598 RDI: ffff888003f40a68
[   97.375715] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[   97.377675] R10: ffffffff811c9ae5 R11: ffffffff8120c4e0 R12: 0000000000000000
[   97.379591] R13: 0000000000000001 R14: 0000000000000015 R15: 0000000000000000
[   97.381536] FS:  0000000000000000(0000) GS:ffff88807dcc0000(0000) knlGS:0000000000000000
[   97.383813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   97.385449] CR2: 0000000000000000 CR3: 0000000002244000 CR4: 00000000000006b0
[   97.387347] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   97.389277] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   97.391196] Call Trace:
[   97.391967]  <TASK>
[   97.392647]  ? __warn+0xcc/0x180
[   97.393640]  ? kprobe_trace_self_tests_init+0x3f1/0x480
[   97.395181]  ? report_bug+0xbd/0x150
[   97.396234]  ? handle_bug+0x3e/0x60
[   97.397311]  ? exc_invalid_op+0x1a/0x50
[   97.398434]  ? asm_exc_invalid_op+0x1a/0x20
[   97.399652]  ? trace_kprobe_is_busy+0x20/0x20
[   97.400904]  ? tracing_reset_all_online_cpus+0x15/0x90
[   97.402304]  ? kprobe_trace_self_tests_init+0x3f1/0x480
[   97.403773]  ? init_kprobe_trace+0x50/0x50
[   97.404972]  do_one_initcall+0x112/0x240
[   97.406113]  do_initcall_level+0x95/0xb0
[   97.407286]  ? kernel_init+0x1a/0x1a0
[   97.408401]  do_initcalls+0x3f/0x70
[   97.409452]  kernel_init_freeable+0x16f/0x1e0
[   97.410662]  ? rest_init+0x1f0/0x1f0
[   97.411738]  kernel_init+0x1a/0x1a0
[   97.412788]  ret_from_fork+0x39/0x50
[   97.413817]  ? rest_init+0x1f0/0x1f0
[   97.414844]  ret_from_fork_asm+0x11/0x20
[   97.416285]  </TASK>
[   97.417134] irq event stamp: 13437323
[   97.418376] hardirqs last  enabled at (13437337): [<ffffffff8110bc0c>] console_unlock+0x11c/0x150
[   97.421285] hardirqs last disabled at (13437370): [<ffffffff8110bbf1>] console_unlock+0x101/0x150
[   97.423838] softirqs last  enabled at (13437366): [<ffffffff8108e17f>] handle_softirqs+0x23f/0x2a0
[   97.426450] softirqs last disabled at (13437393): [<ffffffff8108e346>] __irq_exit_rcu+0x66/0xd0
[   97.428850] ---[ end trace 0000000000000000 ]---

And also, since we can not cleanup dynamic_event file, ftracetest are
failed too.

To avoid these issues, build these tests only as modules.

Link: https://lore.kernel.org/all/171811263754.85078.5877446624311852525.stgit@devnote2/

Fixes: 9fe41efaca08 ("tracing: Add synth event generation test module")
Fixes: 64836248dda2 ("tracing: Add kprobe event command generation test module")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 29db703f68806..467975300ddd5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -824,7 +824,7 @@ config PREEMPTIRQ_DELAY_TEST
 
 config SYNTH_EVENT_GEN_TEST
 	tristate "Test module for in-kernel synthetic event generation"
-	depends on SYNTH_EVENTS
+	depends on SYNTH_EVENTS && m
 	help
           This option creates a test module to check the base
           functionality of in-kernel synthetic event definition and
@@ -837,7 +837,7 @@ config SYNTH_EVENT_GEN_TEST
 
 config KPROBE_EVENT_GEN_TEST
 	tristate "Test module for in-kernel kprobe event generation"
-	depends on KPROBE_EVENTS
+	depends on KPROBE_EVENTS && m
 	help
           This option creates a test module to check the base
           functionality of in-kernel kprobe event definition.
-- 
2.43.0



