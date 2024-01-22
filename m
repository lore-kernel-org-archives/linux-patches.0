Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E30A7C0BE;
	Tue, 23 Jan 2024 02:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975728; cv=none; b=PVU+xYuaWUSr3VcE2nt3dgyKl4kPZrlvUDID6rarXcO6Tw/dDOR/HeD7aT7ZZ2Q9HCZ28YAJAfEsBYtGFW4UTZdk37uIQy5RlSotF6fQEx7YvLAgJ6EXW/Qf/18dzUrLloUEeaZ3HWvj6ruaxLfLeTalyOzxr4zV8lJpJS5XDDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975728; c=relaxed/simple;
	bh=tp+zRZEkzvXxaTtmCpwCkNL2dDXaH90UCnFNprzlDXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2V4BNHCCiq9HzTnw3+2tPrPdfekxvrOsXUPJBWtg7LyuSi0DPqRRJoC1l6wlsFVLxVX24yVzv/46t6NgdHoyN++0IkrAzaDylujyPcdnSBxCBitxv/yKw9mvWN3SNR0G1usMbyafujbodymhKivqzVQVCATNUGRrhWBa97dMCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrg64FuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrg64FuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F65EC433F1;
	Tue, 23 Jan 2024 02:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975728;
	bh=tp+zRZEkzvXxaTtmCpwCkNL2dDXaH90UCnFNprzlDXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrg64FuORMFfCBm4v77eKP3qOmOJFPULMWV57DIRuXVu6npbgmgRByRMAmOVDgabp
	 fEMNewxFUrE2qGsRzoU15DTiOHaP9JdzkB+fWbmFrDa3hH1sEyX7ju3gVAedNf4R/t
	 9qieBH9ZuqorutJWLXS+ROtQyoF3hjVAPnKPsF3g=
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
Subject: [PATCH 6.6 512/583] serial: apbuart: fix console prompt on qemu
Date: Mon, 22 Jan 2024 15:59:23 -0800
Message-ID: <20240122235827.739885822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index d7658f380838..d3cb341f2c55 100644
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



