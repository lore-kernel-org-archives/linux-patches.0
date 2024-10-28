Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D021DFFD;
	Mon, 28 Oct 2024 06:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097940; cv=none; b=IfzQmvd4UKr9zxxN+yPJ+uuqax6NC1MPfWwYhpNm16UFIa49lSu0CEPKEQrYf5xzj8suly1OklMCwlywHtKfj5i9ZVqmhrH6SgNfl/OkmnBmbmXPxcKndMs/Q8rZfO4THqy9O+9uQcIUtfK6fCZsJ8IcgQBPoDIPsubxssKNd78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097940; c=relaxed/simple;
	bh=m4DwvkyxeExhhvsLTj9hiPBRFBYqsFIHkD3ViVaKa2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqE30VCfSg8TA9YHEF1uROVYpBWKYe2pFvBoRW7CeI48C7mcp8ZBABq5tuGF5qREcY37kA07TKHDklxCY10pINJgpIm9Dl9CFX2Z9NneCsS2RHbMLx71qSNiA5mjvR6eULjMzRkINY8rXLMXV6l/lHf9hCHXNaqvrPi3rmaAzq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSCqOImi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSCqOImi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49526C4CEC3;
	Mon, 28 Oct 2024 06:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097940;
	bh=m4DwvkyxeExhhvsLTj9hiPBRFBYqsFIHkD3ViVaKa2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSCqOImi66Y4kuZdMqA55tGsJRAt79hV5sOFeZK70v8A/xI3idUZyl54WEF3ZUrcU
	 7AD+wDFJ5RpiYsTuiqNxY0qQxfknqUhI4q4Y6taWcTMSdxrXWo/7+VQ6M8deXr4de/
	 PLq4hxXXibzWNoLKs0nhm+N9nwdL6uUT0gB/5UkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 186/208] KVM: arm64: Fix shift-out-of-bounds bug
Date: Mon, 28 Oct 2024 07:26:06 +0100
Message-ID: <20241028062311.208631928@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

commit c6c167afa090ea0451f91814e1318755a8fb8bb9 upstream.

Fix a shift-out-of-bounds bug reported by UBSAN when running
VM with MTE enabled host kernel.

UBSAN: shift-out-of-bounds in arch/arm64/kvm/sys_regs.c:1988:14
shift exponent 33 is too large for 32-bit type 'int'
CPU: 26 UID: 0 PID: 7629 Comm: qemu-kvm Not tainted 6.12.0-rc2 #34
Hardware name: IEI NF5280R7/Mitchell MB, BIOS 00.00. 2024-10-12 09:28:54 10/14/2024
Call trace:
 dump_backtrace+0xa0/0x128
 show_stack+0x20/0x38
 dump_stack_lvl+0x74/0x90
 dump_stack+0x18/0x28
 __ubsan_handle_shift_out_of_bounds+0xf8/0x1e0
 reset_clidr+0x10c/0x1c8
 kvm_reset_sys_regs+0x50/0x1c8
 kvm_reset_vcpu+0xec/0x2b0
 __kvm_vcpu_set_target+0x84/0x158
 kvm_vcpu_set_target+0x138/0x168
 kvm_arch_vcpu_ioctl_vcpu_init+0x40/0x2b0
 kvm_arch_vcpu_ioctl+0x28c/0x4b8
 kvm_vcpu_ioctl+0x4bc/0x7a8
 __arm64_sys_ioctl+0xb4/0x100
 invoke_syscall+0x70/0x100
 el0_svc_common.constprop.0+0x48/0xf0
 do_el0_svc+0x24/0x38
 el0_svc+0x3c/0x158
 el0t_64_sync_handler+0x120/0x130
 el0t_64_sync+0x194/0x198

Fixes: 7af0c2534f4c ("KVM: arm64: Normalize cache configuration")
Cc: stable@vger.kernel.org
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20241017025701.67936-1-ilkka@os.amperecomputing.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1708,7 +1708,7 @@ static u64 reset_clidr(struct kvm_vcpu *
 	 * one cache line.
 	 */
 	if (kvm_has_mte(vcpu->kvm))
-		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
+		clidr |= 2ULL << CLIDR_TTYPE_SHIFT(loc);
 
 	__vcpu_sys_reg(vcpu, r->reg) = clidr;
 


