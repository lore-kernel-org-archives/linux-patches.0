Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061639;
	b=VepBDzwwEu8AhZXITrxwrGPFdg8e3ExzoG/juv/1V32lnMpm6I7A8cJjX50aW7KnaYdO
	 S6fD//l8fhmPCdtnCJfxq+MZdEooT6jBcGDSy5fsoNfK1GKneb5MFgemaOZ/vHcqPORSS
	 8Xb2DMVF+FM+y2sLhhQHmTlt0Zwk9RGm59avQ9HbRZ/AU58bsdXw9//L6bg3QU/QD45As
	 wcseg2o7VEyvPWQh4YOdosd4GJ0CXd7xm38g0hBJhJi2SlP95tMSpF4Py2prjosYiivZs
	 AtS+jPg795VyG8flGwtlgPfKL3NM8tv4ts4m1vpw0WKPlzP/o2CYPJqV/zcGtwiImrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XJ39JnVfxJqTzYDa8EasMNWDex2iRrGSzMv0Z89N9SQ=;
	b=KNHpRgLnmkNvfB6VY7A90dQqdGbLvYRSX8UOg+0rkD2uaG9RYIPNic+ICquGGzXfrj7P
	 9dBNNDH+9xF1pYKRvp5+QN2TRgbJQfjgRjraUpP9UgwW6HNyh0CnNT/jhIElVbrobbZ2c
	 KdMWXctJqLo48MMTT3AL6FesKY7GX5OT7i9TFElTxOyBr4dFxV42OCP1O6l00tGkKn6N7
	 TaztDP6kSjB1fv8NXp1ZljaDLCEvC/S4YOkKtmJSsheODuNLL6h1gMD8hC1GfTlhVwsV5
	 KM6FulPAcq3CP3n8iBa0qSMYsRSb9MMDEjj2FEOlxiEebmTg7rfEs4JYLvDvOdgLloA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gw+Pthb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33080606A32D;
	Sat,  7 Nov 2026 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gw+Pthb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C4A1F0089F;
	Sat,  7 Nov 2026 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061639;
	bh=XJ39JnVfxJqTzYDa8EasMNWDex2iRrGSzMv0Z89N9SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gw+Pthb1FStwyDDy1CUGeuFahoLKZ7vMQ5bSiQbjxfjvSz5KYLkBZQTRwIEGpaUEx
	 a4IE9kRbNewFQ4EMwBhiv3pO61KjEjZC80qVu9pSmnooNxDAb9pyqsEkYXvxGmeWF4
	 JBTm6M1BPXtB44XUqYBcC7D9aDaAwqn9SjewyUv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0664/1536] media: rc: mce_kbd: Fix inconsistent locking of keylock
Date: Sat,  7 Nov 2026 08:44:40 -0500
Message-ID: <20261107135016.153884808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


