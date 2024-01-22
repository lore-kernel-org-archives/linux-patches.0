Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D36EB61;
	Tue, 23 Jan 2024 02:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975414; cv=none; b=ZRT+KehCqX/3F9iLm8zxuwFIqiA6KWp65YxN7EpmcDtDtsBdSaqTvClL1UCmM7NajvUUVixqavHTPCEfwSqX7HVb2gidV91YYxZ13C1R+C+eJerpgZhh2Tob9VEFnlNrB04mT2SZzbyevJB7w/Kkw4bATmeeTBGsEhloh0hvJqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975414; c=relaxed/simple;
	bh=Gvi01fR+1rZALIfZAy6vsgdCcBlXcFcMLi6Gl1kp/9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VgTxz3OCDU+0wg2ZpxG6YhKLQ/rkuw7ir9aEMIV50YiZ8No9Lr6UF3Ap4chcGsJJskkDPCy/ELWDQ310U2I1k8dcRxn1P8uaGgjvMTD+P+hrIeV6XwVUd0hWa4slLT6diZqMbp0dsFwF4Ei03w+4ddvbsJoRQDT8mi9uyEQb4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgtoPFkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgtoPFkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AB3C433C7;
	Tue, 23 Jan 2024 02:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975414;
	bh=Gvi01fR+1rZALIfZAy6vsgdCcBlXcFcMLi6Gl1kp/9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgtoPFkdQnzQx4GsA78NjfhtyKpmHVqt11cRUxmOO+9zMJjwJksoL3cCPQNJxz5/l
	 CKFS/Julv5Co6sOVImnwyLYqhFetIg3MwhTp31/YzBr2oyJ45XuiNNuVaaTf7jkf0+
	 /E3j7p2izx0DJYa//r6BCgNxHxrb8hUSZzlonEL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: [PATCH 6.6 373/583] serial: core: make sure RS485 cannot be enabled when it is not supported
Date: Mon, 22 Jan 2024 15:57:04 -0800
Message-ID: <20240122235823.421977239@linuxfoundation.org>
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

commit c73986913fa47e71e0b1ad7f039f6444915e8810 upstream.

Some uart drivers specify a rs485_config() function and then decide later
to disable RS485 support for some reason (e.g. imx and ar933).

In these cases userspace may be able to activate RS485 via TIOCSRS485
nevertheless, since in uart_set_rs485_config() an existing rs485_config()
function indicates that RS485 is supported.

Make sure that this is not longer possible by checking the uarts
rs485_supported.flags instead and bailing out if SER_RS485_ENABLED is not
set.

Furthermore instead of returning an empty structure return -ENOTTY if the
RS485 configuration is requested via TIOCGRS485 but RS485 is not supported.
This has a small impact on userspace visibility but it is consistent with
the -ENOTTY error for TIOCGRS485.

Fixes: e849145e1fdd ("serial: ar933x: Fill in rs485_supported")
Fixes: 55e18c6b6d42 ("serial: imx: Remove serial_rs485 sanitization")
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc:  <stable@vger.kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Link: https://lore.kernel.org/r/20240103061818.564-5-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1453,7 +1453,7 @@ static int uart_set_rs485_config(struct
 	int ret;
 	unsigned long flags;
 
-	if (!port->rs485_config)
+	if (!(port->rs485_supported.flags & SER_RS485_ENABLED))
 		return -ENOTTY;
 
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))


