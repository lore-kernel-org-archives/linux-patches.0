Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C6F58039F;
	Wed,  9 Sep 2026 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963939; cv=none; b=MFGX2tZag5JRoKlGnpdEYsSqa4Up0CXEFl/1MKa5Pb4LIrA0DxyuoYIOSrhWJJyOPzQeKesDYFbuA/BjlHfCJGqwkQG+L3Jgk9yu17ri559Le/n20oEL+JNg/Idwv57NTx5pdn662dIOQwm9ioHBp110LthJRCa7FW0F6lJIhBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963939; c=relaxed/simple;
	bh=EypBsobFWWHFqorLadeXYEIy9qTbMcrtKJopHSrKgvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObaHzErSLVVA651H8bQKIuMDIXiWnfjqCB9sFTeh8QCi02HRsnwHse/ODc8ogCgZh0w/C5Qde2HJVGE7ll/s8sWOL5+x0s+SPkNV+u5X6P1CDn7QGkWw6nqxqX8lVGHKNFS18q/SxmxZ7B9R5r/Upb5XjslevY7ab37kXUabUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BG4SYAPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BG4SYAPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064EC1F00A3E;
	Wed,  9 Sep 2026 14:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963938;
	bh=7QbSKFvH1vGkF1fBQxrQzSDjXXzqZMheRB/iWSjME78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BG4SYAPgumlUP8QgWy/K0/8m24gnIWJTyWx0ruwVnGSJ2oQoMbU75MvCcbv8eGc7J
	 B9DemjekxD6hYdk+e0kb79mqPF/yS9hzwMtBcWBNzil1NFbSv/3A9L3I2NQIuCVwdV
	 RFrtEnMFo2UvO4gAQQvFj5Fi5LyIjMKHTgJ8tNQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.18 251/583] KVM: s390: Restore sigset on error path
Date: Wed,  9 Sep 2026 15:38:56 +0200
Message-ID: <20260909134246.812895425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -5355,7 +5355,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		pr_err_ratelimited("can't run stopped vcpu %d\n",
 				   vcpu->vcpu_id);
 		rc = -EINVAL;
-		goto out;
+		goto out_sigset;
 	}
 
 	kernel_fpu_begin(&fpu, KERNEL_FPC | KERNEL_VXR);
@@ -5384,9 +5384,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	store_regs(vcpu);
 	kernel_fpu_end(&fpu, KERNEL_FPC | KERNEL_VXR);
 
+	vcpu->stat.exit_userspace++;
+
+out_sigset:
 	kvm_sigset_deactivate(vcpu);
 
-	vcpu->stat.exit_userspace++;
 out:
 	vcpu_put(vcpu);
 	return rc;


