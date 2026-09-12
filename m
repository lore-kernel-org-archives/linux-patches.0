Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23244BEE54;
	Sat, 12 Sep 2026 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205862; cv=none; b=qVjGX2IJzkCsCMpJuEJXGn5iTr/Sv8LyYSS7rQIIUN+Do4JmtlYuhROerc8Syhm6QoRI4BFzIiDNCC2FKxSak/dFmzHDmVepQpYrTkl5JA4mNQIYBCML06oNqdhZMEZPrpvU2lvOIIiGQMwrb4qiTH0fkC2j8XXEFC6D/6jCpSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205862; c=relaxed/simple;
	bh=wFHm52lR3cjaIztp9HvyotyK3DMZG3a/k0Dq/M38ECM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1jJf8Nt5jhGea1DW6Bm0eru0xx1eHnFoiaQ8GKnayfLOtsSai/ct6HIe+HUtFQlpog59u6pAsPuObi06Z8/9DBbfeHziOWj611edfXABJisIBtn7xsthcaxRhoSwKdoyR12wltAsvcZiRscRyjqjuF0DpjbZF/av5qi9AnsqH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uy/7VyOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uy/7VyOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C561F000FF;
	Sat, 12 Sep 2026 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205860;
	bh=xlMlU+IxkC7IbQ7hBerhr3EPTl/mbMPnUyfpwTI22IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uy/7VyOfzberURn0+GsnVt7yrczqrNgNH+e+KGn+B01h2tK3XIeJsxCeRW5GzyTyJ
	 u/xgnwUbzLg3RTLNS9xDyfDiyvsF20/kmGzZ3RsQp0lxeOKYDdxG/454FnzcVKon6r
	 NcTTojCTOKD+DWwe5nTHyf7XESV1JPyGsTHB1rhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0086/1518] KVM: x86: Disallow EFER.LME and EFER.LMA if long mode is not supported
Date: Sat, 12 Sep 2026 08:37:35 +0200
Message-ID: <20260912065625.407653815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit e62392bf39ebfdf60d1d082799397fe1cbf8dfc5 ]

Remove EFER.LME and EFER.LMA from EFER reserved bits only if long mode
is actually supported. KVM does check long-mode support before allowing
the bits for guest writes and userspace writes through KVM_SET_SREGS*
(in __kvm_valid_efer()), but userspace writes through KVM_SET_MSRS only
check reserved bits.

In practice, this doesn't really matter. The true motiviation is getting
rid of the #ifdeffery when initializing efer_reserved_bits.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713181020.2735367-3-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ relocated hunks to x86.c and its kvm_x86_vendor_init() because msrs.c and kvm_setup_efer_caps() are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -106,16 +106,8 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_host)
 #define emul_to_vcpu(ctxt) \
 	((struct kvm_vcpu *)(ctxt)->vcpu)
 
-/* EFER defaults:
- * - enable syscall per default because its emulated by KVM
- * - enable LME and LMA per default on 64 bit KVM
- */
-#ifdef CONFIG_X86_64
-static
-u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
-#else
+/* Enable syscall by default because its emulated by KVM */
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
-#endif
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -10157,6 +10149,9 @@ int kvm_x86_vendor_init(struct kvm_x86_i
 	if (r != 0)
 		goto out_mmu_exit;
 
+	if (kvm_cpu_cap_has(X86_FEATURE_LM))
+		kvm_enable_efer_bits(EFER_LME | EFER_LMA);
+
 	enable_device_posted_irqs &= enable_apicv &&
 				     irq_remapping_cap(IRQ_POSTING_CAP);
 


