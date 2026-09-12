Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5580E471D1E;
	Sat, 12 Sep 2026 15:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228305; cv=none; b=kfiwSUN4AYmx+4LddSSekXywCzpdsbTwO7AWhLGCBMuppPTvgKsydSBT0r6dmwSYOyIWhmDOJ7X4puPnMaFoqkgx6PIQFjTi5+0L2iTN0CEmwBEPUTVUxvAks472jkN7aD00m6v8C58jo58pfJ1KjFZIhU8GQbGoFTcYs08qWco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228305; c=relaxed/simple;
	bh=kg7/0fSCkRR0eDTDqcI+BcOw+zrMKUatKJsrnboD9DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlX+6gs61xcjiRjXvOsgLKKgIRcEdyrRGOi8KzT07S86f3j/gK7YR+SJWaNPqe6IdSobycWdfYB/DVO4eaNxoB2AyVZclVNqZ66W70dthkcuAKAw3DuARNfeA+m+Fv9OBlrufnsXgkmnBMDSRluiGjObq4rkl4RC5dyl+xE8ZWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wq+QXo7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wq+QXo7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BF61F000FF;
	Sat, 12 Sep 2026 15:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228304;
	bh=R0ojPR4BjZKal2JY0Z0JGkAoxNvNYtuHbPd8tYb9cVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wq+QXo7tjVKFeFj/zoyAXSwpz6XJiJl6CLHDOzdKwG/Zj6hpqD/ReleXL35vMUG0p
	 bcWJAN2e/ZfbBh+N9pCoApxpbpXi2sNIoon9P++7VO/hCrNPDXzCL1EAImTmzMNpQK
	 5/gjZX/Xl7wnJrd5LoKotbVkZG4OYRNbIBmA7nHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.1 0357/1191] KVM: s390: Take srcu when importing watchpoint data
Date: Sat, 12 Sep 2026 08:51:25 +0200
Message-ID: <20260912065556.247266863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit a4e482def8533ebace517d9f67f1465841b1f982 upstream.

__import_wp_info() backs up the original guest memory contents of a
watchpoint with read_guest_abs(), which is kvm_read_guest() and therefore
resolves the memslot via __kvm_memslots(). That requires kvm->srcu (or
kvm->slots_lock) to be held, otherwise a concurrent memslot update can
free the memslots array under us once its SRCU grace period has elapsed.

As this is not fast path, following lock ordering (mutex first, then
srcu) take the big hammer and hold the srcu for the full import.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-7-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4222,8 +4222,10 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(
 		/* enforce guest PER */
 		kvm_s390_set_cpuflags(vcpu, CPUSTAT_P);
 
-		if (dbg->control & KVM_GUESTDBG_USE_HW_BP)
-			rc = kvm_s390_import_bp_data(vcpu, dbg);
+		if (dbg->control & KVM_GUESTDBG_USE_HW_BP) {
+			scoped_guard(srcu, &vcpu->kvm->srcu)
+				rc = kvm_s390_import_bp_data(vcpu, dbg);
+		}
 	} else {
 		kvm_s390_clear_cpuflags(vcpu, CPUSTAT_P);
 		vcpu->arch.guestdbg.last_bp = 0;


