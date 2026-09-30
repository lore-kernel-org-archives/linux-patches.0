Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E3752B1DE;
	Wed, 30 Sep 2026 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790046; cv=none; b=JljPqphHOdxHZk8gv/r3Gj587hkI8DryqXYWbu1xYTLHjmdlb+ZjSYeWqjQ9SwHcTIJVgzM7VqwPPB4W+ZDkZGXY2mac1DNMZjz6IOJ7r499rIkkxbfT3gLzqmhuehIKDr/2xk49nMNxkvFaBNXjfiergfg+hUfS1Q/bHbCm4R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790046; c=relaxed/simple;
	bh=gCBq5ZfZiNBjsGECyjWYPA5/W9OZ8Bxt0yqsVrEoSOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkXefuVgKL6LVRT4zeuh1l8x/Ki6nozdW9q0LtYYfutu5xsFgyVYpest4TesnL0M5lesiDwVOFq0cwCBT5NgmeBaHHAqrjKy1hMKwPIgKoLyciNlEUng5MyFbcwFPoCdkxuEaEywSTmjNibYKgGANhGHUDRYvy2ZSTuk8wPZ3G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaPqIb2B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaPqIb2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6431F000FF;
	Wed, 30 Sep 2026 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790045;
	bh=lSSIbT/+48HRGU5P/zRsbehWUTtGGj4UEPUMEd1MTCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaPqIb2BXwB2azmUV683O+FcaPQMq+h5PFmXhLP0ES2iZs0zJp9bxu4plNrlb6hs5
	 dBQbMoKGJimJfrnsEvDjItpIyr2hoyGIzKge9m92XHxHEZZchtF3pYWi1GgqIYOZPd
	 UP+iGQjnXDTyVwluzJysewWUmezcFCkNBwyskAW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 646/877] s390/vfio-ap: Fix missing lock required to access list of ap_matrix_mdev objects
Date: Wed, 30 Sep 2026 17:25:57 +0200
Message-ID: <20260930152428.599389600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit 7fa61c29850d05e40ca9ed41bfdf57673023f581 ]

In order to traverse or add/remove ap_matrix_mdev objects in the
matrix_dev->mdev_list, the matrix_dev->guests_lock mutex must be held.
There are two functions that access the list without holding the mutex:

vfio_ap_mdev_probe function
~~~~~~~~~~~~~~~~~~~~~~~~~~~
The vfio_ap_mdev_probe function uses the matrix_dev->mdevs_lock
mutex to guard the add of a newly created ap_matrix_mdev object to the
matrix_dev->mdev_list. This mutex does not protect list access; its purpose
is to guard against concurrent access to fields contained in an
ap_matrix_mdev object. This could lead to kernel memory corruption or
use-after-free if another mdev is created or removed concurrently.

The adding of an ap_matrix_mdev object to matrix_dev->mdev_list
is now guarded by the matrix_dev->guests_lock which is the correct
way to protect against concurrent mdev_list access.

Also removed the following two lines of code because the matrix_mdev is
allocated via vfio_alloc_device macro which uses kzalloc, so req_trigger
and cfg_chg_trigger are already zero-initialised when the struct is
allocated before the call to vfio_register_emulated_iommu_dev. This
prevents a window whereby these triggers are set to NULL after
the device is exposed to userspace.

matrix_mdev->req_trigger = NULL;
matrix_mdev->cfg_chg_trigger = NULL;

vfio_ap_mdev_for_queue function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The status_show function that supports display of the status attribute of
the devices in /sys/bus/ap/devices calls the vfio_ap_mdev_for_queue
function which iterates the matrix_dev->mdev_list to find the object
representing the queue device whose status is to be displayed. In order to
traverse this list, the matrix_dev->guests_lock mutex must be held.

To fix this, the guests_lock mutex is taken prior to taking the
matrix_dev->mdevs_lock mutex in the status_show function. It is taken
there rather than the vfio_ap_mdev_for_queue function - where it is
needed - because it must be taken prior to the mdevs_lock mutex in order to
adhere to the proper locking order and prevent a lockdep splat; also
because the mdevs_lock is needed there to access fields within
the matrix_mdev object in that function.

See the vfio-ap-locking.rst in the linux kernel tree.

Fixes: 2c1ee8983aa3 ("s390/vfio-ap: prepare for dynamic update of guest's APCB on queue probe/remove")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[ Omitted deletion of cfg_chg_trigger initialization because the field is absent in Linux 6.12. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -786,11 +786,17 @@ static int vfio_ap_mdev_probe(struct mde
 	ret = vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
 	if (ret)
 		goto err_put_vdev;
-	matrix_mdev->req_trigger = NULL;
+
+	/*
+	 * Take the matrix_dev->guests_lock mutex before adding the matrix_mdev
+	 * to the mdev_list. All functions that traverse the list must also hold
+	 * this lock to guard against additions to or removals from the list
+	 * while it is being traversed.
+	 */
+	mutex_lock(&matrix_dev->guests_lock);
 	dev_set_drvdata(&mdev->dev, matrix_mdev);
-	mutex_lock(&matrix_dev->mdevs_lock);
 	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
-	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 	return 0;
 
 err_put_vdev:
@@ -2247,6 +2253,8 @@ static struct ap_matrix_mdev *vfio_ap_md
 	unsigned long apid = AP_QID_CARD(q->apqn);
 	unsigned long apqi = AP_QID_QUEUE(q->apqn);
 
+	lockdep_assert_held(&matrix_dev->guests_lock);
+
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
 		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->matrix.aqm))
@@ -2266,6 +2274,7 @@ static ssize_t status_show(struct device
 	struct ap_matrix_mdev *matrix_mdev;
 	struct ap_device *apdev = to_ap_dev(dev);
 
+	mutex_lock(&matrix_dev->guests_lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
 
@@ -2314,6 +2323,7 @@ static ssize_t status_show(struct device
 
 done:
 	mutex_unlock(&matrix_dev->mdevs_lock);
+	mutex_unlock(&matrix_dev->guests_lock);
 
 	return nchars;
 }
@@ -2746,6 +2756,12 @@ static void vfio_ap_mdev_cfg_add(unsigne
 
 	vfio_ap_filter_apid_by_qtype(apm_add, aqm_add);
 
+	/*
+	 * It is safe to traverse this list here because the
+	 * required guard - matrix_dev->guests_lock - is taken in the
+	 * vfio_ap_on_cfg_changed function prior to this function getting
+	 * called.
+	 */
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
 		/*
 		 * The mdevs_lock must be held in order to access fields
@@ -2813,6 +2829,10 @@ void vfio_ap_on_cfg_changed(struct ap_co
 	if (!cur_cfg_info || !prev_cfg_info)
 		return;
 
+	/*
+	 * Take the guests_lock mutex here to guard access to the
+	 * matrix_dev->mdev_list in the two functions called below.
+	 */
 	mutex_lock(&matrix_dev->guests_lock);
 
 	vfio_ap_mdev_on_cfg_remove(cur_cfg_info, prev_cfg_info);


