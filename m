Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E49622301;
	Thu, 16 Jul 2026 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210152; cv=none; b=I4M2p2V4xE4TKu2VSkYrxNf1eb80z7A9zat2gXEGkzvgg6QxoBcmFGY+LSIpozux4nklQ5yDEsGs4aYTvNykf/6fG7gxnUp8IWGxZQdRORO+OggNQY250Z5O/BkVSkCdxlgfZfGBf5APenIspLCfi12h1vWbziCvqEtOTQtowjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210152; c=relaxed/simple;
	bh=ETqP3/O4OTxcq+1u4jLoclEiab3r7bHRjKEI2b+7T64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVMJH7dcZy2wjFR35DB0oWq8+jn7kPUoDQNkEQuDxfgKG5tU4Q3WHA5Nqq3h6DovMfly43D8cINnr6SKOuXJYOwOoYjfL7hmWKmpjE+PlqfKHNpmCK1VuHII7/BtXXHU2uh50c5QtRtC6nPrDLu+fXzJgAPHprhC2Z3uTEGkyN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDK7QRT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDK7QRT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF8F1F000E9;
	Thu, 16 Jul 2026 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210151;
	bh=73537JJahrzv/Tq/5VPfFlN8bLJ/U/whxsD/FxqIC7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDK7QRT1KWzs+owSptKn/s7oF448Qss94nCb2vND/xri7WWz807HzUK7LT7XR28bh
	 fT/+VOvudE1iBTMz0inaC3TkuMPQSZH5pueUZBiYonREjVvxZtAU9fRKyxl47V/wtI
	 BlYR+wv3d9us2DcErDtHH7j3zMn5+pGduYdbxgCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 458/518] KVM: SEV: Dont terminate SNP VMs on #VMGEXIT without a registered GHCB
Date: Thu, 16 Jul 2026 15:32:06 +0200
Message-ID: <20260716133057.864039169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 1797e00bf802d64b859ea18505087daad92019c8 upstream.

If the guest attempts a non-MSR #VMGEXIT without the registered GHCB,
return a GHCB_HV_RESP_MALFORMED_INPUT+GHCB_ERR_NOT_REGISTERED error to the
guest instead of exiting KVM_RUN with -EINVAL (and in likelihood killing
the VM).  KVM has already mapped the requested GHCB, i.e. can cleanly
report an error, and so exiting with -EINVAL is completely unjustified.

Fixes: 0c76b1d08280 ("KVM: SEV: Add support to handle GHCB GPA register VMGEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-19-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20260529183549.1104619-19-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4522,9 +4522,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 	sev_es_sync_from_ghcb(svm);
 
 	/* SEV-SNP guest requires that the GHCB GPA must be registered */
-	if (is_sev_snp_guest(vcpu) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
-		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
-		return -EINVAL;
+	if (is_sev_snp_guest(vcpu) &&
+	    !ghcb_gpa_is_registered(svm, control->ghcb_gpa)) {
+		vcpu_unimpl(vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n",
+			    control->ghcb_gpa);
+		svm_vmgexit_bad_input(svm, GHCB_ERR_NOT_REGISTERED);
+		return 1;
 	}
 
 	ret = sev_es_validate_vmgexit(svm);


