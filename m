Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D277221FC3;
	Tue, 26 Aug 2025 11:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207732; cv=none; b=X//ROV7Y79AL1/bKk9L+70avj1htdSCzweTLCK9gLb5V1BzVbzJ1tuYz/AGw8Rlf5hQhnsIM8SHGTAMKOiHy25HfjIXeimrGL8nmyRuPIyH7zpDJxATjc0SW/eyVDwCMNBo8FMHQZkZGjh5x6giijGduHSv2Ob2AcYUhYBjwH8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207732; c=relaxed/simple;
	bh=ne4GpHa9o/aqFxwP+UIxUfqDzOBB53gKaaGcfK6uP5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqMItFoVQKxT13QnZ9rfhgyEZmhgLe3+1VH74iLoAOTHwnvdS+a40/tXb7suJ5QMmagbE0puOaJR1Ray7A5VCd4ir7XZpyjlEOZJwBy80MQj+EqU48jGiVGkualHupmgsJarfIWepPiJaPQySLQhoI9Wx2csas2HckF/SrweH/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKt5pajH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKt5pajH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFACBC4CEF1;
	Tue, 26 Aug 2025 11:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207732;
	bh=ne4GpHa9o/aqFxwP+UIxUfqDzOBB53gKaaGcfK6uP5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKt5pajH8IeQhgRRsMp1S4hXa68iUPsOVV4UZyiRwuMlS3US82SsMVuG9Xtz257fd
	 70kACkZEbXt2ZKQjOnu0em8ZSA317Dau/rWr/9k6Vg67nuED8njUp5Oz5cMJRrNHBe
	 ICvEgekVKAdqGmzXPNy00G01ignpb5EsDWKOggWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 296/457] iio: accel: sca3300: fix uninitialized iio scan data
Date: Tue, 26 Aug 2025 13:09:40 +0200
Message-ID: <20250826110944.694735478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 4e5b705cc6147f0b9173c6219079f41416bdd3c0 upstream.

Fix potential leak of uninitialized stack data to userspace by ensuring
that the `channels` array is zeroed before use.

Fixes: edeb67fbbf4b ("iio: accel: sca3300: use IIO_DECLARE_BUFFER_WITH_TS")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250723-iio-accel-sca3300-fix-uninitialized-iio-scan-data-v1-1-12dbfb3307b7@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/sca3300.c
+++ b/drivers/iio/accel/sca3300.c
@@ -479,7 +479,7 @@ static irqreturn_t sca3300_trigger_handl
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct sca3300_data *data = iio_priv(indio_dev);
 	int bit, ret, val, i = 0;
-	IIO_DECLARE_BUFFER_WITH_TS(s16, channels, SCA3300_SCAN_MAX);
+	IIO_DECLARE_BUFFER_WITH_TS(s16, channels, SCA3300_SCAN_MAX) = { };
 
 	iio_for_each_active_channel(indio_dev, bit) {
 		ret = sca3300_read_reg(data, indio_dev->channels[bit].address, &val);


