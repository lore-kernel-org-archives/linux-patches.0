Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D611A682A;
	Thu,  2 Jul 2026 16:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010407; cv=none; b=ht1+LbJD3FvMEbejavfxY1uEqNzXW1lTIs8c+W7lZvtb/FG/0QCAlbhIw2VN4wQJdhUp7JxENi6XVzGuksHwT6gZqm7o62JuOJJ7pbdchZKjqrxlNd5VBIS8nfABhQyDC4pLlRadK8l5KPhFGr8FFFDeoVoSxfzGvysVMv2y8PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010407; c=relaxed/simple;
	bh=cemBNTH8td8D9VkGtEgHQUlaPkTzQWU7y9rPl9dhrOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Duqf0uBJqUOLmcJq2JjzH53b5DqhN5dOb3e45CWUFZMQn2oCiMgF0yrSYMhs4t2gE9Nqtv6DLUMGjJMdZgWFAgtImBHmGSh8489+XffwKk6QcR9Ed8oZYv7Ir/9jLiyLHQKx7bwLBpDlIAaDJAI/vvPf3B/TjLD6wSJgEyRs0qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VblpaYzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VblpaYzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515461F000E9;
	Thu,  2 Jul 2026 16:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010405;
	bh=u0agyBAbVToAt7mbEARh84JhfYdyrFB0nz17WzdKnCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VblpaYzZ2O81p5iEwooR/tK2CIPyW4WvMKZ0oh5+SE1k/9m12Vcw4+zL41DMm1FAk
	 3784NN7Mqzs+o/Cnx0o9t7ELK60aqgUzyELkUeS9T7GoAaioQxugCcwjlcm1UQgc2+
	 HmyXz6CsMStO0pTwjI6xdml6xVcwT88VHYERTNzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/204] KVM: SEV: Ignore MMIO requests of length 0
Date: Thu,  2 Jul 2026 18:19:13 +0200
Message-ID: <20260702155120.678263379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 1aa8a6dc7dac8b83234b53518311bf78231f4fa5 upstream.

Explicitly ignore MMIO requests of length '0', so that setting up the
software scratch area (and other code) doesn't have to worry about
underflowing the length, and to allow for special casing '0' in the
future.

Fixes: 8f423a80d299 ("KVM: SVM: Support MMIO for an SEV-ES guest")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 115c59c86f448a..0a01971e33f0b7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4347,6 +4347,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	exit_code = kvm_ghcb_get_sw_exit_code(control);
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
+		if (!control->exit_info_2)
+			return 1;
+
 		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
 		if (ret)
 			break;
@@ -4357,6 +4360,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					   svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
+		if (!control->exit_info_2)
+			return 1;
+
 		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
 		if (ret)
 			break;
-- 
2.53.0



