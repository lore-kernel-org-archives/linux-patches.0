Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C7481B8;
	Mon,  1 Apr 2024 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991229; cv=none; b=RgzRnpNEKpwRWXLciG5Ppi2VGYs5mCj9xuu9NX0ZM7OwBUfdL7rEu9g8gGkQLnXx8UpzhgNVSA7KygoS67MqVrpMcSFKnYj3PH6VLNehQair6lJXH9AcT2OPJow7A0gfGR7wIExROi7gVMWEOzK4D5z2PDCpYlTfVV7BNImaX0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991229; c=relaxed/simple;
	bh=QU7JZRYgQL719AtTI7T3v5B7dFEV7KVv0U3uhYphbJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx1PdbppXM+/3MG6wXRdj/48n7kobW52SpfIZ/eMBBueePeVjsYsJk4vOgP2y8mh2xWW+FRf6yM57qrwvYEt6YZh/N6KKThhoz4c9x48OAVRqQBq7R8+igPZg17MBGten60MJ00kvNv8c0L44shCi7YvMbKVsC8DnMZZ4JsRHs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmf20pQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmf20pQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5296EC433F1;
	Mon,  1 Apr 2024 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991228;
	bh=QU7JZRYgQL719AtTI7T3v5B7dFEV7KVv0U3uhYphbJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmf20pQ3wpcmPzZYoACaVFpgwRkb+n94vgejutnanwyFxxoAPjw25B1VsyQmYlFdo
	 DtGP69ip0zxRMl6Ugru3rU3dRgSeGYCvSwDyKEmBvwp6SlnWzwwXS1/vaKcY4TVkXz
	 4N2ePZOt6h/PQEOAWTPrwe5MYzZTikv/3/ho41qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.1 201/272] vfio: Introduce interface to flush virqfd inject workqueue
Date: Mon,  1 Apr 2024 17:46:31 +0200
Message-ID: <20240401152537.170064562@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit b620ecbd17a03cacd06f014a5d3f3a11285ce053 ]

In order to synchronize changes that can affect the thread callback,
introduce an interface to force a flush of the inject workqueue.  The
irqfd pointer is only valid under spinlock, but the workqueue cannot
be flushed under spinlock.  Therefore the flush work for the irqfd is
queued under spinlock.  The vfio_irqfd_cleanup_wq workqueue is re-used
for queuing this work such that flushing the workqueue is also ordered
relative to shutdown.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-4-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/virqfd.c |   21 +++++++++++++++++++++
 include/linux/vfio.h  |    2 ++
 2 files changed, 23 insertions(+)

--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -104,6 +104,13 @@ static void virqfd_inject(struct work_st
 		virqfd->thread(virqfd->opaque, virqfd->data);
 }
 
+static void virqfd_flush_inject(struct work_struct *work)
+{
+	struct virqfd *virqfd = container_of(work, struct virqfd, flush_inject);
+
+	flush_work(&virqfd->inject);
+}
+
 int vfio_virqfd_enable(void *opaque,
 		       int (*handler)(void *, void *),
 		       void (*thread)(void *, void *),
@@ -127,6 +134,7 @@ int vfio_virqfd_enable(void *opaque,
 
 	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
 	INIT_WORK(&virqfd->inject, virqfd_inject);
+	INIT_WORK(&virqfd->flush_inject, virqfd_flush_inject);
 
 	irqfd = fdget(fd);
 	if (!irqfd.file) {
@@ -217,6 +225,19 @@ void vfio_virqfd_disable(struct virqfd *
 }
 EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
 
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&virqfd_lock, flags);
+	if (*pvirqfd && (*pvirqfd)->thread)
+		queue_work(vfio_irqfd_cleanup_wq, &(*pvirqfd)->flush_inject);
+	spin_unlock_irqrestore(&virqfd_lock, flags);
+
+	flush_workqueue(vfio_irqfd_cleanup_wq);
+}
+EXPORT_SYMBOL_GPL(vfio_virqfd_flush_thread);
+
 module_init(vfio_virqfd_init);
 module_exit(vfio_virqfd_exit);
 
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -268,6 +268,7 @@ struct virqfd {
 	wait_queue_entry_t		wait;
 	poll_table		pt;
 	struct work_struct	shutdown;
+	struct work_struct	flush_inject;
 	struct virqfd		**pvirqfd;
 };
 
@@ -275,5 +276,6 @@ int vfio_virqfd_enable(void *opaque, int
 		       void (*thread)(void *, void *), void *data,
 		       struct virqfd **pvirqfd, int fd);
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */


