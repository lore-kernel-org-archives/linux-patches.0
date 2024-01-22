Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC44136658;
	Tue, 23 Jan 2024 00:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969697; cv=none; b=qel1BggNcw5nuow4UZWiBRz9I5/NCkj4iHW9a1bRpn+KUXb9SJcoAVWqgD4Sl1toWiTclFaRDXThpiijmt6QcpPflOQS+PAIaJHlLfV0LuIp+59UbRj4oCliRXeSWQIKJ8tv3oJ3mTieemyNYeyli326wHwfxSgEu9wezpqqJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969697; c=relaxed/simple;
	bh=QTK89Qr4I53BSao7WEW8TcnaXgs+QZsQ2ewW6uUMcxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J8e1ICnd7FOIOMwrEr/eGpQYWvRG1W5oXGC8/IEsigcmdk4UkOpyXYeuCHSlnbqJM3uujh/rxjHaUNz5o8nfXbLYYQxZ2oZdZvUc/EubWZRJxcxbM7TknlDgbIovmbm2ITYhBKyjxEgFvUE6BRpGtmSP0E/So5GESqfF16EuEtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsY0Aw9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsY0Aw9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389C2C433C7;
	Tue, 23 Jan 2024 00:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969697;
	bh=QTK89Qr4I53BSao7WEW8TcnaXgs+QZsQ2ewW6uUMcxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsY0Aw9DpmLCMfP/f4yUdw+/fwBYBF17I95WH6R0rrh4QIo94QVzVvd3bHedq4jgV
	 ssKqdMxFOzPcn+cImzj1yebNy4/3/DxxGsrux93RSwCJNLm7m5wBRehc5aEKlB70Sr
	 dKy8fS5ZrL8Sck/ENkR3JIav8t4VHJ3DNjjrFffQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.7 410/641] serial: core: fix sanitizing check for RTS settings
Date: Mon, 22 Jan 2024 15:55:14 -0800
Message-ID: <20240122235830.812351422@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 4afeced55baa391490b61ed9164867e2927353ed upstream.

Among other things uart_sanitize_serial_rs485() tests the sanity of the RTS
settings in a RS485 configuration that has been passed by userspace.
If RTS-on-send and RTS-after-send are both set or unset the configuration
is adjusted and RTS-after-send is disabled and RTS-on-send enabled.

This however makes only sense if both RTS modes are actually supported by
the driver.

With commit be2e2cb1d281 ("serial: Sanitize rs485_struct") the code does
take the driver support into account but only checks if one of both RTS
modes are supported. This may lead to the errorneous result of RTS-on-send
being set even if only RTS-after-send is supported.

Fix this by changing the implemented logic: First clear all unsupported
flags in the RS485 configuration, then adjust an invalid RTS setting by
taking into account which RTS mode is supported.

Cc:  <stable@vger.kernel.org>
Fixes: be2e2cb1d281 ("serial: Sanitize rs485_struct")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-4-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1371,19 +1371,27 @@ static void uart_sanitize_serial_rs485(s
 		return;
 	}
 
+	rs485->flags &= supported_flags;
+
 	/* Pick sane settings if the user hasn't */
-	if ((supported_flags & (SER_RS485_RTS_ON_SEND|SER_RS485_RTS_AFTER_SEND)) &&
-	    !(rs485->flags & SER_RS485_RTS_ON_SEND) ==
+	if (!(rs485->flags & SER_RS485_RTS_ON_SEND) ==
 	    !(rs485->flags & SER_RS485_RTS_AFTER_SEND)) {
-		dev_warn_ratelimited(port->dev,
-			"%s (%d): invalid RTS setting, using RTS_ON_SEND instead\n",
-			port->name, port->line);
-		rs485->flags |= SER_RS485_RTS_ON_SEND;
-		rs485->flags &= ~SER_RS485_RTS_AFTER_SEND;
-		supported_flags |= SER_RS485_RTS_ON_SEND|SER_RS485_RTS_AFTER_SEND;
-	}
+		if (supported_flags & SER_RS485_RTS_ON_SEND) {
+			rs485->flags |= SER_RS485_RTS_ON_SEND;
+			rs485->flags &= ~SER_RS485_RTS_AFTER_SEND;
 
-	rs485->flags &= supported_flags;
+			dev_warn_ratelimited(port->dev,
+				"%s (%d): invalid RTS setting, using RTS_ON_SEND instead\n",
+				port->name, port->line);
+		} else {
+			rs485->flags |= SER_RS485_RTS_AFTER_SEND;
+			rs485->flags &= ~SER_RS485_RTS_ON_SEND;
+
+			dev_warn_ratelimited(port->dev,
+				"%s (%d): invalid RTS setting, using RTS_AFTER_SEND instead\n",
+				port->name, port->line);
+		}
+	}
 
 	uart_sanitize_serial_rs485_delays(port, rs485);
 


