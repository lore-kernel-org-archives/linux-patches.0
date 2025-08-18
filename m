Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650AA31770C;
	Mon, 18 Aug 2025 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521906; cv=none; b=ssoslzW956zGIPrLjhC4LDaTR5QHzIgWMQCApxRI6qXrYmmEjD0iybonObgXtPQnoODn/7IbnYug32IBUV871Owjd7+H9pWRSToMYCbxDB0hLYR7SkR/wx6gIJS8zpnlazj7lAy3bMgDXKpe9oaFdg1ZUa5Gsy+GaoSppLfi3vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521906; c=relaxed/simple;
	bh=4AQ8yncItJbiXHgvPMnIqHLx7FvQ16Tl9RmUVppsOgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdySTAznhPzBd/mGG7Di0S6zSUWrdK1bnTYxv0Pss8KYs2NmuRahP/08napfboFBtkCS+AVzlErx3P4QObFLCrXl75leAw+IKVnNWypvNPrcJfPL+zi3IMxzNMvmarXz4d1NXfFnFlRdHZjoNm/8A18zfhKI1Ey8yvovajmpcJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXpp5wc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXpp5wc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E89C4CEEB;
	Mon, 18 Aug 2025 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521906;
	bh=4AQ8yncItJbiXHgvPMnIqHLx7FvQ16Tl9RmUVppsOgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXpp5wc9aEKJpnTN/9l8PQkSLr1VexflkvaT4iVl5xmZDmsVZy5d2so4eYTAiKTo3
	 j99aIqk8ZRO+O0CCTwZuDyWFdyNg0BTurAUoxaHYgWbHNo1u3w2iyFfTjXprpO0e84
	 0+kr4iggtrl7CxXrn4D5KAD2Zb3BY5tMztToXCzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/444] iio: adc: ad7768-1: Ensure SYNC_IN pulse minimum timing requirement
Date: Mon, 18 Aug 2025 14:43:04 +0200
Message-ID: <20250818124454.820879320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a9248a85466e..7956948166ab 100644
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



