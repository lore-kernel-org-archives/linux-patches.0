Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147F0346A15;
	Tue,  6 Jan 2026 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719779; cv=none; b=pBnLQxtzHVP7C/IDGC5QSUUc6olrkVXjyKhkqJqqu3D3cCIv/HOSD6u6Fo2RH/2HIz3rcnW0N9gEUQEXtLcN1MdLV6PoCUnRm42Uh0LNQJ64j9YmoJ4MDHf+LsW5EN9QkmjcauLxVCj69acDcOBR8a+Az91x4sU9z9eAfInZwVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719779; c=relaxed/simple;
	bh=idQskkhpolMgsUehQOdHgcabVfmY/I3FW8ieraSX95g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDR9mKHFwJued0JmtNrJIdioQ+c1wKk1wwxrAf7b1uQkxiH5HmNQ2ibd3+PRcf/56eiRaPfPs1nECehSHg9AQRoEElz6U9FYIVRngJujkho7eqXfd1UUdUhOpP0Qj0MuiNo7fEVPD2/IXaEmVPyK5JD66dLa1dXAI+L7uyxy3Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTNBVr9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTNBVr9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73463C116C6;
	Tue,  6 Jan 2026 17:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719778;
	bh=idQskkhpolMgsUehQOdHgcabVfmY/I3FW8ieraSX95g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTNBVr9pKdIZ6Oy4jeIlujxhTBTOiw1pEnnbDivcv52JMh+lRuRUqSSpjTFsf4S7g
	 AaK4PXGUeF2u6uV49CZ07TMeK6HS+rYkQ1dUOV3FaW54V1xqcZfsg0++PYELHp5s+l
	 ua2sLxTLHVDCpwS4AG+BpOw5vGvhscEtVhrEHL7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	George Kennedy <george.kennedy@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/567] perf/x86/amd: Check event before enable to avoid GPF
Date: Tue,  6 Jan 2026 17:56:31 +0100
Message-ID: <20260106170451.687711386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b4a1a2576510e..36d28edf7a535 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -762,7 +762,12 @@ static void amd_pmu_enable_all(int added)
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



