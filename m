Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226630AAD0;
	Mon, 13 Oct 2025 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366899; cv=none; b=aPxbU5XLCkOsNNXYDlfnXJfMfxvKKdOdII+burwSVlECZaela74H2gISrwbl54DuZegkKCySmHJpbaazi6cYkgYZhdbd+LJcVgDhuq2xpL5a1yXTKnvYHq7KTTNZxnhT9hFo+W3waI4R6zozhe9HLCI/BXn7wqtG2BexbTPBrRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366899; c=relaxed/simple;
	bh=rrKltuquGOmoWYP1FrTr89lqU6jMHxBK+dgE1JcpVgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBRykszVkxjIDLQy5JQMHHiRkM4c1J+rrUzevMtZAOdWMikT+aQy3hg7aaHn3GqV0YQmbDHCad6x0lkbkBuR9W8Y8OMd1hJr2y2b0lqrtaRZLvkg2CMC6RFsBmg+8aPREBCzuIDSZZkyQoqbu0T0PrNUWXGvZOKPuGWn2rhEx6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ye5OIYl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ye5OIYl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B880C4CEE7;
	Mon, 13 Oct 2025 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366899;
	bh=rrKltuquGOmoWYP1FrTr89lqU6jMHxBK+dgE1JcpVgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ye5OIYl1uhBmfJUhL8DnCOl+5n8ISak3k/mr3Bg5GBun9oBryRBLuvmOTT8GFIFss
	 GK0xUxDtxVcIpYefj545GDRF2STF1zZf3ldRdLSyhRp9oppipJgkEEeTiqcsLnuZzd
	 1+c4O7rkiAm0dyfoiz7v01+jVPQr8vQS9WIzF3QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Kenneth Van Alstyne <kvanals@kvanals.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 015/196] KVM: arm64: Fix softirq masking in FPSIMD register saving sequence
Date: Mon, 13 Oct 2025 16:43:08 +0200
Message-ID: <20251013144315.116824412@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

Stable commit 8f4dc4e54eed ("KVM: arm64: Fix kernel BUG() due to bad
backport of FPSIMD/SVE/SME fix") fixed a kernel BUG() caused by a bad
backport of upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally
save+flush host FPSIMD/SVE/SME state") by ensuring that softirqs are
disabled/enabled across the fpsimd register save operation.

Unfortunately, although this fixes the original issue, it can now lead
to deadlock when re-enabling softirqs causes pending softirqs to be
handled with locks already held:

 | BUG: spinlock recursion on CPU#7, CPU 3/KVM/57616
 |  lock: 0xffff3045ef850240, .magic: dead4ead, .owner: CPU 3/KVM/57616, .owner_cpu: 7
 | CPU: 7 PID: 57616 Comm: CPU 3/KVM Tainted: G           O       6.1.152 #1
 | Hardware name: SoftIron SoftIron Platform Mainboard/SoftIron Platform Mainboard, BIOS 1.31 May 11 2023
 | Call trace:
 |  dump_backtrace+0xe4/0x110
 |  show_stack+0x20/0x30
 |  dump_stack_lvl+0x6c/0x88
 |  dump_stack+0x18/0x34
 |  spin_dump+0x98/0xac
 |  do_raw_spin_lock+0x70/0x128
 |  _raw_spin_lock+0x18/0x28
 |  raw_spin_rq_lock_nested+0x18/0x28
 |  update_blocked_averages+0x70/0x550
 |  run_rebalance_domains+0x50/0x70
 |  handle_softirqs+0x198/0x328
 |  __do_softirq+0x1c/0x28
 |  ____do_softirq+0x18/0x28
 |  call_on_irq_stack+0x30/0x48
 |  do_softirq_own_stack+0x24/0x30
 |  do_softirq+0x74/0x90
 |  __local_bh_enable_ip+0x64/0x80
 |  fpsimd_save_and_flush_cpu_state+0x5c/0x68
 |  kvm_arch_vcpu_put_fp+0x4c/0x88
 |  kvm_arch_vcpu_put+0x28/0x88
 |  kvm_sched_out+0x38/0x58
 |  __schedule+0x55c/0x6c8
 |  schedule+0x60/0xa8

Take a tiny step towards the upstream fix in 9b19700e623f ("arm64:
fpsimd: Drop unneeded 'busy' flag") by additionally disabling hardirqs
while saving the fpsimd registers.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: <stable@vger.kernel.org> # 6.1.y
Fixes: 8f4dc4e54eed ("KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix")
Reported-by: Kenneth Van Alstyne <kvanals@kvanals.org>
Link: https://lore.kernel.org/r/010001999bae0958-4d80d25d-8dda-4006-a6b9-798f3e774f6c-000000@email.amazonses.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1848,13 +1848,17 @@ static void fpsimd_flush_cpu_state(void)
  */
 void fpsimd_save_and_flush_cpu_state(void)
 {
+	unsigned long flags;
+
 	if (!system_supports_fpsimd())
 		return;
 	WARN_ON(preemptible());
-	get_cpu_fpsimd_context();
+	local_irq_save(flags);
+	__get_cpu_fpsimd_context();
 	fpsimd_save();
 	fpsimd_flush_cpu_state();
-	put_cpu_fpsimd_context();
+	__put_cpu_fpsimd_context();
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON


