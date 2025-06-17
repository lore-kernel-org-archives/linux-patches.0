Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFC11E502;
	Tue, 17 Jun 2025 16:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178712; cv=none; b=NxWueHP3KsvRWgd1EpfbY1860CzaSGZlcets/hBmyPx9iUASKuMjv4iG1U5Iyg2GvFpvm6By/X6hocV9c84NKQdi8vQZ7WCOKfYvT5fTbQb48VBeKdmP0u+cArKX3GDpzd2Z1nR/bbisacWRTA0qCUYwySbTQm8y2z+BzCXWpCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178712; c=relaxed/simple;
	bh=daZDzXn+/UPqsNth3XVQBteyxsS06cQkeR+R14UUHLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FtNQk2jFxUVxQFxWwGJCk0Dy+Wmwqd6yhbASmU9K+8J91nr+NrQ2ey0CwSUQzK/x3FV/kMoMOxED8xvqU5v2LBBnBCNVokmmbGzsIkTXXrqQA/ci0NV9aXsC6KPVVsr/wFBE6VH7dFr74gLokqv6nZN3aGuRAabkyaF0o7p9ayg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB3qHLO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB3qHLO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A558C4CEE3;
	Tue, 17 Jun 2025 16:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178711;
	bh=daZDzXn+/UPqsNth3XVQBteyxsS06cQkeR+R14UUHLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uB3qHLO+wf1HJvZiefEZl3MinanZYeEhtlnBYHc7lAeEFx8jj6A3gJWFQvp4lvepx
	 TBH4Pxfuo+UZ2HQ5G1YT0llawg8u2ahqZ4ZhQWbKkDBrbEaQagQvqFVtQSyzAUT29d
	 y144py/Smbj8eVAExng6cmhuyMPtnp7DZoof/KKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 530/780] iio: dac: adi-axi-dac: fix bus read
Date: Tue, 17 Jun 2025 17:23:58 +0200
Message-ID: <20250617152513.097656788@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit 921fece3268c3bf2e8c20dd17ff9e5454fa16fda ]

Fix bus read function.

Testing the driver, on a random basis, wrong reads was detected, mainly
by a wrong DAC chip ID read at first boot.
Before reading the expected value from the AXI regmap, need always to
wait for busy flag to be cleared.

Fixes: e61d7178429a ("iio: dac: adi-axi-dac: extend features")
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250409-ad3552r-fix-bus-read-v2-1-34d3b21e8ca0@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/adi-axi-dac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/dac/adi-axi-dac.c b/drivers/iio/dac/adi-axi-dac.c
index 892d770aec69c..05b374e137d35 100644
--- a/drivers/iio/dac/adi-axi-dac.c
+++ b/drivers/iio/dac/adi-axi-dac.c
@@ -707,6 +707,7 @@ static int axi_dac_bus_reg_read(struct iio_backend *back, u32 reg, u32 *val,
 {
 	struct axi_dac_state *st = iio_backend_get_priv(back);
 	int ret;
+	u32 ival;
 
 	guard(mutex)(&st->lock);
 
@@ -719,6 +720,13 @@ static int axi_dac_bus_reg_read(struct iio_backend *back, u32 reg, u32 *val,
 	if (ret)
 		return ret;
 
+	ret = regmap_read_poll_timeout(st->regmap,
+				AXI_DAC_UI_STATUS_REG, ival,
+				FIELD_GET(AXI_DAC_UI_STATUS_IF_BUSY, ival) == 0,
+				10, 100 * KILO);
+	if (ret)
+		return ret;
+
 	return regmap_read(st->regmap, AXI_DAC_CUSTOM_RD_REG, val);
 }
 
-- 
2.39.5



