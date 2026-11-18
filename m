Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040950;
	b=1EV+4LSrtR0+PI0+j8OdPb+sVd4ARjMaDcCQdtvEMH5AzYOmQEd0ThcYUf+rS1F/LFej
	 wZUTJnKJVhJt8m/5hZVWS5PbHn5CRQxJXGJZUWlJWimGwjhXOQNjAjbipdmMH97BrPYCv
	 UUXmcGV1rrIKLnIf8Zmt2fYILdLvErBK0tuptNY6giGh1GaSYjqYwVA58LMd3sH0I9iB1
	 B4bxKA7n7IZ/0HYdY1LQyOkv+97Gps1oXJaF0L5pcvHjfVDUXmOuH0ncx2M+0zYPufi5V
	 AUMUIsceNwsx2wxGgR0rGuhtGGb2qYieqVopq4qTQxIlMRytI66riDVO9KaLQ/jYVMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9g0q3hYsBFtTNJ/jneHHFQMbkR4czxWiBBcUpFdgnuY=;
	b=X+Q7uslz47YKCqSaWDAvygnmcKlnpbfDTacBgNWK5fREknJmjEX1k3fkQc9yihNDTDdQ
	 FRY6sJpkTFUCnbyHb73z5Vv6L1hNnbUpZe8y9rlohtMtVzFx/AIT8cJs1TXfWXJipfcH8
	 SNhGvKHXzd3toLFlG5eOQqEnZM9Ri8rjGPBAYQ9YzvDyvYETdAsZ36NCJ7+NgL6Tn3dhe
	 cNDXym1ALcZ8MK38r5F5iH7sWqSu6HmFttbMSWnEBytiGUGfgwDlcNdOFIunT4DkjmKHf
	 IfVaKkLDySXGez3ex2iz3tbnW0GLmFNUA0DiH3vUBIwo5c8BgC82PKrqY0OHXcXMzZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKPnq4Cx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DAB606A31C;
	Wed, 18 Nov 2026 22:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKPnq4Cx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265E51F000C4;
	Wed, 18 Nov 2026 22:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040950;
	bh=9g0q3hYsBFtTNJ/jneHHFQMbkR4czxWiBBcUpFdgnuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKPnq4CxWIWj16JFrW/rzNBMqi6oqMzIxOc03v7WdIbLBTx23ulSWEbSpOvkMITXV
	 OSqbAjt/9PKZKyIb/E9pb2GweKA7PRXE1LwFg/BrVybo82dHwq7JU95e2k37geiAz3
	 dEf++zUnhR33yu+u+gNp/Waro3ZYyMeyjqJyt05g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schramm <t.schramm@manjaro.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jonas Rebmann <jre@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2640/3318] spi: spi-sun4i: sun4i_spi_handler(): fix race condition between transfer completion and RX FIFO interrupt
Date: Wed, 18 Nov 2026 15:54:22 +0100
Message-ID: <20261118150440.272985966@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit b8f09251da7871fbb9c62bd83516af422641d816 ]

In commit 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO
size"), support for transfers larger than the FIFO size was added.

This commit moves the draining of the RX-FIFO from
sun4i_spi_transfer_one() (after completion of the transfer) to the IRQ
handler when the IRQ "transfer complete" is handled. In addition, the
IRQ "RX-FIFO 3/4 full" is activated for all transfers.

However, this does not take into account that the RX-IRQ for transfers
that exceed 3/4 of the FIFO size is still pending after the IRQ
"transfer complete" has been processed. All interrupt sources are only
deactivated after the wait_for_completion_timeout() in
sun4i_spi_transfer_one().

This opens a race window for "RX-FIFO 3/4 full" interrupts to come.
The sequence is as follows:

| sun4i_spi_transfer_one()
|     sun4i_spi_fill_fifo()       // fill TX-FIFO with 48 bytes
|     // enable RX-FIFO 3/4 full IRQ
|     wait_for_completion_timeout();
|
| // SPI controller transfers 48 bytes
| // SPI controller issues "transfer complete" and "RX-FIFO 3/4 full" IRQ
|
| // IRQ handler start
|     sun4i_spi_handler()
|         // ACK "transfer complete" IRQ
|         sun4i_spi_drain_fifo();
|         complete();                         ----.
|         return IRQ_HANDLED;                      \
| // IRQ handler end                                \__ race
|                                                   /   window
|     // wait_for_completion_timeout() continues   /
|     // disable all IRQ sources              ----'

Avoid the race condition by disabling all interrupts when handling the
"transfer complete" IRQ and before calling complete(). Also move the
draining of the RX-FIFO back into sun4i_spi_transfer_one() where it
was before commit 196737912da5 ("spi: sun4i: Allow transfers larger than
FIFO size").

This has the added benefit of spending a little less time in the IRQ
handler.

With all interrupts disabled once the transfer completed, omit the
clearing of the Transfer Complete bit in sun4i_spi_handler. This is safe
because sun4i_spi_transfer_one() takes care of this before enabling any
interrupts again.

Cc: Tobias Schramm <t.schramm@manjaro.org>
Fixes: 196737912da5 ("spi: sun4i: Allow transfers larger than FIFO size")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
Link: https://patch.msgid.link/20260914-spi-sun4i-fixes-v3-4-9fe919d5cecf@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sun4i.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-sun4i.c b/drivers/spi/spi-sun4i.c
index 59e8a82cd8b64..ad0200d8dce8c 100644
--- a/drivers/spi/spi-sun4i.c
+++ b/drivers/spi/spi-sun4i.c
@@ -82,6 +82,8 @@ struct sun4i_spi {
 
 	struct completion	done;
 
+	int			irq;
+
 	const u8		*tx_buf;
 	u8			*rx_buf;
 	int			len;
@@ -333,6 +335,7 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 	start = jiffies;
 	time_left = wait_for_completion_timeout(&sspi->done,
 						msecs_to_jiffies(tx_time));
+
 	end = jiffies;
 	if (!time_left) {
 		dev_warn(&host->dev,
@@ -340,12 +343,11 @@ static int sun4i_spi_transfer_one(struct spi_controller *host,
 			 dev_name(&spi->dev), tfr->len, tfr->speed_hz,
 			 jiffies_to_msecs(end - start), tx_time);
 		ret = -ETIMEDOUT;
-		goto out;
+		sun4i_spi_write(sspi, SUN4I_INT_CTL_REG, 0);
+		synchronize_irq(sspi->irq);
 	}
 
-
-out:
-	sun4i_spi_write(sspi, SUN4I_INT_CTL_REG, 0);
+	sun4i_spi_drain_fifo(sspi, SUN4I_FIFO_DEPTH);
 
 	return ret;
 }
@@ -357,8 +359,7 @@ static irqreturn_t sun4i_spi_handler(int irq, void *dev_id)
 
 	/* Transfer complete */
 	if (status & SUN4I_INT_CTL_TC) {
-		sun4i_spi_write(sspi, SUN4I_INT_STA_REG, SUN4I_INT_CTL_TC);
-		sun4i_spi_drain_fifo(sspi, SUN4I_FIFO_DEPTH);
+		sun4i_spi_write(sspi, SUN4I_INT_CTL_REG, 0);
 		complete(&sspi->done);
 		return IRQ_HANDLED;
 	}
@@ -462,6 +463,7 @@ static int sun4i_spi_probe(struct platform_device *pdev)
 		goto err_free_host;
 	}
 
+	sspi->irq = irq;
 	sspi->host = host;
 	host->max_speed_hz = 100 * 1000 * 1000;
 	host->min_speed_hz = 3 * 1000;
-- 
2.53.0



