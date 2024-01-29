Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17093F9F0;
	Mon, 29 Jan 2024 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548445; cv=none; b=hOcPBoAsvyrxUpgUC2UzxCRLJoM21K2g3WuP/H5pyX2SZk1v7s0B8RHomtgnyWbwSzv59w2UPFvY2kRbDUy9WgdV/W/VnOdbZoJg6YEecqQl239v7wBpQlzSuVrp8h7KgJ5GzySLTadqu/7SbSPrHeAvgp/6YaVJ1udMvs8YONM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548445; c=relaxed/simple;
	bh=Mo9oEm7Q1NagXdLzHR67/HWPghGbkQgq1aI8FNmY2oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lh0RgRPWAi64ZMH2iPJFrPCX8Rfxs6sl2I6u4j+R3HsBddFrvGRJCfrPVOY4jzaToMNVLYjtpolzetzR7HYYrv+Tq862YbztTCR1xMmRWPdcvRVEOS1e5xCTosyhZzsZzBK2crC6NEUuxBCDeWHr+ZMgfYeK7UjzBXQcfQPUt84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVRZy/2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVRZy/2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A49AC433C7;
	Mon, 29 Jan 2024 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548445;
	bh=Mo9oEm7Q1NagXdLzHR67/HWPghGbkQgq1aI8FNmY2oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVRZy/2rUsxxcUsWKfvyci2LftYPOgxMCxL8ByFva6hxSefb38j3IJrOe7JZ3gBYp
	 I/3AzJFupJHA0HHSZNIUYWGe8wvLLJFEXfeGIALO5snZpS6/jrI2O5i2PMojsPQye/
	 vnvrJd5Rm1NZBGwB+51HMJ7INEAi6mhylGw4qUiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 052/331] rpmsg: virtio: Free driver_override when rpmsg_remove()
Date: Mon, 29 Jan 2024 09:01:56 -0800
Message-ID: <20240129170016.454266706@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
@@ -378,6 +378,7 @@ static void virtio_rpmsg_release_device(
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
 
+	kfree(rpdev->driver_override);
 	kfree(vch);
 }
 


