Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057811;
	b=iSAZ/+3IxvvHLVI4J44qcd24ysU7tYoG3F5tfrhZZNMABhjUIoHYsURIvqJdYpv/YeAG
	 JP3wENWzxudLNg4glVebZ+jJoWjunJdXaybO611Zf6YtFIh6KTwkh2vA87A2DCmXvTb/L
	 ywt4hYzMMyfPWAGildAwkHrmU+87LgigSOO5ojEYTNRACQA8bGybqL60UPoPmh+w9k5fI
	 02ssrOphSwp9ZJmYJktEPpNC91hsZM+k0MT+pdWs4YA5p44IrT7jS2bJ2LVP0crrSCqgy
	 8viiC/F+GBcmNEOFZbllLK6NUMxBbocIMDtVm0m5W9TNQbK+gbNzeD1WN3mKWyUwNPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dfFhkSuysqVOavSpCnIsodOYAS3iO295s/vO3OcrE8o=;
	b=y0rmojTPtNNG6wjuU4+PIt71TSDzLbb0BAp21SPiyqaskY7Vlm8ofodKBCwxp+I4VXvW
	 VDZuV69pKjWzv/f9ro/bEyx7OWT/EdN+5r4z2AQ5C0v2QqlMfha5nT3RdWQj4a7LCTHCB
	 1eMDVPsONV0eCmargxlCZlHYzuVF4gAnqaDJFQLMDAMmiC8yP+xoLMfnCRtDaRp9qKhYG
	 /eSi3YeUgsVOh5kCNT6CUrLFQmRc1nlDMOFhCJcrgO1yjIYz6Gi0Z2esqdkyqFK68xYPe
	 2yhhcA41lzxKvRw8qJ3w3ZG+dUBfOaDBU5kl7ZujFOqE+LnQIrwxa79Ht0vmVfqXhdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpEgDMiX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263BE606A31C;
	Thu, 19 Nov 2026 03:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpEgDMiX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3C51F000C5;
	Thu, 19 Nov 2026 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057811;
	bh=dfFhkSuysqVOavSpCnIsodOYAS3iO295s/vO3OcrE8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpEgDMiXmJIiEO1MGhH0ufYbi+iMkTwLxbKVyU9iLAQLkCSp8HUwTup2kjMUB8pbh
	 lE3JZu0YOnk7E2CSv2IABqQX9JSc8w5viI8WkbkMy1ZJKS3LCGXEv/S4LigsKpykJG
	 Ep8aOBs1oCRz8LoEPJyS0hH5vU5EVwMU3Y9GknMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 5.10 0260/1848] media: rc: fintek-cir: process a full RX buffer instead of overflowing it
Date: Wed, 18 Nov 2026 15:38:18 +0100
Message-ID: <20261118145923.147157046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


