Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C471E1337;
	Wed,  6 Nov 2024 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898630; cv=none; b=h3vew1Krfzbrepz4tISiHXl91ryfkAkTXY0hX/l+3In+xAqlftx2AnR8C3pdjI7OjQxN6IDM9aMGQEyIk3fnnIAHWnTNny22F6f/ZIQH3HAIOH1prixtjpOId6G+rzXBeNn0UcCteMiQWlG1itqLkmMUiMEJ7s23NgaK5L9yvzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898630; c=relaxed/simple;
	bh=u/G2fQJkd/5vrrL+Y8+21zWM3CfnUvmZJff5VrnuUuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIAgFW9+nHQ1pnssGRMi/7nMHrTQSEnSN90+JKB6rbyHuz5QLXwDATpCAANwrYZ4v+S2z/Bupgb1tca6n+cbYAze7BsoJS7nXIMz2eyhNaxX4yoVZ1nUm67TOxxU76zztBGmIRYCc3bM9XDfw39pMOwPuzjOduna2F6W94D+nEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcZHxZae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcZHxZae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68A4C4CECD;
	Wed,  6 Nov 2024 13:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898630;
	bh=u/G2fQJkd/5vrrL+Y8+21zWM3CfnUvmZJff5VrnuUuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcZHxZaeQ+x+mkIgYR8AE/TFfVusmlz719xqesyDKwXN/U6gDuHkNC4sxG+/+xLO2
	 y2Kvt/vwF9JDEOpwaavPh+GeD0AXTjqgj+gD4mvOXiiyMWz0sNMMHb4cgoU0HLsxHv
	 xNiJq9C2d+Alc+u9QAA8t97Ig638tdzZfWGaxUQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 301/462] virtio_console: fix misc probe bugs
Date: Wed,  6 Nov 2024 13:03:14 +0100
Message-ID: <20241106120338.965395407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
index c736adef9d3c8..8cba4c2513736 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2051,25 +2051,27 @@ static int virtcons_probe(struct virtio_device *vdev)
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



