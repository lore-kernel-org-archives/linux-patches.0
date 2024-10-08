Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D451E00B3;
	Tue,  8 Oct 2024 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394138; cv=none; b=IoPNMXR4XKG0b+4J5XH3GsGhOyj9bRJ58QNN13xiQXVvqKuNnHLeA0z/0BhmdULDWBX1r9DuDWTgZCuy5HB/ZcbzoH1YI3uiyBrX5jBQdhGTzV+hvOKAojuha9HxiPjosKQZJhD51uA/D4xWqRN/sPK/PKSRFSBWuOVWqryGk78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394138; c=relaxed/simple;
	bh=tO5v7ZIZGm4fXhuyYewtAfLQqeJgVEGtLFry/RK3oDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEKPz6cI5T8bbrZizvI5HYqN9mDy9yPOSNsZrwn3IDZ7SlfeKvdLAbu5N8b05yMaE4sketVsduVW5+aGsFrbVb0US/SmkkXXBktXtKL+4sbMmRmgIuWHrYFQNjiI/q09FIZta3cqpCyLzeZhXlMA2LTp5h+3PEIFLyAwlcJ7Sx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLWDbsGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLWDbsGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBFBC4CECD;
	Tue,  8 Oct 2024 13:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394138;
	bh=tO5v7ZIZGm4fXhuyYewtAfLQqeJgVEGtLFry/RK3oDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLWDbsGay1yOErLY/0GDekfOn2bA3y8PtAP4U2+ed9h1SpjIzFt+S+gGNDp/iwFkN
	 RAu/G9iHKP3KfGCdU9cZXvWPWPj7hiCwSYc9WBxzWYaM9wrcYckYGkSg1oKGiUwcmT
	 s/qHuna/fKOE/193R/0w2M0+yIm84hYlUHF5/b0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 357/386] iio: pressure: bmp280: Fix waiting time for BMP3xx configuration
Date: Tue,  8 Oct 2024 14:10:02 +0200
Message-ID: <20241008115643.432495376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 3ba718b11c464..84f6b333c9195 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1203,10 +1203,11 @@ static int bmp380_chip_config(struct bmp280_data *data)
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



