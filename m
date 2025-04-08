Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28B02690FB;
	Tue,  8 Apr 2025 11:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111493; cv=none; b=oqMbcuov++ZzgbsYPkr7j7giPqbEZ29HgrxDJDm/9XLe3RztdhCd/ZkKJuu/GbC9rfQzQLRFS9+lvN+cZyNyP30vAcuLDzqPDGcIsMFIbLF9vJMjq+jyJYbPW9PmWGkR/lGE7N8EeyJQHJNM704rpbM3RYSsH1pq4n6PaKpui34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111493; c=relaxed/simple;
	bh=uaGGJXQiR31qpE6ifimTnIu7BUnIv7TSlhkRdCWZ+Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iv252dktJbfKG1vlHvmK66MKaM3hemRyUpdUVyO6T37q1krfBnaPTDIVzzY5RMoAURn3psZ2JcqbYsRAJhR9QZoZ1IoxkONfvxbr+Z4uSlA0w2xccETmUyVnCAgDI6qgz5zAfnfw53SHfSOGvRzT81gKj4nP4EVlTtxs79In6Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpzD85Ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpzD85Ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC3FC4CEE7;
	Tue,  8 Apr 2025 11:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111493;
	bh=uaGGJXQiR31qpE6ifimTnIu7BUnIv7TSlhkRdCWZ+Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpzD85NsQbhLXI5tUNE3OG3RQ6PYYydzzjW+/1ZPCchXcKTpYF3h9xqN78puuCACk
	 L9v9COln8QAilXwtxqr9U9aDOJyCUc2PbWQk23/paF3o5CN95e78axKANcwfJxu+KF
	 zMBl5jmsCS/Hq2/UFxcaxrLHwxtnLA/BXk3x+ylc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 451/731] iio: adc: ad7124: Really disable all channels at probe time
Date: Tue,  8 Apr 2025 12:45:48 +0200
Message-ID: <20250408104924.770055971@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit e903868b4ce73d1ba3663d5e0718424946cebd99 ]

If one or more of the 16 channels are enabled and the driver is not
aware of that, unexpected things happen because different channels are
used than intended. To prevent that, all channels should be disabled at
probe time. In Commit 4be339af334c ("iio: adc: ad7124: Disable all
channels at probe time") I intended do that, however only the channels
that are potentially used by the driver and not all channels are
disabled since then. So disable all 16 channels and not only the used
ones.

Also fix the same issue in the .disable_all() callback.

Fixes: 4be339af334c ("iio: adc: ad7124: Disable all channels at probe time")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250204115023.265813-2-u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 2fdeb32479522..6bc418d388202 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -550,11 +550,10 @@ static int ad7124_disable_one(struct ad_sigma_delta *sd, unsigned int chan)
 
 static int ad7124_disable_all(struct ad_sigma_delta *sd)
 {
-	struct ad7124_state *st = container_of(sd, struct ad7124_state, sd);
 	int ret;
 	int i;
 
-	for (i = 0; i < st->num_channels; i++) {
+	for (i = 0; i < 16; i++) {
 		ret = ad7124_disable_one(sd, i);
 		if (ret < 0)
 			return ret;
@@ -1017,11 +1016,10 @@ static int ad7124_setup(struct ad7124_state *st)
 		 * set all channels to this default value.
 		 */
 		ad7124_set_channel_odr(st, i, 10);
-
-		/* Disable all channels to prevent unintended conversions. */
-		ad_sd_write_reg(&st->sd, AD7124_CHANNEL(i), 2, 0);
 	}
 
+	ad7124_disable_all(&st->sd);
+
 	ret = ad_sd_write_reg(&st->sd, AD7124_ADC_CONTROL, 2, st->adc_control);
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "Failed to setup CONTROL register\n");
-- 
2.39.5



