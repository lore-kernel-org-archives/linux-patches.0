Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8494A33FC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300990; cv=none; b=JOrkOoHM0OMBJ7kb24kYhGq6AIhV58GFOO2xDQK/4/kFJTuPLqqBdfmYRrHi+ae0OGDnQXs5mlH4ga0myhvd4XB40JWRad9mfPbtEwNfh5aN92HwzVc4IMOyKRyUarWv6xpnDXI0Tmyt2aaLJgTTcSgMmRpE2EFMfJs/ZPPXhEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300990; c=relaxed/simple;
	bh=bzZk1TOgUSd5fSDGays6IuFF1nr/j71MGP5pJ4t2xL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRXG00j5ID/LaQg3fYQI0ugz7GQ9w/kc21muVvo0NaHBylyw4u/uZRUD+fEWdY5v0Xy+yLC7QzNhKj7+yPcO38Neeo7Qh9yCtl0wle2kE7xuIBQaTeUAvSvizYoAG08PuBzWxigmIXqvWwIfXhXrJfjATeWtV5WKiLKqxlqv7D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ou7xD8Jv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ou7xD8Jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05899C116D0;
	Sat, 28 Feb 2026 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300990;
	bh=bzZk1TOgUSd5fSDGays6IuFF1nr/j71MGP5pJ4t2xL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ou7xD8JvsP33KFZKxCkEs9Skt1Yuat2AQ3bqMULFex9EmiEQfIKXJKlcbjZXjxI0v
	 WlPBzr2LXwiM6uLBdEGXAzXp4JwBs8TEYYprdfOITs/ZCNaPsyHxpO1exwxWg3+hf9
	 HkB7BG6egM5nCmadfZBkLUfUdm3XmFSlNx6QGl/bdAilqx25ESZSCO7MaCmrPAu3Js
	 HnMjswc7l02n/2/Ya0ARGdvudU9WLBvkBesLXeLId+Grjbd31lJAYFkZWhlJ1HxLFu
	 4FqZTztfRF1UNtdhx7YyuVb3l/G6Cfry42QBnnxtMsVk+iUCtXfXci+DAH7/youowe
	 +/cHKJgoRpn0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jonathan Marek <jonathan@marek.ca>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/752] spi-geni-qcom: use xfer->bits_per_word for can_dma()
Date: Sat, 28 Feb 2026 12:37:12 -0500
Message-ID: <20260228174750.1542406-121-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit fb2bbe3838728f572485706677590e4fc41eec5c ]

mas->cur_bits_per_word may not reflect the value of xfer->bits_per_word
when can_dma() is called. Use the right value instead.

Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://patch.msgid.link/20251120211204.24078-3-jonathan@marek.ca
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-geni-qcom.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-geni-qcom.c b/drivers/spi/spi-geni-qcom.c
index 9e9953469b3a0..5ab20d7955121 100644
--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -548,10 +548,10 @@ static u32 get_xfer_len_in_words(struct spi_transfer *xfer,
 {
 	u32 len;
 
-	if (!(mas->cur_bits_per_word % MIN_WORD_LEN))
-		len = xfer->len * BITS_PER_BYTE / mas->cur_bits_per_word;
+	if (!(xfer->bits_per_word % MIN_WORD_LEN))
+		len = xfer->len * BITS_PER_BYTE / xfer->bits_per_word;
 	else
-		len = xfer->len / (mas->cur_bits_per_word / BITS_PER_BYTE + 1);
+		len = xfer->len / (xfer->bits_per_word / BITS_PER_BYTE + 1);
 	len &= TRANS_LEN_MSK;
 
 	return len;
@@ -571,7 +571,7 @@ static bool geni_can_dma(struct spi_controller *ctlr,
 		return true;
 
 	len = get_xfer_len_in_words(xfer, mas);
-	fifo_size = mas->tx_fifo_depth * mas->fifo_width_bits / mas->cur_bits_per_word;
+	fifo_size = mas->tx_fifo_depth * mas->fifo_width_bits / xfer->bits_per_word;
 
 	if (len > fifo_size)
 		return true;
-- 
2.51.0

