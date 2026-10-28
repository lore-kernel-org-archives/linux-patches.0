Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211286;
	b=DZSltddUhOsv/pE1KtuEGDPXhUHE2kKDXAKY0J3TQ+cNhOVsED/Mq32ZeuxePlB99L8W
	 aLEQl7ZEMT8BzHpqYoWXaBr+dw8MaaoKoqaWpRvQmYb/oZep+kOFUap0LNYjlLvGYqvW9
	 RdZTNJNg0n9Ra6pkQR9Hi7G4SNjeJBTXQ85NomHX6JiS6pHA9JK8ukBHvEItPQdlBfMvY
	 8RlToXxltZtbGKn8Bl1fChDWtkrntgDREGeFJEm1VQzImtWSkGggiJ2/4oldOxqCpFQ4k
	 cRZ/QKLbi1BaZHZr+k56joeNDqeO4fSwrcYg8hGqBVOhMVS1ysPNzVKAIFzufwbzsjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PyciHQ91MACIJ/us+17kvAem3u4E8SErn1Zmj1Gn8iI=;
	b=iRXFMTK/sQ8qQ6IgLy4FdJGBhyZzNiJA+qNEE7gV5QmUC0yflYD0E1Ssm9hhwlQQ9Non
	 TwviKVmwX2gH9eYgjRnJEzmog7h2zLhsusb0u+5sH898knJY6KFTBD/9Fgr/YXyLvjALH
	 U4z21AJJcKFcuAWER07VCWW4guFAXRYap2SV+4cS83zfTW0kxQGyAqFlsaXUblXxAfhOb
	 ZG5/MI6PWzeDYUcklhYpLLHvwI4NrBLzHti3DoLsIwML09+hngnq+vyqOKYWW+It6p6Hk
	 3b0rXy2WUB+aoHF7qyqEQPAijb4co6SbkirIKevKkOYAzuexQAORSFaIcuHcb6qIyjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=es0BxFsE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D258960A2621;
	Wed, 28 Oct 2026 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=es0BxFsE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8B01F01829;
	Wed, 28 Oct 2026 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211285;
	bh=PyciHQ91MACIJ/us+17kvAem3u4E8SErn1Zmj1Gn8iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=es0BxFsEvYWYEMxir3+Frfc1JIsNVpBki7trK27erisFutKyc8DMT/w4SNwoeV2i8
	 4hE/5wY2upiSOxmWIZl3rTInR+MehZRTnIILu1qNoRosT1YbD591D9HKtd/eJrj4mU
	 rRgMDwrhcLkFXkPSU4KUfVf3lL/B2WGxd4/PQKCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/571] serial: fix TIOCMIWAIT race
Date: Wed, 28 Oct 2026 17:57:44 +0100
Message-ID: <20261028170015.521698285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 40adffec8c0090533dfaa863ced7901b60bbf1dc ]

The task state must be updated before checking the wakeup condition to
avoid missing a racing modem status update.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260904115542.E20D11F00A3D@smtp.kernel.org
Cc: stable@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adjusted context for direct spin_lock_irq() and spin_unlock_irq() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 404354727d194..1cba822e068e9 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1213,12 +1213,12 @@ static int uart_wait_modem_status(struct uart_state *state, unsigned long arg)
 
 	add_wait_queue(&port->delta_msr_wait, &wait);
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		spin_lock_irq(&uport->lock);
 		memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
 		spin_unlock_irq(&uport->lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-- 
2.53.0



