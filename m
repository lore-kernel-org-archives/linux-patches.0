Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD43B83F9;
	Tue, 25 Aug 2026 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665535; cv=none; b=Yzcioep0YMHz9nM99D7YYwyLsCT0vc+CkcmXXanfAmGChz7TK4VRh16EeL3DYLH0AS9wJzn3tbNbhDvU2XuZE+lg6ubBKDJm19JpFRcFSkhoU0Mfm7A3T2+E98SSFng6ttL74BuHX7sZHCmcOIfT4f79YtwoB7Rm9sp2G769CEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665535; c=relaxed/simple;
	bh=7UIWMKwT8g64LJGDyNYorJ9T/PD3mIdc8oehGWsvK7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jT+vEi8ehr6JkpiuNE9+xOraEh+TJQ+XyjESAY1Aen97YxJxzhNl3/GVwe9wHRb4g+IdXyWehyCzoz1t3xWtw8sqT44sYfGqF4r1nzzNzjr6NzQ4MfIaIZ66G13Oof+sl1PZMguPuUqYRTHJTdIkugSG9oogUchwdj1a7lh7Mi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPTRMmK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPTRMmK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B035B1F000E9;
	Tue, 25 Aug 2026 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665534;
	bh=ou9D8TMspWkOvxlXxI3tXGy0p/C/X3xpC21v0bX0BOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPTRMmK1Gzm79xXnSUP3o6Awlf6WWe2knDEJctEGybMuOvBSFogH5C5szA9cULkKt
	 tsMnJ7LjaVol6A/uu5adtfC0649kX75jz1VyZcVH3VNB3CmATPy+I1FPxNpGq6FvE7
	 vRXu49aFrRMrrE5T4//nq18PkqQswdHDvNF57I48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luca Fresi <luca.fresi@bithiatec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 19/77] serial: sc16is7xx: enable THRI before filling TX FIFO
Date: Tue, 25 Aug 2026 15:25:41 +0200
Message-ID: <20260825132542.314451414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Fresi <luca.fresi@bithiatec.com>

[ Upstream commit 246ac114f485c2affb454240f3ea4fabfce22456 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -859,6 +859,9 @@ static void sc16is7xx_tx_proc(struct kth
 		msleep(port->rs485.delay_rts_before_send);
 
 	guard(mutex)(&one->lock);
+	sc16is7xx_port_update(port, SC16IS7XX_IER_REG,
+			      SC16IS7XX_IER_THRI_BIT,
+			      SC16IS7XX_IER_THRI_BIT);
 	sc16is7xx_handle_tx(port);
 }
 


