Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AE0146D79;
	Thu, 11 Apr 2024 10:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831995; cv=none; b=fdlyyxNpiuZFAa3CFXLAA2/PDzpH1JI6NkJklux7L2jeMnoVdUW2r6qVLEahfckmpCojJdisTGEWvgiz2+POUQRCvgqemvWUAn/FpoWkVkAJn4tEuk/YrjDfG7wEOr0UPdANsohS6Rdkw5hF9K+TGtF3W+xcxYWcqzSPjXrZaQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831995; c=relaxed/simple;
	bh=ftXOChC5Q2TqTGdFEsw2ZivveBC2QFLLFAtvvivM4Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/f18NIGmhr8xl3PC2PeVLg40Z9Um2f+5YxFOYbh00JM0zrAXhAj61+B+4fM7YIF1VY0ijuTn2mWA9RMkeqL57IIHKzCicejHdyNCWmN3jRdyScutn4k1vt/SIvA9I8c8mtGBRsKt0u+L470kB0cRYMeXgAYA+p68bfuLBwfV7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J43IvUT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J43IvUT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F86C433F1;
	Thu, 11 Apr 2024 10:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831995;
	bh=ftXOChC5Q2TqTGdFEsw2ZivveBC2QFLLFAtvvivM4Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J43IvUT8Sg155OsS5meveDRVLXktURgTBXtlKuAYivz7CCUQgqAqocgoiuTEym8iT
	 dwP/EqjlV+3L8YcJkN4vRSTBzxYyIzJ7lvw/dd8y8vyQrpUU7quGZb+JHadZ0eTNKi
	 rzgqNo9+jE/noBQ7qqntq80wCAVF11qwLESwf3d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.10 197/294] vfio: Introduce interface to flush virqfd inject workqueue
Date: Thu, 11 Apr 2024 11:56:00 +0200
Message-ID: <20240411095441.540551128@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -101,6 +101,13 @@ static void virqfd_inject(struct work_st
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
@@ -124,6 +131,7 @@ int vfio_virqfd_enable(void *opaque,
 
 	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
 	INIT_WORK(&virqfd->inject, virqfd_inject);
+	INIT_WORK(&virqfd->flush_inject, virqfd_flush_inject);
 
 	irqfd = fdget(fd);
 	if (!irqfd.file) {
@@ -214,6 +222,19 @@ void vfio_virqfd_disable(struct virqfd *
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
@@ -221,6 +221,7 @@ struct virqfd {
 	wait_queue_entry_t		wait;
 	poll_table		pt;
 	struct work_struct	shutdown;
+	struct work_struct	flush_inject;
 	struct virqfd		**pvirqfd;
 };
 
@@ -229,5 +230,6 @@ extern int vfio_virqfd_enable(void *opaq
 			      void (*thread)(void *, void *),
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */


