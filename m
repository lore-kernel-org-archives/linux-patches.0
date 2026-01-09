Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2311946C8;
	Fri,  9 Jan 2026 12:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960158; cv=none; b=NNqZIyXnQiZmaGoR3NOfgBymdeajVV4S8Ck9CD3sQhfC3VK5t6zToGY4fG4nUo4g3GqZnjPziBosKPb5RASvXGglz9QsOs911Y4ACy0YEYAZ4EVpSiBRV7z5jt4bAr9UfVeOR+F/lGhzcepbu7mQAKJhXStbT8cBXbeWdsTznRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960158; c=relaxed/simple;
	bh=t0nfZyK4uLsKMLdV/Iy1qyhNpe2gLS208NjF9YykYp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMYMhXCnGFhwRXkQnWds/TOM9Xz47o085/1bCw0ZLwhY9hMLqI1tHiOCxVKM7SRjWSN6Ykgk68nh6a0Nsvmayu8znnEi2XRjpIWSKp2clRY5HsKQ/1qKr+ODcwo/5CwtMRSr7aLlFGiOe636ZCnzWbTDWLAi+jbCZZUQcpAWx8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5VbHEdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5VbHEdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4A9C4CEF1;
	Fri,  9 Jan 2026 12:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960158;
	bh=t0nfZyK4uLsKMLdV/Iy1qyhNpe2gLS208NjF9YykYp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5VbHEdP6ngqc08dU/Dgrxu9p85x+EFqghMQeHpC0+WCbBLCbwhlhrsvexlNta6Mq
	 kOtMMtr6o1+jnpO56sWrsYTAN+KPXnM82RilYUbic5IQush+pXttzI9692dSXoQ8wL
	 lxAxIacVfVw3htD818hai/Q2hoi+/Eo1M+ZL2VMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	George Kennedy <george.kennedy@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/737] perf/x86/amd: Check event before enable to avoid GPF
Date: Fri,  9 Jan 2026 12:37:24 +0100
Message-ID: <20260109112145.479378203@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 866cf36bfee4fba6a492d2dcc5133f857e3446b0 ]

On AMD machines cpuc->events[idx] can become NULL in a subtle race
condition with NMI->throttle->x86_pmu_stop().

Check event for NULL in amd_pmu_enable_all() before enable to avoid a GPF.
This appears to be an AMD only issue.

Syzkaller reported a GPF in amd_pmu_enable_all.

INFO: NMI handler (perf_event_nmi_handler) took too long to run: 13.143
    msecs
Oops: general protection fault, probably for non-canonical address
    0xdffffc0000000034: 0000  PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x00000000000001a0-0x00000000000001a7]
CPU: 0 UID: 0 PID: 328415 Comm: repro_36674776 Not tainted 6.12.0-rc1-syzk
RIP: 0010:x86_pmu_enable_event (arch/x86/events/perf_event.h:1195
    arch/x86/events/core.c:1430)
RSP: 0018:ffff888118009d60 EFLAGS: 00010012
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000034 RSI: 0000000000000000 RDI: 00000000000001a0
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: ffff88811802a440 R14: ffff88811802a240 R15: ffff8881132d8601
FS:  00007f097dfaa700(0000) GS:ffff888118000000(0000) GS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200001c0 CR3: 0000000103d56000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
amd_pmu_enable_all (arch/x86/events/amd/core.c:760 (discriminator 2))
x86_pmu_enable (arch/x86/events/core.c:1360)
event_sched_out (kernel/events/core.c:1191 kernel/events/core.c:1186
    kernel/events/core.c:2346)
__perf_remove_from_context (kernel/events/core.c:2435)
event_function (kernel/events/core.c:259)
remote_function (kernel/events/core.c:92 (discriminator 1)
    kernel/events/core.c:72 (discriminator 1))
__flush_smp_call_function_queue (./arch/x86/include/asm/jump_label.h:27
    ./include/linux/jump_label.h:207 ./include/trace/events/csd.h:64
    kernel/smp.c:135 kernel/smp.c:540)
__sysvec_call_function_single (./arch/x86/include/asm/jump_label.h:27
    ./include/linux/jump_label.h:207
    ./arch/x86/include/asm/trace/irq_vectors.h:99 arch/x86/kernel/smp.c:272)
sysvec_call_function_single (arch/x86/kernel/smp.c:266 (discriminator 47)
    arch/x86/kernel/smp.c:266 (discriminator 47))
 </IRQ>

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index aa8fc2cf1bde7..211f429750f5f 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -745,7 +745,12 @@ static void amd_pmu_enable_all(int added)
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
-		amd_pmu_enable_event(cpuc->events[idx]);
+		/*
+		 * FIXME: cpuc->events[idx] can become NULL in a subtle race
+		 * condition with NMI->throttle->x86_pmu_stop().
+		 */
+		if (cpuc->events[idx])
+			amd_pmu_enable_event(cpuc->events[idx]);
 	}
 }
 
-- 
2.51.0



