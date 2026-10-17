Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9C63D333C;
	Sat, 17 Oct 2026 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257319; cv=none; b=Ofoy5iA+GxAZpwommVx8EtyeMqyDScOp18zupWRjKw1pkJcACwsPvmdoXVcMPyvHfFWvL2jXMZEdVBUWv0sRp3V4QRfDi3rWZHrYU4eAA7hTciLmLR0mWktw7OdwEF9TKX6o2SjnXT/WX0UZdP2JauycqXZAFXTnWgCAdJTGqpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257319; c=relaxed/simple;
	bh=N7lN0oHkOPZv5KdNw9KDpGTLxCHnlNOL7abOAjRnDLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0j7Zj7zh61dwdeOqPZKr3f/NuoTiSP3EiacuStHjdbbK78mEkbX4ELZzBzqmakW1hMTqrarxN70u2BZhchmJqm3ZJmTQXdNXfil5JvhuOpUQ++i2VUSp056AZTUBIJgZCaaXMwJnDEugdaucVOwiTZWWLCMLX33cL6CM+gagFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ceb6DF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ceb6DF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA4E1F000C4;
	Sat, 17 Oct 2026 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257317;
	bh=ZMOBlGHVvj5nXQs4yDarvnQjxFVe1B97oA+qVy4nelg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ceb6DF6cg2ddp9mt+yfmim2XYSTPM+2e7NXvuHW+o9KJ52/2l9AXCjBQJ/CGeRig
	 GW2djWKQvfOCzt0mzXrPrVx9MbauYmP2gpeo1XR/OxRbwooTTEQUARhaH/YX+w9z0P
	 1jT8MLx1P8jwDEUsUFtJqMF86IYvfV3Ixo3tslVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a807caf7680652d53b6@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0519/1674] Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown
Date: Sat, 17 Oct 2026 17:46:31 +0200
Message-ID: <20261017160444.428069828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Palla Raghunath <raghunathpalla.0209@gmail.com>

commit 08e90633377f1b2567ab5ad6810b74c552246a07 upstream.

syzbot hit a NULL pointer dereference in rfcomm_dev_shutdown() when an
RFCOMM tty is closed.

rfcomm_dev_add() puts the new device on rfcomm_dev_list first and only
then registers the tty device and saves it in dev->tty_dev. If that
registration fails, dev->tty_dev is never set at all. The device can be
looked up in the meantime, so an open() of /dev/rfcommN gets through
rfcomm_tty_install() and attaches to it. When that tty is closed again,
rfcomm_dev_shutdown() uses dev->tty_dev without checking it:

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
  RIP: 0010:rfcomm_dev_shutdown+0x48/0xb0 net/bluetooth/rfcomm/tty.c:131
  Call Trace:
   tty_port_shutdown+0x1bf/0x220 drivers/tty/tty_port.c:372
   tty_port_close+0x4e/0x150 drivers/tty/tty_port.c:705
   tty_release+0x359/0x1670 drivers/tty/tty_io.c:1718
   __fput+0x418/0xa50 fs/file_table.c:512

rfcomm_dev_destruct() already copes with a NULL dev->tty_dev. Add the
same check to rfcomm_dev_shutdown(), so the tty device is only moved
when it was actually registered.

Fixes: cad348a17e17 ("Bluetooth: Implement .activate, .shutdown and .carrier_raised methods")
Reported-by: syzbot+4a807caf7680652d53b6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4a807caf7680652d53b6
Cc: stable@vger.kernel.org
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -131,7 +131,7 @@ static void rfcomm_dev_shutdown(struct t
 {
 	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
 
-	if (dev->tty_dev->parent)
+	if (dev->tty_dev && dev->tty_dev->parent)
 		device_move(dev->tty_dev, NULL, DPM_ORDER_DEV_LAST);
 
 	/* close the dlc */


