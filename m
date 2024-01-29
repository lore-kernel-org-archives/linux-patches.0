Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD39B157041;
	Mon, 29 Jan 2024 17:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548040; cv=none; b=f3OzGjkt6V7XP4qvyuuaiCK6UEpJaS80XJz9eQQNwZh59FFte9gDskFbRfy7x8UheZNRQlOd0HcRL+hWRK0O/dKjDmYdQLynpUujQ9raPgeDp2FcpXmfClkGjcXNGvGDC//osdI1qgLUXLLm7ENW1lLCCJd44Y5L9je8Zii7E+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548040; c=relaxed/simple;
	bh=vfDr4bAEVgH/+aLlfEDdOrU7hSb94UIZt1O+Yi7NOso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fetHt83C6a4B6T7HNioLVyz4qXb6HRQTAbNw5ZDwatqsCZCvSs06nUutWLSI3aNxbH5xmoI1hwd1Cl/b+rWRdTmH83otSuGgaHxUyGdjmWMpoMg6bNTRtQoQtKQTt+S5F4wIcLK6xCz1/PQ6eV8jkaJCwAyuBovuQmaVwRJpgvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z+FU0N5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z+FU0N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9269AC433F1;
	Mon, 29 Jan 2024 17:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548040;
	bh=vfDr4bAEVgH/+aLlfEDdOrU7hSb94UIZt1O+Yi7NOso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Z+FU0N5BgHitnXdB/ORwMpnuw4WhxszJI9IE+s8v/GFrN/pniN4kgUZ7JDi1xMWw
	 /Z7kgqgDFT5LeyeVCyPKXAGuGW9WfQJfh0OzXPMPoX/ncJaL34+zoNgm4/+F1ea9tr
	 clRbONN8BaDgu0Xwbrq2oF7G4cAlp27zt0MHy+/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.7 040/346] s390/vfio-ap: reset queues associated with adapter for queue unbound from driver
Date: Mon, 29 Jan 2024 09:01:11 -0800
Message-ID: <20240129170017.563244329@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Krowiak <akrowiak@linux.ibm.com>

commit f009cfa466558b7dfe97f167ba1875d6f9ea4c07 upstream.

When a queue is unbound from the vfio_ap device driver, if that queue is
assigned to a guest's AP configuration, its associated adapter is removed
because queues are defined to a guest via a matrix of adapters and
domains; so, it is not possible to remove a single queue.

If an adapter is removed from the guest's AP configuration, all associated
queues must be reset to prevent leaking crypto data should any of them be
assigned to a different guest or device driver. The one caveat is that if
the queue is being removed because the adapter or domain has been removed
from the host's AP configuration, then an attempt to reset the queue will
fail with response code 01, AP-queue number not valid; so resetting these
queues should be skipped.

Acked-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Fixes: 09d31ff78793 ("s390/vfio-ap: hot plug/unplug of AP devices when probed/removed")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240115185441.31526-6-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |   76 ++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 35 deletions(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -936,45 +936,45 @@ static void vfio_ap_mdev_link_adapter(st
 				       AP_MKQID(apid, apqi));
 }
 
+static void collect_queues_to_reset(struct ap_matrix_mdev *matrix_mdev,
+				    unsigned long apid,
+				    struct list_head *qlist)
+{
+	struct vfio_ap_queue *q;
+	unsigned long  apqi;
+
+	for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS) {
+		q = vfio_ap_mdev_get_queue(matrix_mdev, AP_MKQID(apid, apqi));
+		if (q)
+			list_add_tail(&q->reset_qnode, qlist);
+	}
+}
+
+static void reset_queues_for_apid(struct ap_matrix_mdev *matrix_mdev,
+				  unsigned long apid)
+{
+	struct list_head qlist;
+
+	INIT_LIST_HEAD(&qlist);
+	collect_queues_to_reset(matrix_mdev, apid, &qlist);
+	vfio_ap_mdev_reset_qlist(&qlist);
+}
+
 static int reset_queues_for_apids(struct ap_matrix_mdev *matrix_mdev,
 				  unsigned long *apm_reset)
 {
-	struct vfio_ap_queue *q, *tmpq;
 	struct list_head qlist;
-	unsigned long apid, apqi;
-	int apqn, ret = 0;
+	unsigned long apid;
 
 	if (bitmap_empty(apm_reset, AP_DEVICES))
 		return 0;
 
 	INIT_LIST_HEAD(&qlist);
 
-	for_each_set_bit_inv(apid, apm_reset, AP_DEVICES) {
-		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
-				     AP_DOMAINS) {
-			/*
-			 * If the domain is not in the host's AP configuration,
-			 * then resetting it will fail with response code 01
-			 * (APQN not valid).
-			 */
-			if (!test_bit_inv(apqi,
-					  (unsigned long *)matrix_dev->info.aqm))
-				continue;
-
-			apqn = AP_MKQID(apid, apqi);
-			q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
+	for_each_set_bit_inv(apid, apm_reset, AP_DEVICES)
+		collect_queues_to_reset(matrix_mdev, apid, &qlist);
 
-			if (q)
-				list_add_tail(&q->reset_qnode, &qlist);
-		}
-	}
-
-	ret = vfio_ap_mdev_reset_qlist(&qlist);
-
-	list_for_each_entry_safe(q, tmpq, &qlist, reset_qnode)
-		list_del(&q->reset_qnode);
-
-	return ret;
+	return vfio_ap_mdev_reset_qlist(&qlist);
 }
 
 /**
@@ -2200,24 +2200,30 @@ void vfio_ap_mdev_remove_queue(struct ap
 	matrix_mdev = q->matrix_mdev;
 
 	if (matrix_mdev) {
-		vfio_ap_unlink_queue_fr_mdev(q);
-
 		apid = AP_QID_CARD(q->apqn);
 		apqi = AP_QID_QUEUE(q->apqn);
-
-		/*
-		 * If the queue is assigned to the guest's APCB, then remove
-		 * the adapter's APID from the APCB and hot it into the guest.
-		 */
+		/* If the queue is assigned to the guest's AP configuration */
 		if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
 		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm)) {
+			/*
+			 * Since the queues are defined via a matrix of adapters
+			 * and domains, it is not possible to hot unplug a
+			 * single queue; so, let's unplug the adapter.
+			 */
 			clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
 			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
+			reset_queues_for_apid(matrix_mdev, apid);
+			goto done;
 		}
 	}
 
 	vfio_ap_mdev_reset_queue(q);
 	flush_work(&q->reset_work);
+
+done:
+	if (matrix_mdev)
+		vfio_ap_unlink_queue_fr_mdev(q);
+
 	dev_set_drvdata(&apdev->device, NULL);
 	kfree(q);
 	release_update_locks_for_mdev(matrix_mdev);


