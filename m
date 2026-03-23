Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFCF37F8A0;
	Mon, 23 Mar 2026 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274670; cv=none; b=bB1294L300i6t5EYPYQ9JQdS/cxrZ1EMc+eFRDtJlpwdzbA1ihumFUS+A7a+a0fT657e4SXnt5/FRQFzCCGK9zfGkRhIeSvOFmWGun3Uk1tT9toK2Jb8EPeooNE4HcUTlx8L8PkBvyf4Fwrjsu0u1P0oT/OMX7gOfbdGjHMYX3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274670; c=relaxed/simple;
	bh=b1PPCsrFx25rA4vir2uCA3xbpfg+r7juDLCOrs1dcdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bxFHyVmrxBHKDIri/T00gpa/Gnla/39I2Bdi+B5sFSTTCjcOJb79Q8HO56FY8U4lovF1QHQISgQi9xlapdNrwdaEyV1+MnIG0atLMeEz7ilGE7zWprYNlHOpDka8GfJAxLQ9yD60u4jNK/XgDu7RVsWsxn4MWVzxA+XAQl0sUTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVEcZnYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVEcZnYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26CDC2BCB3;
	Mon, 23 Mar 2026 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274670;
	bh=b1PPCsrFx25rA4vir2uCA3xbpfg+r7juDLCOrs1dcdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVEcZnYEiTUmHt7SJytF6ZdG+Qx1sf+V1tf01NiEBcCrdRZv3oEZrqwIfhG1Wc5Pm
	 wls4rZw6BtK8EDJ8KAb/cC9Hj/9OOFMJf+B5kmTyATdO4sw5y240P7Bn7WykSXjPbE
	 ES8Gy/AuqYGE6IS0L3kgZocYKFd2cQE7MTtF+g7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bandal, Shankar" <shankar.bandal@intel.com>,
	"Murthy, Shanth" <shanth.murthy@intel.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 070/212] serial: 8250: Protect LCR write in shutdown
Date: Mon, 23 Mar 2026 14:44:51 +0100
Message-ID: <20260323134505.983276919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 59a33d83bbe6d73d2071d7ae21590b29faed0503 upstream.

The 8250_dw driver needs to potentially perform very complex operations
during LCR writes because its BUSY handling prevents updates to LCR
while UART is BUSY (which is not fully under our control without those
complex operations). Thus, LCR writes should occur under port's lock.

Move LCR write under port's lock in serial8250_do_shutdown(). Also
split the LCR RMW so that the logic is on a separate line for clarity.

Reported-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Murthy, Shanth <shanth.murthy@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260203171049.4353-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2348,6 +2348,7 @@ static int serial8250_startup(struct uar
 void serial8250_do_shutdown(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
+	u32 lcr;
 
 	serial8250_rpm_get(up);
 	/*
@@ -2374,13 +2375,13 @@ void serial8250_do_shutdown(struct uart_
 			port->mctrl &= ~TIOCM_OUT2;
 
 		serial8250_set_mctrl(port, port->mctrl);
+
+		/* Disable break condition */
+		lcr = serial_port_in(port, UART_LCR);
+		lcr &= ~UART_LCR_SBC;
+		serial_port_out(port, UART_LCR, lcr);
 	}
 
-	/*
-	 * Disable break condition and FIFOs
-	 */
-	serial_port_out(port, UART_LCR,
-			serial_port_in(port, UART_LCR) & ~UART_LCR_SBC);
 	serial8250_clear_fifos(up);
 
 	rsa_disable(up);


