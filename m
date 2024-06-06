Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DCB1C2324;
	Thu,  6 Jun 2024 14:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683648; cv=none; b=aBZYFB3woK0QiIPhQbds0G8AXujuynPR1KfjSD2m7gv35KaiivYwREC7hxh/xoHW8YPcKVW+ZarG7noPKFmCYz92fE0hdMdgKiks6vCZoaYMEBB2XFUQVs79XznVW0pToozJ684Bw8QP8c8xRGqZw0ccFLCLa7BA6coHtDd7A90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683648; c=relaxed/simple;
	bh=5k/yI5jTy9dQR8K2BVKYbvnnpw5a6k/2l3XJ7lTVh5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1NhS9ACu5+GRsoboTe7zERna7hlabp4hYIUvKqHmv8AXjviFnarmit0v8G/lrIVu+oXL5aon0ygVKUwCbS2GodxiiMtlaNd9S+3uq4t0FcK064WMP6H2kZ3v2SBJEX4dPbCMvMHGwISWt25AajKMypgWE0yPr0YAlDvwSerOY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqUooxrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqUooxrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F828C2BD10;
	Thu,  6 Jun 2024 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683648;
	bh=5k/yI5jTy9dQR8K2BVKYbvnnpw5a6k/2l3XJ7lTVh5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqUooxrAJFYmpMPg6Tmt6dS007A/eH16AbvDUjbU9rcIvqI7rfMauIJ8XQxxycEgI
	 4mN/cyOqUOMiIWSMKzuMg8Iy/42rgu3yVaNiTImW3IkmhFrCIm8bI9GjaEVQ14NcID
	 bF/uSUJH5PMtOLoE3hvo8ly9gXGQ3GtZca70IHbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 519/744] serial: sh-sci: protect invalidating RXDMA on shutdown
Date: Thu,  6 Jun 2024 16:03:11 +0200
Message-ID: <20240606131749.089465451@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index a560b729fa3b7..f793624fd5018 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1272,9 +1272,14 @@ static void sci_dma_rx_chan_invalidate(struct sci_port *s)
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



