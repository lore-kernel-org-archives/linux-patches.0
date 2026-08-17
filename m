Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298DF3B9943;
	Mon, 17 Aug 2026 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974360; cv=none; b=oTLmflfXqXMb4w4+5wNK13eEkf3sOcKsdjWiQ2rdBOKnZG2SvwxzaEHUtpyzB5f+uwR//emjEJO/U2/14VbWwcmjaeM7gTtJk/WIpCzC8zHrmJMbjjekI6of44ZO8lpcm8cG8qKJKDG0uWrpxBSilnW4ot/RrQ1b23P7d2X57y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974360; c=relaxed/simple;
	bh=kdWIHoR8ANAertbsUog2Pp9M6tQtmMA6cWXQO+73Mrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGzXX3V8ToJX9kLG9UVr5TtbLX1LWEGm7BXRpnl0RQ3x/wrcg6qiDI4q1/e/OqVubvWtfscP7cMU+c+dV+7h9bzrhMtAVAbJa0bWmYLZNmPDmwaDreK7j0TvlVQrwVGgNiJx8wMnGPFhhSLlADkUkHtBPeb2DyHKC0NaSdq0zZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A33szzAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A33szzAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C8B1F00A3A;
	Mon, 17 Aug 2026 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974356;
	bh=IQw6+7jdXri0E3r21cgoIm6QbQiV2UcLa9I1baEhD0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A33szzAJ8MMWbRnQlAdELjoJBYQhDPe+NqgSMjVsolqD2Imd7Q77fxC1gzAJjB/o+
	 gyNE0OZAeWyD85TacL0AF3bvKIp7mokVKsdazcTbMfcXj38YMfLgEg5mTX6alnuyoK
	 Pagxl6Yf0Y3sYZIiEUeWGjoPWe2l79bD+egneVuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luca Fresi <luca.fresi@bithiatec.com>
Subject: [PATCH 7.1 178/271] serial: sc16is7xx: enable THRI before filling TX FIFO
Date: Mon, 17 Aug 2026 15:31:43 +0200
Message-ID: <20260817132544.165350190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Fresi <luca.fresi@bithiatec.com>

commit 246ac114f485c2affb454240f3ea4fabfce22456 upstream.

sc16is7xx_handle_tx() currently requests the THRI enable only after it has
filled the TX FIFO. The request is asynchronous because the IER update is
performed later by reg_work.

The SC16IS7xx generates a THRI interrupt when the TX FIFO crosses its
trigger level. If the FIFO drains past that level before reg_work enables
THRI, the chip does not generate a new interrupt. Characters remain queued
indefinitely even though the hardware FIFO is empty.

This was observed on an SC16IS752 while both UART channels were active.
During the stall the software TX buffer remained non-empty while TXLVL
reported 64 bytes free, LSR reported THR and transmitter empty, IER had
THRI enabled, and IIR reported no interrupt pending.

Enable THRI synchronously before filling the FIFO so the threshold crossing
cannot be missed.

Fixes: cc4c1d05eb10 ("sc16is7xx: Properly resume TX after stop")
Cc: stable <stable@kernel.org>
Signed-off-by: Luca Fresi <luca.fresi@bithiatec.com>
Link: https://patch.msgid.link/20260721222404.204746-1-luca.fresi@bithiatec.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -828,6 +828,9 @@ static void sc16is7xx_tx_proc(struct kth
 		msleep(port->rs485.delay_rts_before_send);
 
 	guard(mutex)(&one->lock);
+	sc16is7xx_port_update(port, SC16IS7XX_IER_REG,
+			      SC16IS7XX_IER_THRI_BIT,
+			      SC16IS7XX_IER_THRI_BIT);
 	sc16is7xx_handle_tx(port);
 }
 


