Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265EF51A15D;
	Wed, 30 Sep 2026 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789989; cv=none; b=opZPcda0xhT17gBIE5kV/POcFUQkaBAgmkgx0FFGXPrMhYvb1o4/4t3jRb35kKHwORIIgayrF8hwTJCCmMoxQGB31ETu5k0ZE0Cy27451VygnPAtoADasTy8bLv/Nq8es8hFjz+VAONYKta0vnNhaVDc37pv0JbWqniG3pQqzkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789989; c=relaxed/simple;
	bh=gxF4zqXfS0i+goBm1fWyh/8wQsIzeJ74jURD0Ykd71I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGOWQ4vh0ATPlJZksKT454LhCzwUWGulsGR2IuZpbX1TX/2mDYHmql50wg4srK/QVGqrwylubXeEi/Y1V02u1pgyqQCp10utlA8dtPHk0zDIxt/1cPo++wvic8nBQDReIb5KWDUZNpvhbIcYgQ6ZhHpk8zfcf5g+UCHdQhkK/QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xO3Qj211; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xO3Qj211"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C261F000FF;
	Wed, 30 Sep 2026 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789988;
	bh=LLlgXBAXAz+FtnsxyIXnrCEF4eyLJj2jwM2CkZMzy1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xO3Qj211Gld4PbEaI1E1YTF5o7LdqawfZqcEuAGnSBBn8TY8xgB0Tf4c7zWAFWbkf
	 TIk6tWx3oRdk1cm4dIFO4uVy+u/tRvZkJcB9lBGHB76HcJmJx5GIyQhVebtJyjXyGC
	 N77H5PjEQH03DTYxRSm4ITzaYRmZKG7xyw0Dp8OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 670/877] KVM: x86: Disallow EFER.LME and EFER.LMA if long mode is not supported
Date: Wed, 30 Sep 2026 17:26:21 +0200
Message-ID: <20260930152429.126417990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
[ adapted EFER changes to x86.c, placing the capability check in kvm_x86_vendor_init() because kvm_setup_efer_caps() is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -108,16 +108,8 @@ EXPORT_SYMBOL_GPL(kvm_host);
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
 
 static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 
@@ -9366,6 +9358,9 @@ int kvm_x86_vendor_init(struct kvm_x86_i
 	if (r != 0)
 		goto out_mmu_exit;
 
+	if (kvm_cpu_cap_has(X86_FEATURE_LM))
+		kvm_enable_efer_bits(EFER_LME | EFER_LMA);
+
 	kvm_ops_update(ops);
 
 	for_each_online_cpu(cpu) {


