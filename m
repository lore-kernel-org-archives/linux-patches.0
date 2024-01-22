Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CEF59B72;
	Tue, 23 Jan 2024 00:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969808; cv=none; b=cBEvDoJMYMTdL8nS2RKQNjVaB7qqCImolo+b60GGzxYmIwpvSoS+CGYxc08qOVIE9f7Mx9KTiq2WQJMkSzlIXr87ayQ0I0JZqjM1GHHKDrT7F2l2e1eQC7wKaBLP1dHg5/3ANmsGwkyA+ArGQUyzF+4m+T05VwWqm8A2IY2nDuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969808; c=relaxed/simple;
	bh=QSkMfCFYnnIUwzr4f9d5QhxDyYyeHC6tx+8+OdMkvBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7KWmFYtktmxJVhsACBO1I9X10nr8yXLOeGI6H4xoKFHprj22d82MuJOc0IudvRV8v1BzuxV8d+Aragx63mZpUVidbLFJ0w7iZicwIj1d5NI6IGicN5bMH7RJmdTl4eyag/yu5gviYvEVhuWsdPG18eMg6xoGnV3chyRCC3ZgTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykRQObfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykRQObfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777CEC433C7;
	Tue, 23 Jan 2024 00:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969808;
	bh=QSkMfCFYnnIUwzr4f9d5QhxDyYyeHC6tx+8+OdMkvBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykRQObfUprA06ta7hJC7sfpBrXL7aCmX2LC8HtZg4eJeH4Hc1mrPgI3F7f4fgKplV
	 lSwEU4HnJyCiPvSdzoEBssNj/gwvi7YDe6E+VPg12RkqoZnZBv8iM77Zbti8YSG2ik
	 23bixkdeFp6e94gIrw09SwOT/MWOsuVJtbGUdZqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Sterz <s.sterz@proxmox.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.7 463/641] Revert "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
Date: Mon, 22 Jan 2024 15:56:07 -0800
Message-ID: <20240122235832.528055551@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit a484755ab2526ebdbe042397cdd6e427eb4b1a68 upstream.

Revert KVM's made-up consistency check on SVM's TLB control.  The APM says
that unsupported encodings are reserved, but the APM doesn't state that
VMRUN checks for a supported encoding.  Unless something is called out
in "Canonicalization and Consistency Checks" or listed as MBZ (Must Be
Zero), AMD behavior is typically to let software shoot itself in the foot.

This reverts commit 174a921b6975ef959dd82ee9e8844067a62e3ec1.

Fixes: 174a921b6975 ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB")
Reported-by: Stefan Sterz <s.sterz@proxmox.com>
Closes: https://lkml.kernel.org/r/b9915c9c-4cf6-051a-2d91-44cc6380f455%40proxmox.com
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20231018194104.1896415-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -247,18 +247,6 @@ static bool nested_svm_check_bitmap_pa(s
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
-static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
-{
-	/* Nested FLUSHBYASID is not supported yet.  */
-	switch(tlb_ctl) {
-		case TLB_CONTROL_DO_NOTHING:
-		case TLB_CONTROL_FLUSH_ALL_ASID:
-			return true;
-		default:
-			return false;
-	}
-}
-
 static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *control)
 {
@@ -278,9 +266,6 @@ static bool __nested_vmcb_check_controls
 					   IOPM_SIZE)))
 		return false;
 
-	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
-		return false;
-
 	if (CC((control->int_ctl & V_NMI_ENABLE_MASK) &&
 	       !vmcb12_is_intercept(control, INTERCEPT_NMI))) {
 		return false;


