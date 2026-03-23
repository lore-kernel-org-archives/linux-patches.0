Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F0321D00A;
	Mon, 23 Mar 2026 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273955; cv=none; b=UFWzvI2cOi7zkNoyn4LgRyVLi9eFNbMPQ4h/FP0rDdiUBSB/LgazZptcTnLoQ8xSng6HI0lQNfYLrkaNDTrDU8Pb2KpGHvkldEQW8er4WmYWzfhn3h5pa1Gut3rBxsYn+mWW/iSgjqKGslxk748XYLcyeRioRnMUkpM5oUe3K9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273955; c=relaxed/simple;
	bh=pHBeLxE//LaKk9Cnb5KOS/WtqutLFOcPntqNBNYY/Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy+8Ck8ngMmopA1ADRUY4qA3IZySjR5wkfH+71nqmBP9EddZqDtEVIg4mV/hDrKoq4p3vih2tO46X4hU9Yg00LY5HXBlWxOIyrRgOuc+Nwy7TAe1oxfJY+ZK223zvCwnq0fWvmg9QZ5epARfPv4vMP3B28ox+yLWpM1JfRn2tqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBfHFQAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBfHFQAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB99C4CEF7;
	Mon, 23 Mar 2026 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273955;
	bh=pHBeLxE//LaKk9Cnb5KOS/WtqutLFOcPntqNBNYY/Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBfHFQAIHD4Vr6A+89iC5DQ5JiFcmnRzDmUk4xKSLCgX5R4TWtVNhUyS5qUebGA08
	 0KtPPws6XJ+Ea7scLL02WN2qBQqDLk3qUJuNXRsY3Bz/7DkW58GHUhxgQ39IN3PXaQ
	 Lb1OQ0VmDbsvi6fw6liW5ybDXJwRL6RtDmlPGHso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Maximilian Lueer <maximilian.lueer@lht.dlh.de>
Subject: [PATCH 6.19 061/220] serial: 8250: always disable IRQ during THRE test
Date: Mon, 23 Mar 2026 14:43:58 +0100
Message-ID: <20260323134506.520571377@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit 24b98e8664e157aff0814a0f49895ee8223f382f upstream.

commit 039d4926379b ("serial: 8250: Toggle IER bits on only after irq
has been set up") moved IRQ setup before the THRE test, in combination
with commit 205d300aea75 ("serial: 8250: change lock order in
serial8250_do_startup()") the interrupt handler can run during the
test and race with its IIR reads. This can produce wrong THRE test
results and cause spurious registration of the
serial8250_backup_timeout timer. Unconditionally disable the IRQ for
the short duration of the test and re-enable it afterwards to avoid
the race.

Fixes: 039d4926379b ("serial: 8250: Toggle IER bits on only after irq has been set up")
Depends-on: 205d300aea75 ("serial: 8250: change lock order in serial8250_do_startup()")
Cc: stable <stable@kernel.org>
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Tested-by: Maximilian Lueer <maximilian.lueer@lht.dlh.de>
Link: https://patch.msgid.link/20260224121639.579404-1-alban.bedel@lht.dlh.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2147,8 +2147,7 @@ static void serial8250_THRE_test(struct
 	if (up->port.flags & UPF_NO_THRE_TEST)
 		return;
 
-	if (port->irqflags & IRQF_SHARED)
-		disable_irq_nosync(port->irq);
+	disable_irq(port->irq);
 
 	/*
 	 * Test for UARTs that do not reassert THRE when the transmitter is idle and the interrupt
@@ -2170,8 +2169,7 @@ static void serial8250_THRE_test(struct
 		serial_port_out(port, UART_IER, 0);
 	}
 
-	if (port->irqflags & IRQF_SHARED)
-		enable_irq(port->irq);
+	enable_irq(port->irq);
 
 	/*
 	 * If the interrupt is not reasserted, or we otherwise don't trust the iir, setup a timer to


