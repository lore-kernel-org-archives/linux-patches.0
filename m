Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061623;
	b=KLFnFIUdiMWcv6lPKwSb1HjiVleJaW7Mu1CrFnV5rGeiwN40q6E306eocj1QYpDR5dBH
	 W9sc5wUtd/l9nQoY6c03gHrep79IvWSk+GIO6LKWmxP3jzp4+TzZdZIfXXl7haauU5zPy
	 X+vAWMZmi+TpkGgheNDZJ9rltW/nrX7VIS9+6sDvm2pmqlP4HTooAi5r7i6VEfzIc5l5r
	 ml4ttH4Y93q2UCJfaPk0R4NGc8Hao3o5yQ05qR8EuoWD5d8dDcIkKr4xhQnw9g+YcAYTg
	 P8cMatPmTMppcQ8Ih4R9M+/orl8ldp24xiSqPnFuksvNbG02a2Dnj2VRgQcJRXTqTeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pehgAv4MrnomqIHFJwbjp/Ji71Vs1kxLIE4puHuo/jE=;
	b=es1ukQh8mbzP6yJ+7dVNJ8Etihsm1JEAl6KzNbfrbQhxKCzz/nBZvcYoIbPMU6xpRgkU
	 pg37is7gQ0tJrlPecQAp1V2FKR0aAF353E/xrva9DGSZS9zVbwmqTicErcMgskrv353NX
	 +iLYm6rfw8urIT8qEN+SQf60W+oX5NZTrlr9fAe4xR07QnbgB2fclsG/+eNPzZ3Ig0Se1
	 zaeBvtF40934aqmdv1mtbUYXLXc7R8hYePlQxc9C3ZkTIXzDpkXYFOp6aZFjgjh9qJevt
	 ApvpRzOkppSqXVX3cijGu4jQdWDu90bz2S0cpC29/qAxxsMW/3TyYX6DKLot/YdP+4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBFmV4jZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5FF606A326;
	Sat,  7 Nov 2026 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBFmV4jZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9E41F0089F;
	Sat,  7 Nov 2026 14:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061622;
	bh=pehgAv4MrnomqIHFJwbjp/Ji71Vs1kxLIE4puHuo/jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBFmV4jZu45Gyo+H8Qj7ScNKh4OqqQUxojFz23+07gwkZr8h16f1f89PMP22/+Jyp
	 ivPC6KOofO26yCz3WWUCKa3lMmEmUirqCSm1WyfBvsLySqmwNdgJeriFGquAVqpLL/
	 3Qt/dKp1bZae9AEQ6y7LdLIG8Lii5RxDwycxAWsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.12 0663/1536] media: rc: fintek-cir: process a full RX buffer instead of overflowing it
Date: Sat,  7 Nov 2026 08:44:39 -0500
Message-ID: <20261107135016.129015395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Weigang He <geoffreyhe2@gmail.com>

commit d1febef1bcfa7bbc401729f994c375b91a833911 upstream.

fintek_get_rx_ir_data() drains the CIR RX FIFO into fintek->buf[], which
holds RX_BUF_LEN (32) bytes, for as long as CIR_STATUS reports pending
RX data:

	do {
		sample = fintek_cir_reg_read(fintek, CIR_RX_DATA);
		...
		fintek->buf[fintek->pkts] = sample;
		fintek->pkts++;
		...
	} while (status & rx_irqs);

Nothing bounds fintek->pkts. If the hardware reports data for more than
RX_BUF_LEN reads in one interrupt, the loop writes past the end of
buf[], starting with the pkts counter that follows it in struct
fintek_dev.

Hand a full buffer to fintek_process_rx_ir_data(), which parses the
samples and resets fintek->pkts, before storing the next sample. This
keeps the parser state consistent and drops no samples. The loop still
relies on the status register to terminate.

The driver does not document the hardware FIFO depth, so it is not
known whether a working device can trigger this.

Found by static analysis tool CodeQL.

Fixes: 9bdc79ea07d9 ("[media] fintek-cir: new driver for Fintek LPC SuperIO CIR function")
Cc: stable@vger.kernel.org
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/fintek-cir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -340,6 +340,10 @@ static void fintek_get_rx_ir_data(struct
 		sample = fintek_cir_reg_read(fintek, CIR_RX_DATA);
 		fit_dbg("%s: sample: 0x%02x", __func__, sample);
 
+		/* Process a full buffer before storing the next sample. */
+		if (fintek->pkts >= RX_BUF_LEN)
+			fintek_process_rx_ir_data(fintek);
+
 		fintek->buf[fintek->pkts] = sample;
 		fintek->pkts++;
 


