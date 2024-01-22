Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9758C6EB61;
	Tue, 23 Jan 2024 02:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975413; cv=none; b=e5CftG9HJWO6T2m0E6Xx77/FtHhjtqs6ZoqfAZ+yCO9b4dvKOemIN8szhknKk8yacwEbRewqjpbOHFVEWtPQBufm2NDt/B0iYq8Afx+mjWUFxIoNDLPJM2sYiGAgDbTDLOqJFXyz4Ry+dteFV9ULZE6LGkU2fCTRbkCu/g2Luh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975413; c=relaxed/simple;
	bh=JZJR6sPy54ZdoL0HiP3fzXIfhYlTc1+Si98iegLA/38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oELc0QaoH0rQoLAJcqSIuddvMpXQzf2etRQeqytmOjB+Z4uIGZsF5bFtpLR45xtRp/aRTKUxo3swa3L2zfVKnO1r0RGRAjrkXqYR0DIXNU3IPW0sibPPLaOTU71E7Ges9hXW2GCSLhrHeyse4ZzA/kxsko9S8wt2FdGTpVjQRUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nP3ZqG2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nP3ZqG2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B98C43390;
	Tue, 23 Jan 2024 02:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975413;
	bh=JZJR6sPy54ZdoL0HiP3fzXIfhYlTc1+Si98iegLA/38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nP3ZqG2/fR1HLPYPmpiq0I+58Lwtp1eGjkvVc3lTptj+yZptlHKQhoFeximqJu26R
	 IPEQSAtdr4zi5q0VVv4Se1xNdEATBqm0/ytct4y0bxAL93XVAjmrvCxQxxKxWYm/NA
	 4DgsCo2ofXzyYtpEhI3Rwl3VmIoJxhgcQ2rVnNNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.6 372/583] serial: core: fix sanitizing check for RTS settings
Date: Mon, 22 Jan 2024 15:57:03 -0800
Message-ID: <20240122235823.389331157@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1370,19 +1370,27 @@ static void uart_sanitize_serial_rs485(s
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
 


