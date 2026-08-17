Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989683D301E;
	Mon, 17 Aug 2026 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977560; cv=none; b=S2U1Uo+UqxhX9cTxv6wqmMb+qi/ETSLoO2oOJ4ZG3g37+SZtjKt1hbXSgcK7b5WjeP9FgPy5gXrI7ip6lDjplQ9ljAZqaF4RxBsJnoG7Im9/eKBi0DQfHSOsjWCAMV6Oor22oNVmy5Nrn46x78o6m6wzZx7BVn7E3j1ToA90YMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977560; c=relaxed/simple;
	bh=63UD/NzpmaswhI2kFaW4Ajb7M6TYhBYfArfWmsohRSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0NrKSUYBhrI2/B+s1WHtDgB3/pRkD3F5USnAkj9RJLQ0tb+T2KxWLYAA9jrh3xSNQZDmu/QNrYXsBHaDG7IGps+lx+3XAbwcRYpq6fzM7JC8Plu4ksDGc5WKx1ZeGHFRsANFqb3hO/qTY4VVIduvESQo2KqDqr1U+X2qMCn1+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QizVQm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QizVQm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F191E1F000E9;
	Mon, 17 Aug 2026 14:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977559;
	bh=FrUmirbzqxE5PzeuN9DDFqnPbyVcwIdv3xzqaEhB88E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QizVQm8nDJ6/f5zHinSCB6MQjpDTko2xP5cF//zE0NfdoefMb8k8g+0EAUDI1aiD
	 qlhifIfeUjcYiGT/kKvlRldlo/Zy4d5sboRsx6m/Z78OTp2SfnC0YxMoFDLsvgyIJV
	 X9MiZz+hs9l7vRNXImUVANaYPLM1ibQus34cGjPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 354/456] can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error
Date: Mon, 17 Aug 2026 15:32:24 +0200
Message-ID: <20260817132553.384107338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -463,7 +463,6 @@ static int peak_usb_start(struct peak_us
 				netif_device_detach(dev->netdev);
 
 			usb_unanchor_urb(urb);
-			kfree(buf);
 			usb_free_urb(urb);
 			break;
 		}


