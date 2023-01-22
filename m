Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AA72590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3B4C433EF;
	Sun, 22 Jan 2023 15:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400435;
	bh=104OlxchH7FoR/SMWwK/ndCYooV/s02RnjfbRtSdEZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+/FNaM1vQxZ/EAwz3RK/gmPSp8KSKTi2WCkJFNJjLmqvtbshtOpdZjb/9rqTtDZc
	 69Sg409wiv1PXAbtW2w/dQhmXSWxdhLmj7g4qz1dd+VyuMaCUwQ/FdwRLnQ2nPD5yP
	 QmbMZhFetc7/NpiYF6PLLW9x1vtgYXa+NddsWNhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tobias Schramm <t.schramm@manjaro.org>,
	Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 5.10 73/98] serial: atmel: fix incorrect baudrate setup
Date: Sun, 22 Jan 2023 16:04:29 +0100
Message-Id: <20230122150232.528185814@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Schramm <t.schramm@manjaro.org>

commit 5bfdd3c654bd879bff50c2e85e42f85ae698b42f upstream.

Commit ba47f97a18f2 ("serial: core: remove baud_rates when serial console
setup") changed uart_set_options to select the correct baudrate
configuration based on the absolute error between requested baudrate and
available standard baudrate settings.
Prior to that commit the baudrate was selected based on which predefined
standard baudrate did not exceed the requested baudrate.
This change of selection logic was never reflected in the atmel serial
driver. Thus the comment left in the atmel serial driver is no longer
accurate.
Additionally the manual rounding up described in that comment and applied
via (quot - 1) requests an incorrect baudrate. Since uart_set_options uses
tty_termios_encode_baud_rate to determine the appropriate baudrate flags
this can cause baudrate selection to fail entirely because
tty_termios_encode_baud_rate will only select a baudrate if relative error
between requested and selected baudrate does not exceed +/-2%.
Fix that by requesting actual, exact baudrate used by the serial.

Fixes: ba47f97a18f2 ("serial: core: remove baud_rates when serial console setup")
Cc: stable <stable@kernel.org>
Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Link: https://lore.kernel.org/r/20230109072940.202936-1-t.schramm@manjaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2633,13 +2633,7 @@ static void __init atmel_console_get_opt
 	else if (mr == ATMEL_US_PAR_ODD)
 		*parity = 'o';
 
-	/*
-	 * The serial core only rounds down when matching this to a
-	 * supported baud rate. Make sure we don't end up slightly
-	 * lower than one of those, as it would make us fall through
-	 * to a much lower baud rate than we really want.
-	 */
-	*baud = port->uartclk / (16 * (quot - 1));
+	*baud = port->uartclk / (16 * quot);
 }
 
 static int __init atmel_console_setup(struct console *co, char *options)


