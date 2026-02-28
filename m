Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4224301EE9;
	Sat, 28 Feb 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301411; cv=none; b=GGCMK+WwrkRy0zZjG8SL/+tLrUczkJY9c+YwBm/ZBHTuEnsffHe2PfcxGkfbS0SOt3RZrdrE5gnYP5sonuJ/5Fn8dM/gFWMMxwZfrGSbTkE4BK82ZQoHSAgNiLuZZjdKczoK+0Di8XYdicyWltkZM2SbLYYr6pAkWD2mCFBJLHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301411; c=relaxed/simple;
	bh=5I5i1jjxhUstN2Uv356dakIBSNGCNQhojyelrS41nww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc0wMmjwHywsiuATl4jZ5JSdreLvaBTakeOVT4v4dJPDxCGfcXmu89ZW7KvfO+OxbPYcMsuOtdPz7f9rjOS74+XOKFTTboh+oQfA9MwWoaOtMx4WRed1KH6sewueSAXW/DQ1wZ8K9D3y+c9UHXHSUMKTb8n9qBnL0y4l5pg1diE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJ3j+D7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJ3j+D7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D54CC19423;
	Sat, 28 Feb 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301410;
	bh=5I5i1jjxhUstN2Uv356dakIBSNGCNQhojyelrS41nww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJ3j+D7w7zrXSmER6Akyd0SmPraodQQFqWUymK2wZkxVYl5FwtelZD/NgiKiF2nE8
	 fwsZW37zARZvO9uG8DK7g8XUuxlj5jIcrxSZGxj5NKYKMluXw157IfYxRs6Ac7pcRw
	 dTGQ4qXv2untU1Cs2MdCy/2oVM6lp5+A2K5SkoArYZqT2mdabG/OtscN6ddCY6IG5P
	 kp/3PJLHCFQPIAykAKakTQUq9HxQcrUg4Zn1E8TOSVANu0cS5vjeJQjGVPEmX2fYRA
	 bBwkxIxgUjrVwOxAbE/LCWjt22WMPQX1dXjOgRhZbmlMcjwtgGo4mFiVgK+UAt+MFz
	 Pp4ztzmSnPJAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Francesco Lavra <flavra@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 600/752] iio: accel: adxl380: Avoid reading more entries than present in FIFO
Date: Sat, 28 Feb 2026 12:45:11 -0500
Message-ID: <20260228174750.1542406-600-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit c1b14015224cfcccd5356333763f2f4f401bd810 ]

The interrupt handler reads FIFO entries in batches of N samples, where N
is the number of scan elements that have been enabled. However, the sensor
fills the FIFO one sample at a time, even when more than one channel is
enabled. Therefore,the number of entries reported by the FIFO status
registers may not be a multiple of N; if this number is not a multiple, the
number of entries read from the FIFO may exceed the number of entries
actually present.

To fix the above issue, round down the number of FIFO entries read from the
status registers so that it is always a multiple of N.

Fixes: df36de13677a ("iio: accel: add ADXL380 driver")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl380.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/adxl380.c b/drivers/iio/accel/adxl380.c
index 6d82873357cb8..217c5ae56d23a 100644
--- a/drivers/iio/accel/adxl380.c
+++ b/drivers/iio/accel/adxl380.c
@@ -977,6 +977,7 @@ static irqreturn_t adxl380_irq_handler(int irq, void  *p)
 	if (ret)
 		return IRQ_HANDLED;
 
+	fifo_entries = rounddown(fifo_entries, st->fifo_set_size);
 	for (i = 0; i < fifo_entries; i += st->fifo_set_size) {
 		ret = regmap_noinc_read(st->regmap, ADXL380_FIFO_DATA,
 					&st->fifo_buf[i],
-- 
2.51.0

