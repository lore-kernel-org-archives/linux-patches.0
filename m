Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320F218A95F;
	Wed,  3 Jul 2024 11:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005177; cv=none; b=JuQDPXMC9yNRoh8m6+z8iTrS0hlhIv4CVEJ97H7Cu3q/iWjr5KUvJV01aNG4dMCnh/pyZcV0+zKgZjX16TKYMCDPBZdtxYcwuqfXosgWZoXGacd+9VrnmtcyBsn80piTtYk4hiulFma3tgeRk3HjH7B0lXnkD4efUmOzr2jLhx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005177; c=relaxed/simple;
	bh=Pbqg8LcGIk5VMGG6Uu7Z9CY3ASXinFP54zIKgDgfD0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfLtdNIhPIJ0ltR/m3/s6FlWbGkmus60XPzz14s4jTIL99qgSAhfxsUDWVSA6zvhYxd6tb3nT15aJUXsfdIzItUwLOmwFXSvT8VIZYHcjIQ/2FDb49LrXdBIf261NuvFGPnDGfJ0jyAND6wnjfSKJd9d7SsxeQ1Kj8R7i42dbyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDR4c3MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDR4c3MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FE1C2BD10;
	Wed,  3 Jul 2024 11:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005177;
	bh=Pbqg8LcGIk5VMGG6Uu7Z9CY3ASXinFP54zIKgDgfD0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDR4c3MM2VVIOCUbaY4U1glp8n5yoXuxM08wozZ0SnhKB754m+M7x/OFuOz9KcINA
	 OkQseAjCzetWMeynPAu6sCYDBxELexd/mPZBiDkqQfta6SedlQLUMlZXrceVs/eyoG
	 57j4Bvy6jyvVdLqDZ/JHO9qhpzqHCl6jtq83/cGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: [PATCH 5.10 259/290] serial: imx: set receiver level before starting uart
Date: Wed,  3 Jul 2024 12:40:40 +0200
Message-ID: <20240703102913.928202097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit a81dbd0463eca317eee44985a66aa6cc2ce5c101 upstream.

Set the receiver level to something > 0 before calling imx_uart_start_rx
in rs485_config. This is necessary to avoid an interrupt storm that
might prevent the system from booting. This was seen on an i.MX7 device
when the rs485-rts-active-low property was active in the device tree.

Fixes: 6d215f83e5fc ("serial: imx: warn user when using unsupported configuration")
Cc: stable <stable@kernel.org>
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Link: https://lore.kernel.org/r/20240621153829.183780-1-eichest@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1954,8 +1954,10 @@ static int imx_uart_rs485_config(struct
 
 	/* Make sure Rx is enabled in case Tx is active with Rx disabled */
 	if (!(rs485conf->flags & SER_RS485_ENABLED) ||
-	    rs485conf->flags & SER_RS485_RX_DURING_TX)
+	    rs485conf->flags & SER_RS485_RX_DURING_TX) {
+		imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
 		imx_uart_start_rx(port);
+	}
 
 	port->rs485 = *rs485conf;
 


