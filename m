Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0443A255A;
	Wed, 23 Sep 2026 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173794; cv=none; b=aLxS3Yxz1Cd7ehRZnUzSlJnjLMP3L9hhNg5ZD+wUqL3qU19UTxpS0U95CQ4RNWWIw6oBr8TdnUKxNn1pu5tOU8gfmDk9WK+KrbLXgfi4uxv343pk9j5HRtRw+zFl7J0gtTHF3KRh9E89hd3N2u7387j51dtOwwU2aYRFv/9w5hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173794; c=relaxed/simple;
	bh=viWAZiyZ7xhe8OIjg/zEq3JDcZjeymsOJM7HTqwnJQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BC+P44e281+druXriinKd37KKOPyVqXOw0pA9jmgsK2DTIN9j5PiB8fbBojxPhb3d/COgHQTzjyuGDVlyldTxzMl38OxaFR/l9Dx1iJ4TiqTVA3hyUUJ8MNVHXDHAWXDmUTg1kSsDRUpFOjdUiKIfCku2Hu6tgAk4V+xrvQbiRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+PLotnk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+PLotnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633331F000FF;
	Wed, 23 Sep 2026 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173792;
	bh=5ioUByc5dJ2BzYyS5BLlMCXUWPm82JOaKDjAvemUlT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+PLotnkTE/9PfBg/jd9ox/lCc4gC3DNBgOjKRMT+m+yCD5Pyd/PtNC4g+Z6zn37K
	 0UCEGKgPL4nL/Rw8Qaol5Hck04Javcm5GUbKBasX5j98dnlAIYIaUHdJg8n2xtKozS
	 aTeoABLnzqKJzexLkNZWbLlQnyjX/uqIA6XByXR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 346/438] mmc: sdio_uart: fix xmit_fifo leak when the port table is full
Date: Wed, 23 Sep 2026 16:06:07 +0200
Message-ID: <20260923140653.784333920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


