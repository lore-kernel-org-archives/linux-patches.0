Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE51C2DC792;
	Sat, 12 Sep 2026 11:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211742; cv=none; b=BznygDx8AZbKTOcBMCW3rfhDGU2WWbJCF33dYp1S7XXxYHatXi65kUMLkBujNTJ3O1sZ5v6xL7SCKyuhU7Hwqcq5IzSlykOaqvntPowdRBT3mNTMw7IYYpjWtgTG8UaDAwiogTnvYoqu0YhgpuorNesbYBiXRhYmPJUlhqQTE7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211742; c=relaxed/simple;
	bh=ifxvKQvtnkfRlJQW96khC8wu5ljb/fFz2Tt0glcJahs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0nKe5R/tF7evZwdv5n30ZbKaaK6wDz26R3p3lhbj2DGRLd8lAzgDJRZCGcZS08lSVuDTI954H58smP5tuQB7iQ6UwTbh4XEK6FKualZNmHBzrWxKrT9hbmcl/YD4Dzv2E+vB+ZRdn9trq8WvJAV2L6G/r/0b+dTV6D+fzyuyE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1i26QJvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i26QJvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C3E1F000FF;
	Sat, 12 Sep 2026 11:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211740;
	bh=Kd8P8sBN7GNtVPHwLupEzj8zH9zSeaRkFdtxx22egAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1i26QJvXRa7SjBx7hyG9TwKemWNrSQtlAd2lxucqwRl3J00ZsLprsfBV7G+Met+xf
	 dOC3QkYtr+2uH6RpdbqxN7u5RaOyXYpRAnkXTahmSwXF/WnZcTP44NcBMWctQT/Jb2
	 Dlc1Pbzqnv94cMe1u/kcQ087asLBkqPjyTM++FIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1294/1518] virtio_balloon: factor out virtballoon_quiesce()
Date: Sat, 12 Sep 2026 08:57:43 +0200
Message-ID: <20260912065652.788903942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Denis V. Lunev <den@openvz.org>

[ Upstream commit 29536a923a9412812eb3e378258019b54538a220 ]

virtballoon_remove() stops all of the balloon's asynchronous work (the
free page reporting worker, the inflate/deflate and stats workers, the
OOM notifier and the free page shrinker) before tearing the device
down. A following change needs the same teardown from a .shutdown
handler, so move it into a virtballoon_quiesce() helper.

No functional change.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260624140846.2616797-3-den@openvz.org>
Stable-dep-of: 7e17eef04600 ("virtio_balloon: quiesce balloon work before device shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 04c9b601ae4da..33d7dd240261d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1117,26 +1117,39 @@ static void remove_common(struct virtio_balloon *vb)
 	vb->vdev->config->del_vqs(vb->vdev);
 }
 
-static void virtballoon_remove(struct virtio_device *vdev)
+/*
+ * Stop all asynchronous balloon work. The device must still be alive so that
+ * in-flight requests can drain via the host before it is reset or freed.
+ */
+static void virtballoon_quiesce(struct virtio_balloon *vb)
 {
-	struct virtio_balloon *vb = vdev->priv;
+	struct virtio_device *vdev = vb->vdev;
 
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_REPORTING))
 		page_reporting_unregister(&vb->pr_dev_info);
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		unregister_oom_notifier(&vb->oom_nb);
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		virtio_balloon_unregister_shrinker(vb);
+
 	spin_lock_irq(&vb->stop_update_lock);
 	vb->stop_update = true;
 	spin_unlock_irq(&vb->stop_update_lock);
 	cancel_work_sync(&vb->update_balloon_size_work);
 	cancel_work_sync(&vb->update_balloon_stats_work);
 
-	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		cancel_work_sync(&vb->report_free_page_work);
+}
+
+static void virtballoon_remove(struct virtio_device *vdev)
+{
+	struct virtio_balloon *vb = vdev->priv;
+
+	virtballoon_quiesce(vb);
+
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
 		destroy_workqueue(vb->balloon_wq);
-	}
 
 	remove_common(vb);
 	kfree(vb);
-- 
2.53.0



