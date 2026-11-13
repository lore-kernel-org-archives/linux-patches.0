Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591470;
	b=LPmX35Zg39yX+5MYpehJUKrlYYRLtffF26vdAfkDrO/zX1CHHAP71UZ7XCnygWr8Mewx
	 MCKkbeDNCQc/SgxuObSWRIukb8kar6JbvwQxzmsQDkY+Rwu1dJ/Nvx2Ut0gGNZ0y7t8VM
	 UsanpA6vH4RIx3XftMMy7Du6848w68jElRNOUpJuSpZ5cu/30wtbRdhb9B7nG7rs8XFzi
	 mNfBbAZc6/aqgYKQCAFeh4Q7Ou7Psm76H/xXHCFNMKyQhiSTNliyrX3BJOPRKYpd1enFT
	 p6W97SRRba5eBcPlBqXbMTqAj20dxcBk2K7SXgnBGq24F4PVN5D/akThjSmNWK24qOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xYEiw1hS8UxoN0lEeZErjAM1vOoY1q94BFq+IK8m4KU=;
	b=doIAHoIsvuWTpJ5LptQJWQ2QtK43/GlMx8oKqB7rpEquC8KTqqjcJjBYQMzcXTP7ZUfa
	 wBH1EJsRxZB3LQ230SrgyXfYlgGD9zX3hEhMa6KY2MEBW0kxzmXU4XH/+fLoaY+JBETwG
	 DrBE3157XaDk6nYEFuFap81vDRZw3GgLeTtCLWaM4vifwCwJNCKwY+Rkc/WL172dhuXhE
	 mKlIoUbfQOlGWa0JOMJ67Rqrn99poCLaLp632NuNcJUKLbVS5Vp57IjcLefP0SwQDWS6k
	 PsPiYwL9abdF5QI/IT7NsrSPUi3pnWCr6fXHXRAIDqT/2hUXNv4/Gr0NHZGKvT1NeLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c43ElnXt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ED6607D2D1;
	Fri, 13 Nov 2026 17:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c43ElnXt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8325F1F000C4;
	Fri, 13 Nov 2026 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591470;
	bh=xYEiw1hS8UxoN0lEeZErjAM1vOoY1q94BFq+IK8m4KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c43ElnXt/gxpNqRrFRAnb0Z4+wV/b47/e0zfIF1bPFCryWIfMuXRQ14u7H0GRCwI2
	 ggVVg4i90fg2MsuDga05lzRxnNys6/G7zWIXsNVVkHwWRnktY7PRPg/cVoh8BeBKpL
	 BFpsOsbamPJ3rKUKdoMogn/8i0wGrW9qiugsnQT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Fuzzey <martin.fuzzey@flowbird.group>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 554/670] serial: sc16is7xx: fix data corruption due to unexpected xon/xoff
Date: Fri, 13 Nov 2026 10:51:58 -0500
Message-ID: <20261113153830.660279046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Fuzzey <martin.fuzzey@flowbird.group>

[ Upstream commit 8bb50e95c0abd44607bc60a43032c1dbf7470d5a ]

The hardware supports automatically sending XON/OFF based on the
FIFO status and that is already implemented by the driver.
However that capability was not announced with the UPF_SOFT_FLOW bit.

When the port is opened with the default of XON enabled the driver
configures that in the hardware.
If userspace does not want XON/OFF (which is normally the case) it will
use TCSETS to disactivate it. However the serial core optimises this
to only notify the driver if someting imporant has changed, and for
XON/XOFF thit is only if the  driver declares UPF_SOFT_FLOW.

So we end up with unwanted XON/XOFF in the data stream.

The problem only occurs if nothing else needed to be set by termios,
ie if the user space requested values are the same as the default values,
except for XON/XOFF.
Since the default speed is 9600 this means that the problem only occurs
when requesting 9600, otherwise the call to the driver will be made to
change the speed, and that will also clear the XON/XOFF.
As 9600 is quite rare these days that probably explains why this hasn't
already been seen.

It also only occurs on the first port open after boot since the subsequent
opens will use the "logical state" set by TCSETS but not communicated to
the driver the first time.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Link: https://patch.msgid.link/20261001100534.1225894-1-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 5c6339f6f1bcb..f104d6a7a3fd1 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1619,7 +1619,7 @@ int sc16is7xx_probe(struct device *dev, const struct sc16is7xx_devtype *devtype,
 		s->p[i].port.irq	= irq;
 		s->p[i].port.type	= PORT_SC16IS7XX;
 		s->p[i].port.fifosize	= SC16IS7XX_FIFO_SIZE;
-		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY;
+		s->p[i].port.flags	= UPF_FIXED_TYPE | UPF_LOW_LATENCY | UPF_SOFT_FLOW;
 		s->p[i].port.iobase	= i;
 		/*
 		 * Use all ones as membase to make sure uart_configure_port() in
-- 
2.53.0



