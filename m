Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD10824A3;
	Mon, 28 Oct 2024 06:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098507; cv=none; b=t2r1BAdlscFZ86VDWAABJT6WnDyZKOoj1beNBDLMLvlM77PG4WhjKUWyIUTl+6+7y28a6LoPyYjFJpiJlDU6dFWEDhOrZpxfzm9tmNbB+URIWTXWPDV1NheiRwkNCTGiYHmtMsg0UnjoaVwzzmH5N6YWn/CUkqaIPtvU1YfO5FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098507; c=relaxed/simple;
	bh=FLH89bAsf3F1POgn74lv1tDhwfjbdqELHKv+j27Rv/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnaPzakNy8nqPp27+7JUva1xcyhuhrcKeyDiiMDQ86vwK9fugJuUQ0+J4E2OX/dSuC3xswkvLxYxDfVa80sL3RbYjj6HFrvOOG1+6oN6KQOfz9gU0+yynmlXabiXU+064J/z9DSCxipCxNXprQJr2XMmCPecg7XWJgwDuVXbN6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOM3g/k+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOM3g/k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01B8C4CEC3;
	Mon, 28 Oct 2024 06:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098507;
	bh=FLH89bAsf3F1POgn74lv1tDhwfjbdqELHKv+j27Rv/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOM3g/k+xakJD5+09ETR48WrSqUUTlrh5Wo+9dGWGbSywCdu8H4PyHxyE1xGgZEYY
	 LaLX1oJDKJaVjHvqkSwMJdOh9B2sabK8qqtleGHYkzbMD3TGvwQx1LtjYWDbyhDBzh
	 7e20UEpDNQ5t9d215n9k/6lJa3oyi6P0mNgk9GGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.11 220/261] KVM: arm64: Fix shift-out-of-bounds bug
Date: Mon, 28 Oct 2024 07:26:02 +0100
Message-ID: <20241028062317.621461783@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1977,7 +1977,7 @@ static u64 reset_clidr(struct kvm_vcpu *
 	 * one cache line.
 	 */
 	if (kvm_has_mte(vcpu->kvm))
-		clidr |= 2 << CLIDR_TTYPE_SHIFT(loc);
+		clidr |= 2ULL << CLIDR_TTYPE_SHIFT(loc);
 
 	__vcpu_sys_reg(vcpu, r->reg) = clidr;
 


