Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2A1CA8F;
	Mon,  1 Apr 2024 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987355; cv=none; b=X5ACxRdHxdFkegtr3b7ux9An29fyuKI3T+I+MoIGv/ABk6yIQ8b2455qFldWWjfWWs3kaJy3jGqFRJM2llXYHOM9yF9wpIlmLk6jD35NjVUx4RmC4tE57SG0UtjhI6lYYoZfKoULWUzr6UmLCBvGDhRemoe8YdcA2UrVO0xvgHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987355; c=relaxed/simple;
	bh=cYT3cLvuEmIH5GTFGnx1VgHFhbCxP82OFm6GhpOu4Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EI6G4YGikX/HildAkHCLGOA+3avEpQ+OAFTdnVWztnwIIVSO4uLcqa0JCbBo1P0/tGlgk8MLhK2CycIZucRBabcqMTMdtPrgUraXIbVDn4mmDI5K/NR4LYeqoc2xNAW6fqnvLCEk8SnCZq9q2TNiORO1zVkaLu8gkELywICLYmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2u33V79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2u33V79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FA4C433F1;
	Mon,  1 Apr 2024 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987355;
	bh=cYT3cLvuEmIH5GTFGnx1VgHFhbCxP82OFm6GhpOu4Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2u33V79iGH90F00uZIf7fqnWf1VWEjD2kgmGnjn1fkjNdvEEpFbJYJgnW+ukHpHA
	 Ewa4WAqwXG2g2tiA1ykjV5cb727bydlIYkC35Ds0LufDI3dHi4HnJUbcBeBKwbpoRT
	 +ej8cHuuDIYjOwYjyKrI+w/1+oB3jYrR5kDHKge4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 234/399] vfio: Introduce interface to flush virqfd inject workqueue
Date: Mon,  1 Apr 2024 17:43:20 +0200
Message-ID: <20240401152556.163910323@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/virqfd.c | 21 +++++++++++++++++++++
 include/linux/vfio.h  |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 29c564b7a6e13..5322691338019 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -101,6 +101,13 @@ static void virqfd_inject(struct work_struct *work)
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
@@ -213,3 +221,16 @@ void vfio_virqfd_disable(struct virqfd **pvirqfd)
 	flush_workqueue(vfio_irqfd_cleanup_wq);
 }
 EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
+
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
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 89b265bc6ec31..8b1a298204091 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -356,6 +356,7 @@ struct virqfd {
 	wait_queue_entry_t		wait;
 	poll_table		pt;
 	struct work_struct	shutdown;
+	struct work_struct	flush_inject;
 	struct virqfd		**pvirqfd;
 };
 
@@ -363,5 +364,6 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 		       void (*thread)(void *, void *), void *data,
 		       struct virqfd **pvirqfd, int fd);
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */
-- 
2.43.0



