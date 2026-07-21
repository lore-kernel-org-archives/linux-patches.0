Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB710372050;
	Tue, 21 Jul 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649581; cv=none; b=Z2hq/A67SKyYGiIiAbGwDV8g8oV2nufXFo7FmR5e9jlzcrujOoKcJHkbKn3u6XjRcaYBC1DqBgwnqKgFEwO3nlyvpxRR9ghkWvV82DF2j77Y/UShNXQRK+QIQObfiLwAcOOkUqOWrl/ujTGXp/nDgaqZjE0F5Wbq0lKXuSdNYyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649581; c=relaxed/simple;
	bh=+kA8PpnwwdZTt4NfL4sheKXlDM6I677ojrhiPfb3qys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBNapt6i9oAejHEO+gPE+2781LYAwBUGsQaxSRpD0HP7+r1cjpk8i0KX6ftf6mTqtSukaLxqa6j049f33k9jqkcfPBEmnHNTPcY5NHdUvecjFL42y56yoBoGlPY/Wgq8PUwVoL1V8aXmYl5TzIRFHAAblKljcRCTe5xjb6QyIL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iw4EbrXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iw4EbrXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44E91F000E9;
	Tue, 21 Jul 2026 15:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649580;
	bh=nG998MvClr0jLIXWGHsopsBUsElxaU8lvXGZPyMhaAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iw4EbrXvMCUBxPRVGbANynpiHMkZl1pRfHvhR6Aazk6dK1KUxc5fJ7961kxp8FSLj
	 cu2mzypFXCRJserXTVmjOS8uNqKJKz1JtJrmA1/RWK24V1SGgFlwuWy7cuwP9MFVXE
	 wD4fCC1NIOfeQhK6emKbYXLlTd3jLH6vzKafGGoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filip Hejsek <filip.hejsek@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0631/2077] virtio_console: read size from config space during device init
Date: Tue, 21 Jul 2026 17:05:04 +0200
Message-ID: <20260721152607.692244399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a33217c68d9d8..198b9731416803 100644
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
@@ -2052,6 +2060,8 @@ static int virtcons_probe(struct virtio_device *vdev)
 	__send_control_msg(portdev, VIRTIO_CONSOLE_BAD_ID,
 			   VIRTIO_CONSOLE_DEVICE_READY, 1);
 
+	update_size_from_config(portdev);
+
 	return 0;
 
 free_chrdev:
-- 
2.53.0



