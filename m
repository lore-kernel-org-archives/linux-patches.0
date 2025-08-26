Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0333117332C;
	Tue, 26 Aug 2025 11:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208488; cv=none; b=QUI2UFMUT+Z8cNtSqv26Xvb4fuy0wAbUL1k1WoMC9suVyS69tPogDMlVnd2dRZ2trquOmj3H62iQyj3z7OewjrJtgM0EB5/uk3dUnE+zA5ApiD+mEho9i62WA6CbIJ8JTRQ4zXWkNYOETgOjQHLePNkVNRsCHHlwjCUplOg5xrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208488; c=relaxed/simple;
	bh=SXIjs1pvtgMRMNiClstZaPsCHZYqiBDtIfYda59lXOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs7XZIGantEojnsZwHUrOWwxtFu9ssj97bslTNlOBVqdhBWxB5YCibMjKf0oDFUAT7SbC+O5Inulim+fOo4uSvoqY3Gtcwd1TMKDnE/ku9XN1OxFcPC5DkV1t7XccU4rc5fOk54Kodb/eOz3YvAcVOm7PyOV2INwh51Prokd30g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEuaHFm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEuaHFm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875E4C4CEF1;
	Tue, 26 Aug 2025 11:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208487;
	bh=SXIjs1pvtgMRMNiClstZaPsCHZYqiBDtIfYda59lXOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEuaHFm6nG/Nq7e7+IK2opoysRF4LhnQsjbx/piISo6plI2UxUxpavrLk8S2dGSIh
	 /LwSdPDke8IPzgT5emm72mZntHcL0RszbRWocfVwnmJSX/W8tvJSCBTBrKPOXVtIk0
	 vadn66NFtsGSZqfKZclj1z5CQTT3XksRMZLDXHjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 130/322] LoongArch: KVM: Make function kvm_own_lbt() robust
Date: Tue, 26 Aug 2025 13:09:05 +0200
Message-ID: <20250826110919.010881955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1249,9 +1249,11 @@ int kvm_own_lbt(struct kvm_vcpu *vcpu)
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


