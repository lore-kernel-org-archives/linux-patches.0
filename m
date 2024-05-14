Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDC555C36;
	Tue, 14 May 2024 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687451; cv=none; b=NjXu05rsV9KKKlE5s/P8cOvRnHu7zW9SQB0yjA6B5sdmN3+6+2dHuZs5Rfg7fVttFK8mZPZEdKJ+xCwrR1ruGABQkbEYR1mpPEPyvIisly6XxyEArJCiBrz12LylhlgMQSjFaiZpDXI7peWtY9RhXKmEICcOts9gR02PpDpJ+AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687451; c=relaxed/simple;
	bh=1G6SxY+EPyMWxYHHmR73ewugtN+wXYTISG2TpPyWCwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/OPS4JfQOmDEKmLyP+HLR0h0lQ195AsyvjZr2FB1mweZ8kSOqNHa4nj7RjAn3f6ChmGd/6pAXn/W/coWL1KaHPv0oD4OwD2NVTOhU08ZhewAte55NzDKgb+DKdk4dQu8VVLKEnAtl+95G2IZkBo0x9iPnakHR3CHPyWlIM+BsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAAcU8H5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAAcU8H5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60F5C2BD10;
	Tue, 14 May 2024 11:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687451;
	bh=1G6SxY+EPyMWxYHHmR73ewugtN+wXYTISG2TpPyWCwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAAcU8H5Xbsqa+9oLcP4r8z2jhcmmZB4IB61/Fw4dUssZowW77xrDsYMLOGkjSBW0
	 8y+aATp91HcC0Lb0FtMXl0+WN2LhDnbdG9BEW1Sv8z+jrEqXjZA2cw/3puUZId9Kdd
	 08ATRZ1/bYfMGru3fAZfkBS8DxRsWVjY6UesX158=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramona Gradinariu <ramona.bolboaca13@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 101/111] iio:imu: adis16475: Fix sync mode setting
Date: Tue, 14 May 2024 12:20:39 +0200
Message-ID: <20240514101000.969428319@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramona Gradinariu <ramona.bolboaca13@gmail.com>

commit 74a72baf204fd509bbe8b53eec35e39869d94341 upstream.

Fix sync mode setting by applying the necessary shift bits.

Fixes: fff7352bf7a3 ("iio: imu: Add support for adis16475")
Signed-off-by: Ramona Gradinariu <ramona.bolboaca13@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240405045309.816328-2-ramona.bolboaca13@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16475.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -1070,6 +1070,7 @@ static int adis16475_config_sync_mode(st
 	struct device *dev = &st->adis.spi->dev;
 	const struct adis16475_sync *sync;
 	u32 sync_mode;
+	u16 val;
 
 	/* default to internal clk */
 	st->clk_freq = st->info->int_clk * 1000;
@@ -1155,8 +1156,9 @@ static int adis16475_config_sync_mode(st
 	 * I'm keeping this for simplicity and avoiding extra variables
 	 * in chip_info.
 	 */
+	val = ADIS16475_SYNC_MODE(sync->sync_mode);
 	ret = __adis_update_bits(&st->adis, ADIS16475_REG_MSG_CTRL,
-				 ADIS16475_SYNC_MODE_MASK, sync->sync_mode);
+				 ADIS16475_SYNC_MODE_MASK, val);
 	if (ret)
 		return ret;
 


