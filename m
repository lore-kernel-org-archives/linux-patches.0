Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33394315F;
	Wed, 19 Jun 2024 13:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802913; cv=none; b=Z66MC0+X1P7iscmi8VKTVRfaSSDKPpfVG6JpzmxscCQnmRSRhg/2aRPQtvLh0e/RoC7L/uNa4juEt7GGKguwjADdp9P9QvqFObw0K9s7tKJdXrQwQLt8PKj4ETpt5eOr80K5PCBwhKnWJua2HpkP7KF2J11/1E0ANwz4MrILZuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802913; c=relaxed/simple;
	bh=Qkem2G71mXqkpHpdSJFiTi3Vc6hYCLnBYb6KwgIxVJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3qHdMjwDlqaMOVAN01e9BtJom8tA1STqCJ+Wnkq4bqlF3sXtk3CzWIGZhv5TaeHD7eiP2Lodd/aq5mnlLsPhBvTHWtzVr7oowVbhnikFxOoNak87eT9HBBA6uqkRbPl7TEnIlNnrzfS6uRVGLT3DPW1aj28bAIYy3XAZz2N8l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoxsyjCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoxsyjCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2741C2BBFC;
	Wed, 19 Jun 2024 13:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802913;
	bh=Qkem2G71mXqkpHpdSJFiTi3Vc6hYCLnBYb6KwgIxVJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoxsyjCtRxVoEU3veBh5xlGlQGWL67d+v4Llqw3oCW2Ry1B8bADj78NbhZl8dY6Dg
	 BokEdHE8UjvwMG9C6ynRBTOqhfnllkyQJEpxYdiRsAsT32IbUFT/Oc8iYm5jqcX2hv
	 h9x/ndHcx6XpN80QTNQpP6WVMdVtTSMb9gvd3jDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.9 090/281] serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level
Date: Wed, 19 Jun 2024 14:54:09 +0200
Message-ID: <20240619125613.313891997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Doug Brown <doug@schmorgal.com>

commit 5208e7ced520a813b4f4774451fbac4e517e78b2 upstream.

The FIFO is 64 bytes, but the FCR is configured to fire the TX interrupt
when the FIFO is half empty (bit 3 = 0). Thus, we should only write 32
bytes when a TX interrupt occurs.

This fixes a problem observed on the PXA168 that dropped a bunch of TX
bytes during large transmissions.

Fixes: ab28f51c77cd ("serial: rewrite pxa2xx-uart to use 8250_core")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20240519191929.122202-1-doug@schmorgal.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pxa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/8250/8250_pxa.c
+++ b/drivers/tty/serial/8250/8250_pxa.c
@@ -125,6 +125,7 @@ static int serial_pxa_probe(struct platf
 	uart.port.iotype = UPIO_MEM32;
 	uart.port.regshift = 2;
 	uart.port.fifosize = 64;
+	uart.tx_loadsz = 32;
 	uart.dl_write = serial_pxa_dl_write;
 
 	ret = serial8250_register_8250_port(&uart);


