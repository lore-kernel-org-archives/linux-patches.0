Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC5A2F24;
	Mon, 23 Jun 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684833; cv=none; b=AFg9Ab7ubI9odcjtsBK/sVYYW496WX0KQf4gCdV2z8dxN8pTuTttjRR7jCeBd4ZpFx4SZ1aWHvh2lEh7amEUMcpQ+wHk8Gg+45Q6OS34jtkYWAVuCU1Hh7REZ1CABIF1+YHjsdrZzocqZ6BXnuW9r7j7PTJYiB/Wb08Ia4Ul9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684833; c=relaxed/simple;
	bh=lzx5UeC7EPT4ssBrpAvffaI1fLijvYec7q0fqKZBYVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMhGSq2ak5J102KO5p43IH9eMf2GhUL6TWXvDIC8Welk0Rc+1nkdX2kERETT4h/Tvy29L0Y/wQzQOcLyRvp04DC3hGXJsk5xXHaA41apei1hvPsilJf5+iVMJqABJXlzhhAKukZ7XEeDXZGnepsJ9uQfEHxbFp/lqVhUpvU208c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIiBJHQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIiBJHQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E369C4CEEA;
	Mon, 23 Jun 2025 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684833;
	bh=lzx5UeC7EPT4ssBrpAvffaI1fLijvYec7q0fqKZBYVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIiBJHQqD46R8d1VnzjHCYaNusQ2JTeNIk6i/EWtd4NHXJPl80YeD8TwmK0m1kVWw
	 BqZ3SnoCDzk3Y+PrINwHwqIYWZKNHNKBbDDFF2NvZ7H6KQn7j9UIh4C7bR95w1NJpN
	 TPLeCZOzaT5L16LekQknTliTrUodeCt7dcC0EtMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3b6b9ff7b80430020c7b@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/222] net: usb: aqc111: fix error handling of usbnet read calls
Date: Mon, 23 Jun 2025 15:06:12 +0200
Message-ID: <20250623130613.015002999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 405b0d610745fb5e84fc2961d9b960abb9f3d107 ]

Syzkaller, courtesy of syzbot, identified an error (see report [1]) in
aqc111 driver, caused by incomplete sanitation of usb read calls'
results. This problem is quite similar to the one fixed in commit
920a9fa27e78 ("net: asix: add proper error handling of usb read errors").

For instance, usbnet_read_cmd() may read fewer than 'size' bytes,
even if the caller expected the full amount, and aqc111_read_cmd()
will not check its result properly. As [1] shows, this may lead
to MAC address in aqc111_bind() being only partly initialized,
triggering KMSAN warnings.

Fix the issue by verifying that the number of bytes read is
as expected and not less.

[1] Partial syzbot report:
BUG: KMSAN: uninit-value in is_valid_ether_addr include/linux/etherdevice.h:208 [inline]
BUG: KMSAN: uninit-value in usbnet_probe+0x2e57/0x4390 drivers/net/usb/usbnet.c:1830
 is_valid_ether_addr include/linux/etherdevice.h:208 [inline]
 usbnet_probe+0x2e57/0x4390 drivers/net/usb/usbnet.c:1830
 usb_probe_interface+0xd01/0x1310 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x4d1/0xd90 drivers/base/dd.c:658
 __driver_probe_device+0x268/0x380 drivers/base/dd.c:800
...

Uninit was stored to memory at:
 dev_addr_mod+0xb0/0x550 net/core/dev_addr_lists.c:582
 __dev_addr_set include/linux/netdevice.h:4874 [inline]
 eth_hw_addr_set include/linux/etherdevice.h:325 [inline]
 aqc111_bind+0x35f/0x1150 drivers/net/usb/aqc111.c:717
 usbnet_probe+0xbe6/0x4390 drivers/net/usb/usbnet.c:1772
 usb_probe_interface+0xd01/0x1310 drivers/usb/core/driver.c:396
...

Uninit was stored to memory at:
 ether_addr_copy include/linux/etherdevice.h:305 [inline]
 aqc111_read_perm_mac drivers/net/usb/aqc111.c:663 [inline]
 aqc111_bind+0x794/0x1150 drivers/net/usb/aqc111.c:713
 usbnet_probe+0xbe6/0x4390 drivers/net/usb/usbnet.c:1772
 usb_probe_interface+0xd01/0x1310 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:-1 [inline]
...

Local variable buf.i created at:
 aqc111_read_perm_mac drivers/net/usb/aqc111.c:656 [inline]
 aqc111_bind+0x221/0x1150 drivers/net/usb/aqc111.c:713
 usbnet_probe+0xbe6/0x4390 drivers/net/usb/usbnet.c:1772

Reported-by: syzbot+3b6b9ff7b80430020c7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3b6b9ff7b80430020c7b
Tested-by: syzbot+3b6b9ff7b80430020c7b@syzkaller.appspotmail.com
Fixes: df2d59a2ab6c ("net: usb: aqc111: Add support for getting and setting of MAC address")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://patch.msgid.link/20250520113240.2369438-1-n.zhandarovich@fintech.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/aqc111.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index b958e00058820..44bf74b23c0f3 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -30,10 +30,13 @@ static int aqc111_read_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
 	ret = usbnet_read_cmd_nopm(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR |
 				   USB_RECIP_DEVICE, value, index, data, size);
 
-	if (unlikely(ret < 0))
+	if (unlikely(ret < size)) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		netdev_warn(dev->net,
 			    "Failed to read(0x%x) reg index 0x%04x: %d\n",
 			    cmd, index, ret);
+	}
 
 	return ret;
 }
@@ -46,10 +49,13 @@ static int aqc111_read_cmd(struct usbnet *dev, u8 cmd, u16 value,
 	ret = usbnet_read_cmd(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR |
 			      USB_RECIP_DEVICE, value, index, data, size);
 
-	if (unlikely(ret < 0))
+	if (unlikely(ret < size)) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		netdev_warn(dev->net,
 			    "Failed to read(0x%x) reg index 0x%04x: %d\n",
 			    cmd, index, ret);
+	}
 
 	return ret;
 }
-- 
2.39.5



