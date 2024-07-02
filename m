Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F915218A;
	Tue,  2 Jul 2024 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940970; cv=none; b=DNl4T8ukJmESsTfW5jQlStRUXcfCYvBovEGsWA0PjL+4kzxr7zrIJjkBtP/jxynOWH7dm+0yomxopAhlhbHQn7zIX4OrPFQjJ995qWuOrz6bPxUW+4fvngAhmrdC2HpGGezXLlA0BuVj8E9bSuUdwuGsHI6snX7C7gIvt8xxhbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940970; c=relaxed/simple;
	bh=nLcQdP7YjK8UaiXVjiCFKgCjYRGe3bd2ofxMHXauCqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJJPzappLA8gMsrBgQ5dPUADLnxJtPf25lr6ZRXsAo/tRyW0r7HqGMDQYRM110yUmcRQyqTbkyyyEsc4tQ8JfJK7Sf+2k3POsMeem6lKV/dmVuNnFeofmsblUsdYmPANnm6R6K92RCRKQ30D9QU8YzdFxcg7XkEG0lUNlb3jeuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YySvBuNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YySvBuNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0FAC116B1;
	Tue,  2 Jul 2024 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940970;
	bh=nLcQdP7YjK8UaiXVjiCFKgCjYRGe3bd2ofxMHXauCqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YySvBuNWuXORTBysGaa/2tznKuI/rrAR+5uRkATuG3BTD9l6vv8L6JHre9Sino/cu
	 P4QfPociDNKHwE5gIsnD9nbaQ2smxBaEbxzSxukwZHOqZ4GysGgb8L5JTdQZjruenv
	 0fVZhgQnwbAO1Xw2jmsgD8FrHaFQdkwf7FQTLX/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/163] iio: xilinx-ams: Dont include ams_ctrl_channels in scan_mask
Date: Tue,  2 Jul 2024 19:03:24 +0200
Message-ID: <20240702170236.468812653@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 89b898c627a49b978a4c323ea6856eacfc21f6ba ]

ams_enable_channel_sequence constructs a "scan_mask" for all the PS and
PL channels. This works out fine, since scan_index for these channels is
less than 64. However, it also includes the ams_ctrl_channels, where
scan_index is greater than 64, triggering undefined behavior. Since we
don't need these channels anyway, just exclude them.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://lore.kernel.org/r/20240311162800.11074-1-sean.anderson@linux.dev
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-ams.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index f0b71a1220e02..f52abf759260f 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -414,8 +414,12 @@ static void ams_enable_channel_sequence(struct iio_dev *indio_dev)
 
 	/* Run calibration of PS & PL as part of the sequence */
 	scan_mask = BIT(0) | BIT(AMS_PS_SEQ_MAX);
-	for (i = 0; i < indio_dev->num_channels; i++)
-		scan_mask |= BIT_ULL(indio_dev->channels[i].scan_index);
+	for (i = 0; i < indio_dev->num_channels; i++) {
+		const struct iio_chan_spec *chan = &indio_dev->channels[i];
+
+		if (chan->scan_index < AMS_CTRL_SEQ_BASE)
+			scan_mask |= BIT_ULL(chan->scan_index);
+	}
 
 	if (ams->ps_base) {
 		/* put sysmon in a soft reset to change the sequence */
-- 
2.43.0



