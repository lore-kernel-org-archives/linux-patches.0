Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FB832B125;
	Sat, 12 Sep 2026 19:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242051; cv=none; b=iNqmEyp8bVmCDJrpR/KMVCbh7/TlYoflpAO6OXa0MPbEo98/wzP9vq3BoMNhDHRIkYSXpDb1HcdpXhF5f3NnQLUiISjGChWo325g4guWwBedO9oQNlFSmuBoz4b/yE+HwJv0fhHJITGbW/jXmIt70rCjvWbVA9MnD/8CODo6z58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242051; c=relaxed/simple;
	bh=+7I/UDtnwGHZF8SkIlkSU4hRtxFZARJWuRM6d+rgvXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm8szdMCrcBIew63+nBSStu9U9eAUUfJqLkPoMG6Lmt3t0TDY61O4MWqtHh+bCFyqY6kMA0VlgMh8WA03F8upSaV73kdhuonYyG44rIvY34k4tYjJnOUwF4GrkTHbDb0eQQkIwTdAHBnhVA5cuvLAnNrI3M3MQZAgmICOAkvCXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUSxuDWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUSxuDWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DB91F000FF;
	Sat, 12 Sep 2026 19:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242050;
	bh=CSfPj4OZ6ZX4AzCBsO43k3bCXN1C5ZsigfNUDknidk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUSxuDWRan4H0ZDqdSsSWsGoJ2Y0EC3nFd1YgciS7CuigSKGnrtGSleJr5gSUlN6K
	 SbIbREbJz8IE76Let6tEvqWrzsKFBnapM3kEKW6lwh6j2bsMp4820bhYgM0J/eecCi
	 wOVUVPKi72fi6e6SHY1+YoJQL1/6sK4iygcQrDHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.10 268/798] KVM: s390: Restore sigset on error path
Date: Sat, 12 Sep 2026 08:58:16 +0200
Message-ID: <20260912065523.299308810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4401,7 +4401,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		pr_err_ratelimited("can't run stopped vcpu %d\n",
 				   vcpu->vcpu_id);
 		rc = -EINVAL;
-		goto out;
+		goto out_sigset;
 	}
 
 	sync_regs(vcpu);
@@ -4428,9 +4428,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
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


