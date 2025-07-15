Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37D32D028A;
	Tue, 15 Jul 2025 13:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586348; cv=none; b=cdmvhTqZvlptek/VJsc+4FovN1AWgwEuBOewnVt8Yz53jBGAe6Oj3lFGTdYcsVBTYnfjcYQmcDOGlEqihGbBQHsfsfBP37N9SjqgIHYuWPEbbPamwCoky4Edjb2dBuudvqIl3d3zufwy14fgR+oo63Xm9LE+ZAvikPmu4xeUw8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586348; c=relaxed/simple;
	bh=WqZw3pLo4oAGeBxxnd/yHvLTxDqKQllXD/R0dEOjhXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaLsqMzilneexHKsVXz5O3PIfxSGgTkLv5lk5X0d0s7RN964lh6u4cGT6DO9AxXgoS7X1JXnvoFCz5lna09QrPfVufRDCV1nhOSxbl4s9B/9t48KO8iLLkQM5sKVPJxe6chRQl3eQBJusk7zQDVgDG3YM6Y2seM/cLbdV9eYCek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jy9fZzog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jy9fZzog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF9BC4CEE3;
	Tue, 15 Jul 2025 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586348;
	bh=WqZw3pLo4oAGeBxxnd/yHvLTxDqKQllXD/R0dEOjhXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jy9fZzogfFG3DqmIAJoUejnB3mM7tWaFMF2BwwTbcOJYNBXuIxzMGBt02CudEIN43
	 wp5+Ke1C7rl+7cVlZLKXUhIl//nMc4k9Azozg+7Ft2wnkh/zhjC6IVDqtsS/ZK8oZA
	 uu2n95liJa2YSQm/9G70CIcicriYOHGZOH+96En4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+526bd95c0ec629993bf3@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/148] media: cxusb: no longer judge rbuf when the write fails
Date: Tue, 15 Jul 2025 15:12:32 +0200
Message-ID: <20250715130801.521410502@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 73fb3b92da84637e3817580fa205d48065924e15 ]

syzbot reported a uninit-value in cxusb_i2c_xfer. [1]

Only when the write operation of usb_bulk_msg() in dvb_usb_generic_rw()
succeeds and rlen is greater than 0, the read operation of usb_bulk_msg()
will be executed to read rlen bytes of data from the dvb device into the
rbuf.

In this case, although rlen is 1, the write operation failed which resulted
in the dvb read operation not being executed, and ultimately variable i was
not initialized.

[1]
BUG: KMSAN: uninit-value in cxusb_gpio_tuner drivers/media/usb/dvb-usb/cxusb.c:124 [inline]
BUG: KMSAN: uninit-value in cxusb_i2c_xfer+0x153a/0x1a60 drivers/media/usb/dvb-usb/cxusb.c:196
 cxusb_gpio_tuner drivers/media/usb/dvb-usb/cxusb.c:124 [inline]
 cxusb_i2c_xfer+0x153a/0x1a60 drivers/media/usb/dvb-usb/cxusb.c:196
 __i2c_transfer+0xe25/0x3150 drivers/i2c/i2c-core-base.c:-1
 i2c_transfer+0x317/0x4a0 drivers/i2c/i2c-core-base.c:2315
 i2c_transfer_buffer_flags+0x125/0x1e0 drivers/i2c/i2c-core-base.c:2343
 i2c_master_send include/linux/i2c.h:109 [inline]
 i2cdev_write+0x210/0x280 drivers/i2c/i2c-dev.c:183
 do_loop_readv_writev fs/read_write.c:848 [inline]
 vfs_writev+0x963/0x14e0 fs/read_write.c:1057
 do_writev+0x247/0x5c0 fs/read_write.c:1101
 __do_sys_writev fs/read_write.c:1169 [inline]
 __se_sys_writev fs/read_write.c:1166 [inline]
 __x64_sys_writev+0x98/0xe0 fs/read_write.c:1166
 x64_sys_call+0x2229/0x3c80 arch/x86/include/generated/asm/syscalls_64.h:21
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: syzbot+526bd95c0ec629993bf3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=526bd95c0ec629993bf3
Tested-by: syzbot+526bd95c0ec629993bf3@syzkaller.appspotmail.com
Fixes: 22c6d93a7310 ("[PATCH] dvb: usb: support Medion hybrid USB2.0 DVB-T/analogue box")
Cc: stable@vger.kernel.org
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/cxusb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 5a15a6ec204f3..6beed13702d34 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -119,9 +119,8 @@ static void cxusb_gpio_tuner(struct dvb_usb_device *d, int onoff)
 
 	o[0] = GPIO_TUNER;
 	o[1] = onoff;
-	cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
 
-	if (i != 0x01)
+	if (!cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1) && i != 0x01)
 		dev_info(&d->udev->dev, "gpio_write failed.\n");
 
 	st->gpio_write_state[GPIO_TUNER] = onoff;
-- 
2.39.5



