Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831511;
	b=14wkqVqQ6p4/3OBqhbj6g8IVMpWjz4UXCC4L/o5CpwAC89uPFwc6i8CNXp2SsPH6UsWN
	 kHWSDyfzsb5Sghu0l12FG82EfroJPX3mFs6m0QbRrmzs4D765eeRO1aHoPQJ09h1mY03I
	 V5k7Tsw0x8TJl7UmEWmQw1maSYZwOLcDy7K26li5a7O2r7obAp1b9YLr7IAoPVXk6TKt6
	 lVZnAZnOSRqckO1ys2WELp6FrDCu8ZbXDSNkkjuTRpyu5Tc8q7mnNoAm+Z/Cj7wLprF18
	 gfj+StXZ6oAKTqqnSGX3sGaVlFEyfcw5tJIF5r9AemvJnMNjJpqsCNvoW9G8+ioDn0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rb2UocqQkZ1ot671v8hjfZPY6sqzHQ4DpGGOEC05GFc=;
	b=5G0g0vCsZIUrxqEzvOLBSmPPwxSDgsRbT2Dm6mWzUBbhYDgphd83vyuizYIZW3QlnvTd
	 uOoteuCQD9kL7Wp0AijsuhOkXxKWs+0m5f3mA49LlMWYlYe2HE4qVPwUgcB8gFSxV7oRB
	 wa1JEJnxclVvqDToczgnOU1a9ALsl/Wi0XBtpIb6YTUHnXZfmP1vxZuWca6xYkGXObHCj
	 r/kKY5C7ZkEGEsAeSvoG+UJhdDRlIcBcbkQ8BJxhtQRdDQiNOEo5Dok4p1NgPOz1tV9j+
	 k8q8H2GAMqdjAhaTC0vbqSMgA10flKJU+FZOsDPX5DeOgRiq+ilxgeZxDQPPiZEOJGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=os3DDQws;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B89606A33A;
	Wed,  4 Nov 2026 22:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=os3DDQws
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D4B1F000C1;
	Wed,  4 Nov 2026 22:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831511;
	bh=rb2UocqQkZ1ot671v8hjfZPY6sqzHQ4DpGGOEC05GFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=os3DDQwsM2ufNx/dfWsgp3kf4aSzjNU6vrBoyueFCS+jgPUTA/EJ3flwaJf6YQykF
	 xiArxXQXiwOSsz5u7+EecHNEwfeKKExg+tOmk2+qT5ZD+Fe9I3htFSZ1KFcoFnnKby
	 V4w2hzkU47lBFGBqO8yjNIdiiwVgg2227myKQnjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0747/1005] media: rc: mce_kbd: Fix inconsistent locking of keylock
Date: Wed,  4 Nov 2026 16:08:00 -0500
Message-ID: <20261104211104.387767079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -219,6 +219,7 @@ static int ir_mce_kbd_decode(struct rc_d
 	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
 	u32 scancode;
 	unsigned long delay;
+	unsigned long flags;
 	struct lirc_scancode lsc = {};
 
 	if (!is_timing_event(ev)) {
@@ -319,7 +320,7 @@ again:
 			scancode = data->body & 0xffffff;
 			dev_dbg(&dev->dev, "keyboard data 0x%08x\n",
 				data->body);
-			spin_lock(&data->keylock);
+			spin_lock_irqsave(&data->keylock, flags);
 			if (scancode) {
 				delay = usecs_to_jiffies(dev->timeout) +
 					msecs_to_jiffies(100);
@@ -329,7 +330,7 @@ again:
 			}
 			/* Pass data to keyboard buffer parser */
 			ir_mce_kbd_process_keyboard_data(dev, scancode);
-			spin_unlock(&data->keylock);
+			spin_unlock_irqrestore(&data->keylock, flags);
 			lsc.rc_proto = RC_PROTO_MCIR2_KBD;
 			break;
 		case MCIR2_MOUSE_NBITS:


