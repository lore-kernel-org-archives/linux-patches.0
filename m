Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB6B377016;
	Thu, 20 Aug 2026 15:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239015; cv=none; b=f0hOyNuJVEECRd0wmERGK4lk2P5Z3goF5fFa+dNlRuQMXgLdEHScsCHLAprB3weVzfs6Gl++yY9IM4dGyvHqRuU+9C2xhx0ROUHaruPhT/gJ/i0bmGWLPxWgI69R9YsfP+nP2qfgO+VWdEMTdz4tpNMz/I0eeXgRMPnyGZ71r+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239015; c=relaxed/simple;
	bh=BCHm6SEtMmLF+sC1YcxUPjSbGSkYiBhNXyNSpypEffM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFoDhpBKdd/rtWqMsG3Xp1qX2+DCn9KyZ4PfzxC0J6/1H8EC5Ds50YMqU5V2GrTHgtiYMx2hHuoSCeFzlcU7bAF0FchQr87WYCnxZE16Hryai2oBvnPgnoHxCjyb+89ufNiYoar91D51jyHHtvNjy7xCEOXHadYSOc3kzL7EXtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swZxXXbI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swZxXXbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155061F000E9;
	Thu, 20 Aug 2026 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239014;
	bh=5KkhYAE1xQXvnTprFZoYXz7k5NkRnRXiRC3mtbZ/ypQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=swZxXXbIuAQZvLXP/8sBTBn4eYA/Ek+5Pd1S+ak5IfdaGIvUmSL0tNZdRuz4rcrMv
	 XR+p00FFtxiSe3eFuOOMejXUqY1aB9OCOH+rTNamwvpSsrl/NZSURUxsSqYArGI/C7
	 oEdkzbkIbVlZNkipvNp2ouxXNO0OIL0xvpdmEKbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 081/217] s390/vfio_ccw: Cancel existing workqueues
Date: Thu, 20 Aug 2026 16:54:09 +0200
Message-ID: <20260820145240.065168633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit 79c60b2c61105368dcc8444eb45847e21734f7c4 upstream.

The initialization of the io_work and crw_work workqueues begs the
question of whether they should be un-initialized. Add the corresponding
cleanup tags in _release_dev to ensure work isn't dispatched after
the private struct is free'd.

Suggested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Fixes: e5f84dbaea59 ("vfio: ccw: return I/O results asynchronously")
Fixes: 3f02cb2fd9d2 ("vfio-ccw: Wire up the CRW irq and CRW region")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_ops.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -132,6 +132,13 @@ static void vfio_ccw_mdev_release_dev(st
 		container_of(vdev, struct vfio_ccw_private, vdev);
 	struct vfio_ccw_crw *crw, *temp;
 
+	/*
+	 * Ensure these work items are fully drained, so none can
+	 * fire after being released.
+	 */
+	cancel_work_sync(&private->io_work);
+	cancel_work_sync(&private->crw_work);
+
 	list_for_each_entry_safe(crw, temp, &private->crw, next) {
 		list_del(&crw->next);
 		kfree(crw);
@@ -203,6 +210,14 @@ static void vfio_ccw_mdev_close_device(s
 		container_of(vdev, struct vfio_ccw_private, vdev);
 
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_CLOSE);
+
+	/*
+	 * Ensure these work items are drained, in the event the
+	 * device is re-opened instead of released.
+	 */
+	cancel_work_sync(&private->io_work);
+	cancel_work_sync(&private->crw_work);
+
 	vfio_ccw_unregister_dev_regions(private);
 }
 


