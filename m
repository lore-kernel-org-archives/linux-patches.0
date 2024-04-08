Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ED180039;
	Mon,  8 Apr 2024 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584803; cv=none; b=RSnQroSBsLhttvvtVSwwJ8LkiFY+oAg1HNKRvUIqUghFjzrPULZIstKm+7nensU1PiLpZzoa33TjitwNAO84Acn/6O5zS+Oz9RHdsXj55dkQCGGhdGjwd7zp04lTL7uvrdZ2ha6SGmt9JdKAgC0wDb4xQyQd7ZB7yGKfbLQJ2WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584803; c=relaxed/simple;
	bh=J9xC5gW2KoYFAhUw+B79OTfB6bcVW0VU9OPHAPakxJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOOL6vwImS6OMHDFxxHvRNpTBq03Eh42mKjb/lbotncYuDhF/fMMkUx78azjCOSQbFzWUuAyvFu0U6GZ1MY5zFJK3sRLj1u1mkJ5E2nSRFLGSMJWE/sEzFxfYz6jKUA84WC/c8I+bia9OEKw6kiYLjIcQiu9PjwSh4xqbUf76sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZ2/R9F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZ2/R9F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BAFC433F1;
	Mon,  8 Apr 2024 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584803;
	bh=J9xC5gW2KoYFAhUw+B79OTfB6bcVW0VU9OPHAPakxJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ2/R9F5k1YeOHFoNUcqKBJ6OoqlUv8cMWaDe6CLw4ofJSHWjsldtAefJTzx6ZMUN
	 e5un3Lvj0Bjg/ptMo8MrE1usCgRG2dJE0KVj/FeOsCGmq8hqaufQvkOiSxTDDVt2Mt
	 oVEpLFXK+re5/Qfav3r82Wuo2AmWomFnB316qsV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.15 563/690] vfio: Introduce interface to flush virqfd inject workqueue
Date: Mon,  8 Apr 2024 14:57:09 +0200
Message-ID: <20240408125420.030220993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -243,6 +243,7 @@ struct virqfd {
 	wait_queue_entry_t		wait;
 	poll_table		pt;
 	struct work_struct	shutdown;
+	struct work_struct	flush_inject;
 	struct virqfd		**pvirqfd;
 };
 
@@ -251,5 +252,6 @@ extern int vfio_virqfd_enable(void *opaq
 			      void (*thread)(void *, void *),
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */


