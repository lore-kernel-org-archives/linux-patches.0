Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705664;
	b=gcuKPlLbTt9nGn274PeRimKqw8MThJAX7XNZ11kIsWoI4YlVLmCJHdPerQEHHbn62oAQ
	 xWN3/sVu61Kfzdt5pDIBzW2q14naYXIpG4y1p4uoDRPf8MiBehSz57IbYQub07bAFGTKg
	 7dTf9nYRFf6jM0syshMnjC9PZ1C6GyFbQZoEqov235rpLBeMQQXm4TbexvTqfsciW0uQ5
	 Lq5r/zV9F4rus3pXTgjyGqHG1+g2vs8e8EVBDRLvnfbvWXxaUEe1DHueG+njFuqNht0jd
	 RCny0azmQ9fzp+n58F5bHs05zSPi9NMQkAy3HeZ+0lGh92VIQNVcegn3P+z008j0PRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QCm729bbtIghVQiyj7MovCg074tKOO+ZavpRMW0aciE=;
	b=JY06HQ0XPAsviQNBqWal9ZWA2GwH53bCXnPwu6brqJEH4V8PvpBYDSvsAisKm7zIk1ye
	 QUmZetAVvdB/hNJHwAfywCRuRh5CWvAa0GEVDPvUPSq4IZ/nkrDKZcTs8TEhFgbDydklX
	 fC5CaBPw/S58e43jTTokX85OUIudhmTKE5YxiiVAVrDi6kFgX6L0POarmYmG7x0vrA8Hg
	 n3kkjaOnaOCW2NJrpY8HFDBKPUCX0wpxLthFTT/9BvnvVWCuVk/TyhWEDXOR5CEVPIGr6
	 GbPfmlS4Yq+j3LdGR9sbPfKT410J61pazPMaU+vEce6O4eZElDQW2TUHrFB7NakyRag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKL3+LYL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEFD606A32C;
	Thu, 26 Nov 2026 15:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKL3+LYL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB60B1F000D2;
	Thu, 26 Nov 2026 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705664;
	bh=QCm729bbtIghVQiyj7MovCg074tKOO+ZavpRMW0aciE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKL3+LYL45i9NyLh2ulWmdxofJ/+dol1k6diX0K6rrcZC3VTycx+XQ+uN4BiHKoV6
	 I0md4anz2e/Iz1iS0hIITkSqf37wB0Z57j5FSYWuMhqtiTcQ6dJvyZTokH0znBDlWQ
	 uFO85QKMSyQFkDs2bXP2YJjTq4YdSMhn58uRinu0=
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
Subject: [PATCH 5.15 267/319] serial: samsung: dont leak the tty on an RX IRQ
Date: Thu, 26 Nov 2026 15:40:35 +0100
Message-ID: <20261126144012.774363509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -737,14 +737,13 @@ static irqreturn_t s3c24xx_serial_rx_cha
 
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


