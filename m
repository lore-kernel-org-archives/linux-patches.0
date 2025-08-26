Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84DA3451DE;
	Tue, 26 Aug 2025 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216239; cv=none; b=Wtk3MZaAOD6ftkm+IclqxV8rp1DP1R1lOqEl5Qz0aBy1A4sj0matZyxZKWj3Nfw/xLcMolula4+3z1HXNIP9Hwu/8o9tXLBuMT6Z86AftdQklXg5iry83uFJx3KYJsawClfwkDURnQ0FjTRxsYpA//EG9nQLY7Fy3RwzbLO+VRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216239; c=relaxed/simple;
	bh=rYDkvvLaocvHgIfOG1ku6PAQ09QPljNUMshHYREUhBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsD04EHll2oB14mnoDx6CwwnJPXxB7WaaGB9yLc670LVKDQDH//3AGKnmJEUuY+yWxFcZhe0MO51pye3VKvSf198OLdwfnBzhBOKuHCK7Cb/0qiYVk8yhZajig9WFpmhy+2tQigTQWjFgMpDnsqi5+LWHBfonRKg5Z2Jjtp/wB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scVhB0QV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scVhB0QV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D94C4CEF1;
	Tue, 26 Aug 2025 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216239;
	bh=rYDkvvLaocvHgIfOG1ku6PAQ09QPljNUMshHYREUhBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scVhB0QVkpOj+OPE88zCSJGjJ52pkPz+Eb5fom+zwKlVjqNdk0OPzNaxngaP0sSE+
	 QIvZKCAHaJyu/INmp81PUYv/E0Cxbo7UaXjjchSGssFE6lAzjFGuvA/D79Lqek3Tmt
	 arI6o8ahfwb4jzys2MjXDyWzVHJzh1tB0o5GX+B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/644] iio: adc: ad7768-1: Ensure SYNC_IN pulse minimum timing requirement
Date: Tue, 26 Aug 2025 13:07:06 +0200
Message-ID: <20250826110954.690200631@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e240fac8b6b3..c518aeb35c70 100644
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



