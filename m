Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D03183CA6;
	Mon, 12 Aug 2024 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479549; cv=none; b=BkRWdpE+f7DzWo+nUQJXBrKgRpvf2nufN4pe3/DZqJmKgnlgAy9B7CMgtxFfxFRbIRb4rU5FTAETTmnRljMtrWDn4RlpVMZ7UdgKH481qb7MgimGMjhz7IQ8y9ha2AkDULuI7fF1PhgZVg48ecMeoRQwtekuZ1G7liAf4aqgoqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479549; c=relaxed/simple;
	bh=gbQO4hBM3jLqxhDHpTSOG/QpQz24IXn69SIXfY/IlEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ4313XdGNTjSUjjhxn76viuEpxYZ8jk7DVTdxSbsTXcT+T40InAi3BLXOKavH/T3elAIcLfFOW5zWrq1sSkzzFFwGPa3i0bFYlZ8JjZEyaIlpXmm4HVv0i5KgmCOsU5pLXtuC/qbjb58Ool3wurjIYkZj8dJiTtJXHMLVpVf5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uj8c+TkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj8c+TkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B28C32782;
	Mon, 12 Aug 2024 16:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479549;
	bh=gbQO4hBM3jLqxhDHpTSOG/QpQz24IXn69SIXfY/IlEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj8c+TkWVCf6tLCi0Bg+n5Uwl46LybGeMAop2u4VppOXvbI/CFjtaQ2t45R/r59F9
	 6YjZwS62AzV3ca/Jv155wSX8eIAWZqU1jz+cnKbyIEqwmK26y1oQs/8POL2clQ9HqS
	 dj6FNPFyBviiPZyHw970Gv/REgt5a68zgIK7UY8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.6 121/189] usb: gadget: u_serial: Set start_delayed during suspend
Date: Mon, 12 Aug 2024 18:02:57 +0200
Message-ID: <20240812160136.803829274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Prashanth K <quic_prashk@quicinc.com>

commit 5a444bea37e2759549ef72bfe83d1c8712e76b3d upstream.

Upstream commit aba3a8d01d62 ("usb: gadget: u_serial: add suspend
resume callbacks") added started_delayed flag, so that new ports
which are opened after USB suspend can start IO while resuming.
But if the port was already opened, and gadget suspend kicks in
afterwards, start_delayed will never be set. This causes resume
to bail out before calling gs_start_io(). Fix this by setting
start_delayed during suspend.

Fixes: aba3a8d01d62 ("usb: gadget: u_serial: add suspend resume callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/20240730125754.576326-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -1441,6 +1441,7 @@ void gserial_suspend(struct gserial *gse
 	spin_lock(&port->port_lock);
 	spin_unlock(&serial_port_lock);
 	port->suspended = true;
+	port->start_delayed = true;
 	spin_unlock_irqrestore(&port->port_lock, flags);
 }
 EXPORT_SYMBOL_GPL(gserial_suspend);


