Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3AD24A055;
	Tue, 29 Apr 2025 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946244; cv=none; b=RHCaOiw/9etawQFkY7lO6ylXKcEhwn8wLU1X/uOwCGXcvOcYqC0AfbgSHiUGTAo6SJLsxMuPGDJRxiAw1LTQNFVo8BSb/tsuiyNSZ0SaAtfHY0X6sTyECEmcFwPxF5LpXZxEXd98tquuDIypeJWXGinyb0h5Vc0L97umqjLuQZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946244; c=relaxed/simple;
	bh=eqKTnQ+1K+uwuRq/RP58NB/AH7hmIKolqRnCq4UfCbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzRfdDogW9U1tppsL+7IMiBYfNsy2K5ntuxnUdrWPigu4C4P6cuR8nWXzaF/gzYyeMVcV/mB+pMDAAHAE4EhKKnD5/2DDQD6lg8lsnW8YD92YBoNZquR9jkVr8u95V08Q2ENabvKOa8bQ/hlql+9QH4VoVU7dfK0eFJ8y4f9IQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQFhwj7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQFhwj7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531EDC4CEE3;
	Tue, 29 Apr 2025 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946243;
	bh=eqKTnQ+1K+uwuRq/RP58NB/AH7hmIKolqRnCq4UfCbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQFhwj7BPpSihe72qiBw2RRJ2DrthC4t3m6e0Ml7R3fnOmVY3H3kuuI6hbeXtHiZh
	 2fPs7avkrUmtizQdEfJ/5gq4qjfQ5XWYHC3gse+jfPBu+ZrMydXoel8FkaNj+SY8CU
	 akLYQ7L+P26c2i6ft8SwQoRi0lQUPxpGvNBVXPP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 202/311] iio: adc: ad4695: make ad4695_exit_conversion_mode() more robust
Date: Tue, 29 Apr 2025 18:40:39 +0200
Message-ID: <20250429161129.286427437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trevor Gamblin <tgamblin@baylibre.com>

[ Upstream commit 998d20e4e99d909f14d96fdf0bdcf860f7efe3ef ]

Ensure that conversion mode is successfully exited when the command is
issued by adding an extra transfer beforehand, matching the minimum CNV
high and low times from the AD4695 datasheet. The AD4695 has a quirk
where the exit command only works during a conversion, so guarantee this
happens by triggering a conversion in ad4695_exit_conversion_mode().
Then make this even more robust by ensuring that the exit command is run
at AD4695_REG_ACCESS_SCLK_HZ rather than the bus maximum.

Signed-off-by: Trevor Gamblin <tgamblin@baylibre.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Tested-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20241113-tgamblin-ad4695_improvements-v2-2-b6bb7c758fc4@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4695.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/adc/ad4695.c b/drivers/iio/adc/ad4695.c
index b79d135a54718..22fdc454b0cea 100644
--- a/drivers/iio/adc/ad4695.c
+++ b/drivers/iio/adc/ad4695.c
@@ -92,6 +92,8 @@
 #define AD4695_T_REFBUF_MS		100
 #define AD4695_T_REGCONFIG_NS		20
 #define AD4695_T_SCK_CNV_DELAY_NS	80
+#define AD4695_T_CNVL_NS		80
+#define AD4695_T_CNVH_NS		10
 #define AD4695_REG_ACCESS_SCLK_HZ	(10 * MEGA)
 
 /* Max number of voltage input channels. */
@@ -364,11 +366,31 @@ static int ad4695_enter_advanced_sequencer_mode(struct ad4695_state *st, u32 n)
  */
 static int ad4695_exit_conversion_mode(struct ad4695_state *st)
 {
-	struct spi_transfer xfer = {
-		.tx_buf = &st->cnv_cmd2,
-		.len = 1,
-		.delay.value = AD4695_T_REGCONFIG_NS,
-		.delay.unit = SPI_DELAY_UNIT_NSECS,
+	/*
+	 * An extra transfer is needed to trigger a conversion here so
+	 * that we can be 100% sure the command will be processed by the
+	 * ADC, rather than relying on it to be in the correct state
+	 * when this function is called (this chip has a quirk where the
+	 * command only works when reading a conversion, and if the
+	 * previous conversion was already read then it won't work). The
+	 * actual conversion command is then run at the slower
+	 * AD4695_REG_ACCESS_SCLK_HZ speed to guarantee this works.
+	 */
+	struct spi_transfer xfers[] = {
+		{
+			.delay.value = AD4695_T_CNVL_NS,
+			.delay.unit = SPI_DELAY_UNIT_NSECS,
+			.cs_change = 1,
+			.cs_change_delay.value = AD4695_T_CNVH_NS,
+			.cs_change_delay.unit = SPI_DELAY_UNIT_NSECS,
+		},
+		{
+			.speed_hz = AD4695_REG_ACCESS_SCLK_HZ,
+			.tx_buf = &st->cnv_cmd2,
+			.len = 1,
+			.delay.value = AD4695_T_REGCONFIG_NS,
+			.delay.unit = SPI_DELAY_UNIT_NSECS,
+		},
 	};
 
 	/*
@@ -377,7 +399,7 @@ static int ad4695_exit_conversion_mode(struct ad4695_state *st)
 	 */
 	st->cnv_cmd2 = AD4695_CMD_EXIT_CNV_MODE << 3;
 
-	return spi_sync_transfer(st->spi, &xfer, 1);
+	return spi_sync_transfer(st->spi, xfers, ARRAY_SIZE(xfers));
 }
 
 static int ad4695_set_ref_voltage(struct ad4695_state *st, int vref_mv)
-- 
2.39.5



