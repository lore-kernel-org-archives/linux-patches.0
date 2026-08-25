Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B4845DF7A;
	Tue, 25 Aug 2026 13:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665928; cv=none; b=AzP5/olaaYuNNjEXwfJq1Up2eFPPKCG4OzpXtfFucoxaElfHTPhrCBMMF9EsKYexwwqAwDhKULuHT5+um41OHVVk+1mcWmyANfq+ooT47nsLQX7NpyauBdC3hM3O6wax6yD4g2dc9pcI+jb629NPwZri4f9+Mh/MRlqoZ1OM7Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665928; c=relaxed/simple;
	bh=16u24YVw7R43J1Ktjffjkgcgj+/u5RwACpga+twNcfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6XkYPPHS3BPVNE74FDi8ghMeTXIUg+weiPCrKOXzAi+NZ58EnCI4UhbzIG0lBSqE9bjBTf0VVuFOFJo5OTgVjiHzVAGFtoj3chTMeZr0oCCGSMWgXKIYe31iXXY4siCJ+mKb7pNELVLF/+7QqkYoUm97idVinVlgU10RNkkHkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4+/2+wP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4+/2+wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EAE1F00A3A;
	Tue, 25 Aug 2026 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665926;
	bh=1TLzJL+zWxV8h027B8qvd8qFJl94F+7BaFhM+zZtze4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4+/2+wPAhCSrDL8bM8ukU9GppJUTallUcT5lRjQQIqtmjvxh73MsBdmYGAh4EqwF
	 lPF4nMK1iFH4gx0JBQiaHrxFV5yUZJ56GgKgR4E0NFDgR+jZpW8oXTdCvCAauJSKpc
	 xJ5+jPzC6x4riZNdLxQmUUEZJzqmQqmciCvfJaB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luca Fresi <luca.fresi@bithiatec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/79] serial: sc16is7xx: enable THRI before filling TX FIFO
Date: Tue, 25 Aug 2026 15:26:05 +0200
Message-ID: <20260825132542.680437463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -874,6 +874,9 @@ static void sc16is7xx_tx_proc(struct kth
 		msleep(port->rs485.delay_rts_before_send);
 
 	guard(mutex)(&one->lock);
+	sc16is7xx_port_update(port, SC16IS7XX_IER_REG,
+			      SC16IS7XX_IER_THRI_BIT,
+			      SC16IS7XX_IER_THRI_BIT);
 	sc16is7xx_handle_tx(port);
 }
 


