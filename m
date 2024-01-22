Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B44C651B3;
	Tue, 23 Jan 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971570; cv=none; b=InUKi0gW9xcpfHogAXSFrPp3+HnTM9S30vDVWXBjQmVoNJutyHgvUcUqP51ZHMAP4JOazcYKG4JynRybmCBthfo6aAHENhQXNvBSSFy2enNk/P50je3Ix29xuDg/v6eFkxrFiwGJZcfYKQMg96hGKnkOOmfmawRYH8pedIkbr5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971570; c=relaxed/simple;
	bh=xCJbNeqg/40B0MN/xR4oyY3EYnZd7nsKGFdmVO4PGCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVzXP3zhOEQlZDkxGMIV8O7A31GJ1eRu6ATOsLY3DpHAu5xbccEy/fV+F85XHqFHx1DSdbmDiVwmYSknpySGZIH0TQMPcjbYm90YkfnATSShUUe8qQKgW2AIC+jdrA9trWcccK+ApP53jJDCHBNdonWuXglYbzANFf5T+A9d9Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuqSYHNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuqSYHNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC67C433C7;
	Tue, 23 Jan 2024 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971570;
	bh=xCJbNeqg/40B0MN/xR4oyY3EYnZd7nsKGFdmVO4PGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuqSYHNTBL8WyYuIDNVYs0KQVyUCTiBHzMxFnB7/BeW+zauCnuf5+d13LvscgDYHz
	 jNUbQEPLfVPVERNHoFmB0X1zI5NUvCIFmbagzOgRR3m6D9tKw/zrkP3cSjTjh9B8uU
	 nIHct5QwkNyszN+EMhU34heDdBQEfIFhI4QW1YRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.1 270/417] serial: core: fix sanitizing check for RTS settings
Date: Mon, 22 Jan 2024 15:57:18 -0800
Message-ID: <20240122235801.205865967@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1353,19 +1353,27 @@ static void uart_sanitize_serial_rs485(s
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
 


