Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FED846D098;
	Tue, 21 Jul 2026 19:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662058; cv=none; b=jAdk3EG/VIeY01idOPK5Agj42XmHhA25wZAT3myeN0kKA/OewfDNBMGnWYTlpwJERNp0Gz8XVvUD7ogO0tPiT9TJCOX7Vbj4/ofS1PH+PmvsxqdoKD4r5xOeqGH0NNigXxRX0/jd5dF8mP4LA0UML+jNnQRgN70J7F2fgPhmp3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662058; c=relaxed/simple;
	bh=Q6odDrlqLzR6Ec/c4nvqJQPTNnqOskL3KAKYiH9NDOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRI6zcNtJiZENexDuJVbIZ6Y+vtN5IxNM2OCs2sXMROFHAtTFKkFoGts/pD9urvlJrg7ug6jUKG9CrX6+iByyRbEkuzhMaUGCLgPU2yiyLOpadq77AM8SuWR/uscH+bBlHGnRx3DlGS7+1XDFsEgOzO7P1YydAYv/CR71npwIFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCaICrfA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCaICrfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EB81F000E9;
	Tue, 21 Jul 2026 19:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662056;
	bh=xkLJ7OonKainav+xlM3tE+UfuUfrA4S/DgUWbGn+f/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCaICrfA86Ky4p0M6lAbk2qlNpfUV3LA/11flkvrpUMuVB7iRlDaFPrkdfuoEDMwu
	 70tuXuE5HvctvXF7A9Oq+3upQ8HWC2KMgzwxG2e8WxrKxQ2kOxqBafmCS1sHySpcwC
	 xeYZhAN+r9L1R0GUvp1GhGs46z5NUn0AnOekP0Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filip Hejsek <filip.hejsek@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0300/1276] virtio_console: read size from config space during device init
Date: Tue, 21 Jul 2026 17:12:23 +0200
Message-ID: <20260721152452.808861696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c4e2b1e3de0ed..8765e8fcb68a7e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1774,32 +1774,40 @@ static void config_intr(struct virtio_device *vdev)
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
@@ -2057,6 +2065,8 @@ static int virtcons_probe(struct virtio_device *vdev)
 	__send_control_msg(portdev, VIRTIO_CONSOLE_BAD_ID,
 			   VIRTIO_CONSOLE_DEVICE_READY, 1);
 
+	update_size_from_config(portdev);
+
 	return 0;
 
 free_chrdev:
-- 
2.53.0



