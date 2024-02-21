Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306BD3EA71;
	Wed, 21 Feb 2024 13:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521178; cv=none; b=c7sBUme5vHIp7Wc87dFKkjpGe7NLpDmJsIcIGIE+l2ncxE8MqzX4/Wa1goX8NA929H4SrWcRXfXBJgMTTmHXn3PWEO8HfvFsYIBVt9tfiXVekzfsy0KXx2qa7AJoJ/2TJK7bB6OBsC134e5Ft7sNxUe03J475z+mBFb+FvafPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521178; c=relaxed/simple;
	bh=vGx8kJwmUGufOyjjoHjLciJekjPGVyxf6tXVugxQFzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nx7SI26VEt5mhLzUckozoojLzRx9QPMPWtNAdUQhyhqgzK2ojHMabWKedsZzYgNROkgPowPPU2T0LRk5eagCUxL27mHdZv8pYBtdiJW5GssvviHkDdaLb46Eau0EyhoJhC1s1FKJRm9/vP1NngR5zNsSeQyOft/+kiNFZ1NRYc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQ+T69k+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQ+T69k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3EFC433C7;
	Wed, 21 Feb 2024 13:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521178;
	bh=vGx8kJwmUGufOyjjoHjLciJekjPGVyxf6tXVugxQFzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQ+T69k+HZuXpzXLB2gdkSN6JPYkZj9Xg4wGCXdok6YiUQL/sqlPxWTv/9C+W0fzB
	 VFuAaxVgIGV/Sd7F22nEl9KGfGw4frwDPkfOlOgMlEH/n009sJbt2N3klvXedwJob4
	 u6t/+OmQdGzqKq7FI+UMIUPWO5zwTXdIRCPleimM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 014/202] rpmsg: virtio: Free driver_override when rpmsg_remove()
Date: Wed, 21 Feb 2024 14:05:15 +0100
Message-ID: <20240221125932.217791421@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 


