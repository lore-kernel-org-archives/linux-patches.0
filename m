Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB43264F4;
	Sat, 12 Sep 2026 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228319; cv=none; b=Kda6WfgqgNoDvBdkt+aI8xcYCyMmX/4+9e5iHXrhrej/R8bF7Mubc/vL86eCuNYxvhPtkf0lovvqIl3kB72Bwa+jOhJN8Rjd6n03AwPlToR5CEXDn0ZdvmFhzR8+odUbVAanPxSLgp+emFN7FGz4eDBT/a0s1Rd8IWon0qj9J7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228319; c=relaxed/simple;
	bh=sp7gKgusEfNJbrxUZiRq4VqCaLPC2GVa17LnMilj0cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUqGyCq47wSFQDnvNji2cnP2c6R2N0xYriJOmuFGLblgG4OUp4BQOgzsCkDG/FqT/LYLbJN1q4TqScFc4b93JYFO9As5WyBh2cmJY7drARTlKLyHI64PlHPGEPskHw+hGn1qsW/BtMZ6adDZQ5KJ/DHPNXQCrKCAw8sYojS0yyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpTF+R7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpTF+R7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61B01F000FF;
	Sat, 12 Sep 2026 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228318;
	bh=r768uzXhWvwNJjOgZhAZD+q2nw2o6KHbOX8B6l3D0B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpTF+R7RIgIil9tNfO0WDxYMwDZY20PBgxJyjhhtJDDyaW/1lZjmMi9XFwRigOYfJ
	 tbnVkw5DPjRv0lVFJVLQJAWu0uYcIyHhq0a8o+rhhRzKs8EJ6yM9ih/PDsB0sR99wE
	 Opr8EO+jVJeFflSs6oX2Z9zthXqgpMqabh6TcRqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.1 0360/1191] KVM: s390: Restore sigset on error path
Date: Sat, 12 Sep 2026 08:51:28 +0200
Message-ID: <20260912065556.313936974@linuxfoundation.org>
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
@@ -4911,7 +4911,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		pr_err_ratelimited("can't run stopped vcpu %d\n",
 				   vcpu->vcpu_id);
 		rc = -EINVAL;
-		goto out;
+		goto out_sigset;
 	}
 
 	sync_regs(vcpu);
@@ -4938,9 +4938,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
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


