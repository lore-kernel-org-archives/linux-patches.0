Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044465;
	b=No7NYNGZm9yWJqFx0aq6MSY6EwJncFjbIAfkXR4MhWKNYJvahTRDRhoPScgOeWwEqOh1
	 luOVCjZIF3Z+XpXB7LJzMuovAnTfGG1xH1yRkf/1OLRwUohJsct6ehw3sSzlexpicdgb9
	 2c0mVLYHx0DWRUK8NhTaNTzsDFzbeV2bdoinSLSk+aKovpBmZzFyDNg/zTQqd9yBOWX1Q
	 9qsumbjZt6Vk3Y8njfwOcFwNxfwhfQJ9/aPquZ/LGRs1lOPPAwYlhIqQZZ16LJCk2QgJ0
	 qH98uV3Q2yx7lhFaKQAul53GERMsHcDCckKTHQJFEyipJGSr1FYitt4vPw3Wh1/tfrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lLcXWcMSyZ5CnOV8eLg4QWyT6GzKjHZ7kX2EovfxQH4=;
	b=fCnztXI4AYBYkya8mtw4gJc+SwmkpTS8pgB0tGQY3WkBM1peJIXoAC8hBSoKXrG6CfYv
	 xFnb4LvSqc53ojQEfHN02fVwKwqDWrnYpEy0IIKyEFE6Af9hMbeyDU4bM0oCBnYYC5AQB
	 354ZanXSusf+UpMJtxNk0xoATpqA4AAe1s4a4tg86UdB9Y8pcTyslViLEPL4AudGdJxAp
	 AilAf7QnTJntOdDVX5UhMXSl52R/86m09h5PULkgERvn1yrFWceDUKHRN2xi9AHr3Qtys
	 M9S/vwXGIrExFnNCB9kkuh5ybZq6L/3m28wBs0PrdiSUg4waCzyKrFH+SiWo9gW/h+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp4srzyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7F5606A320;
	Wed, 18 Nov 2026 23:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kp4srzyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC2A1F000C4;
	Wed, 18 Nov 2026 23:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044465;
	bh=lLcXWcMSyZ5CnOV8eLg4QWyT6GzKjHZ7kX2EovfxQH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kp4srzyYQVJs8zBSeatNGuOMCyxW4kCIhoDypv2oDV5o1+9Z24If0F4scD+aFA9b0
	 +mjLHgzsA7c65EaIaFvYRZ2UPbabj1L7b8E8ldRIQw3zm+CPH5Cnvza2Yu5tWraBPb
	 KqFS/soFP2O8L7wJxJ71ZsiugQmFfT2uwVwjWr7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0570/2857] media: rc: mce_kbd: Fix inconsistent locking of keylock
Date: Wed, 18 Nov 2026 15:26:44 +0100
Message-ID: <20261118150222.008747728@linuxfoundation.org>
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


