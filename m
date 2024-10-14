Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADADE1AAE00;
	Mon, 14 Oct 2024 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919705; cv=none; b=Yb6PEG3Dih2wAO6rs4mLdY7BoWuoc88Cd5jf6ITAkyXhMqE40MmzbbaSyur5QZxwVORieUF0lPYar90hgoljockeDJ90pzWNRxFC5+bUW1dCP3ifYKV6D11fHmDLvqL7FEvWlZUOQro0EluD9aQQMiHFUwx462laN8LSrvZi0wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919705; c=relaxed/simple;
	bh=m8Hkxij51fWIW/1wDyWbwKxSdeaRJVJQWdbychv/XZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ2EzYsZJslSZKwWtyFzSojLsGAoQF2AMN673x5SOthFCHSWkYe060sIBT2t+SGXfc7I9eJnNopftiaTf+lR0gqua0yby4BohSx5oCFKWGPmmhDDSWOHFbQUYYyvfTgHQLqTZ2+fmeyCY7ztIZnSIJY8ODqDoIuaHofapTNHrO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRGM2tcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRGM2tcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D58FC4CECF;
	Mon, 14 Oct 2024 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919705;
	bh=m8Hkxij51fWIW/1wDyWbwKxSdeaRJVJQWdbychv/XZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRGM2tcuBBEG0X386Mb942PWKAfJc/FkH/vsTyZMBbgkk0ULnd70pBO4UXTlPK0/p
	 7hmCa2GO1rdsi00qkz71/ahvNxMQrS5sLd5keSqa6AF+wHehZHeVR0gqN5/P6w1AXA
	 2UhlkogfcOu0ZLAvm5IxFR11+QJC8l6F6oR3hPUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 684/798] virtio_console: fix misc probe bugs
Date: Mon, 14 Oct 2024 16:20:38 +0200
Message-ID: <20241014141244.942410616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9fa3c76a267f5..899036ce3802c 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2055,25 +2055,27 @@ static int virtcons_probe(struct virtio_device *vdev)
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



