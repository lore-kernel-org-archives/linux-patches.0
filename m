Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC5F513555;
	Wed, 30 Sep 2026 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783577; cv=none; b=ZNXC1Y9vpTifRyb0Zbv8UsFKT8R6SQySNYf/mfdcsFfGrACMqnQV1AJ5rH3L4C3//fF9Um5U6Hznm47I5sS7WW9EgoDp34dQMCJAqi21lToqwDh6czMQxDrvBBFHehPq5fBklJQfZTj/v2OQEv/fb+5/LU/H9Jrh4P/ZOuo+JHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783577; c=relaxed/simple;
	bh=ImSR7kDUXDeN0x4Dohn0pqvPr/xrR0t+SCqRTzyueWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdJsflBHy+VP2PLgPx36dlVJHDu9lDLDf77i2ERXCdA0cxacQoHu9xev2gkYJWuw4WlWgmc+283STPanZ/Vk2Igz2iWualR/NyKCTle/4xP/NBRDgv51Xz56rLSC0NfD67hFqr50r48v2TZ8ZlYPNa9Fp2N414hLjZUQmSiGQfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1guwMnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1guwMnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0437F1F000FF;
	Wed, 30 Sep 2026 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783571;
	bh=IrRJJ8JYqxOMgvEU8X+a5915TRZpso/A+glKBm/czYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1guwMnPxZlp9ugO5tvHR3JQqCpMhRMFN0HAZBceJifznJuvsNnNOWcN1sDRARkgP
	 tVkoKqQVWsuz3o2vXf1IRVeAl7OX5d+BTDXfDN2pjfmdM7DJ7nZ4rREAaHYW9qu4/A
	 UkEUFJ/SwdP8BChlixwOQe2CFnRg8T+A45q3pK4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 444/595] mmc: sdio_uart: fix xmit_fifo leak when the port table is full
Date: Wed, 30 Sep 2026 17:25:37 +0200
Message-ID: <20260930152357.231596346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -103,6 +103,9 @@ static int sdio_uart_add_port(struct sdi
 	}
 	spin_unlock(&sdio_uart_table_lock);
 
+	if (ret)
+		kfifo_free(&port->xmit_fifo);
+
 	return ret;
 }
 


