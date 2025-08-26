Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D41C352091;
	Tue, 26 Aug 2025 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216845; cv=none; b=VC9KgggfheU7NAWQWpi8NZBvF+g4zb00fllS5p6AOPi06VolIuLs4v9H77dUOYOfhM8nuXkE5P/ytmiUDKXLgbJsRrWXjUHWTkdbdNRKXsVuo/v1Sr4TkmOvvOQU/MKduQO9ydw2AyfSY/0aDna5FfpQdBN0mut4n3ZR6fQqNAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216845; c=relaxed/simple;
	bh=V/hPTiwurgozOMoxEqB/PmOEKYCTPVAeJw89J5JXCEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnSpKy4YV9eZrh38IN7Dr7zMndR6xHv3tZ6Q26XCiFCiRMII83piq4zqhQ6XrhnVsfQfOctzN0CbF/onoODeN4mnj5Td3/aSwx/35GdSy1m4phLzLbDKx7B3w2xFSFXyFU3Jbp+wnaXz7/5xurund6BGL3+nme+AhGPX5MD+OUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MP7ppqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MP7ppqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3338C4CEF1;
	Tue, 26 Aug 2025 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216845;
	bh=V/hPTiwurgozOMoxEqB/PmOEKYCTPVAeJw89J5JXCEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MP7ppqCT/VI/ZMExYVJo7mEb2YpD8xA8ZLPj5/xz1D87FzNCdHYYbWtvHExJvPVH
	 11gLcjK9VecmO6sAU5QbAxv6/XMkOOo1D0yZsiiODHeCiy/gGhlq2c0pp0K4olrrCm
	 zaviDDbPwYfHojnaVfhO0mHC+NDicvRr/akBjcWk=
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
Subject: [PATCH 5.15 563/644] KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix
Date: Tue, 26 Aug 2025 13:10:54 +0200
Message-ID: <20250826111000.481457567@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1303,10 +1303,10 @@ void fpsimd_save_and_flush_cpu_state(voi
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


