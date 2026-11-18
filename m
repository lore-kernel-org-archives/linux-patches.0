Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035186;
	b=sP8FcFXnIeb4B7LffKGLHaiV9bvHEbVdWd/fsGmk9PEOxSSPrJJvqtDb4Ogo9iCwX0gY
	 v+AN/RC6uwf/zQLueNt1mNGoLp78Rhsh+hb+xeJQU7Dch0zOnLjUf+7IgDwKnQ0zWzSU6
	 TFD/KNC6DbU2JM8RAnzVg0t3j0DEbHs4DtjYGoD2AkwC0hpxbgE+pv90RiM478m7vVYDG
	 2fWSvaQsCOkxPOrlsotEfFejgjzzqiPF5Gbmvrw/lMo6odoujdMk1bcvzaIXI2La9aypM
	 lS2Xx4i/I0rDk8QdMtuhOxUXIt+MB9z4DD31x/TIowfPIbUTGotmbu8ckflUBVbQ8Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Rx4ee1oCNOnv9GpIhDr5d0ctWvo+GjoAQ1iR1fFv9A=;
	b=zMHMd1JQaqi54oZcA6Y5eqxHqLWSj5c3MVajqW8KkpXEYzumVCgzfvzm3i4FH9gQXilx
	 9gI4c6xeJjv41AoPLfN27mIipILqlcx4o4dfiVpDjP1ow7uIwYXsiPlqGpDMfxQo0FKHD
	 n7C3SeTz1XwtGRcVZk6xtK3FJQtV+f5jIJxDudH4vDDtaL5sfdgTXqYqIiDZa9kbbVfyK
	 7X1xohbJOB8YpG3LC5dYcA292kC9R9nxXA8PVIBUXAk3Kq6Am/v114MG4C7Wvsmd8erzb
	 fTZT9t620Gjvyn7RPCGFqhlUDUBAEE5K5N6n9L65PhdZr+OX7cdm5apwMktBlI/5bIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssvCTvC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3EB60A260B;
	Wed, 18 Nov 2026 20:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssvCTvC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5AC1F000C9;
	Wed, 18 Nov 2026 20:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035185;
	bh=9Rx4ee1oCNOnv9GpIhDr5d0ctWvo+GjoAQ1iR1fFv9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssvCTvC3mnb7rDBTl9E0VRL3t4MrY1Ah2IyMOXY/xt7/pluJ7JfSBfDkrHqyt3Dvh
	 dBxYYXhzdWP8qC71D51me65Jb+lvVmW4L2upQrkKKWeipGJHUPt9dEvAQXimXmCiGQ
	 BTOKcTkPfTBUnQXgPw895O+/y5Y4D8GMr7aiIPLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0634/3318] media: rc: mce_kbd: Fix inconsistent locking of keylock
Date: Wed, 18 Nov 2026 15:20:56 +0100
Message-ID: <20261118150336.925004280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


