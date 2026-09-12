Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30C933F59A;
	Sat, 12 Sep 2026 11:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213335; cv=none; b=Sa1vLK7+ucDuwK7Pp6PClX0BbT5uz3cM7Erqh1EKGJhfQQlh+rn5IxU0iJFZtpx8C2FLRMDoCbJi2ZkkUIvsT+woitf6sIcMxzkBXyRAC0zLGKID33F4yWgyBMHPNPoO5+p2SE1X/HnJHaJKR4W4PXPpplpUNFPK8+D0TwpZdmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213335; c=relaxed/simple;
	bh=OfOKvJuXs0LECK1oOCjOq7bYZZ/VGUIzYMzVlcOE2iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqsLVYbHvrXsezjP0Yg4b5eyKGvrPcQD3PgWX7g5RtO+1i9+FZzvolGdHFTT6vYVbsUv+LcvhpNKWgwlTlQjg2A1BjphEybLmiY6auqFD99IqbwL3bSzuwZHZX0bQdmznIEprdJu5abkQIa0raK2qehoHdtTcJKiSSku1OpOIT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K082t+kU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K082t+kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B03E1F000FF;
	Sat, 12 Sep 2026 11:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213333;
	bh=KLtHH6wJUhLi3G5OfscoDBRAf8BEkOqHFtplmPU0t/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K082t+kUbfYohRGxkjJ47plDq5lOpJ516yC6CLbN6MgIyn0nbUYutbKu8HNfjhpX7
	 B0fmAaKZgZddUpqPQ+609fYAGy2nqKCd1mLr8ZZjmoFYT/akZFA1ORznf/Xso22qmW
	 C1gtisSWfbuDW1RzyiQHmOGPEcuQBwyriHOsTl2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 0101/1376] s390/vfio-ap: fix stale pqap_hook pointer on error in vfio_ap_mdev_set_kvm()
Date: Sat, 12 Sep 2026 08:42:07 +0200
Message-ID: <20260912065609.808853624@linuxfoundation.org>
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

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit 4400270ec0348d05dc0439d8f0130853ce7f9e20 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   45 ++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -48,15 +48,19 @@ static void vfio_ap_mdev_reset_queue(str
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
 
@@ -68,16 +72,19 @@ static inline void get_update_locks_for_
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
 
@@ -1817,26 +1824,17 @@ static const struct attribute_group *vfi
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
 
@@ -1879,18 +1877,15 @@ static void vfio_ap_mdev_unset_kvm(struc
 	struct kvm *kvm = matrix_mdev->kvm;
 
 	if (kvm && kvm->arch.crypto.crycbd) {
-		down_write(&kvm->arch.crypto.pqap_hook_rwsem);
-		kvm->arch.crypto.pqap_hook = NULL;
-		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
-
 		get_update_locks_for_kvm(kvm);
+		kvm->arch.crypto.pqap_hook = NULL;
 
 		kvm_arch_crypto_clear_masks(kvm);
 		vfio_ap_mdev_reset_queues(matrix_mdev);
-		kvm_put_kvm(kvm);
 		matrix_mdev->kvm = NULL;
 
 		release_update_locks_for_kvm(kvm);
+		kvm_put_kvm(kvm);
 	}
 }
 


