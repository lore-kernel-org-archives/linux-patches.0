Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C678188CDA;
	Wed,  3 Jul 2024 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004246; cv=none; b=uqFexXGeu5QKPAHr69dXs1rJYjiERvpsDbiUdQ+WJYmb8ixGHgQqJQ6+LhOzloV7sTSmcb9AtsLAIWgv1Y18eSq0pajWSsSC6uukG2Hn1YnptFYBDGp31cjsYiCXGeXuSqO0tdE00tOo5wSP4OEoXZh+xE7S3fkdRNsXxv5IWwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004246; c=relaxed/simple;
	bh=+WVZuWQCjfL2ImJ23MNOtcdMfwOv3BqmGdbX7DkmjBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvhiY1HZvHdEEGoBEC/sAo17SVwzCsenvLHBiYWQcxbjxKrWm66m876GK8GZic2gxZanaiGn4UbYbUmV6hC4YYlBPIxjXB4ygO4V4RLocdWHccFFSNFxTz3xOUfRoYJU8Cx+XZrtoWvS6tm1xmbht2w9fQl6Jy7xmEAN6y+3gv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHhYdEjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHhYdEjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20771C2BD10;
	Wed,  3 Jul 2024 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004246;
	bh=+WVZuWQCjfL2ImJ23MNOtcdMfwOv3BqmGdbX7DkmjBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHhYdEjIrhaX3x3NwNVq0ItFVkPktBrzhy51tDvFVH0B2FUzhOGdqG4Gd7DBuq57J
	 MBw/tRknfgt9ASzNS6SUpDbC7dx8fAgw5LjFf2sKhT3UtTktxoq+x6mk17pPtXTSJr
	 x5OC6qaHJX4os5kFr/jjykovku4vcdJ/3p6Jd4ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: [PATCH 5.4 169/189] serial: imx: set receiver level before starting uart
Date: Wed,  3 Jul 2024 12:40:30 +0200
Message-ID: <20240703102847.847113870@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1887,8 +1887,10 @@ static int imx_uart_rs485_config(struct
 
 	/* Make sure Rx is enabled in case Tx is active with Rx disabled */
 	if (!(rs485conf->flags & SER_RS485_ENABLED) ||
-	    rs485conf->flags & SER_RS485_RX_DURING_TX)
+	    rs485conf->flags & SER_RS485_RX_DURING_TX) {
+		imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
 		imx_uart_start_rx(port);
+	}
 
 	port->rs485 = *rs485conf;
 


