Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6130346EC8D;
	Tue, 21 Jul 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656567; cv=none; b=ufJWSzJVp8xMk8OsY1sl2fk5dZJu5U0JoPWr9xIuECxXM34/Geu0bFiOh7fZ/ZwMPL0ZLtomH/JuAGfdP70NP/EnGlo/+P0UL+dA0sxaZw3fptK+EEhQqgtPzrOepSo+10ENjY1kAoPu72UPokgU2u6C+RE/urpx6nAA/ZsfywQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656567; c=relaxed/simple;
	bh=fX7R5IGOc1D6w8sx0sP/lpAtjwLs93xJJ19qPaYVetA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPh3hVii3SC30d0NpK0ftZrV98oS4bZoD7WcfPG0DUqvGgh1K5JJUyjeHZlCmukbfB6Opf0Cw5PivUOlQDYZpjgy1rrmWBRV811cq3uFSwLS06e3ssZlOEfjyoFYAr5yzmEo/IdT6yU5gJP1CYCQAPL1BhIVg/xO00MZVa690mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHQ+/f8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHQ+/f8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EE51F000E9;
	Tue, 21 Jul 2026 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656566;
	bh=OHeYUBuP/LhrtvgwA28LKt8kX+Xrs3NAgTOrwjAFYVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHQ+/f8uHGAEUdON1BIdffj4O6rpXmPfHY/i3C1xZc4Gws2uiHbyboCWSpshss6iD
	 bJ3s0Eoc/SGpHWfFECUuubSf25LAlHu7R2SXxxGb1sW5GFJEyIJXo989CvfwJH1QDb
	 u2oa76dX3Wgpb5Bhgigmf5JtagE1A54dOLSP89Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filip Hejsek <filip.hejsek@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0437/1611] virtio_console: read size from config space during device init
Date: Tue, 21 Jul 2026 17:09:13 +0200
Message-ID: <20260721152525.114421631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Filip Hejsek <filip.hejsek@gmail.com>

[ Upstream commit b3592a32b34f37874dc94aa1a0d15c4334ed86ca ]

Previously, the size was only read upon receiving the config interrupt.
This interrupt is sent when the size changes. However, we also need to
read the initial size.

Also make sure to only read the size from config if F_SIZE is enabled.

Fixes: 9778829cffd4 ("virtio: console: Store each console's size in the console structure")
Signed-off-by: Filip Hejsek <filip.hejsek@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260223-virtio-console-fix-v1-1-0cf08303b428@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 52 +++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 088182e54debd6..c355f6d3927481 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1771,32 +1771,40 @@ static void config_intr(struct virtio_device *vdev)
 		schedule_work(&portdev->config_work);
 }
 
-static void config_work_handler(struct work_struct *work)
+static void update_size_from_config(struct ports_device *portdev)
 {
-	struct ports_device *portdev;
+	struct virtio_device *vdev;
+	struct port *port;
+	u16 rows, cols;
 
-	portdev = container_of(work, struct ports_device, config_work);
-	if (!use_multiport(portdev)) {
-		struct virtio_device *vdev;
-		struct port *port;
-		u16 rows, cols;
+	vdev = portdev->vdev;
 
-		vdev = portdev->vdev;
-		virtio_cread(vdev, struct virtio_console_config, cols, &cols);
-		virtio_cread(vdev, struct virtio_console_config, rows, &rows);
+	/*
+	 * We'll use this way of resizing only for legacy support.
+	 * For multiport devices, use control messages to indicate
+	 * console size changes so that it can be done per-port.
+	 *
+	 * Don't test F_SIZE at all if we're rproc: not a valid feature.
+	 */
+	if (is_rproc_serial(vdev) ||
+	    use_multiport(portdev) ||
+	    !virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
+		return;
 
-		port = find_port_by_id(portdev, 0);
-		set_console_size(port, rows, cols);
+	virtio_cread(vdev, struct virtio_console_config, cols, &cols);
+	virtio_cread(vdev, struct virtio_console_config, rows, &rows);
 
-		/*
-		 * We'll use this way of resizing only for legacy
-		 * support.  For newer userspace
-		 * (VIRTIO_CONSOLE_F_MULTPORT+), use control messages
-		 * to indicate console size changes so that it can be
-		 * done per-port.
-		 */
-		resize_console(port);
-	}
+	port = find_port_by_id(portdev, 0);
+	set_console_size(port, rows, cols);
+	resize_console(port);
+}
+
+static void config_work_handler(struct work_struct *work)
+{
+	struct ports_device *portdev;
+
+	portdev = container_of(work, struct ports_device, config_work);
+	update_size_from_config(portdev);
 }
 
 static int init_vqs(struct ports_device *portdev)
@@ -2054,6 +2062,8 @@ static int virtcons_probe(struct virtio_device *vdev)
 	__send_control_msg(portdev, VIRTIO_CONSOLE_BAD_ID,
 			   VIRTIO_CONSOLE_DEVICE_READY, 1);
 
+	update_size_from_config(portdev);
+
 	return 0;
 
 free_chrdev:
-- 
2.53.0



