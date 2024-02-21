Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA8D7CF08;
	Wed, 21 Feb 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525037; cv=none; b=NgqQ1mV0MQmN3m5mGeQmxwvxmCVFw/W+mBfqQaJb5FfqQzoc1iJ/Ax7vpaPbn/oZKyTb9suPTXYxWFnBpPjwXOe1099x3fuAP6jTQNEql9PvEH3D8wpwiYZIncLX7So7qbvViG7pedLxWJ1T+sysP9qRc+NPaIbeIyQ530w3U2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525037; c=relaxed/simple;
	bh=N2LFya0fl/sBaZoS4R5Xd9KqXk8GeplQN2SZ/I87D0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMa0m7/DVITT3PGpHU7wLUIO3tnP5WDNQqy1lexIAM++fjsD/djE4WZG4TdSIuUNNT9IqKnsn8glbYpgA1f/Ioi3C5rloggsuCXuCYOPyrNfmDfnLGXap9oEb8LTYKOngY9bZA4P5+Ojraj0rW3Mp05Q2G33Yy/wWDwSG1KJdcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHmz7uG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHmz7uG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D31C43390;
	Wed, 21 Feb 2024 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525037;
	bh=N2LFya0fl/sBaZoS4R5Xd9KqXk8GeplQN2SZ/I87D0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHmz7uG/ytk0YHpXRTTnIifhFm/o4gTMNxyGDESTl7mG2+PwsBEdK7enjbNf4u609
	 UUczTFzsp/wT8AZKq0iQkVRLliUZ0SOa4GePQZsUOQFZH+gJ8opAUD6GUkM+hgK6vN
	 2kHHP+H/9PFEXGgsEOcaGmrO6pkacbmvQKLwGFRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.4 013/267] rpmsg: virtio: Free driver_override when rpmsg_remove()
Date: Wed, 21 Feb 2024 14:05:54 +0100
Message-ID: <20240221125940.472799699@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit d5362c37e1f8a40096452fc201c30e705750e687 upstream.

Free driver_override when rpmsg_remove(), otherwise
the following memory leak will occur:

unreferenced object 0xffff0000d55d7080 (size 128):
  comm "kworker/u8:2", pid 56, jiffies 4294893188 (age 214.272s)
  hex dump (first 32 bytes):
    72 70 6d 73 67 5f 6e 73 00 00 00 00 00 00 00 00  rpmsg_ns........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000009c94c9c1>] __kmem_cache_alloc_node+0x1f8/0x320
    [<000000002300d89b>] __kmalloc_node_track_caller+0x44/0x70
    [<00000000228a60c3>] kstrndup+0x4c/0x90
    [<0000000077158695>] driver_set_override+0xd0/0x164
    [<000000003e9c4ea5>] rpmsg_register_device_override+0x98/0x170
    [<000000001c0c89a8>] rpmsg_ns_register_device+0x24/0x30
    [<000000008bbf8fa2>] rpmsg_probe+0x2e0/0x3ec
    [<00000000e65a68df>] virtio_dev_probe+0x1c0/0x280
    [<00000000443331cc>] really_probe+0xbc/0x2dc
    [<00000000391064b1>] __driver_probe_device+0x78/0xe0
    [<00000000a41c9a5b>] driver_probe_device+0xd8/0x160
    [<000000009c3bd5df>] __device_attach_driver+0xb8/0x140
    [<0000000043cd7614>] bus_for_each_drv+0x7c/0xd4
    [<000000003b929a36>] __device_attach+0x9c/0x19c
    [<00000000a94e0ba8>] device_initial_probe+0x14/0x20
    [<000000003c999637>] bus_probe_device+0xa0/0xac

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Fixes: b0b03b811963 ("rpmsg: Release rpmsg devices in backends")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231215020049.78750-1-xiaolei.wang@windriver.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -381,6 +381,7 @@ static void virtio_rpmsg_release_device(
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
 
+	kfree(rpdev->driver_override);
 	kfree(vch);
 }
 


