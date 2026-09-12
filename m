Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8626208D0;
	Sat, 12 Sep 2026 09:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205910; cv=none; b=EVClQ5qQZBgqLIc9vdY1BroYIO5i9qJcB/trBgWOm729oWGorHzgrmq11nOS+xY84QgFXpD+2CRga9KxHn8Yze4jkcKH1kJ5VUd+Hkbmv9V52ZMSss8u+cWaJ8FdhmIufVJkazd2XPgNZxGg79KaLzbklpLDrlHxFcm681qM1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205910; c=relaxed/simple;
	bh=xDbA2P0QD+b5FVfEI8MgbPpB2Y0rkETn2m9cw5IuslM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0aCbVm+MriReFOWB/8t8ZVFALfXrwjBTqJCmWYksv8XUAEPME0pZX9sWrstakkq5vcHSIzNDXH9cqEoh+Jgr/fmjj3yh+hNNeuG+UehsEc2GACPUQ4VW3NSyN+GLg3Bj+/6ywk91DK/SaaSK7nCbsDYn7nS/0ZdlvbOI2LwPOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pX9y1gsZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pX9y1gsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5CE1F000FF;
	Sat, 12 Sep 2026 09:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205909;
	bh=GXlOsoGF2nB/a3AXfVhYUW+AsWVCHKiAn1UWSGq+fRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pX9y1gsZ4XanNF0P2U9Gj511paymF60NnJJ2qjIRJ/8XzIPiFjXBCfcY6JR1soOs3
	 t90ZVtLPrTesYlPxvp9pAgbTjPJgz0Ix/sBxHblEEszLw91tpePzd8QmntXX0jF4zU
	 mugaXxfJzkk+XJ4w9IABx/TeQ1G4bR61rGWOOb3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0091/1518] KVM: x86: Check EFER validity on KVM_SET_SREGS*
Date: Sat, 12 Sep 2026 08:37:40 +0200
Message-ID: <20260912065625.529912930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 184bd464bdb66daa9173670904f24c29c7b7f7d4 ]

When handling userspace SREGS writes, check the validity of EFER (i.e.
allowed bits) before writing the new value of EFER through the
per-vendor set_efer callbacks. This prevents userspace from writing
bogus values (e.g. EFER.SVME=1 with nested=0).

Note: on KVM_SET_MSRS, KVM only checks EFER validity in terms of KVM
caps, not guest caps, so it is possible to set EFER bits that are
supported by KVM but not by the guest CPUID. Potentially allowing
userspace to set msrs before CPUID.

However, for KVM_SET_SREGS*, check the validity of the set bits against
both KVM and guest caps. This is consistent with other validity checks
(e.g. for CR4) that check validity against guest caps, which already
imposes the need to set CPUID before SREGS.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713180153.2728382-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/regs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -476,7 +476,8 @@ static bool kvm_is_valid_sregs(struct kv
 	}
 
 	return kvm_is_valid_cr4(vcpu, sregs->cr4) &&
-	       kvm_is_valid_cr0(vcpu, sregs->cr0);
+	       kvm_is_valid_cr0(vcpu, sregs->cr0) &&
+	       kvm_valid_efer(vcpu, sregs->efer);
 }
 
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,


