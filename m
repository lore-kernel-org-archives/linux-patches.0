Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057813;
	b=qIfO61gSpOfyg0sasHYr+KWEYhWGud/QFHFjI5In7EiEXFBfgFlMZc358+RFx6ub1qop
	 xncDL6/xDp4qzEZJWH2QeRD2iBWN0IV2/s8NkFoNH1yBvbb4cFsv2DGI4pquSIo6PAlOX
	 GtaorZth22WrZhtuJaMYG8Ly9MQPNzYNhcEx4FlBzVUmGirm2d44Vg+njKRl15OXwXC7J
	 SvuKR1z6Y4uleao7tCdPJM1CFCXCDWlFXYc+C1C66ZnjL9MI47eqN/0lQvoc3WeUcoe4v
	 U/1KIodVOAs9/kzZ4C8mUJLCasL0hu7zJrS0bH9v8CwQRuB4Fvl9WkRme9w+EEeO4oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LeyRI1AHWr7GGu/2Q5xHcMlUwnIwW/z3iCdpEOWQgh8=;
	b=TD5Mpv/gqd8j03KlssoisjH5tYcEX17gJGM3FNlAP0SrW0iAAA9zpnC0O8ceg3XqGUsl
	 p2378FW/eitaUSOEo4+z737IHwZUmhwEklyefjwq1HrI68NGb7qC2nTJyiVhJVOZPgmlo
	 xheHgP7wXAJOVyP7jXaea1VxzXGI+pTuFfKdmlppgVhAaR8jNTh+pkc1/+hF5LjidRqlY
	 XUkD4VChSRPDupfbe/mAcETv67RPlymjEAUnBg0BtxciIJRQBvoqWaJcVLaE5HJlVseiF
	 miZLHB5YfRHkXQz7dZCcubuQpVqN8ecurQXEgPqtfQf21aWNd3ZN3tQngZIdXL7hRQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2TzFSR1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAD7606A320;
	Thu, 19 Nov 2026 03:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2TzFSR1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5FB1F000C4;
	Thu, 19 Nov 2026 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057813;
	bh=LeyRI1AHWr7GGu/2Q5xHcMlUwnIwW/z3iCdpEOWQgh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2TzFSR1Wxq37ws2uj9Co8i5Lbiue+1gG83PkvacReZbT73Q5zHxXLs07zg6b5wTR
	 iynpLzadIc11Ecuo0BuTQROGsmHG5ylcY3ObOphc9nhXEQTL+vxoZ5c6BDd04AJcf7
	 3CKB9QvUN+Mw132qtlrUw5/hMt6mMlokaAPHRpFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 0261/1848] media: rc: mce_kbd: Fix inconsistent locking of keylock
Date: Wed, 18 Nov 2026 15:38:19 +0100
Message-ID: <20261118145923.202941549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 29ee25fa9beb3232808e6d0b3e8ebfb0427cb820 upstream.

data->keylock is taken with spin_lock() in ir_mce_kbd_decode(), which
runs in the raw IR decode kthread with local interrupts enabled, but
with spin_lock_irqsave() in mce_kbd_rx_timeout(), the rx_timeout timer
callback, which runs in softirq context.

If the decode kthread is holding keylock via spin_lock() when a timer
interrupt fires on the same CPU and the softirq runs
mce_kbd_rx_timeout(), the softirq spins forever waiting for a lock
that only the now-preempted kthread can release, while the kthread
cannot run again until the softirq gives up the CPU. This deadlocks
the CPU.

Fixes: 53a62800efb2 ("media: rc: mce_kbd decoder: fix race condition")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -218,6 +218,7 @@ static int ir_mce_kbd_decode(struct rc_d
 	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	u32 scancode;
 	unsigned long delay;
+	unsigned long flags;
 	struct lirc_scancode lsc = {};
 
 	if (!is_timing_event(ev)) {
@@ -318,7 +319,7 @@ again:
 			scancode = data->body & 0xffffff;
 			dev_dbg(&dev->dev, "keyboard data 0x%08x\n",
 				data->body);
-			spin_lock(&data->keylock);
+			spin_lock_irqsave(&data->keylock, flags);
 			if (scancode) {
 				delay = usecs_to_jiffies(dev->timeout) +
 					msecs_to_jiffies(100);
@@ -328,7 +329,7 @@ again:
 			}
 			/* Pass data to keyboard buffer parser */
 			ir_mce_kbd_process_keyboard_data(dev, scancode);
-			spin_unlock(&data->keylock);
+			spin_unlock_irqrestore(&data->keylock, flags);
 			lsc.rc_proto = RC_PROTO_MCIR2_KBD;
 			break;
 		case MCIR2_MOUSE_NBITS:


