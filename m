Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53F253FD37;
	Wed,  9 Sep 2026 14:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962500; cv=none; b=UT1eUHkvuzEjCrUuXSY46n2rL5YscMmElYbliHX/4msBStyhBOPszPfdIg9kyuf8oI2RKhLMv/1UrwWhbLcqezNzi6amc+0XF8bZcqHI2KHnW5KrHd3jhkLDBdgyedzSegKIHbXbBs7OvgX2l/rQIbllGfO7+SkX1AJITMZ7V2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962500; c=relaxed/simple;
	bh=7kR2dkMVGVho4QBXkIPZfbkYBqFO+qAlg9LjSxGaDoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOqp1XCY0mPVN9V+m1OMewHP6iQXMtPPCDDPhyFHHebWZtsSK1bu6t8ql2VMxUZsNOF8akM/ve8f0G7g0g5IsXXcVfwFFKgJF+7+A2ddHZsNSXbfHeAstiASf3mJ/+xEqQTYbZJdvxrX4I4n5cOqsR6ZMwUWW5oC+Lw7RtolD2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7L2eG4p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7L2eG4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287C61F00A3D;
	Wed,  9 Sep 2026 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962499;
	bh=MptPGvbElqIfwdqYORTJN5PgBphiIG/2lxORG9em57A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7L2eG4pqA3MC7c7Y+QPd9zR1ogIFdWdifz91wrGe2ryfSCxu92ny+LRdcBCsb6yI
	 TgtcN9zC0YevjcUXZtM/grnmf2hvBauhmi2dYs23//oLxPT32I677mb4DMAK6AUh89
	 f7+YH0VsMpbBFfWBTb2qn6q5ZV/t5KOEBuhNYAtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 313/556] KVM: s390: Restore sigset on error path
Date: Wed,  9 Sep 2026 15:39:53 +0200
Message-ID: <20260909134241.676878114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -5073,7 +5073,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		pr_err_ratelimited("can't run stopped vcpu %d\n",
 				   vcpu->vcpu_id);
 		rc = -EINVAL;
-		goto out;
+		goto out_sigset;
 	}
 
 	kernel_fpu_begin(&fpu, KERNEL_FPC | KERNEL_VXR);
@@ -5103,9 +5103,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
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


