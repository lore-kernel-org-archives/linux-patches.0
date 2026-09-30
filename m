Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0760130D401;
	Wed, 30 Sep 2026 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796373; cv=none; b=hmu5/zu/REQ5iTBSrSDalFQWNu1Z0u9mryK9vMTkQh6NDmzlH/Ql8mn1Xgo39p+QBR4vB4tDGZPWm0388pRMah9epm3WqrPD0Pgx7K7RL7g1CG6wETuBg6bt5M6yWOzg2ljpTz5N/fgSj0HrDqd4oK/hLqUbbTKbQwdjRow6zJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796373; c=relaxed/simple;
	bh=KF+ynqu9mT5AROsww4+QRXhwB4eItZlrOUdfKeNyl5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQEk99dIM3wUDxssHTe+mXNO4VhcjUShhkw/SG1vf/s4zhDgxaUQ2D78lRdguGm2cLbJtDwmJ+rJQAhe41y4NbkAvEOxhax2A3h5m1YPk2wdrHKajs8BVo+c1mDHmy7TAhOuvoiKTuHSrRismOm1MHWOwN+IatAcPmlVPQPDmYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHpvBKcg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHpvBKcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635A21F000FF;
	Wed, 30 Sep 2026 19:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796371;
	bh=ho+0jKTVNg13S8CWMiCxdb28o8qH9NJoqYsARRovXlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHpvBKcg2/PQrsV89x3mZo1lABvMcPAJS9Y++IgsOV16EdqygVnVd6p05Q9A+d7m8
	 Af9lO2pKsq7E5wJcDwKpZTg3VC4tOZD+aDrbrMIxl88V94YygKHKfkSRw8jVRdfr5M
	 epWC5vkwYHI0BjpovVOUEO2MDegQRqRiA78ID+i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0889/1193] mmc: sdio_uart: fix xmit_fifo leak when the port table is full
Date: Wed, 30 Sep 2026 17:26:13 +0200
Message-ID: <20260930152453.999627189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Felix Gu <ustc.gu@gmail.com>

commit 53823e25793a97d07e6e98e0904bbf74cac8bc76 upstream.

sdio_uart_add_port() allocates the transmit fifo before claiming a
slot in sdio_uart_table[].  When all UART_NR slots are taken, it
returns -EBUSY with the fifo still allocated, but the probe error
path only kfree()s the port, leaking the transmit fifo.

Free the fifo in the failure path of sdio_uart_add_port() itself so
the function retains nothing on error.

Fixes: 8b197a5ce7a7 ("sdio_uart: Use kfifo instead of the messy circ stuff")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio_uart.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/core/sdio_uart.c
+++ b/drivers/mmc/core/sdio_uart.c
@@ -104,6 +104,9 @@ static int sdio_uart_add_port(struct sdi
 	}
 	spin_unlock(&sdio_uart_table_lock);
 
+	if (ret)
+		kfifo_free(&port->xmit_fifo);
+
 	return ret;
 }
 


