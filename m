Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F33101DE;
	Mon, 13 Oct 2025 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369004; cv=none; b=R+m6DER7fPeqSU7K3l1O5t+OXzoPTRVht+aZ/j/mN04Ky4Z/U68mmcxG3kKZs/gUKE4spFGcSY5KP7KVrcmIyGyAUlQKBV8vtJhaWRFBOzuEU7/8AzG1uTYfseUfEm+0rCdALCEMeqd/csZ0u3J3MsqpCkJsPouis3yrVSIsHC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369004; c=relaxed/simple;
	bh=1nqTXgdUz/+m1GqEO1VpPR5FdeFV4+8QhOXZfxKtBEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CqaZF10CHzmyPtqE2SLG8WvaAJ2Uvsb16z+PxDZ7NJ961krL8Z8YHgTzYutHv/qjKzCj2oD+v9KAH7+FejpNpIYQ+RwbJ5iaLMyJQhS7LAQN/8bBQjTvDQ/JIHEKumV+5oAHfsetQ35rgLH7uviLcAKX3iOiEsXPBbQXGa2KoGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fB8a/hp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fB8a/hp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B503BC4CEFE;
	Mon, 13 Oct 2025 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369004;
	bh=1nqTXgdUz/+m1GqEO1VpPR5FdeFV4+8QhOXZfxKtBEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fB8a/hp6PljwyLfjEco9SkyEffsYVeEF36mlpxe84Vyd7mAxq0iWQ/fnCFpiL4eQ0
	 RxqxCXE8whppyrTnjfmlDbu/IdbhIso9Rj/1YiQwwAgG542Vn5kwH804ot3LXYEEhl
	 KJvUyHwVL5Sa0ib8qjtGh8N0vTqyWx+9S8pyi2xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junnan Wu <junnan01.wu@samsung.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 061/563] firmware: arm_scmi: Mark VirtIO ready before registering scmi_virtio_driver
Date: Mon, 13 Oct 2025 16:38:42 +0200
Message-ID: <20251013144413.501277971@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junnan Wu <junnan01.wu@samsung.com>

[ Upstream commit e8faa8a466f61f4ae07069ed6b0872f602f1cba9 ]

After commit 20bda12a0ea0 (“firmware: arm_scmi: Make VirtIO transport a
standalone driver”), the VirtIO transport probes independently. During
scmi_virtio_probe, scmi_probe() is called, which intune invokes
scmi_protocol_acquire() that sends a message over the virtqueue and
waits for a reply.

Previously, DRIVER_OK was only set after scmi_vio_probe, in the core
virtio via virtio_dev_probe(). According to the Virtio spec (3.1 Device
Initialization):
  |  The driver MUST NOT send any buffer available notifications to the
  |  device before setting DRIVER_OK.

Some type-1 hypervisors block available-buffer notifications until the
driver is marked OK. In such cases, scmi_vio_probe stalls in
scmi_wait_for_reply(), and the probe never completes.

Resolve this by setting DRIVER_OK immediately after the device-specific
setup, so scmi_probe() can safely send notifications.

Note after splitting the transports into modules, the probe sequence
changed a bit. We can no longer rely on virtio_device_ready() being
called by the core in virtio_dev_probe(), because scmi_vio_probe()
doesn’t complete until the core SCMI stack runs scmi_probe(), which
immediately issues the initial BASE protocol exchanges.

Fixes: 20bda12a0ea0 ("firmware: arm_scmi: Make VirtIO transport a standalone driver")
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
Message-Id: <20250812075343.3201365-1-junnan01.wu@samsung.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/transports/virtio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/arm_scmi/transports/virtio.c b/drivers/firmware/arm_scmi/transports/virtio.c
index cb934db9b2b4a..326c4a93e44b9 100644
--- a/drivers/firmware/arm_scmi/transports/virtio.c
+++ b/drivers/firmware/arm_scmi/transports/virtio.c
@@ -871,6 +871,9 @@ static int scmi_vio_probe(struct virtio_device *vdev)
 	/* Ensure initialized scmi_vdev is visible */
 	smp_store_mb(scmi_vdev, vdev);
 
+	/* Set device ready */
+	virtio_device_ready(vdev);
+
 	ret = platform_driver_register(&scmi_virtio_driver);
 	if (ret) {
 		vdev->priv = NULL;
-- 
2.51.0



