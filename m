Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015102;
	b=M0F9KR2bmJUELpSBI+Fqr/mVLXTmH+23IDMfRNeNc9D7RA1LQ5yW5rvadmrl5bDKF0b3
	 UA6fS0mD5VPiwu1owQX4pUzlPMjyBTC1Rgr9oXTVUni6gRmRa/DKgpecma0eE9lmSWFWc
	 CJFNjndTH171QNuk24Ed4YVKG6ioTjk9q23IZYvjz/JfhbaNY39wi/4MKqVA6AxPg7J8W
	 BnH/mK/Gu+bcNso4f6iT3STaOcnchPLmq5Ibv3LW228C5FgoSKe+XTDZCn9caLu2Yr6Q7
	 K9BZ5h016IfaVtKquBs8iT7RVg46HVm8eUjww/cOB9vqmVacD4kDyEYXvBLT5WWoamw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MfWKuLlHOSinXO/vOY+Q4Fd7Fkx9Izf0IaYrGz6XEw8=;
	b=HBZgyIryYI/zOitpRnGvn7IxUkMhp6s5dI1fFKrJVKiroo86J+4SyMVGveSXdCVzTjie
	 Z/AgTyQXss64M+Z70KEi8YiZ5h9HY5SXFrPVzmqUxkxbCUphDpjzEBaGJvf9Ve+Vu7bbY
	 NHkLrYYzK3sebUUrq6woYez99isgk3JCzHMWaQEFUsyYbfJqFDAn0AKLp9WaSKKDyUhEn
	 TPPbVQXBuf67pRqY0ceJSgY3nyHsjZOJpI6AM8qFU/HBkGkAVDQUAghrn8v5xSjVTCXsx
	 +fSLm9nPFHGWzAbuY2kEhPhHvHNEGS7BpT3DFR2qa5cGOzdPrrsTM/K/mebk7ZvpSeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vN1aRFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED53260A6F50;
	Wed, 18 Nov 2026 15:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vN1aRFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD6A1F0182F;
	Wed, 18 Nov 2026 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015101;
	bh=MfWKuLlHOSinXO/vOY+Q4Fd7Fkx9Izf0IaYrGz6XEw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vN1aRFTtvJSmFXFIAxOSIZzlBVCiSZtl0N4rLB5dcwktkvuCOQm3vj2aQe4Rl36e
	 URKQWx9vm6kZsrS4rQBoDA7Cc9T6g5fDbzGZ9b+ra3ZYd8MyM8aicde1tZ3HyGn7dK
	 9ipL+4mx0ZuoG1s2Utw8qbgjNFZdglAVhVch3+RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>
Subject: [PATCH 7.3 0053/2651] serial: max310x: schedule tx_work directly from the IRQ handler
Date: Wed, 18 Nov 2026 15:21:33 +0100
Message-ID: <20261118150249.865117311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

commit c06fcc258db0c0c7f607e64a7ce6a157bb2414b1 upstream.

The TXEMPTY interrupt asks for a FIFO refill, and start_tx() does
nothing beyond scheduling tx_work, so going through it makes no
functional difference. It does conflate two distinct events, though:
start_tx() is the serial core starting a new transmission, while
TXEMPTY can only fire for a transmission that is already running -
the bit latches on the FIFO's non-empty to empty transition, and the
IRQ handler's read of IRQSTS consumes the latch, so a stale TXEMPTY
cannot exist on an idle port (if the bit were level-triggered, the
handler's read-until-clear loop would never terminate).

Schedule tx_work directly, keeping the interrupt path a pure FIFO
refill. This is preparation for a following patch that adds
software-timed RS485 RTS control, where start_tx() also starts the
RTS envelope and a refill must not restart it.

No functional change.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-7-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -840,8 +840,12 @@ static irqreturn_t max310x_port_irq(stru
 		}
 		if (rxlen)
 			max310x_handle_rx(port, rxlen);
+		/*
+		 * TXEMPTY latches on the FIFO becoming empty, so a stale
+		 * interrupt cannot pump data during an RTS setup delay.
+		 */
 		if (ists & MAX310X_IRQ_TXEMPTY_BIT)
-			max310x_start_tx(port);
+			schedule_work(&s->p[portno].tx_work);
 	} while (1);
 
 	return res;


