Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044356;
	b=skHgxhh2DXFoge9yCnTRb5a2UXGAIHe2toOwnus/RBlgxHlMX7rj1vjjG5Rf8a84tbs2
	 Z4/eq9nJSoCvLFiTYj27PnLNaC7WQy9wwrFJL+TML6gnS4M2qx+Yj1fBjS8ZnGALqdhpl
	 d0XpjnZlP5fjdT3CFi0ESMzgNfpkXDukExAX8GP6RrQfeAfRPnBUya119/1JFf/Fwdwzy
	 +DQQjSul00pD9jUp/1UJO1qiX1aK+KnyABwGgq8tsqLRPHyhFHqmLB/L4cPzz1vC8QuLc
	 wGFMa0vOYisuxqOHoy4eQNu8DIoqhZdyexlStExwq99dhfFi+TWIYVCoslBXacnTP0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zu/50qeBagp0pqTNp7NPUl21i+jleSV9EOXnGRXzAxk=;
	b=OtNBeoCjbtyqMN/xR3beT8UNtoSV4/eJ+KJyOYwkWBc7duGH6o9FwSLOR521oKtsRjRd
	 rXLFUwNiSn+OecqFsuS6muF4p5LqmO8s1fbB4OKtAQYDDS4v3rLj8ZgLxXV1U5xPhDnk3
	 TY4/75Cqi9APuBWodzVHSwuG0wV4+I1iMPhJvUv8QQRS7JmmMCvBRc+9WoLBZGD+8l+gW
	 +3Logs2NjiId4VNlQnflvqucpCrQqKvG6brexPVO85xcEjQ0QhXeVybpKOPutDxljm+CI
	 y/su/soLym0edC/dgvQqemUaZyImkDVH9qOMwvK0dA7Ig1WMK9OgZSATFRL0mBtb1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGrI97Nv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFFB606A31C;
	Wed, 18 Nov 2026 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGrI97Nv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1291F000C8;
	Wed, 18 Nov 2026 23:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044356;
	bh=zu/50qeBagp0pqTNp7NPUl21i+jleSV9EOXnGRXzAxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGrI97NvHPDxrpc7gSrriGHc3p2fRyCtnCJyVJXz8yuEdnd5Hh3NKrHsbxvASL7F4
	 6+oKzsa6HLZ1NNixkNihT46Mizk+pSbmHj4KAvw/ug2rsALrKs+3whMDoaaFqEt3oy
	 5zS0B1OHOub4pITW3RCfRZh7++lBGIwnH3Y/dHAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.1 0538/2857] media: imon: fix use-after-free in display_close via dev_dbg
Date: Wed, 18 Nov 2026 15:26:12 +0100
Message-ID: <20261118150220.856465895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 118a3590a4080c71c565265b05b3f92e814d7647 upstream.

ictx->dev is a raw pointer to the usb_interface's embedded device.
On disconnect, usb_disconnect() can drop the last reference on the
interface and free it while a userspace fd for /dev/lcd0 is still
open. When that fd is later closed, display_close() dereferences
the now-freed ictx->dev via dev_dbg(), causing a use-after-free.

Remove the dev_dbg() calls that dereference ictx->dev in
display_close() and free_imon_context(), rather than taking a
reference on the device.

Fixes: 21677cfc562a ("V4L/DVB: ir-core: add imon driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bfac891bdd42eb708fc
Link: https://lore.kernel.org/all/20260918054851.26083-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260928121230.35359-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/imon.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -497,16 +497,12 @@ MODULE_PARM_DESC(pad_thresh, "Threshold
 
 static void free_imon_context(struct imon_context *ictx)
 {
-	struct device *dev = ictx->dev;
-
 	usb_free_urb(ictx->tx_urb);
 	WARN_ON(ictx->dev_present_intf0);
 	usb_free_urb(ictx->rx_urb_intf0);
 	WARN_ON(ictx->dev_present_intf1);
 	usb_free_urb(ictx->rx_urb_intf1);
 	kfree_rcu(ictx, rcu);
-
-	dev_dbg(dev, "%s: iMON context freed\n", __func__);
 }
 
 /*
@@ -582,7 +578,6 @@ static int display_close(struct inode *i
 		retval = -EIO;
 	} else {
 		ictx->display_isopen = false;
-		dev_dbg(ictx->dev, "display port closed\n");
 	}
 
 	mutex_unlock(&ictx->lock);


