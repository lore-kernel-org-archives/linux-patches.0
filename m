Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F001BE86C;
	Tue,  2 Jul 2024 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941532; cv=none; b=uSlc/vDsVzgSJ6x6m7xyWcTkEXfQ1pGpyzOVdvJC8xxfbMxLiqhH+4TTPV9ulIkNvf23/xT5tS7TiKoaL73dGCOdUVkFx76uMM0jP5kAYBv5OdL7YTCNakJ4iT9B1Zii0fViIRQPU3AXUSnEhXqpXUDTt3qGJL5RGVA0+vTLqQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941532; c=relaxed/simple;
	bh=zVWpyYN2uHpKM51G8csXzUmip5nrQhAc2+bYh53a9s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFHq0Pcchie/QG7IS4d8nz40Ryy58SywbTlujM6oBjSmFx5C3qTa/jPjFmvlUx7NwuLxmaLpD/zlTMrnAlc9knTkL/+Vb7qcSZP/pQ2hf061OIrNf9gQqBTZ39sCbX4TchhGsi8S1tomezKFbRdlFfi+h+NL1401mxJP46wFMyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQ07LEEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQ07LEEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCBDC4AF0A;
	Tue,  2 Jul 2024 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941532;
	bh=zVWpyYN2uHpKM51G8csXzUmip5nrQhAc2+bYh53a9s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQ07LEEHXic3A4ef/WuLX1YZIZztYY51RJIfS4T9lpD+/L+62AnswDl+YYO+jy0fl
	 2yNHyz64R5sNNU1BlD7bHJjxjKOlkb0CIEG6KzQJ9BCMnJhxPKoJzcOo+0JBul/KMB
	 P75tvthD578wpoiJpk5oHotOM1jVE9bpOjWQkQx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: [PATCH 6.1 091/128] serial: imx: set receiver level before starting uart
Date: Tue,  2 Jul 2024 19:04:52 +0200
Message-ID: <20240702170229.664632784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1978,8 +1978,10 @@ static int imx_uart_rs485_config(struct
 
 	/* Make sure Rx is enabled in case Tx is active with Rx disabled */
 	if (!(rs485conf->flags & SER_RS485_ENABLED) ||
-	    rs485conf->flags & SER_RS485_RX_DURING_TX)
+	    rs485conf->flags & SER_RS485_RX_DURING_TX) {
+		imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
 		imx_uart_start_rx(port);
+	}
 
 	return 0;
 }


