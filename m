Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75936233722;
	Wed,  9 Sep 2026 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963593; cv=none; b=ngEwqVfqDFAdravsyWM+JQpciNimA9IOQ+ChbcZWWsjeH5SvnVX0L9wV0oBJ/+gDbm3gXw8meC38qmyqiqD1ZL0SLy6KYzXcgnlP167Jxz2a/p6mJluRmTr/vTHmBorpnpGEPYwznxaCw+ITDolBMvx4szJEBNGMI6Fq1jkkrRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963593; c=relaxed/simple;
	bh=M/xmyOD1GEk1HvpAIVzILBucqF8rEzFP/DgTTci688g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YApSr1sKGUOxRh54kanlXEvWav4h3HoLS+iyENpEdKR5OsZh+09AtdqG91jWAnI2276TcCADdSibP/Aczd9dpeEGiB2hzFcQ2zApuQWtJ9raasbQc3mfKgZxCoWGsHHMixQB4uxt4B92aN1mCc1jmw15TkPusIt0MYUjORdmPjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4WyC/q3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4WyC/q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAB91F00A3A;
	Wed,  9 Sep 2026 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963592;
	bh=QPKN7QKJtqlH98bG1oTGTxQjji5NiScdP8uARJRxTCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4WyC/q3K/0/cgjJcSgeSiG+wSRf3p1IlRzTY7SgpNnTVv8OJmAVKG/edHKJjfdRK
	 qF+k29GArM9OsJ6uE5INCXRq7UkxWHpd8cOqEYvJYn1CwoJD92Udh1dqNWxpj8O2hx
	 SgrErqKj+/0cPM3HV2Faxe+1KjnzsVBuelSgeQs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 133/583] s390/vfio-ap: Fix NULL deref in status_show() during queue probe
Date: Wed,  9 Sep 2026 15:36:58 +0200
Message-ID: <20260909134242.748911957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2321,6 +2321,23 @@ static ssize_t status_show(struct device
 	mutex_lock(&matrix_dev->guests_lock);
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
@@ -2345,6 +2362,7 @@ static ssize_t status_show(struct device
 		nchars = sysfs_emit(buf, "%s\n", AP_QUEUE_UNASSIGNED);
 	}
 
+done:
 	mutex_unlock(&matrix_dev->mdevs_lock);
 	mutex_unlock(&matrix_dev->guests_lock);
 
@@ -2419,14 +2437,17 @@ void vfio_ap_mdev_unregister(void)
 
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
@@ -2434,11 +2455,10 @@ int vfio_ap_mdev_probe_queue(struct ap_d
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
@@ -2467,8 +2487,13 @@ done:
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


