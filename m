Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AB837DE83;
	Thu, 20 Aug 2026 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238300; cv=none; b=hUnVAZeUnUKfPHa/ojBTdDBZUOsx/4lWKosNAZirRpvCB44JtPTP3l6/6FwD5WKU+yaQyE27JBHsk15Iq7thVQHvzOIBGe9wWfawEX6kcOVhIv5fcTeWNFM/6XQEiN7DDCL4BeC3PnCf+7Wfml4Wj4OO7/Rg4pWbE/MH1BWOxoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238300; c=relaxed/simple;
	bh=kF6FWVpg2xJhSg45h2asr93GhVngRgeEfGlOtJOGCWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smIoAVWSu6SQSE3XdQHbmG3Q3HsyKy2v6pTzNE+CrkQ3RQkwWhKah0VS0jz0WGp3u5nJGuiZA/IDLAqSEra7b56BArZU+w9Pkl6ssOqO1eH/TNUJzf9HNB/M2IoxxZCK4yyfLswehFEEMqhxXH1f67s0nnrfOTYexahL13t0ghE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wryexfgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wryexfgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED951F000E9;
	Thu, 20 Aug 2026 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238299;
	bh=NO/dGLhIsw3xpwsFY+U7jcxxh3MSq1m810gtVtty5hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wryexfgAvggrMjOyEK6GcZeWXVsdc7QUOjA5HQjwd4aH2gOZJKcqKgyjceyH22hCV
	 +/hLVDUjIkveaTsPQqcCWcjkLY2lqRjeE8pIYfxWXJWCGkB8KHoUCORjUr+z6g3pq7
	 oy2fqI4DqjfxDVq66ul/FYA6dATMOJbHoIocfizM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.1 097/228] s390/vfio_ccw: Cancel existing workqueues
Date: Thu, 20 Aug 2026 16:53:59 +0200
Message-ID: <20260820145247.601314004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,6 +131,13 @@ static void vfio_ccw_mdev_release_dev(st
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
@@ -202,6 +209,14 @@ static void vfio_ccw_mdev_close_device(s
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
 


