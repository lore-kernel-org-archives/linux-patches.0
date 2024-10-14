Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F7A24B34;
	Mon, 14 Oct 2024 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916734; cv=none; b=jsg6O9RBJKmeJSGKqJtwWqhDPg4eefOSck7R67uxakiw2h5UVbNJpfHLAoU4VES0m2A/AFXVPQDZdS6esYBZ6gu82QXrNKIY3lL/9tW51+uDV/ASpLFQpIJAGkdkWe0SIIREw6XHbb6RwbEslggZw4kIls0fAMhZ5CENAmTxxyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916734; c=relaxed/simple;
	bh=aP3/zuY/NDwxlmiOdwgEIN1hiJYo9ypqM7PgiLkWV7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYYxg0w1hXdl3wxyn6Nc/rR5XWgJYGAr9XmD1n38Hd0RkPaYgO26l+Q3rq+5LtiB0TpitTyP6dtMZhW7ibAOm5MeXvDFd3Ms9VpKnBEzjodmiruAJRtl7hgZ0CYhevCM8n+ii18oqURjVxtl2TA9EP/n3M3AHx6hj7zLh4J2MXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+TzBk9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+TzBk9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3F4C4CEC3;
	Mon, 14 Oct 2024 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916734;
	bh=aP3/zuY/NDwxlmiOdwgEIN1hiJYo9ypqM7PgiLkWV7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+TzBk9jyFXBPxq9WNL71dxTqPImx1M+tLKyi/KQtlCkqH2B4Z2K7q6H+qAC+q2hp
	 9QOXfpTxvEJQb4FxYkfqm7erv/w5Yi0XavqiR74EiP/431AxFM8cEVq4xoS4vEz1/t
	 iuRRfUmhrrSRIBR1GePjN9jr6rrdmjSU8MNQHZhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/213] virtio_console: fix misc probe bugs
Date: Mon, 14 Oct 2024 16:19:17 +0200
Message-ID: <20241014141044.984549589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit b9efbe2b8f0177fa97bfab290d60858900aa196b ]

This fixes the following issue discovered by code review:

after vqs have been created, a buggy device can send an interrupt.

A control vq callback will then try to schedule control_work which has
not been initialized yet. Similarly for config interrupt.  Further, in
and out vq callbacks invoke find_port_by_vq which attempts to take
ports_lock which also has not been initialized.

To fix, init all locks and work before creating vqs.

Message-ID: <ad982e975a6160ad110c623c016041311ca15b4f.1726511547.git.mst@redhat.com>
Fixes: 17634ba25544 ("virtio: console: Add a new MULTIPORT feature, support for generic ports")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 680d1ef2a2179..796ab9a4e48fa 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2052,25 +2052,27 @@ static int virtcons_probe(struct virtio_device *vdev)
 		multiport = true;
 	}
 
-	err = init_vqs(portdev);
-	if (err < 0) {
-		dev_err(&vdev->dev, "Error %d initializing vqs\n", err);
-		goto free_chrdev;
-	}
-
 	spin_lock_init(&portdev->ports_lock);
 	INIT_LIST_HEAD(&portdev->ports);
 	INIT_LIST_HEAD(&portdev->list);
 
-	virtio_device_ready(portdev->vdev);
-
 	INIT_WORK(&portdev->config_work, &config_work_handler);
 	INIT_WORK(&portdev->control_work, &control_work_handler);
 
 	if (multiport) {
 		spin_lock_init(&portdev->c_ivq_lock);
 		spin_lock_init(&portdev->c_ovq_lock);
+	}
 
+	err = init_vqs(portdev);
+	if (err < 0) {
+		dev_err(&vdev->dev, "Error %d initializing vqs\n", err);
+		goto free_chrdev;
+	}
+
+	virtio_device_ready(portdev->vdev);
+
+	if (multiport) {
 		err = fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
 		if (err < 0) {
 			dev_err(&vdev->dev,
-- 
2.43.0



