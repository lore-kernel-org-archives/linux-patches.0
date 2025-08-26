Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1835145B3E;
	Tue, 26 Aug 2025 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212875; cv=none; b=Q56S6hTvl2WPV6bbCe4JJbmsOwGjN12WEJquXBO5HM15J405X3O5aW2t1bVlhMjjaZ3w4rdnkAoCWBWktI0GzvaECnDoy7NZ4atkYFOEGubQqPFgbc0mqOmTK6dJmpeQtZ9WscQWi20g5EXXFy8hJenLsgA2ZylnWakriwZIx6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212875; c=relaxed/simple;
	bh=3Vgy52usXlO+wjGBWTnRMajgK4EHmxdy6nQKUc9ZIWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqw94pyQNIM5wgNvhsmPyt+ij63MQYIqMQdHBPZhJiyRdrfs5B8x9FWyx8vB2Tp7u3bzgqLF9+an8VTfum/RqgDJqrON8EbJsLTv4aGE963euFSTzC/KDrGyuvwNCasUEQx7vzA5nT5c8qB1uPzumF6+MWuHrmp9CLS/zpCtX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrmhEjpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrmhEjpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F747C4CEF1;
	Tue, 26 Aug 2025 12:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212875;
	bh=3Vgy52usXlO+wjGBWTnRMajgK4EHmxdy6nQKUc9ZIWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrmhEjpISf+UdIZmVEkGQFP9j9FfrdY0eKr7QRPafGiGKv8yVHCP7iNxbcKX7cl0C
	 VPmQvznr3WaQcCZvtl6KeYltkb4w2Q0txX4EcZOl1mbB/c8q8ErKWsNWUPWzg8mheg
	 i37V/MIQ/8PWRtx7shGwr6gRaSpE4f36FEuh4v7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/587] iio: adc: ad7768-1: Ensure SYNC_IN pulse minimum timing requirement
Date: Tue, 26 Aug 2025 13:04:45 +0200
Message-ID: <20250826110956.412863723@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Santos <Jonathan.Santos@analog.com>

[ Upstream commit 7e54d932873d91a55d1b89b7389876d78aeeab32 ]

The SYNC_IN pulse width must be at least 1.5 x Tmclk, corresponding to
~2.5 µs at the lowest supported MCLK frequency. Add a 3 µs delay to
ensure reliable synchronization timing even for the worst-case scenario.

Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/d3ee92a533cd1207cf5c5cc4d7bdbb5c6c267f68.1749063024.git.Jonathan.Santos@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 967f06cd3f94..e147eaf1a3b1 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -203,6 +203,24 @@ static int ad7768_spi_reg_write(struct ad7768_state *st,
 	return spi_write(st->spi, st->data.d8, 2);
 }
 
+static int ad7768_send_sync_pulse(struct ad7768_state *st)
+{
+	/*
+	 * The datasheet specifies a minimum SYNC_IN pulse width of 1.5 × Tmclk,
+	 * where Tmclk is the MCLK period. The supported MCLK frequencies range
+	 * from 0.6 MHz to 17 MHz, which corresponds to a minimum SYNC_IN pulse
+	 * width of approximately 2.5 µs in the worst-case scenario (0.6 MHz).
+	 *
+	 * Add a delay to ensure the pulse width is always sufficient to
+	 * trigger synchronization.
+	 */
+	gpiod_set_value_cansleep(st->gpio_sync_in, 1);
+	fsleep(3);
+	gpiod_set_value_cansleep(st->gpio_sync_in, 0);
+
+	return 0;
+}
+
 static int ad7768_set_mode(struct ad7768_state *st,
 			   enum ad7768_conv_mode mode)
 {
@@ -288,10 +306,7 @@ static int ad7768_set_dig_fil(struct ad7768_state *st,
 		return ret;
 
 	/* A sync-in pulse is required every time the filter dec rate changes */
-	gpiod_set_value(st->gpio_sync_in, 1);
-	gpiod_set_value(st->gpio_sync_in, 0);
-
-	return 0;
+	return ad7768_send_sync_pulse(st);
 }
 
 static int ad7768_set_freq(struct ad7768_state *st,
-- 
2.39.5



