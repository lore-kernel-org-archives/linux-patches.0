Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25884227EA8;
	Tue, 26 Aug 2025 13:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215115; cv=none; b=ea2YH6mwnuQhnIE8YS5CM0OHlI+uIH7PhAp1zHic3kiKukwP8TdnnmWoqEDPnwsqLt3zjGVzg/6INylZ08sb1+9AOhit84eyZ54LnjEqKCjWs9jeGXmZBJA19YdCOkm3yYMfjTDijUGOa9Bhhq+5T8m5chxdSZHcHy3FA8JgtXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215115; c=relaxed/simple;
	bh=BNnK53uPRK+y6Ogr0SsL6W3MPNd+3DzY3I0kY5gQt/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reLD/aOndWQt61bLR8S2r3WC3F6Kxa5/mcQ6O+ix4UvfH3xiSJLQ471zfp4dMd5ibRwPX4TeHCZpLVwutp1buqCSD4k5zIWRNaoXaHzlQoC9/y+LhL7WUJ/ATOSk0IYU7F8w/+Vg2oB4H1B5cnr6wP3JQSv9mztoNcH18NOrWOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xlqjffOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xlqjffOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D56C4CEF1;
	Tue, 26 Aug 2025 13:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215115;
	bh=BNnK53uPRK+y6Ogr0SsL6W3MPNd+3DzY3I0kY5gQt/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xlqjffODvAoNlO5vCBMv9Z03j+UIxoOhLsZyXmVOTUsj3nbyOXvN3nx5u49aeMzcV
	 trkA7Y9PbTxSuh80F+vwAIBvqwG75rEjfU/uEGV0iHuMuUPzM7+QrJxKDC+fOWWiOE
	 Ez6pqizIuB9w7xwdB2ZydbLSRagFH4cCI/0Z5WIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 393/482] KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix
Date: Tue, 26 Aug 2025 13:10:46 +0200
Message-ID: <20250826110940.538650326@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

Upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally save+flush
host FPSIMD/SVE/SME state") relies on interrupts being disabled during
fpsimd_save_and_flush_cpu_state() so that a softirq cannot be taken
while the host floating point context is being saved and potentially try
to use kernel-mode NEON.

Unfortunately, stable kernels without 9b19700e623f ("arm64: fpsimd: Drop
unneeded 'busy' flag") leave interrupts enabled in
fpsimd_save_and_flush_cpu_state() and so the BUG_ON(!may_use_simd()) in
kernel_neon_begin() has been observed to trigger in real-world usage:

 |  kernel BUG at arch/arm64/kernel/fpsimd.c:1904!
 |  Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
 |
 |  Call trace:
 |   kernel_neon_begin+0xdc/0x12c
 |   ...
 |   crypto_aead_decrypt+0x5c/0x6c
 |   seqiv_aead_decrypt+0x88/0x9c
 |   crypto_aead_decrypt+0x5c/0x6c
 |   esp_input+0x280/0x364
 |   xfrm_input+0x6ac/0x16f8
 |   ...
 |   net_rx_action+0x13c/0x31c
 |   handle_softirqs+0x124/0x3d0
 |   __do_softirq+0x14/0x20
 |   ____do_softirq+0x10/0x20
 |   call_on_irq_stack+0x3c/0x74
 |   do_softirq_own_stack+0x1c/0x2c
 |   __irq_exit_rcu+0x54/0xb4
 |   irq_exit_rcu+0x10/0x1c
 |   el1_interrupt+0x38/0x58
 |   el1h_64_irq_handler+0x18/0x24
 |   el1h_64_irq+0x68/0x6c
 |   fpsimd_save+0xe4/0x130
 |   kvm_arch_vcpu_load_fp+0x2c/0x58
 |   kvm_arch_vcpu_load+0x88/0x26c
 |   kvm_sched_in+0x2c/0x3c

Given that 9b19700e623f ("arm64: fpsimd: Drop unneeded 'busy' flag") is
not a fix in its own right, has non-trivial dependencies and is a
reasonably invasive change to the in-kernel use of fpsimd, opt instead
for a simple fix to use the softirq-safe {get,put}_cpu_fpsimd_context()
helpers in fpsimd_save_and_flush_cpu_state().

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.y, 6.1.y and 6.6.y
Fixes: 806d5c1e1d2e ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state") # 6.6.y
Fixes: 04c50cc23a49 ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state") # 6.1.y
Fixes: 5289ac43b69c ("KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state") # 5.15.y
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1851,10 +1851,10 @@ void fpsimd_save_and_flush_cpu_state(voi
 	if (!system_supports_fpsimd())
 		return;
 	WARN_ON(preemptible());
-	__get_cpu_fpsimd_context();
+	get_cpu_fpsimd_context();
 	fpsimd_save();
 	fpsimd_flush_cpu_state();
-	__put_cpu_fpsimd_context();
+	put_cpu_fpsimd_context();
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON


