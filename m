Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183722FE18;
	Mon, 10 Mar 2025 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628279; cv=none; b=cX547YPwSSBRMxl4xAwbzjbwWnldk9dh0T2rfJErulU6wtQYlbI+D29e8zqK5SNBJRMyhvXfpvW1XJoBco3mOEnUZ4kAwfqcAaAq7WmQozpzWEx+iO4XCpTJM3W7pUrK7A+saYkIdrjV+DafCWb7v5BmxGVArDBNtbOh3jpBhy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628279; c=relaxed/simple;
	bh=6hJOoEhnweOuYOm69KbOwxy1chCQr3K2ed/K/NfQgb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txsWYpZ6Vhjh0chd7MdOJuz5Ze9EHh0SafuO2b35HZ1PsdX5NKqaaSOifmEzvPffQx7+uae7QqAYSj+OOHJKNoTVp23f8cL1QnXTex9CKjZj020N5l+fJ3iji5D89Xryoc4mJDTmP+2PXTShOvKsMHrkRhNhTlBPSHzTtBfgnGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A47lc5G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A47lc5G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CD0C4CEF0;
	Mon, 10 Mar 2025 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628279;
	bh=6hJOoEhnweOuYOm69KbOwxy1chCQr3K2ed/K/NfQgb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A47lc5G8zSeBCDA2lhQjMjAOM5om/Tte7y1nuPemP8mLiRKr+/O4gQAYe5oZAKQuU
	 4O3EKe2AGwoOQq5D1l2lG1cw1GBNp1f7viNiDGAoKFSpVurSyrVYv7HiyazZ4pXyJN
	 0bDlz2kfrJVVDOXIJmOcZIaR1Db3+b59qoE5fB6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Makarov <maxpain@linux.com>,
	Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Simon <simon@swine.de>
Subject: [PATCH 6.6 138/145] uprobes: Fix race in uprobe_free_utask
Date: Mon, 10 Mar 2025 18:07:12 +0100
Message-ID: <20250310170440.325783638@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit b583ef82b671c9a752fbe3e95bd4c1c51eab764d upstream.

Max Makarov reported kernel panic [1] in perf user callchain code.

The reason for that is the race between uprobe_free_utask and bpf
profiler code doing the perf user stack unwind and is triggered
within uprobe_free_utask function:
  - after current->utask is freed and
  - before current->utask is set to NULL

 general protection fault, probably for non-canonical address 0x9e759c37ee555c76: 0000 [#1] SMP PTI
 RIP: 0010:is_uprobe_at_func_entry+0x28/0x80
 ...
  ? die_addr+0x36/0x90
  ? exc_general_protection+0x217/0x420
  ? asm_exc_general_protection+0x26/0x30
  ? is_uprobe_at_func_entry+0x28/0x80
  perf_callchain_user+0x20a/0x360
  get_perf_callchain+0x147/0x1d0
  bpf_get_stackid+0x60/0x90
  bpf_prog_9aac297fb833e2f5_do_perf_event+0x434/0x53b
  ? __smp_call_single_queue+0xad/0x120
  bpf_overflow_handler+0x75/0x110
  ...
  asm_sysvec_apic_timer_interrupt+0x1a/0x20
 RIP: 0010:__kmem_cache_free+0x1cb/0x350
 ...
  ? uprobe_free_utask+0x62/0x80
  ? acct_collect+0x4c/0x220
  uprobe_free_utask+0x62/0x80
  mm_release+0x12/0xb0
  do_exit+0x26b/0xaa0
  __x64_sys_exit+0x1b/0x20
  do_syscall_64+0x5a/0x80

It can be easily reproduced by running following commands in
separate terminals:

  # while :; do bpftrace -e 'uprobe:/bin/ls:_start  { printf("hit\n"); }' -c ls; done
  # bpftrace -e 'profile:hz:100000 { @[ustack()] = count(); }'

Fixing this by making sure current->utask pointer is set to NULL
before we start to release the utask object.

[1] https://github.com/grafana/pyroscope/issues/3673

Fixes: cfa7f3d2c526 ("perf,x86: avoid missing caller address in stack traces captured in uprobe")
Reported-by: Max Makarov <maxpain@linux.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20250109141440.2692173-1-jolsa@kernel.org
[Christian Simon: Rebased for 6.12.y, due to mainline change https://lore.kernel.org/all/20240929144239.GA9475@redhat.com/]
Signed-off-by: Christian Simon <simon@swine.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1721,6 +1721,7 @@ void uprobe_free_utask(struct task_struc
 	if (!utask)
 		return;
 
+	t->utask = NULL;
 	if (utask->active_uprobe)
 		put_uprobe(utask->active_uprobe);
 
@@ -1730,7 +1731,6 @@ void uprobe_free_utask(struct task_struc
 
 	xol_free_insn_slot(t);
 	kfree(utask);
-	t->utask = NULL;
 }
 
 /*


