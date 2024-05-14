Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BAAF9D4;
	Tue, 14 May 2024 11:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687925; cv=none; b=SPzfHZV1hV9eBX1S9OmMLcNWnEklyIZdFamrJbdPDvFKhn8LX8ABf6Jh1QEzNqzowNC5DAKH50hwCTQa8AaKVEH/wlm+ZEqTP5XhlHqJ0F+olCf8ubAKxxiPOU4tP0IEmrFgYVpA8Ta7F58ShX31PPq5Mbjxf0TgB5wYOJ/N9Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687925; c=relaxed/simple;
	bh=oAzSFAPZc4nX03Ua+l3YVubsjl0/2Q3V/qQIQqzscEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh84jd/heRSWbEo/uTyX9bcm2DUZSBSFObP2dRdcutI8AESSr2VWSFBHbTitiVeafCeVFnGLS/6xm8ZZY+csC3+jXsPNasWNLUEgUyPxak2gBYTHhMntUc48AKoevs+vPs5vZJCnjSDzfaetErXbnAhDWzkFx3NpayTW4Pbb2yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2/1LfnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2/1LfnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FA1C2BD10;
	Tue, 14 May 2024 11:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687925;
	bh=oAzSFAPZc4nX03Ua+l3YVubsjl0/2Q3V/qQIQqzscEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2/1LfnIDY2kgzhDgmTbmMMcXPVkV7xQ8rCb/+OhuaTZurCKTxl+6BIA2HQnGKkmA
	 U9EwF0uRVj3wUtgEBETeGe5hSm7n+N9Fjn6TE52WIS9Kro0BKgH7pNo2JBT6ilIaim
	 77jl7bRoBCDQ5THJ+0c6HurJ9MpJzJHPpWs/IsKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramona Gradinariu <ramona.bolboaca13@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 153/168] iio:imu: adis16475: Fix sync mode setting
Date: Tue, 14 May 2024 12:20:51 +0200
Message-ID: <20240514101012.535485742@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1145,6 +1145,7 @@ static int adis16475_config_sync_mode(st
 	struct device *dev = &st->adis.spi->dev;
 	const struct adis16475_sync *sync;
 	u32 sync_mode;
+	u16 val;
 
 	/* default to internal clk */
 	st->clk_freq = st->info->int_clk * 1000;
@@ -1214,8 +1215,9 @@ static int adis16475_config_sync_mode(st
 	 * I'm keeping this for simplicity and avoiding extra variables
 	 * in chip_info.
 	 */
+	val = ADIS16475_SYNC_MODE(sync->sync_mode);
 	ret = __adis_update_bits(&st->adis, ADIS16475_REG_MSG_CTRL,
-				 ADIS16475_SYNC_MODE_MASK, sync->sync_mode);
+				 ADIS16475_SYNC_MODE_MASK, val);
 	if (ret)
 		return ret;
 


