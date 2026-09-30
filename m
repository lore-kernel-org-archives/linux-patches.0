Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9841351B174;
	Wed, 30 Sep 2026 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792801; cv=none; b=cuNZmTeoPP0CwtfHdjtOn4NCSt2unOuMyBMiLoHJ5kdDB8vhfmEutDZA5V6k1DWWgZkx/nJ0T7TbEPffmn9DYh64X4EBFbs+ZIb8vCVStB8jTVLCrIuCE1MfK188w2t1JkYrpgJZYB7ZtChuniGgHJH/CNw0iXiyENpzrI6OrRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792801; c=relaxed/simple;
	bh=22fgY4njH6dj1KNDzSmPle4PQHcxeVO6ro+JozYeVdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQBYVY7OZ8Bxj3d2W4YzjzoPCKsEfGIosucaKrYjdvj0vtcPDZIZ67bqYAJ1S3eCXU2yBJJlNAc5CLnp6wW41NjGJFh/Z3RgBpFWsHQ61sIDdwELFQF9AVQeiBNa5A0Vvev1j6+04YUYNHQ5Q7YpwVoqYAY/FX6usrxF3xd50uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0ej/MEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0ej/MEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D361F000FF;
	Wed, 30 Sep 2026 18:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792800;
	bh=+Iypc08MTX6srBH1fLb1PBCJSIF4oue2fn5SqCvw5YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0ej/MElGbgKgVltrmoqbH1Ki589qQpg0h83nUEGMk6VTheFLDxeZXkiisTb1JpaP
	 KZdLBLe/14UvRZbyffuRZR4LywUfWYeQsfARQsOsYsd/o0wRvJGd9+57kxxAc4xvJW
	 b2RQraxr52FzLC+WONoldGomAuRXtShw2TgciFFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/395] KVM: s390: Fix IRQ injection with SIGP Stop and Store Status
Date: Wed, 30 Sep 2026 17:24:29 +0200
Message-ID: <20260930152340.768199819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit d343407b728a80b74be3c24b59f15e60289ea527 ]

When __inject_sigp_stop() is called for a Stop and Store Status
operation, if the vCPU is running, the interrupt is marked as pending
and the status is stored by the thread performing the KVM_RUN IOCTL.

If the vCPU is already stopped, the status is stored immediately.

Storing the status means writing into userspace, which might fault, and
__inject_sigp_stop() is called from do_inject_vcpu() which in turn is
always called holding a spinlock, which is obviously an issue.

Fix this by returning -EWOULDBLOCK from __inject_sigp_stop(), and
adding a bool flag to indicate whether a store status is needed. The
callers of do_inject_vcpu() are modified to pass the pointer to the
bool flag; whenever a Store Status operation is needed, the callers can
now perform it outside the spinlock.

Opportunistically refactor kvm_s390_set_irq_state() to use
scoped_guard() and __free().

Fixes: 6cddd432e3da ("KVM: s390: handle stop irqs without action_bits")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
[ Added Fixes tag while picking -- Claudio ]
Message-ID: <20260812104436.109741-7-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/interrupt.c | 70 +++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 1c83962baf5f6..d39884e63fa13 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1579,23 +1579,21 @@ static int __inject_set_prefix(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 }
 
 #define KVM_S390_STOP_SUPP_FLAGS (KVM_S390_STOP_FLAG_STORE_STATUS)
-static int __inject_sigp_stop(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
+static int __inject_sigp_stop(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq, bool *storestatus)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	struct kvm_s390_stop_info *stop = &li->irq.stop;
-	int rc = 0;
 
 	vcpu->stat.inject_stop_signal++;
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_SIGP_STOP, 0, 0);
 
 	if (irq->u.stop.flags & ~KVM_S390_STOP_SUPP_FLAGS)
 		return -EINVAL;
-
 	if (is_vcpu_stopped(vcpu)) {
-		if (irq->u.stop.flags & KVM_S390_STOP_FLAG_STORE_STATUS)
-			rc = kvm_s390_store_status_unloaded(vcpu,
-						KVM_S390_STORE_STATUS_NOADDR);
-		return rc;
+		if (!(irq->u.stop.flags & KVM_S390_STOP_FLAG_STORE_STATUS))
+			return 0;
+		*storestatus = true;
+		return -EWOULDBLOCK;
 	}
 
 	if (test_and_set_bit(IRQ_PEND_SIGP_STOP, &li->pending_irqs))
@@ -2132,7 +2130,7 @@ void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu)
 	spin_unlock(&li->lock);
 }
 
-static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
+static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq, bool *storestatus)
 {
 	int rc;
 
@@ -2144,7 +2142,7 @@ static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 		rc = __inject_set_prefix(vcpu, irq);
 		break;
 	case KVM_S390_SIGP_STOP:
-		rc = __inject_sigp_stop(vcpu, irq);
+		rc = __inject_sigp_stop(vcpu, irq, storestatus);
 		break;
 	case KVM_S390_RESTART:
 		rc = __inject_sigp_restart(vcpu);
@@ -2180,11 +2178,16 @@ static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
+	bool storestatus = false;
 	int rc;
 
 	spin_lock(&li->lock);
-	rc = do_inject_vcpu(vcpu, irq);
+	rc = do_inject_vcpu(vcpu, irq, &storestatus);
 	spin_unlock(&li->lock);
+
+	if (rc == -EWOULDBLOCK && storestatus)
+		rc = kvm_s390_store_status_unloaded(vcpu, KVM_S390_STORE_STATUS_NOADDR);
+
 	if (!rc)
 		kvm_s390_vcpu_wakeup(vcpu);
 	return rc;
@@ -2928,7 +2931,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu, void __user *irqstate, int len)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
-	struct kvm_s390_irq *buf;
+	struct kvm_s390_irq *buf __free(kvfree) = NULL;
+	bool tmp, storestatus = false;
 	int r = 0;
 	int n;
 
@@ -2936,31 +2940,33 @@ int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu, void __user *irqstate, int len
 	if (!buf)
 		return -ENOMEM;
 
-	if (copy_from_user((void *) buf, irqstate, len)) {
-		r = -EFAULT;
-		goto out_free;
-	}
+	if (copy_from_user((void *)buf, irqstate, len))
+		return -EFAULT;
 
-	/*
-	 * Don't allow setting the interrupt state
-	 * when there are already interrupts pending
-	 */
-	spin_lock(&li->lock);
-	if (li->pending_irqs) {
-		r = -EBUSY;
-		goto out_unlock;
-	}
+	scoped_guard(spinlock, &li->lock) {
+		/*
+		 * Don't allow setting the interrupt state
+		 * when there are already interrupts pending
+		 */
+		if (li->pending_irqs)
+			return -EBUSY;
 
-	for (n = 0; n < len / sizeof(*buf); n++) {
-		r = do_inject_vcpu(vcpu, &buf[n]);
-		if (r)
-			break;
+		for (n = 0; n < len / sizeof(*buf); n++) {
+			tmp = false;
+			r = do_inject_vcpu(vcpu, &buf[n], &tmp);
+			if (r == -EWOULDBLOCK && tmp) {
+				storestatus = true;
+				r = 0;
+			}
+			if (r)
+				break;
+		}
 	}
 
-out_unlock:
-	spin_unlock(&li->lock);
-out_free:
-	vfree(buf);
+	if (storestatus) {
+		n = kvm_s390_store_status_unloaded(vcpu, KVM_S390_STORE_STATUS_NOADDR);
+		return r ? r : n;
+	}
 
 	return r;
 }
-- 
2.53.0



