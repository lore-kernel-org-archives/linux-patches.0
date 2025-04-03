Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA11E2505C1;
	Thu,  3 Apr 2025 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693863; cv=none; b=Qq9SmblRI8rSwwxRvqJ8MbykDsz8KcocPqjxLBCAkFKFJJdXlEeg+z+RG5PjgdcLsKDgLjKIlFuAmueGRX8bvXV06OBd6s0z/p3a6dcHxFkRfbs17V/u9cgWJFzg9+6ymov/81KH4nzbJQGsZKk8wdshR7GiNx9BijknzYqOctA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693863; c=relaxed/simple;
	bh=TQk5GAC+yIGchf5sKPu+b/cjf50MpzJOnDdeqqovitk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjGEPsWICtJOV/2zRPh65tgwwHAFLQjPGJ/4pcSKHWu6ciuNkBYZXzc+2cRJoxEqzq/vLk3XXSo/7eX6hYSotraLX3DRF8GnUwvNsOCYEYIqJ+j37FFBacKz/xHA75/AkrjIbk4FSxldoAWPRaH2fkMZfOF/C3CYosIusn7ATNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swwdCyk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swwdCyk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11959C4CEE3;
	Thu,  3 Apr 2025 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693863;
	bh=TQk5GAC+yIGchf5sKPu+b/cjf50MpzJOnDdeqqovitk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swwdCyk1NHCxcr0o7cAknTXcr856mOK3LwjnfH5jaqmZpldyfxgVw1hS5Blfr//tp
	 J6/JQEJQu0VIMbBe7kb9S7ATtCh+2MlAdcsJZXpqqCsvyc4nluvlWuKby50I7wyBh9
	 RREhzBy/zqUt9AA6ZSOEwdSe9DpWp1zHIWOrwwAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 12/22] tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers
Date: Thu,  3 Apr 2025 16:20:22 +0100
Message-ID: <20250403151622.390649696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sherry Sun <sherry.sun@nxp.com>

commit f5cb528d6441eb860250a2f085773aac4f44085e upstream.

According to the LPUART reference manual, TXRTSE and TXRTSPOL of MODIR
register only can be changed when the transmitter is disabled.
So disable the transmitter before changing RS485 related registers and
re-enable it after the change is done.

Fixes: 67b01837861c ("tty: serial: lpuart: Add RS485 support for 32-bit uart flavour")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250312022503.1342990-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1483,6 +1483,19 @@ static int lpuart32_config_rs485(struct
 
 	unsigned long modem = lpuart32_read(&sport->port, UARTMODIR)
 				& ~(UARTMODIR_TXRTSPOL | UARTMODIR_TXRTSE);
+	u32 ctrl;
+
+	/* TXRTSE and TXRTSPOL only can be changed when transmitter is disabled. */
+	ctrl = lpuart32_read(&sport->port, UARTCTRL);
+	if (ctrl & UARTCTRL_TE) {
+		/* wait for the transmit engine to complete */
+		lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+		lpuart32_write(&sport->port, ctrl & ~UARTCTRL_TE, UARTCTRL);
+
+		while (lpuart32_read(&sport->port, UARTCTRL) & UARTCTRL_TE)
+			cpu_relax();
+	}
+
 	lpuart32_write(&sport->port, modem, UARTMODIR);
 
 	if (rs485->flags & SER_RS485_ENABLED) {
@@ -1502,6 +1515,10 @@ static int lpuart32_config_rs485(struct
 	}
 
 	lpuart32_write(&sport->port, modem, UARTMODIR);
+
+	if (ctrl & UARTCTRL_TE)
+		lpuart32_write(&sport->port, ctrl, UARTCTRL);
+
 	return 0;
 }
 


