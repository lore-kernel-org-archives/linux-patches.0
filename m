Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E69F612D7;
	Tue, 20 Feb 2024 21:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463897; cv=none; b=QNlb8FfdM7PT4IU04ilILK6AMVVYEFpIo9kSUvdc9vTn6bh12mDbl2Vxss6s1JAVmvLhVZBeZ0VNjvGSTSCnwyIn/RvIQctP+bKzgdhbzGhUOvsXJLZGKg2Hjj0dbLDCmSQKP25se6+xja9MWkWCvHy/x98UJysOh5eM82QZYEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463897; c=relaxed/simple;
	bh=Lf7ljG+JVyslXUvBda8cdY2Z4WxgG7ie3JIdyw9ioj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrrWTREYkEXkP8AcbCJwhH/yrrt2y6LzPcfxklEs3Wah3QaQ9d9fa0XkwoV3Nc/DKMJ8L3vmFwfoFgO4sXWCrfrzE7c3bbEAuVrrcWCQ1INZYef1u67aj/bC9AketBgshxAfoy0Jt07F2K9T7uFTs56+CsT8R9wfUNg46xXur5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0yEIkTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0yEIkTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FC3C43399;
	Tue, 20 Feb 2024 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463897;
	bh=Lf7ljG+JVyslXUvBda8cdY2Z4WxgG7ie3JIdyw9ioj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0yEIkTw3mgn9aENwrGRWgYBB7K3F4pSQsPuzmd5rVm3sHX1Vfw6wQplzLPTzVWCM
	 5JtrYP0iloIBQ7HpWHWChFAbECW5WpEk1cbn+16VT+n7qYiTbsHF4ZzCCLosYSpuAw
	 GQ8YwDyf5psjgRR5LY3nTdxBkZW/EoEJ4zNrvZ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Emil Kronborg <emil.kronborg@protonmail.com>,
	stable <stable@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.6 188/331] serial: mxs-auart: fix tx
Date: Tue, 20 Feb 2024 21:55:04 +0100
Message-ID: <20240220205643.466743448@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 7be50f2e8f20fc2299069b28dea59a28e3abe20a upstream.

Emil reports:
  After updating Linux on an i.MX28 board, serial communication over
  AUART broke. When I TX from the board and measure on the TX pin, it
  seems like the HW fifo is not emptied before the transmission is
  stopped.

MXS performs weird things with stop_tx(). The driver makes it
conditional on uart_tx_stopped().

So the driver needs special handling. Pass the brand new UART_TX_NOSTOP
to uart_port_tx_flags() and handle the stop on its own.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Reported-by: Emil Kronborg <emil.kronborg@protonmail.com>
Cc: stable <stable@kernel.org>
Fixes: 2d141e683e9a ("tty: serial: use uart_port_tx() helper")
Closes: https://lore.kernel.org/all/miwgbnvy3hjpnricubg76ytpn7xoceehwahupy25bubbduu23s@om2lptpa26xw/
Tested-by: Stefan Wahren <wahrenst@gmx.net>
Tested-by: Emil Kronborg <emil.kronborg@protonmail.com>
Link: https://lore.kernel.org/r/20240201105557.28043-2-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mxs-auart.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -605,13 +605,16 @@ static void mxs_auart_tx_chars(struct mx
 		return;
 	}
 
-	pending = uart_port_tx(&s->port, ch,
+	pending = uart_port_tx_flags(&s->port, ch, UART_TX_NOSTOP,
 		!(mxs_read(s, REG_STAT) & AUART_STAT_TXFF),
 		mxs_write(ch, s, REG_DATA));
 	if (pending)
 		mxs_set(AUART_INTR_TXIEN, s, REG_INTR);
 	else
 		mxs_clr(AUART_INTR_TXIEN, s, REG_INTR);
+
+	if (uart_tx_stopped(&s->port))
+               mxs_auart_stop_tx(&s->port);
 }
 
 static void mxs_auart_rx_char(struct mxs_auart_port *s)


