Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9238523EAAA;
	Tue, 25 Aug 2026 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666497; cv=none; b=rof6yqHrR1rIT23A/CJq36wYzyHGsKrq1L4zC0ObNaSadxX4ivJpZGnCIUuuKTk5EY6/ltomjlRxrhEQzUrwa/aDn5cKY2VY9Z1xmrUpgoAe2PomRXTPmieVnACMAi9qO/jZOJzkQQIGsWQXV40Ipcbip62q0XqNE9X4dWT8cz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666497; c=relaxed/simple;
	bh=Ee9Fy7nZsuGh+j3JZjqNcZrTiRh+CSH65wCXyFbvr7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeTRIiMivCTjyygHe0uq233A++1GYb5nZqTK3GVaLOPLe8Uw3dg4SvF5WtJRNyzxiQELn+A9O0cgtKJeBVrfmYH+YpPKVh4qryTczeOU+SQmi4aPwlhPO+4/8G8p4j70DEC3f2TAQxWwC2dr6jIp4nUw3Uqlvli6FIaHytjmY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F07evDDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F07evDDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8641F000E9;
	Tue, 25 Aug 2026 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666496;
	bh=EJZkpAjO9g/GCaOLuiqGcyy7mBVtb6Aprbkem5ovGrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F07evDDIq85vFdgMmx5cnTIwkEQkdme+wpsH4hPUV6PV+V5W03Bp66bXdpm8qyfTI
	 3RIVXUVqaloofPu1Ohz3flIXYbBwWXWBgkRI7pL1urjdlymISnhgzHMPzwwB1CFoJx
	 iTJxlDMbqqSuZNMCy1yA+gDQBbXTZsFqI9mwE9WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/57] s390/vfio_ccw: Cancel existing workqueues
Date: Tue, 25 Aug 2026 15:26:49 +0200
Message-ID: <20260825132542.373258366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 79c60b2c61105368dcc8444eb45847e21734f7c4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_drv.c |    7 +++++++
 drivers/s390/cio/vfio_ccw_ops.c |    8 ++++++++
 2 files changed, 15 insertions(+)

--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -241,6 +241,13 @@ static int vfio_ccw_sch_remove(struct su
 
 	vfio_ccw_sch_quiesce(sch);
 
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
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -204,6 +204,14 @@ static void vfio_ccw_mdev_release(struct
 	}
 
 	cp_free(&private->cp);
+
+	/*
+	 * Ensure these work items are drained, in the event the
+	 * device is re-opened instead of released.
+	 */
+	cancel_work_sync(&private->io_work);
+	cancel_work_sync(&private->crw_work);
+
 	vfio_ccw_unregister_dev_regions(private);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				 &private->nb);


