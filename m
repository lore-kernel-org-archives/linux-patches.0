Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022755;
	b=QL6eZIWXrgsG3oP1St7HfAwdIKcKksX4XqA303ZqJfrARdoG13YoxM95YSkZ61NlEhn/
	 DQ7ZmKItGv3lVl4a6TZUGxrTG+Oj75JQM0GT5aHn5n1/dzsg0Pv6qdUt1LXsSqjV9yVxE
	 7X8xfTE591ULwvnJvTGnvVfjuKrUtEEK4rlyBVMT1Qn1L162MoneDLwQ3USgyVfOkS7JV
	 8o7N1cSi0mXwZQQSUR0ltQ/3EZmH7j+6xltLXPp4V7inHs/KM7OFhgedHIMZzv4qJFH1e
	 4G7EPtQc/zlJRT5kNzaMRZ9rHcKAYUBNKql/y9ALfGncGnwDz51u8U/Flcfx+EficKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kfs+SNOnFfR8wWNap3M+ICAf+nYOp9C9B19191x1o5A=;
	b=zX3vqYjvsk9jQ+HqNmBQZOkeZAr0+gYQKTTx73Gx5SkULnFu6EVY9QgtnOUQSTutWQtS
	 ZhYUVcrM/D2QX8O2/TQC5Oqx5aXl5ZEFajm2FnKDhIu8hlfd68WQOBWSBajPpO+YGHVAu
	 y09mArk8g1xJ+PvV/TmpbkQyse8JFO7KvzHdRra+VrGqT2KHIZaIpq4NKKXiRicc4Ft5E
	 A2FW547ztPKT6IgcCRP/M8nfyf6qeLurTE+ro4QWbwVOLRBpS65DRce9lMMhEHsvgZpNp
	 Au5OQtG3WHKg1PEFFEgPMQsHHWEZzxpgn5asp3sC3NkxSidRljctGmQ6iztIQcaZvrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLNp8WxQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D571606B3FE;
	Wed, 18 Nov 2026 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLNp8WxQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48871F000C9;
	Wed, 18 Nov 2026 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022755;
	bh=Kfs+SNOnFfR8wWNap3M+ICAf+nYOp9C9B19191x1o5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLNp8WxQl31Hai+dEPdgiTkt5qyKARMURzVmeymfJf9Is5r+vhfAvFyg1oYIpQnIU
	 WTYCB2RkWxMuybpQfxjvwxrhIebZWxFQaSyd0pkTGCKsuxGCDfhP1oNhUzDEWoZdY3
	 V7ojViq4uXqnkofYSR/K4DbUS/3fVmHtR4LQz2RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>
Subject: [PATCH 6.18 0125/2151] serial: max310x: schedule tx_work directly from the IRQ handler
Date: Wed, 18 Nov 2026 15:31:00 +0100
Message-ID: <20261118150126.342681620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -810,8 +810,12 @@ static irqreturn_t max310x_port_irq(stru
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


