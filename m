Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3020332EA7;
	Sat, 30 May 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160087; cv=none; b=YxoLgw6nWOOinzp3Yh0dFtFeXknBi/4tjJfpHAtbF2nhEh2Utp/fLn1NhXOpEwSM5Grqvi7wdXWRymnvXpSxYPD5hxK6nyGzauaB72HgDADbXbOIfS8btofFwi7HRkhnwdviVCwTWQ3OfMRh1enZ79dKaF2Dh8SFgkWIDHJr3L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160087; c=relaxed/simple;
	bh=SRQGW1ks4ya5/UULyaNVNMDip9NBlac0b++z1XqzY5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JW/kXNLblwiz1Rx8TOVhP7ZJGgk49sPhLNJsMvhq/D7n8I3kyUUTmUQ2h+gUEyY0vECln6LH7fg3q3o+dVHDqfh5/SMBxEVyKdEM7nm4SitFLnK5OeT21Gxvz7+nHcgXBc74EYWnYnuyGf8cXEc/ER3feNRU1kPg+92vTm/s6Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUcMzz1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUcMzz1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA4A1F00893;
	Sat, 30 May 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160086;
	bh=CzZ14+zKPFmYqIqKkM9ChBT1ew4mJrEw0T8Ujf7/CXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUcMzz1lT2aHFvXUi20OgnFo9h4ATmgBm7HXfjAqTQF7ewcxyb6qgzQTnBCWzJ2UX
	 Ra9HcBcF3mXR3TwjADMLURHAlQ3xAMoL7bBqmf4OJSWWwJRwHUUK6vVlM+2RoM5Pnu
	 L8PfNdKVSzm75EVSz/bhaNfqNKcOkT7TOjEbG/WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 242/969] KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
Date: Sat, 30 May 2026 17:56:06 +0200
Message-ID: <20260530160307.143764787@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 96bd3e76a171a8e21a6387e54e4c420a81968492 upstream.

According to the APM Volume #2, 15.5, Canonicalization and Consistency
Checks (24593—Rev. 3.42—March 2024), the following condition (among
others) results in a #VMEXIT with VMEXIT_INVALID (aka SVM_EXIT_ERR):

  EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.

In the list of consistency checks done when EFER.LME and CR0.PG are set,
add a check that CS.L and CS.D are not both set, after the existing
check that CR4.PAE is set.

This is functionally a nop because the nested VMRUN results in
SVM_EXIT_ERR in HW, which is forwarded to L1, but KVM makes all
consistency checks before a VMRUN is actually attempted.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260303003421.2185681-17-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    6 ++++++
 arch/x86/kvm/svm/svm.h    |    1 +
 2 files changed, 7 insertions(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -292,6 +292,10 @@ static bool __nested_vmcb_check_save(str
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
 		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
 			return false;
+
+		if (CC((save->cs.attrib & SVM_SELECTOR_L_MASK) &&
+		       (save->cs.attrib & SVM_SELECTOR_DB_MASK)))
+			return false;
 	}
 
 	/* Note, SVM doesn't have any additional restrictions on CR4. */
@@ -378,6 +382,8 @@ static void __nested_copy_vmcb_save_to_c
 	 * Copy only fields that are validated, as we need them
 	 * to avoid TOC/TOU races.
 	 */
+	to->cs = from->cs;
+
 	to->efer = from->efer;
 	to->cr0 = from->cr0;
 	to->cr3 = from->cr3;
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -118,6 +118,7 @@ struct kvm_vmcb_info {
 };
 
 struct vmcb_save_area_cached {
+	struct vmcb_seg cs;
 	u64 efer;
 	u64 cr4;
 	u64 cr3;


