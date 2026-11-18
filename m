Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036644;
	b=nFJObXJleGSa4ORiH/9nU3lY3VwGeMDoO7qF3da+7PfpSi6cpP05nvv9Oi9XhiS/QAxK
	 OdbL5V5b3afmB3Jq+nduzWWkSFuBlVnD5Fi9QCQkOXC994k/SLGAixu9nlY0KfRya0bBR
	 soVdkUVlqRzGOJPOQDMLINyOMZzVTzmf7bD92WlUh4RzrPlT/WtMc+XpWP2e7wn8a+LC0
	 fxGtZ63uV5a9o61Hh9gZ0YPVI31gJu/6V+d8YwTRkMKNo0nfebK+KpdnzqIXpZxHN+v1T
	 wV+wPuqkGLY7TtFB8fuIlTIF0dTVukLtqC49AZ6YCjoUx/WSfwr8EwaNe/ZAsYgtBxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sz0aRks5dIk4NnibT1DVxD9D8rXHMjNwO8WZAat0JNU=;
	b=hneCQUyW8miUviR6+NBvZ/deMs/PfvNGPb3cPVKqXSX1DAujJ027jCbYKW2lVMyyj5F+
	 eKCDyqujATk7iZlis/wJHZG9zZ4B7aDev3ibU4NvY29rIcGrBvimWzn/O3SMHguO3Dk2X
	 Tq77N2lvmhgqAX5viVTIbrm/5kHBr979QrAc6AqdR58XOIwQNi+OzoJ3UDO26JEKxb4Fv
	 dCuKG7wC3sdnAHx1+u3vDsaVFHENfteLiVyBVFARjvD/6tIMTLc3E1DL/h4yzRzH/lV3b
	 spJo/88vxnRdjucsYIGeqsCF1ZCheaQD5xDRWNf1YeVQcpa6FD4vyZannOJ4u2YWmpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ufsl0A4Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979B606A31C;
	Wed, 18 Nov 2026 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ufsl0A4Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6011F000C4;
	Wed, 18 Nov 2026 21:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036644;
	bh=sz0aRks5dIk4NnibT1DVxD9D8rXHMjNwO8WZAat0JNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ufsl0A4QTpOrJ8xTK2ejChWdlHYMvvrD5hGfUxhVSg16yeIw/D9pX0IXKfgu2jxK6
	 lexGPflGjZJcMqzBDJvBXNDQ4UW+bLNvP6CErJe7W8qQkA04sAEycEd1b71oXQhfmb
	 5PpcBFSr326YNjbv5riNKbNRUMKQ0leKs335iipU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1133/3318] spi: amd: fix len==0 underflow and FIFO overflow
Date: Wed, 18 Nov 2026 15:29:15 +0100
Message-ID: <20261118150354.036897071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit e2f4edfc061e493fddde16c4bbe1c4f230f41e4a ]

amd_spi_fifo_xfer() unconditionally decrements xfer->len when a tx_buf
is present. The SPI core does not reject zero-length transfers, so a
transfer submitted through the SPI_IOC_MESSAGE ioctl with len == 0 and
a tx_buf makes the u32 len wrap to 0xFFFFFFFF, and the following
per-byte loop writes far past the FIFO window.

The driver also never checks the cumulative FIFO offset against
AMD_SPI_FIFO_SIZE. The core splits each transfer down to the
controller's max transfer size but does not bound the total message
length, so a message of several transfers whose total exceeds the FIFO
overflows it with out-of-bounds MMIO writes (tx) and reads (rx).

Skip zero-length transfers and reject any transfer that would run past
the end of the FIFO window.

Tested with a user-space replica of the fifo_xfer length arithmetic
(ASAN build): a zero-length transfer with tx_buf makes len-- wrap to
0xffffffff, and skipping zero-length transfers avoids the wrap. No AMD
SPI hardware was available, so the FIFO bound check was verified by
inspection against AMD_SPI_FIFO_SIZE.

Fixes: bbb336f39efc ("spi: spi-amd: Add AMD SPI controller driver support")
Cc: stable@vger.kernel.org # 5.8+
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261014-spi-amd-fifo-fix-v1-1-9fec9ab753e8@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index 5d9b246b69634..eb0f38d1522c8 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -284,11 +284,22 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
 	list_for_each_entry(xfer, &message->transfers,
 			    transfer_list) {
+		/* Skip zero-length transfers to avoid len underflow below */
+		if (!xfer->len)
+			continue;
+
 		if (xfer->speed_hz)
 			amd_set_spi_freq(amd_spi, xfer->speed_hz);
 		else
 			amd_set_spi_freq(amd_spi, spi->max_speed_hz);
 
+		/* Reject transfers that would overflow the FIFO window */
+		if (fifo_pos + xfer->len >
+		    AMD_SPI_FIFO_BASE + AMD_SPI_FIFO_SIZE) {
+			message->status = -EMSGSIZE;
+			goto fin_msg;
+		}
+
 		if (xfer->tx_buf) {
 			buf = (u8 *)xfer->tx_buf;
 			if (!tx_len) {
@@ -331,6 +342,12 @@ static inline int amd_spi_fifo_xfer(struct amd_spi *amd_spi,
 
 		list_for_each_entry(xfer, &message->transfers, transfer_list)
 			if (xfer->rx_buf) {
+				/* Reject transfers that would overflow the FIFO window */
+				if (fifo_pos + xfer->len >
+				    AMD_SPI_FIFO_BASE + AMD_SPI_FIFO_SIZE) {
+					message->status = -EMSGSIZE;
+					goto fin_msg;
+				}
 				buf = (u8 *)xfer->rx_buf;
 				/* Read data from FIFO to receive buffer */
 				for (i = 0; i < xfer->len; i++)
-- 
2.53.0



