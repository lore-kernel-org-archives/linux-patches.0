Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035182;
	b=ofWBnTyr03A9Iu5LfwWhXSxHorQa5G67IQRDOKM5xuscib9vWM7Pb0S8EDWSmr2D1qAO
	 5SY8RE1LydUfYTW2l2xtRE1z79DNOjw6n3/NPYrnasxP46WpHWo89cMwLA8BNkx45iDJP
	 1yfszl6hqHxrdqQiZAOOZV1wr9tWnXLcwrncw4dHYXMl+pvmxXI42iwC7IrnDWePnV7Bw
	 ARjQjJV4zlGLVlsR8g9ZqTG4GqT0ewQVf2/EPtNAica771ro33oBGOqh4sV1yomZfRMeo
	 5OCVVZb5ijSxY6tzUBZWxtYdI87yzE+Z6RS4+kIahWdBPFcZO2laA7N/DsWVlYdeyKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQ6Psmx1rF0U7tgSsgFwmFgxfo38Jqvto2lw+rIgz80=;
	b=29JCsjNy9TMHurhwzjlyvbol7hN6tv117pLf4b00mv73GiGcE8M13Rno/LHtWiqfekMC
	 DajCD8iEEBt7J7hxVQTTzoO3F6cE+XtS65lvRW7AcjiV/xnWR563/CR+OLgxp4QXJFSuG
	 od7Ab+dVMEpMCU/Lq72ajua1RgJ/FLOEo0womL5J4RPN2FcLCoJZzWk1vVHVAXdM9Z7cr
	 TNotM19YJzb6tOrU36NJbopAt76dr1UmbSbnDiXhUIOJ+H9FjcHMWzpOMJf+og5LTZLs9
	 n/X6H8EWrRlk/C6F8eXnmGF1LsexpapjF160LwQp0yU/2zbzAhowjuxifMDmbqNCjkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUhfs40L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF67606A31C;
	Wed, 18 Nov 2026 20:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUhfs40L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D391F000CD;
	Wed, 18 Nov 2026 20:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035182;
	bh=kQ6Psmx1rF0U7tgSsgFwmFgxfo38Jqvto2lw+rIgz80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUhfs40LGPivhcU2FF1FbXbRwCJnidCHGh0MXXushubN+PbWQSghAnxof7SvjZZTr
	 lg1WzT0O7SGHNKxbsMT1AkHoX+rbncdUZahz/gkkKn1s8P/9eMIJ+wJEDnYo869GHb
	 FxyTBts4/q+JKa1T14S0C2Hou9havEx8CUgk8KjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.6 0633/3318] media: rc: fintek-cir: process a full RX buffer instead of overflowing it
Date: Wed, 18 Nov 2026 15:20:55 +0100
Message-ID: <20261118150336.887107020@linuxfoundation.org>
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
 


