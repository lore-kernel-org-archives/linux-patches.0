Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FC51A256B;
	Tue, 26 Aug 2025 11:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207468; cv=none; b=I8P9jILb8qU3ltkjU5zVa+lHVRh3d3AkAKEiBcMPmHsg7JEX69CVXyxp3ykajCT2TvYbC44WcH8tDSHBQBJ3TjDfDlVk4SBZh+yWflDDPDsP4iwzrPBnsVbbSBeEEvOtg/8trHvuWQ6L6Uf/LedWB9P8801MuAvMc5MlnO+4Lmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207468; c=relaxed/simple;
	bh=b2vb0tRnAY7HFKKJvFQuJxPD9+cVAEbgUA30oRiQ/LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPQxFO9YMEIY10xRLrl8SmVqhxokV1nwgH+CsZTW2GfyZJT60WpjfCdT55t2tcYHYxiO5Zt7lbHShsYqvbfrOC99fX0Qzj7G0yTYxZXa22GKjWyPmOZFIUTlk5G8IBV13D56Ue/qytlhHZPWfW5yS5UTtdLtPwxPllOqaNiQb2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnsOOdjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnsOOdjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCB0C4CEF1;
	Tue, 26 Aug 2025 11:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207468;
	bh=b2vb0tRnAY7HFKKJvFQuJxPD9+cVAEbgUA30oRiQ/LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnsOOdjzFirSJZ+fBNtL1v2BJIc8tQkwuU0S1RfZzB//6QsPJdpwTptiPZvSUi/K1
	 /TCVcsjozFm7axSrLFz10zxlp5pReQoUVbMPD1Hd+Su+gBW56MUdFLnBb8Nq3EgxxD
	 9XZJm36bEJN1tocnAcI7sMmhA8dzDpogA21pcjBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 194/457] LoongArch: KVM: Make function kvm_own_lbt() robust
Date: Tue, 26 Aug 2025 13:07:58 +0200
Message-ID: <20250826110942.162335586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 4be8cefc132606b4a6e851f37f8e8c40c406c910 upstream.

Add the flag KVM_LARCH_LBT checking in function kvm_own_lbt(), so that
it can be called safely rather than duplicated enabling again.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1277,9 +1277,11 @@ int kvm_own_lbt(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	preempt_disable();
-	set_csr_euen(CSR_EUEN_LBTEN);
-	_restore_lbt(&vcpu->arch.lbt);
-	vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
+	if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
+		set_csr_euen(CSR_EUEN_LBTEN);
+		_restore_lbt(&vcpu->arch.lbt);
+		vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
+	}
 	preempt_enable();
 
 	return 0;


