Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051750;
	b=nY6cXoz9L3RJ7n1KYRD7wQF20Fvkxc78l7Vrc0AITbHANxvczg06NMaP2cV829lYOma0
	 nxhRDRy1NHrAg2SNDB05kIR12I6FSq+wZ2U1SfCzLmIs1QmXICVUI5WoqAn3Fzl+Duhrh
	 piHHUhuMWLx/55biEC2F2o3GOTYx7vcWbtV7/NlS289sOizm/5ryRLvNqA+g5Mfm+3NS6
	 rU9E4o+5SHC7XlC7xdR6jLBa4GX4S0BMKgS5uTf6g8y2eLqUP4P8Z2wD5aTgy8J7z8iaR
	 4xdqNjFZxa3DBWvJ2ZTd6WjpL1cZW8qOkBOgsoeh3SEto1vZVav59ftIOts8imiiylg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sqWeKsOT9Db6/YCq0ByXbYka3P8JgiEYkWDbHElLmQQ=;
	b=Uz+1qjZFZQcdoH9OjJasceE0d34ImKNuk16fSVwGFP2Mhj5in6bX9mbuaN5B17ZAdRL3
	 dTQfsRJVgXDeAf3rZKzhPuvSXIgz6UyOBWM0jv3uVhR2RHtdk48Gh5fToSP24CJJco6K1
	 /6lqVck6uvsFcE0tiBpZ3M88zhKMbxCe+dbAVTeLXKp36YOi/lCSTfUZgDY9HrS1Uwwwo
	 en7QCiN7IiIm6wFaQEKkcXV3XIPN2DXcjQcheAXTwqi7kevCf0ZGOU0mNcn8RSFNdj3ol
	 SRGJlBEwXMNqXBjuglhNlPz1c6oLFx5kNNGs7rpCbqJvwc7JIm+gLRqpTWr4zYZUSkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCj9huxd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACB2606A31C;
	Thu, 19 Nov 2026 01:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCj9huxd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83CD1F000C4;
	Thu, 19 Nov 2026 01:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051750;
	bh=sqWeKsOT9Db6/YCq0ByXbYka3P8JgiEYkWDbHElLmQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCj9huxdoJGy2fjF+BZv8vvsrC3IZoechJeD84tce5ECGs/NnIiuqzkJtljnUJLpl
	 xsntL3Cz3kHXKwEicaf8wnIxmklf9pBpciRvQskuhWChnDR4P1KQXgEpQvpuBUczcr
	 2bLxUcO4PvWUagGBYA6wsHqpiwiOmCt88DCupYZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0320/2214] media: rc: mce_kbd: Fix inconsistent locking of keylock
Date: Wed, 18 Nov 2026 15:33:16 +0100
Message-ID: <20261118150023.068245504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


