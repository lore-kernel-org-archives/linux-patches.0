Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1F24E1D8;
	Tue, 23 Jan 2024 00:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970017; cv=none; b=UphmCtZ1RmzFv5NqU0JzYxyhHVfRurzA6r4Dsau4qSpym1pHl41iszHn91VZL1RGFrezBU4WngW74uGL+ot/Ad/jIHdF9eS1ycNKmC8ZuyDODuEpjWTDW4IdY/haUwMDF87CwtLNxHwrMa4avoJDxjHCSVQiMHmTpFzXaYLZIYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970017; c=relaxed/simple;
	bh=S/53sIyORfbtW3JOS2dHshgCOdYsZ3OWICKBCDBYBJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHcDxTz8+8xnTRn8s43smFFF6U/Jz+CImBfyH4eQzvjsxLEBsoP/Ubb71o8rwlcdhRNaGhxB3OKEgAAqGLibS0Z+M7+W5kFB90o36bOO3wgOBkdsPHYNn/gFLTE3cjXnSGFYgK2yBV35Qze3a4PErfnkzRBmrfN952/VOuW8URU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hD5KGhzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hD5KGhzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34279C433C7;
	Tue, 23 Jan 2024 00:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970017;
	bh=S/53sIyORfbtW3JOS2dHshgCOdYsZ3OWICKBCDBYBJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hD5KGhzqqppk5P/oKIrouzfVu+Osph+hQoA3nD9JeDUdcg/Dc14KXH/Lxb/EHMkjV
	 WTT1huYA0zOuf1mcZ0hOznmcDH2xbPnoufsFGCzRZYnjKHiL63Ivz7WZpISJzQjLIQ
	 7lKfgK1VCgDpZ+vjQw6xTjdK+tK8rlKdPYUO9dsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Ravnborg <sam@ravnborg.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	linux-serial@vger.kernel.org,
	sparclinux@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 564/641] serial: apbuart: fix console prompt on qemu
Date: Mon, 22 Jan 2024 15:57:48 -0800
Message-ID: <20240122235835.807377892@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Ravnborg <sam@ravnborg.org>

[ Upstream commit c6dcd8050fb7c2efec6946ae9c49bc186b0a7475 ]

When using a leon kernel with qemu there where no console prompt.
The root cause is the handling of the fifo size in the tx part of the
apbuart driver.

The qemu uart driver only have a very rudimentary status handling and do
not report the number of chars queued in the tx fifo in the status register.
So the driver ends up with a fifo size of 1.

In the tx path the fifo size is divided by 2 - resulting in a fifo
size of zero.

The original implementation would always try to send one char, but
after the introduction of uart_port_tx_limited() the fifo size is
respected even for the first char.

There seems to be no good reason to divide the fifo size with two - so
remove this. It looks like something copied from the original amba driver.

With qemu we now have a minimum fifo size of one char, so we show
the prompt.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Fixes: d11cc8c3c4b6 ("tty: serial: use uart_port_tx_limited()")
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc:  <linux-serial@vger.kernel.org>
Cc:  <sparclinux@vger.kernel.org>
Link: https://lore.kernel.org/r/20231226121607.GA2622970@ravnborg.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/apbuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/apbuart.c b/drivers/tty/serial/apbuart.c
index 716cb014c028..364599f256db 100644
--- a/drivers/tty/serial/apbuart.c
+++ b/drivers/tty/serial/apbuart.c
@@ -122,7 +122,7 @@ static void apbuart_tx_chars(struct uart_port *port)
 {
 	u8 ch;
 
-	uart_port_tx_limited(port, ch, port->fifosize >> 1,
+	uart_port_tx_limited(port, ch, port->fifosize,
 		true,
 		UART_PUT_CHAR(port, ch),
 		({}));
-- 
2.43.0



