Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD4569942;
	Wed, 21 Feb 2024 13:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523665; cv=none; b=Myk8CioRpIkPlUQ0JjBCHvkaOx1EcPRYMQhBTkYvU8qyeXqZ1wDfPW7xWdHyd6ED/RHDAvZQhsthZ00VffsJnuNwrWJZRgWM5vnWBPkvsAwCP5HNrYvDDcIPKOmaBwxLpGzsw7n20v2Up4N+KFhs7YKIta7anBb9DqiJRZFdWpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523665; c=relaxed/simple;
	bh=bb5HGLmJw5ZM+cRsxrqqd3nP4T4mrEnPuiXcVKjvwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJPl/SHoK+bKa0P92CiBudeTVVFAazlz3lialm2pqlOvJS1rMH8NO1I2GsEB8zeXyjouQd2v3WVohtHTZ5+URaxVt2ONymPhfB0iAoo3w6fXV+xSROAOGhnQkBw5Tp1J7ZNlh/b0/46LDxaAgtnHqjpDfocxX/vs74BhNM95dp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvo+S8F4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvo+S8F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA5DC433F1;
	Wed, 21 Feb 2024 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523664;
	bh=bb5HGLmJw5ZM+cRsxrqqd3nP4T4mrEnPuiXcVKjvwO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvo+S8F4q/PyONO8IuvmUiujm5U+NZjKozhi0gd4pL4TLOHXzuhtgdTAZlpVuPCaa
	 fmaHd8mmVVYSGqbkln0LMcx1BXImlTzsFeJ1dlsl3BnvbpSw+mOhYOMSX1Wdere80Y
	 Cu154UPx2b9rz5Z8b02SfyNhJupQ15ZqBz0Qw6Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 022/379] rpmsg: virtio: Free driver_override when rpmsg_remove()
Date: Wed, 21 Feb 2024 14:03:21 +0100
Message-ID: <20240221125955.575329864@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -387,6 +387,7 @@ static void virtio_rpmsg_release_device(
 	struct rpmsg_device *rpdev = to_rpmsg_device(dev);
 	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
 
+	kfree(rpdev->driver_override);
 	kfree(vch);
 }
 


