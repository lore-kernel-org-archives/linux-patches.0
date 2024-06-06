Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31D11BBBC4;
	Thu,  6 Jun 2024 14:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683493; cv=none; b=gPOVIB+5Ebl0YOURf9O3QcfpPtW13N5/sgWt5cayiCKBuIMz4G5H7XxNSYlBzqVCI+rPCH+XOlwEynLnRv7/8pSFmWwuY/d7dx93dX8I57JXWzHZGGki6Qkhyql1xSZACdkDpNcWcQHigS9+NGnHjiZV7CAF5A4pCs01U762Yhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683493; c=relaxed/simple;
	bh=talaWayOweaTyY744o++qJfH/rAEgM/cXtexHEVnwNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBbN+uoiSCrBajPCKr2Td/bFN450RXI5pezu4evKY8YJR9ImkvPL0BX0RUcZI3HcARBJ2+v/U9cnMnovMtw6+yMOgr5LXLtIfDvi0eD5225Dz/bnI8tkkhusSiOy6hMl3Ch4MOsy2wT5JTxz2Rn/OiJC5Wmaw85egUJ6P6RfUDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZMNKQ9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZMNKQ9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B5CC2BD10;
	Thu,  6 Jun 2024 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683493;
	bh=talaWayOweaTyY744o++qJfH/rAEgM/cXtexHEVnwNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZMNKQ9C/L21fiWH5lIu+w01dZiDC5FanrbKL4hba4sZmBLSg1DW6ymHryVh2eXpX
	 whpQjdgPazGsy40/46Rh02usp9/7WTuiDBGUNqgiiMJmzI13sm7v7r4Ovaxgh+AnOt
	 l1Ngj5/KDY7TS2QDbljDrixCFrsTxdspp5Bv+zTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 436/744] iio: adc: stm32: Fixing err code to not indicate success
Date: Thu,  6 Jun 2024 16:01:48 +0200
Message-ID: <20240606131746.462391981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 3735ca0b072656c3aa2cedc617a5e639b583a472 ]

This path would result in returning 0 / success on an error path.

Cc: Olivier Moysan <olivier.moysan@foss.st.com>
Fixes: 95bc818404b2 ("iio: adc: stm32-adc: add support of generic channels binding")
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20240330185305.1319844-4-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stm32-adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/stm32-adc.c b/drivers/iio/adc/stm32-adc.c
index f7613efb870d5..0b3e487440a66 100644
--- a/drivers/iio/adc/stm32-adc.c
+++ b/drivers/iio/adc/stm32-adc.c
@@ -2234,6 +2234,7 @@ static int stm32_adc_generic_chan_init(struct iio_dev *indio_dev,
 			if (vin[0] != val || vin[1] >= adc_info->max_channels) {
 				dev_err(&indio_dev->dev, "Invalid channel in%d-in%d\n",
 					vin[0], vin[1]);
+				ret = -EINVAL;
 				goto err;
 			}
 		} else if (ret != -EINVAL) {
-- 
2.43.0



