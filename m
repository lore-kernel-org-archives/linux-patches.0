Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2D841F35E;
	Sat, 12 Sep 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211746; cv=none; b=G2NRo1o4c5Uh2Unl/aUXiFRRGc8gMVF3Z7QZvPKzx2TR4Vgzma3phFZ1LRzOXsPASR3EzOYbjJvMtbVXFb2exGFDFXzR2tYBi1YtjsrTNTFGmuXMdqcLOb8bOdGDm3HrgLzQHiQ3ch0M1CiYG16goHBmF4n7K+gxto64OWLzdR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211746; c=relaxed/simple;
	bh=kweF7JaJcYkKv4FvFyVXyjZ0PJJz0K7S99KrJnNRTzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyF2lHNUlWAroUwyiKfZ0QXnI0UpSa0S3dMaH1OSGmGoOf3mIZt6kMH5XX7J8LyBo+I7iIQEXEmcT8ow090bPLikmgtNkq4x8GVAXkcg8GpFdRi/lpiQ/qabFQ3FDrwAhWdxqgrW4XrcxJrFAqUj+SexiBux3utkccnqJLFZ/8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5ftEwOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5ftEwOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D41F000FF;
	Sat, 12 Sep 2026 11:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211745;
	bh=8mG7IhG5bBp919AelW9X4eLxrCmihziZEAbSnfd8DYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5ftEwOOB/05HQVlR9r23BRxgsvi6ekMv6nQBByOv9MrjZ22bI0GX5Bti3i7Iy3Vd
	 yMRfFt95ZXd0v7DluLF00ngvw1OYO1GtVm0fjqK0q9RIDKqUsHyLXK8JiVUZL9xOiG
	 F0VsS6+H389v+AhXNyv4nnRnkfDj5gwRO25qL4XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1295/1518] virtio_balloon: quiesce balloon work before device shutdown
Date: Sat, 12 Sep 2026 08:57:44 +0200
Message-ID: <20260912065652.811614240@linuxfoundation.org>
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

[ Upstream commit 7e17eef04600c399c7e0f5ce765da5cf9d40d8e1 ]

Commit 8bd2fa086a04 ("virtio: break and reset virtio devices on
device_shutdown()") added a generic virtio bus .shutdown handler that
breaks and resets every virtio device during device_shutdown(), i.e. on
reboot and kexec.

virtio_balloon provides no .shutdown of its own, so that generic path
runs while the balloon's asynchronous work is still armed. Once the
device has been broken, virtqueue_add_inbuf() in
virtballoon_free_page_report() returns -EIO and trips its
WARN_ON_ONCE(). On a kernel booted with panic_on_warn that turns an
ordinary reboot, for example a kexec based upgrade, into a fatal panic
in the middle of device_shutdown(), so the machine never reaches the
new kernel.

Relaxing that single WARN_ON_ONCE() would only hide the symptom: the
inflate/deflate and OOM paths do not warn, they call
wait_event(vb->acked, ...) and would instead block forever on a broken
queue that can no longer complete. The device has to be quiesced, not
just kept quiet.

Add a .shutdown handler that quiesces the balloon via the shared
virtballoon_quiesce() helper while the device is still alive, and only
then breaks and resets it via virtio_device_shutdown(). Unlike
virtballoon_remove() the balloon workqueue is not destroyed, as shutdown
does not free the device and cancel_work_sync() together with stop_update
already prevent any further work from being queued.

Fixes: 8bd2fa086a04 ("virtio: break and reset virtio devices on device_shutdown()")
Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260624140846.2616797-4-den@openvz.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 33d7dd240261d..a3995e77a652c 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1155,6 +1155,12 @@ static void virtballoon_remove(struct virtio_device *vdev)
 	kfree(vb);
 }
 
+static void virtballoon_shutdown(struct virtio_device *vdev)
+{
+	virtballoon_quiesce(vdev->priv);
+	virtio_device_shutdown(vdev);
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int virtballoon_freeze(struct virtio_device *vdev)
 {
@@ -1225,6 +1231,7 @@ static struct virtio_driver virtio_balloon_driver = {
 	.validate =	virtballoon_validate,
 	.probe =	virtballoon_probe,
 	.remove =	virtballoon_remove,
+	.shutdown =	virtballoon_shutdown,
 	.config_changed = virtballoon_changed,
 #ifdef CONFIG_PM_SLEEP
 	.freeze	=	virtballoon_freeze,
-- 
2.53.0



