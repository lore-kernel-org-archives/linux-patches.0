Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C0936D4E1;
	Wed, 30 Sep 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792144; cv=none; b=iPuFsrvUHt8jR8EDYn7nD+V4OkRMIIbDVm7tQNKuck5tTJlxBUspGbx+C8as57vg8xM8b6iaidOqcxbkUQhBZ8V8egIIRRgv5/D3GGKcTyZQ+OLrWqq98kRULW3OMTlet6dmcwxi5Y+jLF7DBTKDI6FRFS+TWH45YMG483OOyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792144; c=relaxed/simple;
	bh=9DHvfjEby2G4+U2nGW+y6RdbzXAmNMry+4ETup6LSgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qzq1uHwT5waiZm02FXt2ReIyjhkkwI9CVwd2eBoQ6i2hcuPzeJx9XFz0605C3xslc18rq9USQjcvOqZYoGpXY8XfSrUaOcQJz1svx5KpOSqR36hsnJDQoTEnNJqoNAdbDrVyj5R/BEtdytsrttZFGKZf5YdM3zLFJlQXZ65xYuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqkAEs4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqkAEs4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACBB1F000FF;
	Wed, 30 Sep 2026 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792143;
	bh=6EaGgppLJG3D3jv84Lg1qTSt6SG6aXLi5o5dU+DvDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqkAEs4MW5hnCYhjWDZ7aI19M18trR+zL9+kW2BKcg2kyR+938tsD43FzvRfBRNCP
	 SHnh5MiOYlPAdBNclzIY3/Efeph6OyKnlft6GDfmqfADGsxY/czyO4iBVbAD+KMP9f
	 ngBUgZDbKNR1/hAJOn+voQNhz5Lw8ktRsJrkAPvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 549/752] mmc: sdio_uart: fix xmit_fifo leak when the port table is full
Date: Wed, 30 Sep 2026 17:26:59 +0200
Message-ID: <20260930152410.124181249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


