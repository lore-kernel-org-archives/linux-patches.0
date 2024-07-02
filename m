Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7643015218A;
	Tue,  2 Jul 2024 17:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941061; cv=none; b=EkjQXl2bOqEf+W2CZ4Yc54AIOhjJy0Jx93ps0gLMDO8iM4PGaAR0JuS3DtYpIU6hX4ATOrcuu4S3c3ZOLtUb2yuCkdNWfdHxD/PpV57iIumZHlaLHFwPnYgeEt8rqvHsg1OoTzDxPo9965RWFMpLdr5g2r7HlX2PF7yw8S5omuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941061; c=relaxed/simple;
	bh=oBKtzy06sf7Rhis1jN67WVCIgf3hYdkWbGv0ZAFebHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ng/co+39255jnSQFCESVL0jFmKXIgK5noHwc7hvgpmVSR9g/ws8tBe4Aq7oBXnndEOvOFIYjTEQxf/NkfP3DdpGg4M+8QPOOb+quHcxyL4EUOyQN2WDVZ03Dmyo0OECJMXSfRz7NVZiXrbPcGTFx/JCE3CTbXS8y8v5Vn8rg3Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1PRvPaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1PRvPaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B5BC4AF0A;
	Tue,  2 Jul 2024 17:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941061;
	bh=oBKtzy06sf7Rhis1jN67WVCIgf3hYdkWbGv0ZAFebHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1PRvPaXe4zYxMnW8muS7Lkq7us0jgJqHFXnSehsuxteH34a39262AaNE4nbMZPdO
	 hLG4ypSewvHLg6aDnJ5WLAJidLrp38BlCNmR7s20xPcE3dGbIWgnOPJWWqdxKomOhS
	 XqUMh73paIali2OuQkAXkccxNEty+kATbbY6X9NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: [PATCH 6.6 117/163] serial: imx: set receiver level before starting uart
Date: Tue,  2 Jul 2024 19:03:51 +0200
Message-ID: <20240702170237.484023961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
@@ -1959,8 +1959,10 @@ static int imx_uart_rs485_config(struct
 
 	/* Make sure Rx is enabled in case Tx is active with Rx disabled */
 	if (!(rs485conf->flags & SER_RS485_ENABLED) ||
-	    rs485conf->flags & SER_RS485_RX_DURING_TX)
+	    rs485conf->flags & SER_RS485_RX_DURING_TX) {
+		imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
 		imx_uart_start_rx(port);
+	}
 
 	return 0;
 }


