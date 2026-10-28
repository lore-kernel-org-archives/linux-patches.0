Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216274;
	b=As1PxuoNIVO2zwmVcptXKqaYANlgroy9z67bzbyIg+PBVXP+jD7ln7R2LZfCEHZeADMi
	 xhbr5sdjPBI68j/eUerV2g/eEpn762Iqvp0ArWMNuWYg/qmAuTB0zXL2dCzu0xxqNYRoy
	 fjDDBxTNBPHzm4vSYZxYCWZhptWXPVwTMw9sdT6DpBBePn7oE2Vh/+9NzLpDO6f0i9/dH
	 dXxb/oluC7dWe4UFT4VpHBQIANF2pZLPm1IfdecbdKylG9ThIlR93+e3pSUGYs+A68tfm
	 5xzAiX7L1IjI9+c6bRHGSYCR4PhHi43x5rg1zyzcuD7h2f/RTzm48L9jzH3v4UJYMyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LC1HsQreULY5H3n9trB2/AdPjedGeJUI0zqdqrYWcjs=;
	b=HLogz6t1AWNy++EVH3ekpBLEXj1RG4OlX1CKPOqBbFstHxkPcS7u1ebm/uaMwkKmdPoz
	 9XEhRNaFqDXe4QKPk6ttIJTVLALAlXIDlVf1EFakSTp4yVR60oB/yKHX+sOQmbVPmGpQF
	 yepwWHPn1Mks8HrDhmbw2coy/vgq7slT0faoJBYo3GNmOR5sn2iy4OUmUfM89M1osPT9c
	 QeuICZR/NMDKk71P/terSzJE+B0fl3pcc8MHWnHGPyL3LQomDaSmrtzKAg1ktZstaKgAN
	 kPgoEwh57lApNcHkcT5lO5+Jut939uwAda1A+LZzi6lPqsELR5K41E/iTgtmq9FkmqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEhMPRLD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE2A606A322;
	Wed, 28 Oct 2026 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEhMPRLD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B371F01825;
	Wed, 28 Oct 2026 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216273;
	bh=LC1HsQreULY5H3n9trB2/AdPjedGeJUI0zqdqrYWcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEhMPRLD9YMZC1hcJzvt4qZYPWrf/0BTNWqKWxGatZzc0b8p4S9/T7qxY9GOI3n5v
	 YX03XImB+sihrU8H4CeWOcLRjBqKFO/BWWCD4ZmxmzOcfx6XeBu1rARMBaP5+Vka9A
	 +/Qo3iqNs4fgj1oBH8sXcboo8UZat/5qVBxzqSew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1499/1887] s390/vfio-ap: fix stale pqap_hook pointer on error in vfio_ap_mdev_set_kvm()
Date: Wed, 28 Oct 2026 17:59:55 +0100
Message-ID: <20261028170533.570157826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit 4400270ec0348d05dc0439d8f0130853ce7f9e20 ]

In vfio_ap_mdev_set_kvm(), kvm->arch.crypto.pqap_hook is set to
&matrix_mdev->pqap_hook before the update locks are acquired and the
mdev list is checked for a conflicting assignment. If another mdev is
already attached to the same KVM instance, the function returns -EPERM
without restoring the hook pointer, leaving kvm->arch.crypto.pqap_hook
pointing at the failing matrix_mdev instead of the mdev that legitimately
owns the KVM.

Since matrix_mdev->kvm is never set on this error path,
vfio_ap_mdev_unset_kvm() will not clean up the hook when matrix_mdev
is later closed. If matrix_mdev is subsequently freed, any PQAP
instruction executed by the guest will dereference the stale pointer
through pqap_hook_rwsem, resulting in a use-after-free.

Since kvm->arch.crypto.pqap_hook is only set in the vfio_ap_mdev_set_kvm()
function and is cleared in the vfio_ap_mdev_unset_kvm() function, a check
for 'kvm->arch.crypto.pqap_hook != NULL' is all that is needed to determine
whether it belongs to another mdev. This will alleviate the need to iterate
the matrix_dev->mdev_list list to see if the kvm object is assigned to
another mdev.This was introduced in v3 to alleviate the need to take the
mdevs_lock while iterating the list; however, this did not prevent a
potential race condition.

