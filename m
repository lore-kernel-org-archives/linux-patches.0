Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FA020C00A;
	Fri, 17 Oct 2025 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715857; cv=none; b=WT8fd9zw25thrG/c/s/YEVgksx695JIyVXAY6uBujBB0ha/PiRUVWqcHZPCxAmdina4/t1nIppY6Jzl5lshCH1r0/ng87BNlBqZktiFufzEExCJa5DLuCgy/LYaYNT7yP0frDnB2hla0PhOrJhmAIo6QUyxU8pyJL+N0wOEbhQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715857; c=relaxed/simple;
	bh=xbtNezG51RR146oDMa1m0EmqIIkDcPcnNURFHymMh+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/jzPRGQpj1igQpNgnLeecKGGVPukHAwKjNbbr2UB6tjJ8jOJWb8Zchk1TjU8nQj2SIZLcdB9qIBuHsgRCDTjwpZbGG+vc3mB0djDB/nDK8iBzJgrjWOOehQSnrFdo+MwFlVrr7dkI4T9xfKsjxc725uwqi4gJXEHfOHboDj9vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFUUCmFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFUUCmFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBBBC4CEE7;
	Fri, 17 Oct 2025 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715857;
	bh=xbtNezG51RR146oDMa1m0EmqIIkDcPcnNURFHymMh+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFUUCmFvZ7Rr8SYmpw1omGO4JabSyKh9Lff5QCwwxieESO/3s8Lc/Jct2OWc+WiOx
	 jEv4MbOQHwXcP3cTGMOku1blDmzUSz1lePwt1U+XhUVS4bZ1RMUKQ3bloq5/V+IS89
	 zq7N6gS0+RL9Fj6cB3UkSl4N3m/63RZlDoAJHt2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gaoxiang17 <gaoxiang17@xiaomi.com>,
	Baoquan He <bhe@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 361/371] pid: Add a judgment for ns null in pid_nr_ns
Date: Fri, 17 Oct 2025 16:55:36 +0200
Message-ID: <20251017145215.150977965@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gaoxiang17 <gaoxiang17@xiaomi.com>

[ Upstream commit 006568ab4c5ca2309ceb36fa553e390b4aa9c0c7 ]

__task_pid_nr_ns
        ns = task_active_pid_ns(current);
        pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
                if (pid && ns->level <= pid->level) {

Sometimes null is returned for task_active_pid_ns. Then it will trigger kernel panic in pid_nr_ns.

For example:
	Unable to handle kernel NULL pointer dereference at virtual address 0000000000000058
	Mem abort info:
	ESR = 0x0000000096000007
	EC = 0x25: DABT (current EL), IL = 32 bits
	SET = 0, FnV = 0
	EA = 0, S1PTW = 0
	FSC = 0x07: level 3 translation fault
	Data abort info:
	ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
	CM = 0, WnR = 0, TnD = 0, TagAccess = 0
	GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
	user pgtable: 4k pages, 39-bit VAs, pgdp=00000002175aa000
	[0000000000000058] pgd=08000002175ab003, p4d=08000002175ab003, pud=08000002175ab003, pmd=08000002175be003, pte=0000000000000000
	pstate: 834000c5 (Nzcv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
	pc : __task_pid_nr_ns+0x74/0xd0
	lr : __task_pid_nr_ns+0x24/0xd0
	sp : ffffffc08001bd10
	x29: ffffffc08001bd10 x28: ffffffd4422b2000 x27: 0000000000000001
	x26: ffffffd442821168 x25: ffffffd442821000 x24: 00000f89492eab31
	x23: 00000000000000c0 x22: ffffff806f5693c0 x21: ffffff806f5693c0
	x20: 0000000000000001 x19: 0000000000000000 x18: 0000000000000000
	x17: 00000000529c6ef0 x16: 00000000529c6ef0 x15: 00000000023a1adc
	x14: 0000000000000003 x13: 00000000007ef6d8 x12: 001167c391c78800
	x11: 00ffffffffffffff x10: 0000000000000000 x9 : 0000000000000001
	x8 : ffffff80816fa3c0 x7 : 0000000000000000 x6 : 49534d702d535449
	x5 : ffffffc080c4c2c0 x4 : ffffffd43ee128c8 x3 : ffffffd43ee124dc
	x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffffff806f5693c0
	Call trace:
	__task_pid_nr_ns+0x74/0xd0
	...
	__handle_irq_event_percpu+0xd4/0x284
	handle_irq_event+0x48/0xb0
	handle_fasteoi_irq+0x160/0x2d8
	generic_handle_domain_irq+0x44/0x60
	gic_handle_irq+0x4c/0x114
	call_on_irq_stack+0x3c/0x74
	do_interrupt_handler+0x4c/0x84
	el1_interrupt+0x34/0x58
	el1h_64_irq_handler+0x18/0x24
	el1h_64_irq+0x68/0x6c
	account_kernel_stack+0x60/0x144
	exit_task_stack_account+0x1c/0x80
	do_exit+0x7e4/0xaf8
	...
	get_signal+0x7bc/0x8d8
	do_notify_resume+0x128/0x828
	el0_svc+0x6c/0x70
	el0t_64_sync_handler+0x68/0xbc
	el0t_64_sync+0x1a8/0x1ac
	Code: 35fffe54 911a02a8 f9400108 b4000128 (b9405a69)
	---[ end trace 0000000000000000 ]---
	Kernel panic - not syncing: Oops: Fatal exception in interrupt

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Link: https://lore.kernel.org/20250802022123.3536934-1-gxxa03070307@gmail.com
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/pid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index d94ce02505012..296cd04c24bae 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -491,7 +491,7 @@ pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
 	struct upid *upid;
 	pid_t nr = 0;
 
-	if (pid && ns->level <= pid->level) {
+	if (pid && ns && ns->level <= pid->level) {
 		upid = &pid->numbers[ns->level];
 		if (upid->ns == ns)
 			nr = upid->nr;
-- 
2.51.0



