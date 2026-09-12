Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0667F390CBE;
	Sat, 12 Sep 2026 11:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213684; cv=none; b=XFBmfYc2ZCcD6IsxS7W8LAcKT2Zlck4fFicguvyX8Y/BH81FyYtuz9UuSsSx7m+ZHYVimPmKlwCnr/0aqnyY+3plQSGCZya0uNh3E6ZKDCN0hdrCucis7ncYgI/QoCDWAv8+/TPdZ7os0EKnqljDwEJc1oK6Ub72eg7hkR5RhtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213684; c=relaxed/simple;
	bh=kcfK1Qkbkl0WkkI6Cl/cyfQviU3p6YFvrQ9lLHuC+ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRpV/TVIWQ6Vikjr+panlylNY6yAPO3jG85KaKNU+U8w622fugPETEG5tru/0aHADLGjzc+yNiYcFGep60DIHdL+QkD26MdBiHYGO8G7uysgb3MAa3sw90z8PP2uJNUp6b8SOFp70I+bahbGGyAvWtB8WGpmupX668wRREA/duM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjtkDULR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjtkDULR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6A01F000FF;
	Sat, 12 Sep 2026 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213682;
	bh=KFXMcbEnsUD++uaX9D16/1q9nITqh5312CHhtkUXoSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjtkDULRi1Lc6dsrtw95W5ISqbLxfRCi7jpYReRCTRmcM5dM+TUfLH+1gDFfVXO2C
	 U6URokAbp91GDS5Ob1DG/NTDeKNcI0Dd+bM3SNsoz2H9MfqS0EMafExUCdvLer/084
	 M0O/r/mJiOfYBePMHpfsgGGPs3M/XaN40xMDJMU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 0171/1376] KVM: s390: Restore sigset on error path
Date: Sat, 12 Sep 2026 08:43:17 +0200
Message-ID: <20260912065611.361671196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -5067,7 +5067,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		pr_err_ratelimited("can't run stopped vcpu %d\n",
 				   vcpu->vcpu_id);
 		rc = -EINVAL;
-		goto out;
+		goto out_sigset;
 	}
 
 	kernel_fpu_begin(&fpu, KERNEL_FPC | KERNEL_VXR);
@@ -5096,9 +5096,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
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


