Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BEA42D758;
	Fri,  7 Aug 2026 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115523; cv=none; b=pRI/xYErI5ozNVStqrbgZZJSjOupKvGllBA11kyWpEMvm9LA2V6yBDhyGM3kJXgIVHWFfBxqCB68SA6JH+Dhao9RTnN9JYo2rxRLbbwmY7VmAjTmueayqxvexnFBy9o8J44CkOt8/rC6gmYEuFZJnOBGuPTrvtZDSy/x3rAbUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115523; c=relaxed/simple;
	bh=hx8uv+2kBo/DA25sUzeQMXqtB78+P5oc/ng96asS3DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pum4AGKlwclDVIGwH5QqCetrQ8alCrY10WoC6UL38m8Niu57S/rZZIkNM2LpJ1C4wX3ebymG47xVCUGbqx/7KvWuf3Oi5cfu1+4oD6eTe/Oyc9/+B/xVvc7cEBwtS9Zj/QrCTuk3e/xEkM6clFG4RKee9eGB0bkH23UE4RMPoVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uofaonh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uofaonh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60F71F000E9;
	Fri,  7 Aug 2026 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115520;
	bh=55vXEPPyH2RtQX7LVpkvTqFzgHwveP7kCWzDCov8nRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uofaonh6SnhEQ4oWQXCJgABIpH0fDk+0TWJqL/ZysBx6HBs+UMfCu2k/0GQWMxfh1
	 eM4NGD19FcPBw+MFJOy2H5doxYPrXdihR3G0dTQHHWo1WqKBDkhWFxEyYDPfCxoGen
	 qiMomwzn1VFZYyJWuUJgk1q0vnzlycmLdre95EFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 305/396] can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error
Date: Fri,  7 Aug 2026 16:37:45 +0200
Message-ID: <20260807143430.852888363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


