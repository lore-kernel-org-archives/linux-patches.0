Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F30A28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2305C4339E;
	Mon, 30 Jan 2023 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087526;
	bh=jKlW4LFOkRfjr9FgQUkl/DDEvgE7gUWf2ejCbe95XAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaFuxaGsWqZiJEbtlVjHDQLymozLrm5fjX4T19mPwI1ycr6uk8wySnamVTxOpPpjn
	 GM9GOifHzEqyUiV/sfOdo2eSRvcqItRZFly53D0gpTd30BlkMaOBQRyyvRTvpnRG3e
	 JUtKvwKqMM9gk5mAtk4prxx0iA6dfqKBqYhSBWl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/313] kvm/vfio: Fix potential deadlock on vfio group_lock
Date: Mon, 30 Jan 2023 14:50:43 +0100
Message-Id: <20230130134346.380794077@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 51cdc8bc120ef6e42f6fb758341f5d91bc955952 ]

Currently it is possible that the final put of a KVM reference comes from
vfio during its device close operation.  This occurs while the vfio group
lock is held; however, if the vfio device is still in the kvm device list,
then the following call chain could result in a deadlock:

VFIO holds group->group_lock/group_rwsem
  -> kvm_put_kvm
   -> kvm_destroy_vm
    -> kvm_destroy_devices
     -> kvm_vfio_destroy
      -> kvm_vfio_file_set_kvm
       -> vfio_file_set_kvm
        -> try to hold group->group_lock/group_rwsem

The key function is the kvm_destroy_devices() which triggers destroy cb
of kvm_device_ops. It calls back to vfio and try to hold group_lock. So
if this path doesn't call back to vfio, this dead lock would be fixed.
Actually, there is a way for it. KVM provides another point to free the
kvm-vfio device which is the point when the device file descriptor is
closed. This can be achieved by providing the release cb instead of the
destroy cb. Also rename kvm_vfio_destroy() to be kvm_vfio_release().

	/*
	 * Destroy is responsible for freeing dev.
	 *
	 * Destroy may be called before or after destructors are called
	 * on emulated I/O regions, depending on whether a reference is
	 * held by a vcpu or other kvm component that gets destroyed
	 * after the emulated I/O.
	 */
	void (*destroy)(struct kvm_device *dev);

	/*
	 * Release is an alternative method to free the device. It is
	 * called when the device file descriptor is closed. Once
	 * release is called, the destroy method will not be called
	 * anymore as the device is removed from the device list of
	 * the VM. kvm->lock is held.
	 */
	void (*release)(struct kvm_device *dev);

Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20230114000351.115444-1-mjrosato@linux.ibm.com
Link: https://lore.kernel.org/r/20230120150528.471752-1-yi.l.liu@intel.com
[aw: update comment as well, s/destroy/release/]
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/vfio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 495ceabffe88..9584eb57e0ed 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -336,7 +336,7 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 	return -ENXIO;
 }
 
-static void kvm_vfio_destroy(struct kvm_device *dev)
+static void kvm_vfio_release(struct kvm_device *dev)
 {
 	struct kvm_vfio *kv = dev->private;
 	struct kvm_vfio_group *kvg, *tmp;
@@ -355,7 +355,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 	kvm_vfio_update_coherency(dev);
 
 	kfree(kv);
-	kfree(dev); /* alloc by kvm_ioctl_create_device, free by .destroy */
+	kfree(dev); /* alloc by kvm_ioctl_create_device, free by .release */
 }
 
 static int kvm_vfio_create(struct kvm_device *dev, u32 type);
@@ -363,7 +363,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type);
 static struct kvm_device_ops kvm_vfio_ops = {
 	.name = "kvm-vfio",
 	.create = kvm_vfio_create,
-	.destroy = kvm_vfio_destroy,
+	.release = kvm_vfio_release,
 	.set_attr = kvm_vfio_set_attr,
 	.has_attr = kvm_vfio_has_attr,
 };
-- 
2.39.0



