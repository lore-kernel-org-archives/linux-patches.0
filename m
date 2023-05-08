Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9D0168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAAAC433EF;
	Mon,  8 May 2023 10:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543046;
	bh=2tp9ftnmiVd39AtJGUhDVZj/4N1Rr2e1i9ciwy4XU5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8ZF9u8UkOzIpgH2u1wRCQ5ZKr+eX9GwoWgVHngyJlF4SX3EdNTc7nrtkjDLUF6hc
	 3UmjiWZfX9XTt7O9xwyFZftEYVDeRJvxhETmqGdRAUc7cYpfC1kXW9/i+7DKf0C1Sv
	 46+DB2faGGA/6H2Lf6Fc5fcOCIO9q/VKoUIl4j4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 601/663] mfd: ocelot-spi: Fix unsupported bulk read
Date: Mon,  8 May 2023 11:47:07 +0200
Message-Id: <20230508094449.039812441@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit f0484d2f80a72022b7fac72bcb406392900ef1eb ]

Ocelot chips (VSC7511, VSC7512, VSC7513, VSC7514) don't support bulk read
operations over SPI.

Many SPI buses have hardware that can optimize consecutive reads.
Essentially an address is written to the chip, and if the SPI controller
continues to toggle the clock, subsequent register values are reported.
This can lead to significant optimizations, because the time between
"address is written to the chip" and "chip starts to report data" can often
take a fixed amount of time.

When support for Ocelot chips were added in commit f3e893626abe ("mfd:
ocelot: Add support for the vsc7512 chip via spi") it was believed that
this optimization was supported. However it is not.

Most register transactions with the Ocelot chips are not done in bulk, so
this bug could go unnoticed. The one scenario where bulk register
operations _are_ performed is when polling port statistics counters, which
was added in commit d87b1c08f38a ("net: mscc: ocelot: use bulk reads for
stats").

Things get slightly more complicated here...

A bug was introduced in commit d4c367650704 ("net: mscc: ocelot: keep
ocelot_stat_layout by reg address, not offset") that broke the optimization
of bulk reads. This means that when Ethernet support for the VSC7512 chip
was added in commit 3d7316ac81ac ("net: dsa: ocelot: add external ocelot
switch control") things were actually working "as expected".

The bulk read opmtimization was discovered, and fixed in commit
6acc72a43eac ("net: mscc: ocelot: fix stats region batching") and the
timing optimizations for SPI were noticed. A bulk read went from ~14ms to
~2ms. But this timing improvement came at the cost of every register
reading zero due the fact that bulk reads don't work.

The read timings increase back to 13-14ms, but that's a price worth paying
in order to receive valid data. This is verified in a DSA setup (cpsw-new
switch tied to port 0 on the VSC7512, after having been running overnight)

     Rx Octets: 16222055 # Counters from CPSW switch
     Tx Octets: 12034702
     Net Octets: 28256757
     p00_rx_octets: 12034702 # Counters from Ocelot switch
     p00_rx_frames_below_65_octets: 0
     p00_rx_frames_65_to_127_octets: 88188
     p00_rx_frames_128_to_255_octets: 13
     p00_rx_frames_256_to_511_octets: 0
     p00_rx_frames_512_to_1023_octets: 0
     p00_rx_frames_over_1526_octets: 3306
     p00_tx_octets: 16222055

Fixes: f3e893626abe ("mfd: ocelot: Add support for the vsc7512 chip via spi")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230322141130.2531256-1-colin.foster@in-advantage.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ocelot-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
index 2ecd271de2fb9..85021f94e5874 100644
--- a/drivers/mfd/ocelot-spi.c
+++ b/drivers/mfd/ocelot-spi.c
@@ -130,6 +130,7 @@ static const struct regmap_config ocelot_spi_regmap_config = {
 
 	.write_flag_mask = 0x80,
 
+	.use_single_read = true,
 	.use_single_write = true,
 	.can_multi_write = false,
 
-- 
2.39.2



