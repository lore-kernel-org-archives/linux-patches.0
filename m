Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3130422A7F6;
	Sat, 12 Sep 2026 14:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221793; cv=none; b=RaMSDC9DAt8QERb9TM2s8RVjpHPP0uDW/4dzBbAbd5UNg4gOHyrIC90TGeWbdkOS9qa3cYlTjeOMTeIv2jnTDUdd+FS6+8L34b/FmEgi8D/6pSyiAMGo5tLOvwdsXPIkz0mHVYvYMHUQTiquiryROXa5O0DNR0pVmPXI9q2rYrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221793; c=relaxed/simple;
	bh=djuJc9x2kd2YMartq6g4e/BurqwKqNFVVuyY5j3sNmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXpDNgIirZKuGpV3qeB3jq7+oKgjfQctTK2FvR0W+LAlQeqHKD9tVVC41W10g4P3wTdo8NKKg8mZPk7qPbUPxcYVJ463ktAYlNJ9VtF4P9z3X0Bl1q1SdojxQiBW3e1OV7cuMcR6shbWZCtS9bfoTzEJB2jEI8RFh2NUVdOVCyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8NvaS3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8NvaS3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C981F000FF;
	Sat, 12 Sep 2026 14:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221791;
	bh=pOQo1BJEvwH/KDLkDrLL2wwGm79mDX3hBuiqU32H49g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8NvaS3P5+aQ61tzE92DYNS2grka9IuIz5Zz/d1SBxUdGCeevWf+bcjiZHUEClwRm
	 J7nY3EOkTGoNpuRppSHoED9vQ1RUWgBkNoMsObwUp633DzCEPxQwvvg5lfPf03Z3PX
	 8U34ZYT/7Gj+PdGIsdJsULfBPLb7fbBPRCgLkNP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.6 0438/1424] KVM: s390: Restore sigset on error path
Date: Sat, 12 Sep 2026 08:47:50 +0200
Message-ID: <20260912065617.094537670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit c44d36d8e6501c4934412d9014e5e02da9efdb8f upstream.

kvm_sigset_activate() installs vcpu->sigset via sigprocmask() and
stashes the caller's mask in current->real_blocked; only
kvm_sigset_deactivate() restores it.

For KVM_RUN on a STOPPED vcpu the error path will not restore the
userspace mask.  Re-arrange the error handling to also restore the
signal mask.

Fixes: 6352e4d2dd9a3 ("KVM: s390: implement KVM_(S|G)ET_MP_STATE for user space state control")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260811153738.206885-5-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5078,7 +5078,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		pr_err_ratelimited("can't run stopped vcpu %d\n",
 				   vcpu->vcpu_id);
 		rc = -EINVAL;
-		goto out;
+		goto out_sigset;
 	}
 
 	sync_regs(vcpu);
@@ -5105,9 +5105,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	disable_cpu_timer_accounting(vcpu);
 	store_regs(vcpu);
 
+	vcpu->stat.exit_userspace++;
+
+out_sigset:
 	kvm_sigset_deactivate(vcpu);
 
-	vcpu->stat.exit_userspace++;
 out:
 	vcpu_put(vcpu);
 	return rc;


