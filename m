Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB4830BBB8;
	Mon, 13 Oct 2025 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369728; cv=none; b=j9rp9XRdv0L494k/8MCcqQ4L8FS4addJ58kFqV0zB6PTONorBjec0xpAHyVHjhmkaBxxtytVqK2coCqW4/48ab+R7xqaOAdCRJFMxKJ35N3Xh9CBC1xvdZkIxPdh7Uc9s8/gqhFf625KelpiqG8WYJRJqU7N0m5jQ6W2LD0VhNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369728; c=relaxed/simple;
	bh=Gpx+inrrEAfbOS782MauGVd07NsCHSuArX2AQrBgaTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdCmFr1wgimCndy2dtkT1SzZudzT0jACfoOO5R/PEFhr6i96tOoga6XCmnkkKK6dr6Q5zzbxEyowkNtjI/cZkFU/Tx4bJ0PYdrErUCdXBr1BiOG6ONh2yon9d3kArKBrQa6zIY4t4NAmxKJmJqJbYs9dxCEzd3R5eC3XcWe2tq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpLMhAVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpLMhAVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599DCC4CEE7;
	Mon, 13 Oct 2025 15:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369728;
	bh=Gpx+inrrEAfbOS782MauGVd07NsCHSuArX2AQrBgaTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpLMhAVnIHL9Jbk/x+WV4JAtHlN35TVAk1t9vNGXyjLdue5B2CG4+0/sptLd35Iiw
	 YxSMlxykX+4AZWv61SgBci8Araux2FtVZHzC0c9FUk2Bxvp/0pHwkdrUELfZxwWMXl
	 SOHGv4Cj19EfV+L78PATmyl4YFPn+FEbGdChhI9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 341/563] iio: consumers: Fix offset handling in iio_convert_raw_to_processed()
Date: Mon, 13 Oct 2025 16:43:22 +0200
Message-ID: <20251013144423.622567381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 33f5c69c4daff39c010b3ea6da8ebab285f4277b ]

Fix iio_convert_raw_to_processed() offset handling for channels without
a scale attribute.

The offset has been applied to the raw64 value not to the original raw
value. Use the raw64 value so that the offset is taken into account.

Fixes: 14b457fdde38 ("iio: inkern: apply consumer scale when no channel scale is available")
Cc: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250831104825.15097-3-hansg@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index d36a80a7b8a93..642beb4b3360d 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -640,7 +640,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		 * If no channel scaling is available apply consumer scale to
 		 * raw value and return.
 		 */
-		*processed = raw * scale;
+		*processed = raw64 * scale;
 		return 0;
 	}
 
-- 
2.51.0



