Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842FD550DD6;
	Mon, 31 Aug 2026 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184013; cv=none; b=Gb1WG0EU5pmUpbGZufXA+47Z5cYKzfjdlohNezV/oMaysJ9fECQeRCv4btizWGLXf9pRBL5NVl5Z85oDhI1vatvDIHC/uhaPacVHMCBz4d+N/I5yEc5yRXEvVoBICwzNytdaMU6PiS7C3RYnQTKRdNP2Epl1UhpBPBD7aEGxq4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184013; c=relaxed/simple;
	bh=C47U+KQ/VC6oQB/DUYkljZq+EqDJNklsDweNtqMVO2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6Z3SNiMAEgyMhUjkQuKWYfndW3MPFg+bt3WQV5GUctJSwLE+Jy66gAxz6jhPw58T3ppVlwmpTfK+8H4T2bZs8hW0fKwguI9KT4QLX87d8DUs81264Zbb2Kf77Twh6pkwTkIsGiKRkLci2Krk80gwATa02TELbkNuM3b8GS8IXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij5ZJpHE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij5ZJpHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608ED1F00A3E;
	Mon, 31 Aug 2026 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184010;
	bh=6WkJEIcrMSxDSNlVx/Ai3t+ZMkmJhGkZ3zkd9Ps+Olk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ij5ZJpHEY2b9v4Opl3Yjg+vsLZ2wNp0FjsddRLMyDicMWJjQSVh+j3EggMPxjG7+r
	 EaP47sgqsE4WHQWhNMdjzbJGh3DTHvmtUuTIT1NHcjBzwTV7CIVjidGQUoV/9Gl2V0
	 ATNQVvPFu7ClnbaR5ASIA/cxrj9mo8Dh9AaMA4yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 43/83] KVM: SEV: Mark vCPU RUNNABLE after AP_CREATE, even if VMSA is unusable
Date: Mon, 31 Aug 2026 15:34:19 +0200
Message-ID: <20260831133401.706947341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 98ade8c48c28c227fe2e80e545ff0c57cd4712a3 upstream.

Always mark the vCPU as RUNNABLE after responding to AP_CREATE, even if the
guest-specified VMSA is unusable, e.g. isn't backed by a memslot or doesn't
have a backing guest_memfd page.  If the VMSA is unusable, leaving the vCPU
in a non-running state will effectively hang the vCPU instead of reporting
an error to userspace.  This will also allow retrying the VMSA load in the
future, to fix a bug where KVM doesn't honor guest_memfd invalidation
events, e.g. if AP_CREATION races with PUNCH_HOLE.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4062,9 +4062,6 @@ static void sev_snp_reload_vmsa(struct k
 	svm->sev_es.snp_guest_vmsa_gpa = gpa;
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
-	/* Mark the vCPU as runnable */
-	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
-
 	/*
 	 * gmem pages aren't currently migratable, but if this ever changes
 	 * then care should be taken to ensure svm->sev_es.vmsa is pinned
@@ -4096,6 +4093,15 @@ static void sev_snp_init_protected_guest
 	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
 
 	sev_snp_reload_vmsa(vcpu, gpa);
+
+	/*
+	 * Mark the vCPU as runnable for CREATE requests, indicated by a valid
+	 * VMSA GPA, even if installing the VMSA failed, so that KVM_RUN will
+	 * fail instead of blocking indefinitely and hanging the vCPU, e.g. if
+	 * the backing guest_memfd page is unavailable.
+	 */
+	if (VALID_PAGE(gpa))
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 }
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)


