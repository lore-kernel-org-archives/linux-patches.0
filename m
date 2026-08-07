Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFAD279DCC;
	Fri,  7 Aug 2026 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114364; cv=none; b=iCVwyoeUKRZekIMCke4X09ZuccldxG93KtHVi5As8E6k36z/oRWjKFJwL2W6xFHuDtt0SEvj5gbhRbrYZdyVT7rRypbZ2Ib9LO/n+f2uQtLSeWupWTunxosL3RA4f5BPlj8i0h1XqlhRKcjO/aT2LP2RFY5FF008dswCGuJJY2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114364; c=relaxed/simple;
	bh=6f8drTcmq/CqDyLE1pj7iumAU7q2qI5XuM+5Ns0x0vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QByvlsd5FnoreaOpRavwRaCe89dbMxjAS6gL0GMkMfsoR/9ffsBxZCunv4OZEYsHuaaxys8i31e72BAtONhPoI01MG3Qd5VoSlzgQbZJ8ErEGzCAhBr+VeQv+MPXTc5M5kQCGuuPjWVITluujwqXXiqRhe5dUoWznI/EnP4bmM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdQN13m5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdQN13m5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A051F000E9;
	Fri,  7 Aug 2026 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114362;
	bh=sdhAZ4YFN9jXy6LON4dA7e3SS8flCujv9IRnpy0nODA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdQN13m5enbsIHvOt3e/srsGd1DItG/nRTFmYv28NgWKG/NJhWAS/mIHk4Y+oL6iw
	 YsJ9bC1EwxzxA9FT32wDTnblyR4rImHLr0PsrANl8kMrdheq4DUTEtuea5Ovs/+AkW
	 +uMhFkt8HpwRI1GAlyJAqHCytpgec5kFr087QQ9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 237/337] can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error
Date: Fri,  7 Aug 2026 16:37:20 +0200
Message-ID: <20260807143423.687877409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -470,7 +470,6 @@ static int peak_usb_start(struct peak_us
 				netif_device_detach(dev->netdev);
 
 			usb_unanchor_urb(urb);
-			kfree(buf);
 			usb_free_urb(urb);
 			break;
 		}


