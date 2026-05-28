Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785CA32BF5D;
	Thu, 28 May 2026 19:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998234; cv=none; b=Z8aXFxWg5hT/i8z7mlqb7wwY+Hb5PKqw/zLdFZpTM0KkSSM9hFvaAcT17Eg3VZvexXCmO3N+M1v/vfzesWY46YHNON0ONs+k80ub0IQfmv9a10fPOfDJE1tn32awxs/DYvC/SlN64mTDt/mUErxBxRBtEIGg5DKr20fePAle/9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998234; c=relaxed/simple;
	bh=LqFnhMeaJl3PYO2slleeE5dQMq9ZB/Pxu/Z81oEWT2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTORx+x63mTPmt2PbGfzDPiQEPuvnOcZvl7yhkOqL81C5DB0Y2d1XhmmbxuI23WXj2QnRUMBEKDcurS0L/p1pKnar187qqAl1w/Akp0Okxil8+lCFO6dCLvyPjNgtGVjtOBkzkcxvEQZfob/vQjEhwVVYog+5hkrgkpySpW7u0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfG90rOK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfG90rOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71E91F000E9;
	Thu, 28 May 2026 19:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998233;
	bh=zNCh5tp8WHINGdOrvEdH1dAi6czHTAi7rEWjm/MkTBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfG90rOK1TynVTQsJKeCY2cV7msXl+j5JBn0pdj8Yj7mIRhmhwjLfrnDbj8tBVbby
	 ldZIyAJG9sF4WT60ZapR6tMqvYPdILBIOurZdW7PIOSFKilxBKApMj74W5rZsJW7ys
	 ygUTbxhB8NgH/SBps2P51XAZwoCVCIBgM4HKeS/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 101/461] KVM: arm64: vgic: Free private_irqs when init fails after allocation
Date: Thu, 28 May 2026 21:43:50 +0200
Message-ID: <20260528194649.878108245@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit f19c354dbd457759dfcf1195ab4bdba2bb568323 upstream.

Companion to commit 250f25367b58 ("KVM: arm64: Tear down vGIC on
failed vCPU creation"), which added the missing kvm_vgic_vcpu_destroy()
call to the kvm_share_hyp() failure path in kvm_arch_vcpu_create(). The
kvm_vgic_vcpu_init() failure path immediately above it has the same
shape and still needs the same cleanup.

Call kvm_vgic_vcpu_destroy() when kvm_vgic_vcpu_init() fails so private
IRQs allocated before a redistributor iodev registration failure are
released before the failed vCPU is freed.

Fixes: 03b3d00a70b5 ("KVM: arm64: vgic: Allocate private interrupts on demand")
Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://lore.kernel.org/r/20260519135042.2219239-1-michael.bommarito@gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -540,8 +540,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	kvm_destroy_mpidr_data(vcpu->kvm);
 
 	err = kvm_vgic_vcpu_init(vcpu);
-	if (err)
+	if (err) {
+		kvm_vgic_vcpu_destroy(vcpu);
 		return err;
+	}
 
 	err = kvm_share_hyp(vcpu, vcpu + 1);
 	if (err)