The pqap_hook_rwsem(write) is now performed inside
get_update_locks_for_kvm(), which is updated to acquire
pqap_hook_rwsem(write) between kvm->lock and mdevs_lock. This ordering
is consistent with the PQAP intercept path, which acquires pqap_hook_rwsem
in read mode while srcu is held under vcpu->mutex, establishing the
dependency: kvm->lock -> vcpu->mutex -> srcu -> pqap_hook_rwsem(read).

The pqap_hook_rwsem is now released inside the
release_update_locks_for_kvm(), which is updated to release
pqap_hook_rwsem(write) between mdevs_lock and kvm->lock.

Additionally, kvm_put_kvm() in vfio_ap_mdev_unset_kvm() is moved
after release_update_locks_for_kvm(). Previously it was called while
kvm->lock was held; if it were ever the last reference, kvm_destroy_vm()
would run under kvm->lock, which would deadlock.

Fixes: 86956e70761b3 ("s390/vfio-ap: replace open coded locks for VFIO_GROUP_NOTIFY_SET_KVM notification")
Cc: stable@vger.kernel.org
Co-developed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260806173435.105044-1-akrowiak@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 45 ++++++++++++++-----------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 42999d0934628..f6a543599ba88 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -45,15 +45,19 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned int retry)
  * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
  *			       guest's APCB.
  * 2. kvm->lock:	       required to update a guest's APCB
- * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
+ * 3. kvm->arch.crypto.pqap_hook_rwsem: required to update pqap_hook and
+ *					serialize against PQAP intercepts
+ * 4. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
  *
- * Note: If @kvm is NULL, the KVM lock will not be taken.
+ * Note: If @kvm is NULL, the KVM lock and pqap_hook_rwsem will not be taken.
  */
 static inline void get_update_locks_for_kvm(struct kvm *kvm)
 {
 	mutex_lock(&matrix_dev->guests_lock);
-	if (kvm)
+	if (kvm) {
 		mutex_lock(&kvm->lock);
+		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
+	}
 	mutex_lock(&matrix_dev->mdevs_lock);
 }
 
@@ -65,16 +69,19 @@ static inline void get_update_locks_for_kvm(struct kvm *kvm)
  *
  * The proper unlocking order is:
  * 1. matrix_dev->mdevs_lock
- * 2. kvm->lock
- * 3. matrix_dev->guests_lock
+ * 2. kvm->arch.crypto.pqap_hook_rwsem
+ * 3. kvm->lock
+ * 4. matrix_dev->guests_lock
  *
- * Note: If @kvm is NULL, the KVM lock will not be released.
+ * Note: If @kvm is NULL, the KVM lock and pqap_hook_rwsem will not be released.
  */
 static inline void release_update_locks_for_kvm(struct kvm *kvm)
 {
 	mutex_unlock(&matrix_dev->mdevs_lock);
-	if (kvm)
+	if (kvm) {
+		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
 		mutex_unlock(&kvm->lock);
+	}
 	mutex_unlock(&matrix_dev->guests_lock);
 }
 
@@ -1531,26 +1538,17 @@ static const struct attribute_group *vfio_ap_mdev_attr_groups[] = {
 static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 				struct kvm *kvm)
 {
-	struct ap_matrix_mdev *m;
-
 	if (kvm->arch.crypto.crycbd) {
-		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
-		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
-		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
-
 		get_update_locks_for_kvm(kvm);
-
-		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
-			if (m != matrix_mdev && m->kvm == kvm) {
-				release_update_locks_for_kvm(kvm);
-				return -EPERM;
-			}
+		if (kvm->arch.crypto.pqap_hook) {
+			release_update_locks_for_kvm(kvm);
+			return -EPERM;
 		}
+		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 
 		kvm_get_kvm(kvm);
 		matrix_mdev->kvm = kvm;
 		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
-
 		release_update_locks_for_kvm(kvm);
 	}
 
@@ -1577,18 +1575,15 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 	struct kvm *kvm = matrix_mdev->kvm;
 
 	if (kvm && kvm->arch.crypto.crycbd) {
-		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
-		kvm->arch.crypto.pqap_hook = NULL;
-		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
-
 		get_update_locks_for_kvm(kvm);
+		kvm->arch.crypto.pqap_hook = NULL;
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
-		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
 		release_update_locks_for_kvm(kvm);
+		kvm_put_kvm(kvm);
 	}
 }
 
-- 
2.53.0



