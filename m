Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A69015B0FE;
	Tue,  2 Jul 2024 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940448; cv=none; b=eIUli27cL6g9+xPJ7z5QUEwXPxkJsDLs4zHXtgfuespTy/9G43Tn/L0YJQBYhRccxOgZ6LH+0ZI/Hdfz5LvvFHsd2G63vakka9zC+yPJMxAYNPJ/SP36PIESZyF/UIFc6KJGY78wZ+z0v2sGdoD1RIzlzHIr4ihs/H4mHiFKceg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940448; c=relaxed/simple;
	bh=ntOlKH6dA3iM8vkmWgv9ayVmpu/TkUcpm60QhVrHMHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9BUH5VJhfu59GnVQ2ocH2Q8qF5v3UYI4A9EL5vFJoOnvzfVGbDfU80pYOWyZ7TvNqyp53y9Yj+OL9WmGbigkhWsEdLvYVDxJFZuGO60REyrfRCjA36pMwVh4lLrnMVVlEFUN2md0NirNX+VfJfyDXulPf1nblm1N9DgVflXMAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Gfzk1hM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Gfzk1hM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD7FC116B1;
	Tue,  2 Jul 2024 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940448;
	bh=ntOlKH6dA3iM8vkmWgv9ayVmpu/TkUcpm60QhVrHMHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Gfzk1hMToRXka/5E1FWrSvBER2J2X6n1TsZjt2VYQ/hFf0rw5FCFyKROl2CfRSTv
	 5QLtHZur7q3zHJ4J9/6IpxMKm319GsV0afSyznJ3xmNlFKZKhF5FH3yEbzittDcgVR
	 QZtUcjtaqbsDS1Jpw4e8hNWFxurRrAnfAU7Rq0wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: [PATCH 6.9 158/222] serial: imx: set receiver level before starting uart
Date: Tue,  2 Jul 2024 19:03:16 +0200
Message-ID: <20240702170250.017415102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1960,8 +1960,10 @@ static int imx_uart_rs485_config(struct
 
 	/* Make sure Rx is enabled in case Tx is active with Rx disabled */
 	if (!(rs485conf->flags & SER_RS485_ENABLED) ||
-	    rs485conf->flags & SER_RS485_RX_DURING_TX)
+	    rs485conf->flags & SER_RS485_RX_DURING_TX) {
+		imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
 		imx_uart_start_rx(port);
+	}
 
 	return 0;
 }


