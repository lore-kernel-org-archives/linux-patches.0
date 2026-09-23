Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD253F23C5;
	Wed, 23 Sep 2026 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175104; cv=none; b=JJAKGFSwQpIjRNMvI4toF/fkNArPcUfeDjqs82vFc/BxJObML64cu2xyP2jfUpdjcjJ0yHyBM7+vYUXeEMiLwC9S901Ru8unqjqh3Hl1NLZ9+cGIaxEkUsxx5coQfAhWk6W9fO2hQfHOF7qUGdjrSq5g504oqCtej3btQIpO82I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175104; c=relaxed/simple;
	bh=QWTT6Ea3avIGnQ1sZtvYdeM8Gio8cM7cwPboWNtAsEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3FvAzl/pKMREXwKnmUngMseG40VPbN+DFgoozu9vCs/zjYt4kOtGf3fUGfc8U80XEb/rdDCZPD9dcQ1Q5q7Ts4wq+kZKwXdALNvPyqT7qSW10FfOjgnw4yUF5AdqVPMP83h0PPBCmajLQ4IGl7Byw8ifH8Z75Z716KA8gR2Vuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3Ke23Pv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3Ke23Pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B5E1F000FF;
	Wed, 23 Sep 2026 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175103;
	bh=fqJhiG3ZcLUEIcwIPi1vpMM4HUuBBzFnSpPcNAxu9HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3Ke23Pvv/nLWLK/9I/ML61a7FG504z8JcS6WZBHPvHTLLReAhzuV05540RgxbuU5
	 KHYyM/slb/TyIccuDF5IOM+6MwCCce6EKRwL4E3apgqX7qNTBq/E4z4vB6Y4pgTukR
	 XV4chdFNeDJmC+a33fOG0GUZhG49AeOLEvORfRss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 287/398] mmc: sdio_uart: fix xmit_fifo leak when the port table is full
Date: Wed, 23 Sep 2026 16:06:01 +0200
Message-ID: <20260923140650.859293555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


