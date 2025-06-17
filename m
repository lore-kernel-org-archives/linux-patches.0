Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2581E3DCF;
	Tue, 17 Jun 2025 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179209; cv=none; b=bxnxVnlf9MtgYduxoK4v4XuHuD0cAPzTHiZm7BSxKjnJvskW+5xk48VXpskaDfpu6M2PyeTJ8AxoVOuiMYh+4RX6XZ0cpkcrYGWNjUmWp/R9fhmjFA43i9Irio0uD6IUIaIeKZYRPRw+vf9bQgsEMclJ8EYj6Sut0xlj0sxPgWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179209; c=relaxed/simple;
	bh=2EW/sIDNgCWEkKlc3r48hJc2jnI9hycG9Zt4YkHJ/WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YgqLBcs3sZYuGwPvDlIVKLcIfVS4BaAH5jAwKMqPbEYYZwogI4Tquh+HYfxBZBKut8sDqwIwg2Vd9GVuYWXVK3KE58E3se4jhZH4HHDbA4l+C5PdymqevZ1PYm+IJudVsq9RCYYB6ax37CN1oKfLf5ZvCz8BGV1oUP+UHxPEnHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQNo45XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQNo45XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB8FC4CEE3;
	Tue, 17 Jun 2025 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179208;
	bh=2EW/sIDNgCWEkKlc3r48hJc2jnI9hycG9Zt4YkHJ/WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQNo45XEs5CIrp8hwpaBmKla+P6EAq3S+D2MjJR59rO1ARbqWORD8YAvJ/GidWLIa
	 lex5wfkmz/Iv/qcbCWkwTPfSmAj3YwAEgud04H9dS7vLpoPE3rjAFr7DU7EBRO0a1n
	 p0uCEBxIETdho+pVBQolOhS/AUl9wHuMfwt9hAZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?F=C3=A9lix=20Pi=C3=A9dallu?= <felix.piedallu@non.se.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 682/780] spi: omap2-mcspi: Disable multi-mode when the previous message kept CS asserted
Date: Tue, 17 Jun 2025 17:26:30 +0200
Message-ID: <20250617152519.248028150@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Félix Piédallu <felix.piedallu@non.se.com>

[ Upstream commit 10c24e0d2f7cd2bc8a847cf750f01301ce67dbc8 ]

When the last transfer of a SPI message has the cs_change flag, the CS is kept
asserted after the message.
The next message can't use multi-mode because the CS will be briefly deasserted
before the first transfer.

Remove the early exit of the list_for_each_entry because the last transfer
actually needs to be always checked.

Fixes: d153ff4056cb ("spi: omap2-mcspi: Add support for MULTI-mode")
Signed-off-by: Félix Piédallu <felix.piedallu@non.se.com>
Link: https://patch.msgid.link/20250606-cs_change_fix-v1-2-27191a98a2e5@non.se.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index e834fb42fd4ba..70bb74b3bd9c3 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -134,6 +134,7 @@ struct omap2_mcspi {
 	size_t			max_xfer_len;
 	u32			ref_clk_hz;
 	bool			use_multi_mode;
+	bool			last_msg_kept_cs;
 };
 
 struct omap2_mcspi_cs {
@@ -1269,6 +1270,10 @@ static int omap2_mcspi_prepare_message(struct spi_controller *ctlr,
 	 * multi-mode is applicable.
 	 */
 	mcspi->use_multi_mode = true;
+
+	if (mcspi->last_msg_kept_cs)
+		mcspi->use_multi_mode = false;
+
 	list_for_each_entry(tr, &msg->transfers, transfer_list) {
 		if (!tr->bits_per_word)
 			bits_per_word = msg->spi->bits_per_word;
@@ -1289,22 +1294,17 @@ static int omap2_mcspi_prepare_message(struct spi_controller *ctlr,
 
 		if (list_is_last(&tr->transfer_list, &msg->transfers)) {
 			/* Check if transfer asks to keep the CS status after the whole message */
-			if (tr->cs_change)
+			if (tr->cs_change) {
 				mcspi->use_multi_mode = false;
+				mcspi->last_msg_kept_cs = true;
+			} else {
+				mcspi->last_msg_kept_cs = false;
+			}
 		} else {
 			/* Check if transfer asks to change the CS status after the transfer */
 			if (!tr->cs_change)
 				mcspi->use_multi_mode = false;
 		}
-
-		/*
-		 * If at least one message is not compatible, switch back to single mode
-		 *
-		 * The bits_per_word of certain transfer can be different, but it will have no
-		 * impact on the signal itself.
-		 */
-		if (!mcspi->use_multi_mode)
-			break;
 	}
 
 	omap2_mcspi_set_mode(ctlr);
-- 
2.39.5



