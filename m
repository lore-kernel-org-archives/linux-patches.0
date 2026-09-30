Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764F04E324C;
	Wed, 30 Sep 2026 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786825; cv=none; b=Zt+mczA4YUazdQTtsMjsB88Ls3CwtTjI92gwX4oiNIq0aU6rm4B83wzVbBY4rYKThNMXcFuwqSKgWphkO39HGgx+wvKPLSTJxmBh/7jXI6tEEnsCZLdPu8BiS87GyKKO5sudS1i7LILFKfgNptv3YLOZXw5ysbm5spl+XfqtuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786825; c=relaxed/simple;
	bh=mi62pGGWQw35sSuOH9IkvY1ILVIEPjXR7wEqnAKtKfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0t2SIzcFzoBH9ABHU3TgVjLiMHROXUi6SIkeJDtJtAMAhg5WXV8X7l0aklkY7+FrvqDPdmue9ZkIKrPkPbykSqV/CIRYlq2/Awv4aXIS2ucVgir7Vd5wHDY6gicE2RoOw1kWkxPZ+VOvf2jdoIA8EZO5tE2DiwKz6B3xYj3RjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJ6PgIea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJ6PgIea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27051F00893;
	Wed, 30 Sep 2026 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786824;
	bh=geq+99ijp6VxVZKn5TVdsHqJte421S2EtYiTtrO20BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJ6PgIeaTOthma9xVJlWsgoPX9cXceCH6b6B2ZgttqkUkggKtZpf5gK8tODyFl1eu
	 n5bSJxc7G7gVIhtrWRiFHh/do1JK7uu6ouyqORr3+XqyapXOddsB/saSnFhSxA43Md
	 o+orsTQVIjqvQGtIDTxlqNKqls33BLpOmgFxJ3NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 008/457] KVM: s390: Fix IRQ injection with SIGP Stop and Store Status
Date: Wed, 30 Sep 2026 17:21:53 +0200
Message-ID: <20260930152346.210867086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
Stable-dep-of: f3a557067d57 ("KVM: s390: Add missing srcu in kvm_s390_set_irq_state()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/interrupt.c | 70 +++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 70431eb38aa50..6397b53e33f52 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1550,23 +1550,21 @@ static int __inject_set_prefix(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
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
@@ -2102,7 +2100,7 @@ void kvm_s390_clear_stop_irq(struct kvm_vcpu *vcpu)
 	spin_unlock(&li->lock);
 }
 
-static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
+static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq, bool *storestatus)
 {
 	int rc;
 
@@ -2114,7 +2112,7 @@ static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 		rc = __inject_set_prefix(vcpu, irq);
 		break;
 	case KVM_S390_SIGP_STOP:
-		rc = __inject_sigp_stop(vcpu, irq);
+		rc = __inject_sigp_stop(vcpu, irq, storestatus);
 		break;
 	case KVM_S390_RESTART:
 		rc = __inject_sigp_restart(vcpu);
@@ -2150,11 +2148,16 @@ static int do_inject_vcpu(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
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
@@ -3190,7 +3193,8 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
 int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu, void __user *irqstate, int len)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
-	struct kvm_s390_irq *buf;
+	struct kvm_s390_irq *buf __free(kvfree) = NULL;
+	bool tmp, storestatus = false;
 	int r = 0;
 	int n;
 
@@ -3198,31 +3202,33 @@ int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu, void __user *irqstate, int len
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



