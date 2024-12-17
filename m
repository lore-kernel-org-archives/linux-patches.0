Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BF01F4735;
	Tue, 17 Dec 2024 17:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455385; cv=none; b=pNmTE6eaPMcIGDeYBCzOe658VCm6iOlqFRZE90jctOqPYwq4JuJTNPtwQdRavLiJvC5v9T98h/e91Ke5/ysWZE+dU1vZiLXvAsYWwvIxjcKfDCl7P3TlwM84HQLh4+68evqdD0682RR0Hb8fMt8fgXrjgMlzurxm7T2+7BrfEns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455385; c=relaxed/simple;
	bh=zMq/2gc9i7ZBTQFF1TEOMX4avfK9xSOgBQCbpvUcZZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTUbwXhvTvxa4MCV+F0qW0aWLDcUDXcjHYxsH1tDdvyVju0b3mvY6y05TC7B5VlVlKdRQCGwGLGhK63whwHfWi2YcR7nrekut9f7HawUheQ3+tgCCRKZ0YiRcZPp0AvnaHFYHzfzkQw2e+uUiPkNppP892qA7NvN5tFyKnjQy1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7notOE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7notOE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B3DC4CED3;
	Tue, 17 Dec 2024 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455384;
	bh=zMq/2gc9i7ZBTQFF1TEOMX4avfK9xSOgBQCbpvUcZZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7notOE6OyGZtW0g/hp4U/WW7lYWHBTGCfNFFZnKt5kvjLSUWj4qLJrHv0/HLt37u
	 JJ7B8f5H3HFyXm7WJJD/8eDppxz8l8WpqDePNUyPNaWFpa7UEw5H7rGCzkVFl4jP3N
	 1PJnAvPaVM8D2Fbe6VmPPByuhyIO5cRg9dTolefQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>,
	Lianqin Hu <hulianqin@vivo.com>
Subject: [PATCH 5.4 05/24] usb: gadget: u_serial: Fix the issue that gs_start_io crashed due to accessing null pointer
Date: Tue, 17 Dec 2024 18:07:03 +0100
Message-ID: <20241217170519.227130081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

From: Lianqin Hu <hulianqin@vivo.com>

commit 4cfbca86f6a8b801f3254e0e3c8f2b1d2d64be2b upstream.

Considering that in some extreme cases,
when u_serial driver is accessed by multiple threads,
Thread A is executing the open operation and calling the gs_open,
Thread B is executing the disconnect operation and calling the
gserial_disconnect function,The port->port_usb pointer will be set to NULL.

E.g.
    Thread A                                 Thread B
    gs_open()                                gadget_unbind_driver()
    gs_start_io()                            composite_disconnect()
    gs_start_rx()                            gserial_disconnect()
    ...                                      ...
    spin_unlock(&port->port_lock)
    status = usb_ep_queue()                  spin_lock(&port->port_lock)
    spin_lock(&port->port_lock)              port->port_usb = NULL
    gs_free_requests(port->port_usb->in)     spin_unlock(&port->port_lock)
    Crash

This causes thread A to access a null pointer (port->port_usb is null)
when calling the gs_free_requests function, causing a crash.

If port_usb is NULL, the release request will be skipped as it
will be done by gserial_disconnect.

So add a null pointer check to gs_start_io before attempting
to access the value of the pointer port->port_usb.

Call trace:
 gs_start_io+0x164/0x25c
 gs_open+0x108/0x13c
 tty_open+0x314/0x638
 chrdev_open+0x1b8/0x258
 do_dentry_open+0x2c4/0x700
 vfs_open+0x2c/0x3c
 path_openat+0xa64/0xc60
 do_filp_open+0xb8/0x164
 do_sys_openat2+0x84/0xf0
 __arm64_sys_openat+0x70/0x9c
 invoke_syscall+0x58/0x114
 el0_svc_common+0x80/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x38/0x68

Fixes: c1dca562be8a ("usb gadget: split out serial core")
Cc: stable@vger.kernel.org
Suggested-by: Prashanth K <quic_prashk@quicinc.com>
Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Acked-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/TYUPR06MB62178DC3473F9E1A537DCD02D2362@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -566,9 +566,12 @@ static int gs_start_io(struct gs_port *p
 		 * we didn't in gs_start_tx() */
 		tty_wakeup(port->port.tty);
 	} else {
-		gs_free_requests(ep, head, &port->read_allocated);
-		gs_free_requests(port->port_usb->in, &port->write_pool,
-			&port->write_allocated);
+		/* Free reqs only if we are still connected */
+		if (port->port_usb) {
+			gs_free_requests(ep, head, &port->read_allocated);
+			gs_free_requests(port->port_usb->in, &port->write_pool,
+				&port->write_allocated);
+		}
 		status = -EIO;
 	}
 


