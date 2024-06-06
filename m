Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01D71974EF;
	Thu,  6 Jun 2024 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682950; cv=none; b=leAlmNsEr4lMNwuNOYwGCSdLD8OIL4QMX6G+c6K4O6XTNxcsK0bgGCDgWuDnBQZwbYF2eHBwBD5uKrlbGT5Dp9794k48LiTMq2GrT0FhGp8rg7qCXjdiLI7UYelKk8KLJcvHFVebW47+zBAQDI68BvHSyh7v804SnM6xkfjffuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682950; c=relaxed/simple;
	bh=lFEB+5Bj8Nb9W1AZYdwTzO1sIweoeQ1WYd9kwWio+38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwbe1SqQjV8+uSiZgKoKtFe+ugIGJi4qtMjtNbYCAH7ofmglw/rHhnuo7tbR0QE8Eik8pf8TxILz6FKqXaQb/6vbpQ2Mv0xOlBUT2YE2DgM5qH+PMxYr0Y9G1dgilHRJz/6gcVRGv9JlEDiMbizL4cJj8cUxmlqOB2JtdFRu5k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3BJi298; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3BJi298"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ED2C2BD10;
	Thu,  6 Jun 2024 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682950;
	bh=lFEB+5Bj8Nb9W1AZYdwTzO1sIweoeQ1WYd9kwWio+38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3BJi298YuBJy9DvxeKgMYU61jbX05oEiFDSR624xDZY0yBwusCjEz6XpKFLRqrRL
	 uE5PW3TkUKsJ9e82G303chNqL5Zmyja4bikL7S0dK41M7+THfEv1wtLpdeFIKPUn8c
	 HVYHidS772dbydHFkpQU6qK7CGaJsZbpABTlseq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 114/374] serial: sh-sci: protect invalidating RXDMA on shutdown
Date: Thu,  6 Jun 2024 16:01:33 +0200
Message-ID: <20240606131655.744065762@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit aae20f6e34cd0cbd67a1d0e5877561c40109a81b ]

The to-be-fixed commit removed locking when invalidating the DMA RX
descriptors on shutdown. It overlooked that there is still a rx_timer
running which may still access the protected data. So, re-add the
locking.

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Closes: https://lore.kernel.org/r/ee6c9e16-9f29-450e-81da-4a8dceaa8fc7@de.bosch.com
Fixes: 2c4ee23530ff ("serial: sh-sci: Postpone DMA release when falling back to PIO")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20240506114016.30498-7-wsa+renesas@sang-engineering.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index e512eaa57ed56..a6f3517dce749 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1271,9 +1271,14 @@ static void sci_dma_rx_chan_invalidate(struct sci_port *s)
 static void sci_dma_rx_release(struct sci_port *s)
 {
 	struct dma_chan *chan = s->chan_rx_saved;
+	struct uart_port *port = &s->port;
+	unsigned long flags;
 
+	uart_port_lock_irqsave(port, &flags);
 	s->chan_rx_saved = NULL;
 	sci_dma_rx_chan_invalidate(s);
+	uart_port_unlock_irqrestore(port, flags);
+
 	dmaengine_terminate_sync(chan);
 	dma_free_coherent(chan->device->dev, s->buf_len_rx * 2, s->rx_buf[0],
 			  sg_dma_address(&s->sg_rx[0]));
-- 
2.43.0



