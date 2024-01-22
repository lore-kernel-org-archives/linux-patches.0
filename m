Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3168B136658;
	Tue, 23 Jan 2024 00:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969702; cv=none; b=Fu5RZ3Z75KXWKNoV8mZpSMjrOLwQ9NJI6va5tGnI+aUBx7JUhokOhAC+eu48TH+ZdY1mFY76QXegfvl8SbmjDgo8+z/9CO0ZxGBoQnQIxw10IqfM/erzc8+2IIo5MGNP1jWH26Q2Ghkm4VEzbvtKhWvwaS4ZlUQJJQKvAqfCaIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969702; c=relaxed/simple;
	bh=zmtznzuk1e0ckZ+ShXCQ+QkmVOq5JAFEvKVaAt2++bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNaeZtldvPZhaBWev1j+OarNUlcFI9kW6SkS5Q+gJ2pb1M46iV26uKAQimKR/hntfNE1oUfc1UvSZQZ8Ak/+yVp4ei/Hg6f+xa2gvB6PpAX+X7uUeVoQKYh++SixL0hxFqGPKE1HFZzYCM6nFFHJ3hAHmjjQDoCijHsuZuFyQ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j48LaO0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j48LaO0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3149C433F1;
	Tue, 23 Jan 2024 00:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969702;
	bh=zmtznzuk1e0ckZ+ShXCQ+QkmVOq5JAFEvKVaAt2++bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j48LaO0UFFS5aqfgnjxz2ZZF/x7eWnu0jaD2SW9recuCNuSDhjxSU6sFU2viW4xHN
	 LoFj4IMiE2MgVJ35tzM24a2P4nf8y+t6qQWZMGKTfLLRWCno8m6gzTwwR2HYjGo9j5
	 5qO6JxHRJahRLT09KlJ9EiFmR+j/zZdH8FddzHwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.7 412/641] serial: core: set missing supported flag for RX during TX GPIO
Date: Mon, 22 Jan 2024 15:55:16 -0800
Message-ID: <20240122235830.871809020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 1a33e33ca0e80d485458410f149265cdc0178cfa upstream.

If the RS485 feature RX-during-TX is supported by means of a GPIO set the
according supported flag. Otherwise setting this feature from userspace may
not be possible, since in uart_sanitize_serial_rs485() the passed RS485
configuration is matched against the supported features and unsupported
settings are thereby removed and thus take no effect.

Cc:  <stable@vger.kernel.org>
Fixes: 163f080eb717 ("serial: core: Add option to output RS485 RX_DURING_TX state via GPIO")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-3-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3650,6 +3650,8 @@ int uart_get_rs485_mode(struct uart_port
 	if (IS_ERR(desc))
 		return dev_err_probe(dev, PTR_ERR(desc), "Cannot get rs485-rx-during-tx-gpios\n");
 	port->rs485_rx_during_tx_gpio = desc;
+	if (port->rs485_rx_during_tx_gpio)
+		port->rs485_supported.flags |= SER_RS485_RX_DURING_TX;
 
 	return 0;
 }


