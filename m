Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924E33D9DDB;
	Fri,  9 Oct 2026 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557197; cv=none; b=FbnLOhIZ+seYmaCyCe5nkR3OiaawCMZ/4FtSdXOB/V1iLGnyd/a61Cyn8uOZ+Zde2xDOg9gZFD12RhVJr3AT5HIbwSd50/3DF0io+iFjMxyMqQzFYdrq38zkA4XXfutF8EdkFTWykjmWy7SPBK90p6tK2uRCRb4mNU8iPCPpULI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557197; c=relaxed/simple;
	bh=FhcMfPgIXALcg3bvBoXBrHOc+DocVDn/wVZteg1QEKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiShJOlcjRk6FZBPnnGCVXdVZBMk+adZ02V9PikdQ+TFDa4wj5anLceXhQHXSGxUpkZclE62g89f9zIvNDsNd/6kFfmiI/Pp8KiOGA78iMMwvzZ9wM8Q59dR72MmyfYv6sn/Wet/eEuDGaiyBgOko0eXIbweMoiKdId9JCUMDX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsbvB2bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsbvB2bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF661F000FF;
	Fri,  9 Oct 2026 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557195;
	bh=L200fJw9Uij14hxeGX9yGgms09ZxRFgE4RH5HyTvKlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsbvB2bvF8qlYIlFRRgXMvA2EsOmCCS6Xd7SSZOdQNmI20GWTXO6f25/qof5PjznK
	 mV3oHPsZt1eCKq5VI2oVGJb3zrK/+9xjsj53lGvcu5fybTxquMFaqbSDv2L+OYWKoT
	 lGAGORMdJ1fHqHM16JuNWbPTIG/K56ahNj79/+HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 317/428] KVM: SVM: Update control fields on #VMEXIT if and only if VMRUN succeeded
Date: Fri,  9 Oct 2026 16:10:54 +0200
Message-ID: <20261009140953.090138651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit e27fc915c8f575ab5630e27d97465c2077d4b9d1 upstream.

Leave control.erap_ctl and control.clean as-is in the VMCS if VMRUN fails,
because as per AMD:

  there's no explicit architectural guarantee about the behavior in the
  presence of VMRUN failures. So the best thing to do would be to assume
  that if VMRUN fails, the actions requested in the control fields may not
  have been performed.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260904170642.3291466-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4615,16 +4615,16 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 	if (!svm_is_vmrun_failure(svm->vmcb->control.exit_code)) {
 		this_cpu_ptr(&svm_data)->flush_all_asids = false;
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
-	}
 
-	/*
-	 * Unconditionally mask off the CLEAR_RAP bit, the AND is just as cheap
-	 * as the TEST+Jcc to avoid it.
-	 */
-	if (cpu_feature_enabled(X86_FEATURE_ERAPS))
-		svm->vmcb->control.erap_ctl &= ~ERAP_CONTROL_CLEAR_RAP;
+		/*
+		 * Unconditionally mask off the CLEAR_RAP bit, the AND is just
+		 * as cheap as the TEST+Jcc to avoid it.
+		 */
+		if (cpu_feature_enabled(X86_FEATURE_ERAPS))
+			svm->vmcb->control.erap_ctl &= ~ERAP_CONTROL_CLEAR_RAP;
 
-	vmcb_mark_all_clean(svm->vmcb);
+		vmcb_mark_all_clean(svm->vmcb);
+	}
 
 	/* if exit due to PF check for async PF */
 	if (svm->vmcb->control.exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR)


