Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBA5331203;
	Sat, 12 Sep 2026 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226713; cv=none; b=tzXRFQlC9QkkutBfhwGzL6Gp+NAtsZ5t5qyHiVQZHwwKkULQQ3dmRPhgxk2LaRT6M1EGbEJaeL08oQgSy2Rb0orAH/Axqza3LKrnEV9RdZYBTASQamZW83H00S56O//xizxRb49Stb3pUjyNDtsd4pxKtarE6ohu3yzpeqyQsJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226713; c=relaxed/simple;
	bh=BEKOPhIyGxvJQc3Y3lgTU3YMHSBGXpw7Dc36ioKxSE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+NgGXzkVTBL61ojf0C5szBqVlxluTxZ0pOxYNO5pzgVPn6+Z2WE5sJsCRnOClLS+3wQeAOeaTYf2GMeSp3k8NohRCPLJdEoSMe7MV1egOHDjrV+FipoD7GoHx0Bgai4JmF1EU9MoyMxKqFiDZ/5MPytP1eRvOugt7ldZw9QnsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htE77aeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htE77aeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD411F000FF;
	Sat, 12 Sep 2026 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226712;
	bh=ylX11RdtOeSRs6OaO5b29OZAIIwdzLW4+eC0lq14Kqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htE77aeFqL0SgRV28QQzzRUMMBjUVBnHy8V78PAJjsO/PlPItO/KYfyOIwjWymsg1
	 5uQbRNYlhUFepXvL+zDXwst+CCygnj/kJhAETYGg+8XVOohfDXBTYpKTjTIYaA1Llt
	 BJ7hmBZwxWXg3eFYt4FyWE7NMktg9KSEYXA09zxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0033/1191] media: cec: stm32: prevent out-of-bounds write on RX overflow
Date: Sat, 12 Sep 2026 08:46:01 +0200
Message-ID: <20260912065548.869620322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

commit fb9dda38d4b9e90db07ed9a0ee2d35bf85494035 upstream.

stm32_rx_done() appends each received CEC byte to rx_msg.msg[] using
rx_msg.len as the write index, incrementing it on every RXBR
(receive-byte-ready) interrupt without checking it against the buffer
size:

	cec->rx_msg.msg[cec->rx_msg.len++] = val & 0xFF;

rx_msg.msg[] is a fixed CEC_MAX_MSG_SIZE (16) byte array in struct
cec_msg, and rx_msg.len is only reset on RXACKE/RXOVR or after a
completed message (RXEND). The number of bytes received before RXEND is
decided by the remote CEC device (it sets EOM), not by the driver. A
peer that keeps sending bytes without ending the message drives RXBR
repeatedly, pushing rx_msg.len past 16 and writing peer-controlled bytes
out of bounds into the surrounding memory. This is reachable in normal
operation once the driver has probed and receiving is enabled, from the
IRQ thread, without any local privilege.

The length check in the CEC core runs on the consumer side, after the
byte has been stored, so it does not prevent the overflow. Bound the
index in the driver before the store, as the other platform CEC drivers
already do (e.g. tegra_cec), dropping the excess bytes of an overlong
frame.

Found by static analysis tool CodeQL.

Fixes: d69ae57453c8 ("[media] cec: add STM32 cec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/platform/stm32/stm32-cec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/cec/platform/stm32/stm32-cec.c
+++ b/drivers/media/cec/platform/stm32/stm32-cec.c
@@ -133,7 +133,8 @@ static void stm32_rx_done(struct stm32_c
 		u32 val;
 
 		regmap_read(cec->regmap, CEC_RXDR, &val);
-		cec->rx_msg.msg[cec->rx_msg.len++] = val & 0xFF;
+		if (cec->rx_msg.len < CEC_MAX_MSG_SIZE)
+			cec->rx_msg.msg[cec->rx_msg.len++] = val & 0xFF;
 	}
 
 	if (cec->irq_status & RXEND) {


