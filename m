Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828890;
	b=s2ulqIzeiNKsD+tsmPeEkZoZbYxRl0CRQTztuuNc7Ak6nxU4RH4iDMyo5MqeGtVoOjuw
	 dfLIeUPckI7Z0OowNH3cdC95y6Qu+TxJpriFVPl4O5vrAXFKDbmvTRN5zkF6AWlcNw11C
	 C+dnCYSHAUe2t6xnbv8llcaEXEoPNcu/tN2B2JgFI+RplD0ww8+6EJNtpEWgkzTzguupV
	 BfL0JCduVHusqEOz/rM2uNHB+lPKOnPTiiqU8fHvxB/W2kOruB8xMk8tUgSjnPIcuzY6v
	 y9Xj2oDdPqh11DI5vUrL05JMujp3Sr8xmKB25kueNUVf7MhWi9+KUsBnk4QyqGuEMDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E5rcZYyHeNtpiJqZSwtcIpI7u3p5qDQ08DVyFs/aR48=;
	b=lo6a4g+R2tec5/304SDtZYGSYQUKg2K/a63QMQ55lQUnabb/AcTP8OHYxo9ik/3iKAf7
	 ZPMypE1EkoQoYjZtOXHE3eGNIo2ytVKEQpLg6nI8poC6rBP5t4gYCYPeVsBFrbhMTr1AR
	 Hfjzp01jV4CXMcVDjj9s/WitQNX1rwJWxJ/B8WM15odlbDy1OR87TDC5E4FbPG8PdM5AH
	 OE0vWQP9wDa0Yl3XIotmf+0rUVPLJZKxUuIz+TMbH4MKVsOBUQuR/8fjG72jkL7kS2DGc
	 sycw7wer/QXrlpcHBVON+hhBAm9fNu0UK3SnPZpJ2aFEcxzaF4idrMGdw/Qi8t8wvYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cU+UcM+v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835A16070415;
	Wed,  4 Nov 2026 21:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cU+UcM+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52AA1F00A02;
	Wed,  4 Nov 2026 21:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828890;
	bh=E5rcZYyHeNtpiJqZSwtcIpI7u3p5qDQ08DVyFs/aR48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cU+UcM+v1qTgtJTdWQ+UFuLnl61GCPN0FbGuWQYA1VUtPraCckvq0UxLAv0GyyR9V
	 TcONQlsc0aULtAOYb/uX1YscfJilaLQiOURLt0UxE2DBZ5a02OllVYHa0nEQ4dCCOo
	 IeQPb46uYHqvSzwEvuf+CiKMisEtipzv53aTGODw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 267/547] media: rc: mce_kbd: Fix inconsistent locking of keylock
Date: Wed,  4 Nov 2026 16:07:31 -0500
Message-ID: <20261104211045.773308047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


