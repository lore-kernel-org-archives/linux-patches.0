Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BEB2512D8;
	Tue, 29 Apr 2025 17:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949110; cv=none; b=Qjuu9uZ0fDINIIUR27zR0TAPfTCEVP4MpUS+DMikbNbjVdLMv2WyMM018FPk9lWe2Zt91nTSJTtV1/68bVKS8i4qiFqZi/0f4lQTQiANioN7Uy4V144zUEVIrk/xGGGA75dqTJb/2bkdSaPEoknH3FDY7ASl0O+TobLGECZJiMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949110; c=relaxed/simple;
	bh=CM36itYhfP8gD8s+ocgnpdAnTDaoCtOQ80JVthZy2iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lx9S3kUTwzNYytpyBHXuN7n4NwALOvmRw2GcfUUjqEerJt6jlLl7nVAOFMarG1dMd2OlXkxh7T5kye3xdHjxyWRjGofueGldPVZ+TTqd4LfF5oDRUrTYtmRnC0r4abN+fGTtsnP7koMkNMTXQoMNtMNRvcvPYiOhi6XuiCd6OCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTlr29p2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTlr29p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CDEC4CEE3;
	Tue, 29 Apr 2025 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949110;
	bh=CM36itYhfP8gD8s+ocgnpdAnTDaoCtOQ80JVthZy2iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTlr29p2Nw8CzhGFnYK2FjO1gzK3oGrwVQ2UE/RhLBEJMtx5jrDpRfF52llKGWfV+
	 3H3feUGbHZsT17MAwDaxzYTAMZf5XHYocfPbtLMAdqHw3miTytqqpdvWjI8F2w/mKi
	 YzZQvCkitTUtjqwZer5jvWKseI1Sw3hwCPCTwDCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,  linux-kernel@vger.kernel.org, stable@vger.kernel.org,  Mark Brown" <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 187/373] KVM: arm64: Always start with clearing SVE flag on load
Date: Tue, 29 Apr 2025 18:41:04 +0200
Message-ID: <20250429161130.854881234@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit d52d165d67c5aa26c8c89909003c94a66492d23d ]

On each vcpu load, we set the KVM_ARM64_HOST_SVE_ENABLED
flag if SVE is enabled for EL0 on the host. This is used to restore
the correct state on vpcu put.

However, it appears that nothing ever clears this flag. Once
set, it will stick until the vcpu is destroyed, which has the
potential to spuriously enable SVE for userspace.

We probably never saw the issue because no VMM uses SVE, but
that's still pretty bad. Unconditionally clearing the flag
on vcpu load addresses the issue.

Fixes: 8383741ab2e7 ("KVM: arm64: Get rid of host SVE tracking/saving")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220528113829.1043361-2-maz@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/fpsimd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -75,6 +75,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
 	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
+	vcpu->arch.flags &= ~KVM_ARM64_HOST_SVE_ENABLED;
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 }


