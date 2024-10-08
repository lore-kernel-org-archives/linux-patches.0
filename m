Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3BD1779B1;
	Tue,  8 Oct 2024 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391092; cv=none; b=hxL3cB/w0I+uox/DJAiueDmcVid5c6nuRXqgZYncdiKnzZSMn4mhZIfIG+457VnZiqqFgbE8R/Pol3prbYPMRnCNnCi4UDKlSXDOm/Eo9+SB4U/VoGd/bnhg7w8S0IAqwIUD0cr7xqJldXuO6S88GN/bcikfUFbruVzRoYboeic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391092; c=relaxed/simple;
	bh=HkwZBK9bsdXcp1RPaoOq1iorZYo9dPJmbT/kquOkDOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9RDC514g5MA2pGT9WIrZYaPEbaT8YGu2nF+iYS79GXuGCxDhQt27U12a/HAvBlO1mbWQOdVltr5WbI6ntjf4D9OQYLPpBqwGhvb4k+hxCThlp3NY3bhRxkz+5t9VIoe8RyNZ02lOZWYua0nGGumpg1K1gWEnwYZ6AO5vmEhcQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivl6Jk2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivl6Jk2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1E3C4CECC;
	Tue,  8 Oct 2024 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391092;
	bh=HkwZBK9bsdXcp1RPaoOq1iorZYo9dPJmbT/kquOkDOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivl6Jk2fT5pg2IAcHZfBfCOGI5W4bV7O2U/ZKRq8KHEThKCM6TPtaOI2hnyxbs5p9
	 eKzW9bTv+x+H4XveveKoFOgBldBuSz+0BaWoXnQM0lPqQQzYTJYErwSzeKTqukJhil
	 2mTNgc0KdeSvO0Dpf3qCeegW208DmVAld6ZFqAio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 468/482] iio: pressure: bmp280: Fix waiting time for BMP3xx configuration
Date: Tue,  8 Oct 2024 14:08:51 +0200
Message-ID: <20241008115706.930103069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

[ Upstream commit 262a6634bcc4f0c1c53d13aa89882909f281a6aa ]

According to the datasheet, both pressure and temperature can go up to
oversampling x32. With this option, the maximum measurement time is not
80ms (this is for press x32 and temp x2), but it is 130ms nominal
(calculated from table 3.9.2) and since most of the maximum values
are around +15%, it is configured to 150ms.

Fixes: 8d329309184d ("iio: pressure: bmp280: Add support for BMP380 sensor family")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://patch.msgid.link/20240711211558.106327-3-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index 55ea708489b66..1549f361a473f 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1204,10 +1204,11 @@ static int bmp380_chip_config(struct bmp280_data *data)
 		}
 		/*
 		 * Waits for measurement before checking configuration error
-		 * flag. Selected longest measure time indicated in
-		 * section 3.9.1 in the datasheet.
+		 * flag. Selected longest measurement time, calculated from
+		 * formula in datasheet section 3.9.2 with an offset of ~+15%
+		 * as it seen as well in table 3.9.1.
 		 */
-		msleep(80);
+		msleep(150);
 
 		/* Check config error flag */
 		ret = regmap_read(data->regmap, BMP380_REG_ERROR, &tmp);
-- 
2.43.0



