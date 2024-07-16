Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097BF12B72;
	Tue, 16 Jul 2024 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144881; cv=none; b=o/J+651TGg0j+POOIPLbMmckW+H8DTFsGnuLLS/VOPz8JkTAsgdQAfFMmKFa9BnurVW4bqFIP8biQbcxw7/w+BZRYtvv8u7cmQ5XBEYoS6On1IFYcYNA7P6XocpU8win8h485ddVlBseu83gZB4UWScqVf3HPH7QUudFNDDMKCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144881; c=relaxed/simple;
	bh=ZzUagMKja3/EYxlNiAyedvGZV1dJhsZJWuVTPnsfV24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUg2KEvjOVZwHJCFcswMcRUryjFAfYPv34pEp4LH8TIrtuPsBKi8punbh/5Nrk2EVYo9ydHIdRf/ZznmmMFn0SCpvVm/NpEuB6V+Tz236plL0AenCJ00CnezYA/wJYGurYLN7Key/RmsHsGPjsdindYXuug22jCf7M5KbEe8Qsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYRJzXl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYRJzXl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84245C116B1;
	Tue, 16 Jul 2024 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144880;
	bh=ZzUagMKja3/EYxlNiAyedvGZV1dJhsZJWuVTPnsfV24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYRJzXl1KEsWUfueLuHBqjmgXLmrIaly+AITuDpz1r7A3i+v+F/YvEsrIhSko0Zgs
	 tgDtKYT59lJqL0doRHv3wD1wAnr4H3w1e5ekkvo5ggpkmROzuYmgMG0Q8gQmvun5wP
	 4Rs9BFb0bYwXjFtg/kuOOKf0yjcxkVtQNu5pjC7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 005/143] spi: axi-spi-engine: fix sleep calculation
Date: Tue, 16 Jul 2024 17:30:01 +0200
Message-ID: <20240716152756.192487012@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 40b3d0838a1ff242e61f341e49226074bbdd319f ]

The sleep calculation was not taking into account increased delay when
the SPI device is not running at the maximum SCLK frequency.

Rounding down when one SCLK tick was the same as the instruction
execution time was fine, but it rounds down too much when SCLK is
slower. This changes the rounding to round up instead while still
taking into account the instruction execution time so that small
delays remain accurate.

Fixes: be9070bcf670 ("spi: axi-spi-engine: fix sleep ticks calculation")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20240620-spi-axi-spi-engine-fix-sleep-time-v1-1-b20b527924a0@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index e358ac5b45097..96a524772549e 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -164,16 +164,20 @@ static void spi_engine_gen_xfer(struct spi_engine_program *p, bool dry,
 }
 
 static void spi_engine_gen_sleep(struct spi_engine_program *p, bool dry,
-				 int delay_ns, u32 sclk_hz)
+				 int delay_ns, int inst_ns, u32 sclk_hz)
 {
 	unsigned int t;
 
-	/* negative delay indicates error, e.g. from spi_delay_to_ns() */
-	if (delay_ns <= 0)
+	/*
+	 * Negative delay indicates error, e.g. from spi_delay_to_ns(). And if
+	 * delay is less that the instruction execution time, there is no need
+	 * for an extra sleep instruction since the instruction execution time
+	 * will already cover the required delay.
+	 */
+	if (delay_ns < 0 || delay_ns <= inst_ns)
 		return;
 
-	/* rounding down since executing the instruction adds a couple of ticks delay */
-	t = DIV_ROUND_DOWN_ULL((u64)delay_ns * sclk_hz, NSEC_PER_SEC);
+	t = DIV_ROUND_UP_ULL((u64)(delay_ns - inst_ns) * sclk_hz, NSEC_PER_SEC);
 	while (t) {
 		unsigned int n = min(t, 256U);
 
@@ -220,10 +224,16 @@ static void spi_engine_compile_message(struct spi_message *msg, bool dry,
 	struct spi_device *spi = msg->spi;
 	struct spi_controller *host = spi->controller;
 	struct spi_transfer *xfer;
-	int clk_div, new_clk_div;
+	int clk_div, new_clk_div, inst_ns;
 	bool keep_cs = false;
 	u8 bits_per_word = 0;
 
+	/*
+	 * Take into account instruction execution time for more accurate sleep
+	 * times, especially when the delay is small.
+	 */
+	inst_ns = DIV_ROUND_UP(NSEC_PER_SEC, host->max_speed_hz);
+
 	clk_div = 1;
 
 	spi_engine_program_add_cmd(p, dry,
@@ -252,7 +262,7 @@ static void spi_engine_compile_message(struct spi_message *msg, bool dry,
 
 		spi_engine_gen_xfer(p, dry, xfer);
 		spi_engine_gen_sleep(p, dry, spi_delay_to_ns(&xfer->delay, xfer),
-				     xfer->effective_speed_hz);
+				     inst_ns, xfer->effective_speed_hz);
 
 		if (xfer->cs_change) {
 			if (list_is_last(&xfer->transfer_list, &msg->transfers)) {
@@ -262,7 +272,7 @@ static void spi_engine_compile_message(struct spi_message *msg, bool dry,
 					spi_engine_gen_cs(p, dry, spi, false);
 
 				spi_engine_gen_sleep(p, dry, spi_delay_to_ns(
-					&xfer->cs_change_delay, xfer),
+					&xfer->cs_change_delay, xfer), inst_ns,
 					xfer->effective_speed_hz);
 
 				if (!list_next_entry(xfer, transfer_list)->cs_off)
-- 
2.43.0



