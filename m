Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF2475801;
	Mon,  4 May 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903413; cv=none; b=dqlPH2BuiAPwo2p3Lu1CavdbCJI72X+tHmWSkSuQRWYiX+CP24cNvbERbemh70PgB3eYCgJokHW0wzgVUKwzNNcJahZkOnCPkWPqMvy2pYN0H4H+sJja7UeXE8zZ+xRBpDqqXjV8wu3fIkljYtjg8CPmlhw6sHNL/cgJPuyEzWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903413; c=relaxed/simple;
	bh=U6dE/nQL52xioUi5vbr8Bi7n7r9GKpgz56SnTLyfINs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+81ALsH54fzyA/OfRstx5lRpsIEpci5dCchss+9gKoFAaKe6gJKKk/WUTzklkpr5rm7KjK2I/6DUFshoXYcP55S6RSzOct4jr9spzqYgbNWUAkKeBb+7+Vs6+hUN6wTcG1S6H0wO2HFqQHizCQ4OpArDMOW7rSY4RZrQB5VtR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iS4CDwy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iS4CDwy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E10FC2BCB8;
	Mon,  4 May 2026 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903413;
	bh=U6dE/nQL52xioUi5vbr8Bi7n7r9GKpgz56SnTLyfINs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iS4CDwy6yqBaomfpDyds7q93kcUchkYUXlIuFo/5PNL7r3CCHnFgg14YtfoKvXIHw
	 afJHVNvD1v7rkyvTRdHThuq4twHBnril7nKP1wIpix7EdeD/UbTEh+lULPirEhRCW/
	 e9wg6FMMQfkuG4Dk49JP8O4hu9lpzJ5wpcmWv+0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 224/307] KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
Date: Mon,  4 May 2026 15:51:49 +0200
Message-ID: <20260504135151.288542950@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -392,6 +392,10 @@ static bool __nested_vmcb_check_save(str
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
 		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
 			return false;
+
+		if (CC((save->cs.attrib & SVM_SELECTOR_L_MASK) &&
+		       (save->cs.attrib & SVM_SELECTOR_DB_MASK)))
+			return false;
 	}
 
 	/* Note, SVM doesn't have any additional restrictions on CR4. */
@@ -508,6 +512,8 @@ static void __nested_copy_vmcb_save_to_c
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
@@ -140,6 +140,7 @@ struct kvm_vmcb_info {
 };
 
 struct vmcb_save_area_cached {
+	struct vmcb_seg cs;
 	u64 efer;
 	u64 cr4;
 	u64 cr3;


