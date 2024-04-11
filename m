Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D6B146D51;
	Thu, 11 Apr 2024 10:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830859; cv=none; b=hVo1epAy90E9AGoTPXoXTjJMjnQ2XuxLp695p+tZTjRM24QSRfxr6xnBjJ0LSAT1RobAQuE2y6Iuf2sfP/z5rQV/FbaPd+JJlS9lvwEKSEJaJCniO86ij2fmSUXvf8HxL4tKqkGFSEtsQsTbzjw/aEQaKVzS30RS9cWjS0KxzfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830859; c=relaxed/simple;
	bh=dhUG2HVpUFG/mP557MV4aAUsMLg3GONRODGuU7joths=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2DemTkNZdR1bx4ktRQESLg4PKm/VN1XggX/jtqZ48UnROzJp3EamgEEqa1ITgzu/jIC018pqKdLvHVRlxC1tJ9z22tbNqBQk3giM7PunKSvUDZcfIXhfC6IhIW/mMlX9MhC7UfVyDzSUPBNuJgsy6f/B0TKoZIuN2hAFajzoFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g09x7pQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g09x7pQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97FFC43390;
	Thu, 11 Apr 2024 10:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830859;
	bh=dhUG2HVpUFG/mP557MV4aAUsMLg3GONRODGuU7joths=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g09x7pQPRWRnF0usnbYUzylPAx7OlKUACXOd+pVlWt4JcnzgkltHN0a18VmjK4REv
	 ovr8tZgOHo52VYDBm7Y+B13oDy7bvIwZFzh1xMqSR6V9PqqAdOq5Ydk1NgOO3Gs8Af
	 ApfORV6kBtuUueQ1CQZ+xGAenE6zUlQZiPqUL74Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.4 141/215] vfio: Introduce interface to flush virqfd inject workqueue
Date: Thu, 11 Apr 2024 11:55:50 +0200
Message-ID: <20240411095429.131070244@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -186,6 +186,7 @@ struct virqfd {
 	wait_queue_entry_t		wait;
 	poll_table		pt;
 	struct work_struct	shutdown;
+	struct work_struct	flush_inject;
 	struct virqfd		**pvirqfd;
 };
 
@@ -194,5 +195,6 @@ extern int vfio_virqfd_enable(void *opaq
 			      void (*thread)(void *, void *),
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */


