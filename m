Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FBB4E50DD;
	Fri,  9 Oct 2026 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557202; cv=none; b=iLkApBfiEbtxy9+DI+kBUNIlYuMwBap+BePkDJ4PtLYGfqC+7bFyzHOzEQpsMDGTUAqC7FFdZgLy89EYW+U5E6eg5emK9ux8hg+0hbXu55MYtPQtKFKj0EJ/6ePl/vbaweUXbL5gl4RV4KKkG2AKmDJFZwmchgjTtClvoLdIiMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557202; c=relaxed/simple;
	bh=d9XCyeQ2qhTNVQ+6TV3PHF9U9xyu8gFlFAeB1sje7jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI90AzMwOvbTFghoSsUqdURmzbDwhv2UFtWpuLxU7NQ31+eqf7gk4x+qXK7yVxP5CfMf9cfHBOsBu/dgfK26dS81OzWRzisMD+L3jleMldShJsbs2ZTv5Kjmv6lRkDDV4lHKNJIBXjIFHTaP02GyOHAD4+b3GPhW9RPHc0tBRB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gkfrM+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gkfrM+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0B81F000FF;
	Fri,  9 Oct 2026 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557201;
	bh=r3z8Bxg9k5hdVDk7UfSoH09wssPW62DLnAS7P623I+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gkfrM+3Jis7Knc3IbV2/bxhJ4iYmuSoStWDp23/lKLwHonKbCMfy6RQtmKuPsdS7
	 j/SyQkI4j4Fi88ry6r+v3P0h8OqjiE4kCuZtLWC3beBRjmjUBVd32NGkyDPJlxmR9F
	 ZK9kkFgWUxT4OnBnj80Nj1Hx+Bb8YpiG5CkSyVKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 318/428] KVM: arm64: Clear HCR_EL2.RW for 32-bit non-protected vCPUs
Date: Fri,  9 Oct 2026 16:10:55 +0200
Message-ID: <20261009140953.112721331@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

commit 80ae56184b57176b908cd6a7ececf274a7e4b3c7 upstream.

pKVM keeps its own copy of each vCPU's HCR_EL2 at EL2, initialised with
RW set unconditionally. Nothing stops userspace from creating a
non-protected AArch32 VM, and with RW set, entering one of its vCPUs is
an illegal exception return: KVM_RUN fails with KVM_EXIT_FAIL_ENTRY.

Clear RW for a vCPU that is AArch32 at EL1, when the CPU has AArch32
EL1. On a CPU without it, RW stays set and the entry still fails, rather
than EL2 switching *32_EL2 registers that are UNDEFINED there. The host
already rejects such a vCPU, but EL2 takes the vCPU's features from the
host and doesn't rely on that.

Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260929090031.3829185-3-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -54,6 +54,15 @@ static void pkvm_vcpu_reset_hcr(struct k
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
 
+	/*
+	 * Without AArch32 EL1, leave RW set and let the entry fail with an
+	 * illegal exception return: the *32_EL2 registers EL2 would otherwise
+	 * switch are UNDEFINED there.
+	 */
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT) &&
+	    cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
+		vcpu->arch.hcr_el2 &= ~HCR_EL2_RW;
+
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
 


