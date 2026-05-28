Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9662733439A;
	Thu, 28 May 2026 20:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000597; cv=none; b=Lb3o9mo3NWs0IDbBjyuqZeumDqveB0O7zWqd1+BPoP1B9eLqNv3prmJSgcoy2oGqqe8nc09D7fsXi3O5tE3i/2W3DnUSKCnFEth6xj85RMmFr0N4kdLqdbuGNx/Hd1ZiL6i0NwXE+fFnSDkHI79wnH+fu77ZNG4+tYuNwbrGDes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000597; c=relaxed/simple;
	bh=lkmlxuu0/qZqf1RmieX3w4h0bLnIkcnWUzRid41jZ0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRcwIXhOhW5k5y9Ji4gOmTwVyYIlgjbhj/TOeH5tjGCFLlLUs7sPK8kIb5Lg6srvvC3nWTvDkZcUQhIn9OXyamu9OFV55HI8x/JOhwC5stBcOa9Q536IrvmLhvTqGz8oVzD68MH5cs05NdbZQKYqnR2AUjKcsrjou8TghiQwSnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8HdOCJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8HdOCJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33B01F000E9;
	Thu, 28 May 2026 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000596;
	bh=oBlDUq2ZA4N6nSN2wdUnzVejv4ZO5cXwkDkenV3Z/qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8HdOCJaRvLUWpWCXttgQKSotBK8kjiXGLgFjMomRfP8L6Q6I9V7wVCxUnT+nOspK
	 We1dVa0K/3vgqGVPW8Td9PeanxqAgBj7IEzPgau7Ah/JhK6YczuoZTFD5xJ2XRWG5O
	 ge6cp7mRMOzkZplIB9nDY8x04dgQUhEp6ErJ7+Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 102/272] KVM: arm64: vgic: Free private_irqs when init fails after allocation
Date: Thu, 28 May 2026 21:47:56 +0200
Message-ID: <20260528194632.237111957@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -490,8 +490,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	kvm_destroy_mpidr_data(vcpu->kvm);
 
 	err = kvm_vgic_vcpu_init(vcpu);
-	if (err)
+	if (err) {
+		kvm_vgic_vcpu_destroy(vcpu);
 		return err;
+	}
 
 	err = kvm_share_hyp(vcpu, vcpu + 1);
 	if (err)


