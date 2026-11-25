Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626110;
	b=rRVvgPH308T3OKrnoPHZI03TgyvZE+TKWylyUthRyZdHwzJNpHNttL/pgdkmyE46ukbD
	 95c+ErkyV5x4AdTS8L8HhT64+npwvLCboQAQSddovL6YdpkZxUFJgMHJQ4nbHiY6gKuV5
	 Q1EvQQyow0m7teK5tF/3cvJsiOhl00lupRbAkxIo/jTvQPhTkG9Y1E2NqH3RcLBlCwKyl
	 G+KiZAkM8ri1zhB0AfSd6PteWxmTGpN0N1+4eX+Lg49QQYpAq0OUOaKe8Nn2jwW+TTKuK
	 dkkvhXuHFPXv7GAFD1FizOCxEGVHK3v3jFxPOpJQMFZuJAgxww9RgI4W21tMalbvqcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bKib9wjYwu3eEM+e6rH5PLRkZA544OQFTDaMS7uNnxs=;
	b=e6x98ujTPvUgQ7yeeuRremK0X8zSAxdGm7GHxj0CJbJvVbUI4Or7aLMaYkLrzpVmg8Df
	 +mwN2lHzB3g/uBV7+lzIbGwGyMsjtP0wxfkIptsfTxdPgnxNtXnx3VD3cIL6zyBdZuDr6
	 2X3UAlu0bLaWmoLFojQeIjcYXWmgt9I1w3NrjHXMX5Tb4I7T+mcfEjB4FKaZWh3blBONa
	 w5Db80/jlEUNlaiEnCntdOB6csm+m7/b79zNF+ZaWk/R785d6sNiI3Jsz2QH/xRQDT758
	 fqmYj/IBS0FJhWHxA3xwbMTS5WRPw/iFz1DGKef5BANfvK1Mmc5pt6WEPK7vZJqXG9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VxN7+FXQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3C4606A31E;
	Wed, 25 Nov 2026 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VxN7+FXQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A0B1F000C6;
	Wed, 25 Nov 2026 17:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626109;
	bh=bKib9wjYwu3eEM+e6rH5PLRkZA544OQFTDaMS7uNnxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxN7+FXQRfNc6oax0yh4UI+ssLlxhPkDwL1s1RW3bBL0wPC0dmFI1HPipx9DNWfSr
	 RPoneBXV0NI378GvUnwD/ZutbrlwAwV1k+KewQY8kPdnTfa4vIZyUYk/c454a8r+3o
	 9AcQAQgwcZok6JqlRU1g5px5B+5hkumZL1UOk1go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Robert Baldyga <r.baldyga@samsung.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 734/816] serial: samsung: dont leak the tty on an RX IRQ
Date: Wed, 25 Nov 2026 15:38:02 +0100
Message-ID: <20261125143906.169647574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 7ada442f5ef77f8d53f608a0141a5e88a888ca9f upstream.

s3c24xx_serial_rx_chars_dma() starts by taking a reference to the tty.
If the interrupt is not a receive timeout, it switches the port from PIO
back to DMA and leaves through the "finish" label, which does not drop
the reference.

A port with RX DMA changes to PIO on every receive timeout, that is at
the end of every burst of data, and comes back this way when the next
burst starts.  So each burst takes a reference which is never dropped,
and the tty structure is not freed when the port is closed for the last
time.

Drop the reference on both paths.

Fixes: b543c301c2c5 ("serial: samsung: add DMA support for RX")
Cc: stable <stable@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-21-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -734,14 +734,13 @@ static irqreturn_t s3c24xx_serial_rx_cha
 
 	s3c24xx_serial_rx_drain_fifo(ourport);
 
-	if (tty) {
+	if (tty)
 		tty_flip_buffer_push(t);
-		tty_kref_put(tty);
-	}
 
 	wr_regl(port, S3C2410_UTRSTAT, S3C2410_UTRSTAT_TIMEOUT);
 
 finish:
+	tty_kref_put(tty);
 	uart_port_unlock(port);
 
 	return IRQ_HANDLED;


