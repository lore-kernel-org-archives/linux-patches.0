Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282FE3264D4;
	Sat, 12 Sep 2026 13:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221481; cv=none; b=ZngeUYcmsgDbPR5MdU/deGlhH0XVkkPcErNZE28acRlECGEZ4kdfy0Stq/klkC0gaMJ+Pcjhb/tQCaV24Ps3Zo/3V8rymoaAo9aX+jyLJWN0Ux51NIvHlDrtETsvVXps4Rv1oWI/84XgCg+69iO1zQMvTp3u5v18bAaYr8WmbtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221481; c=relaxed/simple;
	bh=c/8St5PS3O+FRXevt7YWObJhGM6RUmBthBaCp36dWLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1X1Q++LiieJ/VzNats5TF+lu7RmYCujxYu1kfsbdb5QSUqiRC335v2/taQLxZIZCd/Q+SVZH9ILtKnjoT9kc70nK0gvCWcxQ5TnphBbMYiIv+6bLUuUcGXLdYMA4PU7jyeknbioib9YUvWjuSkXkLUsjWkAWna3UGuYBQ+RMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVHFpnzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVHFpnzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD751F000FF;
	Sat, 12 Sep 2026 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221480;
	bh=nl0ij++fOz/M2TbBIAwboqEYyplkF/xlS2UMwvMJ5VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVHFpnzwjLFlpJhbSJJ86yBQKo6exvF13WmV7VSVBz8QFLzdEFo4TWtRN8U/g8/TS
	 EYq2qoUeMgyUB2PggwxWJAVao1iHB8vW3pRAHAJub/YQI0WXiDo63B0OHCoNoZ3GKR
	 SzNSCNMytiB9HZ5/PFQ+EPvPqF8Ex1d3yX5TIhyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.6 0389/1424] s390/vfio-ap: Fix NULL deref in status_show() during queue probe
Date: Sat, 12 Sep 2026 08:47:01 +0200
Message-ID: <20260912065616.003593850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

commit dd6f4ef6f8a37412909ad787c837332fb070159c upstream.

When vfio_ap_mdev_probe_queue() creates the sysfs attribute group,
the queue's driver data has not yet been set. A concurrent read of
the 'status' attribute can therefore call dev_get_drvdata() and
get NULL, which is then passed directly to
vfio_ap_mdev_for_queue() where q->apqn is unconditionally
dereferenced, causing a NULL pointer dereference.

Fix this by acquiring the update locks before calling
sysfs_create_group(). The status_show() function acquires
guests_lock before reading the driver data, so any concurrent
read will block until after dev_set_drvdata() has been called
and the update locks are released.

As a bonus, the APQN no longer needs to be read from the queue
struct after allocation — it can be read directly from apdev
before allocation and stored in a local variable, which is then
assigned to q->apqn once the allocation succeeds.

Fixes: 260f3ea141382 ("s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2065,6 +2065,23 @@ static ssize_t status_show(struct device
 
 	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
+
+	/*
+	 * Make sure the drvdata has been set before proceeding. There is a
+	 * possibility that the drvdata was not set if the vfio_ap_queue object
+	 * could not be allocated when the queue device was probed. In that case,
+	 * the locks used in vfio_ap_mdev_probe_queue() are released prior to
+	 * removing the sysfs status attribute to avoid a lockdep
+	 * splat. That opens a very small window where the status attribute is
+	 * still available without the vfio_ap_queue object having been
+	 * stored in the device drvdata. In that case, indicate the queue is not
+	 * assigned.
+	 */
+	if (!q) {
+		nchars = sysfs_emit(buf, "%s\n", AP_QUEUE_UNASSIGNED);
+		goto done;
+	}
+
 	matrix_mdev = vfio_ap_mdev_for_queue(q);
 
 	/* If the queue is assigned to the matrix mediated device, then
@@ -2092,6 +2109,7 @@ static ssize_t status_show(struct device
 				   AP_QUEUE_UNASSIGNED);
 	}
 
+done:
 	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
@@ -2165,14 +2183,17 @@ void vfio_ap_mdev_unregister(void)
 
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
-	int ret;
+	int ret, apqn;
 	struct vfio_ap_queue *q;
 	DECLARE_BITMAP(apm_filtered, AP_DEVICES);
 	struct ap_matrix_mdev *matrix_mdev;
 
+	apqn = to_ap_queue(&apdev->device)->qid;
+	matrix_mdev = get_update_locks_by_apqn(apqn);
+
 	ret = sysfs_create_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	if (ret)
-		return ret;
+		goto err_release_locks;
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q) {
@@ -2180,11 +2201,10 @@ int vfio_ap_mdev_probe_queue(struct ap_d
 		goto err_remove_group;
 	}
 
-	q->apqn = to_ap_queue(&apdev->device)->qid;
+	q->apqn = apqn;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 	memset(&q->reset_status, 0, sizeof(q->reset_status));
 	INIT_WORK(&q->reset_work, apq_reset_check);
-	matrix_mdev = get_update_locks_by_apqn(q->apqn);
 
 	if (matrix_mdev) {
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
@@ -2213,8 +2233,13 @@ done:
 	return ret;
 
 err_remove_group:
+	release_update_locks_for_mdev(matrix_mdev);
 	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	return ret;
+
+err_release_locks:
+	release_update_locks_for_mdev(matrix_mdev);
+	return ret;
 }
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)


