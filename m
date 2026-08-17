Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2115543F085;
	Mon, 17 Aug 2026 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980105; cv=none; b=bjFvZ9Yt74K1bdPgGaJuziVDsWzMvUP6lZJroAU0n0+unNF2z+01aWMPXEXI6B+NUV9C4ooWWt2CYYuip8APoRjpP/qW9e9VrnYHQBm/pxRRoQgz6n26Tt7Matn6+SBLm5mip2f6zFUOWkC14qmhVsezFW6NNS6VrekZ7sS8ckM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980105; c=relaxed/simple;
	bh=mjYrZkYASq5Mq53fGJ+L2smGV60WTNjo3+9uC/JfIJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgQdjd74gyg5f3dAVcfwYn5AT4yloRIrXmXqoZgXaHZ1eVTVNncsf80R9iUI3n6iZre6Q+v/0xSg1RcVQCAC/laF3fsG+wwOHhACjFKz380YHJkce+4GUVkwhVOGFnuJp9agyh1KmA6QV6pf3+JQAW9k1Rn0jUpFzbp0JAvORVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouYgOPsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouYgOPsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D28A1F000E9;
	Mon, 17 Aug 2026 15:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980104;
	bh=jOYLcFp46sS3Ew+dFmR3/lftHZ+sfVRgTijW6eJHekU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouYgOPsB6P3d8iS9tGQDPTG6N4q5ehK9mpG5QFJkLmrltarpwODoLCMeBj0Y8WCfA
	 oGCZTeR/MCwrsYLtvOyl6RCNaqJvXfKlYpfPaF0zTA9QE//V1VNSXJ+QBcipuhxSIE
	 kkss+2Rr9tylZkEl4RVwf3TgJdaSJEbjFiBUuiZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 458/609] can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error
Date: Mon, 17 Aug 2026 15:32:34 +0200
Message-ID: <20260817132559.350635811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 9b3d5a6d952c38bbcf07f903cbeadefdb56b9bc9 upstream.

In peak_usb_start(), each RX URB transfer buffer is allocated with kmalloc()
and the URB is flagged URB_FREE_BUFFER so that the final usb_free_urb() also
frees the transfer buffer.

If usb_submit_urb() fails, the error path frees the buffer explicitly with
kfree(buf) and then calls usb_free_urb(urb). Because URB_FREE_BUFFER is set,
usb_free_urb() -> urb_destroy() frees the same buffer a second time, a double
free of the transfer buffer.

  BUG: KASAN: double-free in usb_free_urb.part.0+0x91/0xb0
  Free of addr ffff8881069ccb80 by task trigger.sh/285

  Call Trace:
   kfree+0x113/0x3c0
   usb_free_urb.part.0+0x91/0xb0

Drop the redundant kfree(buf); usb_free_urb() already releases the transfer
buffer. This mirrors commit 03819abbeb11 ("net: usb: lan78xx: Fix double free
issue with interrupt buffer allocation").

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Closes: https://lore.kernel.org/linux-can/178159320216.2154888.16953451793788581739@maoyixie.com/T/#u
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/178163373110.2507866.216458825145756798@maoyixie.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -461,7 +461,6 @@ static int peak_usb_start(struct peak_us
 				netif_device_detach(dev->netdev);
 
 			usb_unanchor_urb(urb);
-			kfree(buf);
 			usb_free_urb(urb);
 			break;
 		}


