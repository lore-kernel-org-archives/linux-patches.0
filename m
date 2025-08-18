Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EE431E115;
	Mon, 18 Aug 2025 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523512; cv=none; b=H2QsfOei+LKC87i2V+y+/uGDVKRAUE3WsfaYWA8r+cWUm0G78T8ror0O4qX93m1s2T+tbPamCg2q1X9YFDmi/+PqvLLuUzUXdGclzc8jK5/8TNyorTfFRSyZj0XZ1cogxBPPqRBZXTxkNkGdvNnvpdv6GUNXc13Ds2oyYq17GtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523512; c=relaxed/simple;
	bh=3jPPzQQ8tKcnJStMw3L8T6sq/D6Ds2Vpv8oHHWp15kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwLlfErXIxyFQIRt2KkDPSRjMuleW+NOMaWEnbybnMzD8k4rR6S81lgw+a618OYp0iHVINeJ/LQT9IQNUSaNtGEWq0g1bPJqQj5qL3xIdd9dUGOUsQd45OH4/khMQ42vIbEj2QJyzlK4NuFzEUaBLXqVxKoRk/RB2+ylM3/rXgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gj5P6du8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gj5P6du8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B688CC4CEF1;
	Mon, 18 Aug 2025 13:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523512;
	bh=3jPPzQQ8tKcnJStMw3L8T6sq/D6Ds2Vpv8oHHWp15kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gj5P6du8qfnNzVH1ZjzXbs5PxsG/YnQvtuJb1oSueC0DSKNq5CwR8dk/EUP0NkC2D
	 hSzDjqSvdza3g8kE++KSG1wKmi1VUYZseIebZsiUc1fOprtWLjZPPtc6dOPkbKS/pF
	 POEjr22yZ3u+8ogEUDuT4UCv9isi/lcs69o3II3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 186/515] iio: adc: ad7768-1: Ensure SYNC_IN pulse minimum timing requirement
Date: Mon, 18 Aug 2025 14:42:52 +0200
Message-ID: <20250818124505.534540802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index 5e0be36af0c5..32063f54f364 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -202,6 +202,24 @@ static int ad7768_spi_reg_write(struct ad7768_state *st,
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
@@ -289,10 +307,7 @@ static int ad7768_set_dig_fil(struct ad7768_state *st,
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



