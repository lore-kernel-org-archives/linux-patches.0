Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BC431CA50;
	Mon, 27 Oct 2025 18:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591073; cv=none; b=Otv6rYMhRy2saAt7gYYwugZCGDMQV5G7AwOZbkoVz48xBGRSH5VPsyfLO/u1Ee2/jVC9AgGRgJLsQxobKhQjPkLMNp4qRtVOfAQsWSeRHNqh/HRqneUEIPboo7dbtUSb5IiFjqVHlQV5qcFbuZ7zhxpXYHbjpi4gEiFXJJm+e4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591073; c=relaxed/simple;
	bh=DX/b80VgWK5zhTMV/YDqtxBnJGYOQsIBvhUIxtHaSlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nytJgJKILNQouB18bwtMvUCvJGwXkyFWF7xstCCmG933QZFoNaWN8W+ESxSclYMFxJqorlMUAi7vjanspzRCaskuiV7KJX8BgHvkqoPzKtj72u8BI1izQmhjbW1rDBCNn/bmVVOxJidwQA1UvNDvU0QC/AT7Ny7Dm/yDbUm6NaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8GQrG31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8GQrG31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6E6C4CEF1;
	Mon, 27 Oct 2025 18:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591073;
	bh=DX/b80VgWK5zhTMV/YDqtxBnJGYOQsIBvhUIxtHaSlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8GQrG31jnybjHQQsG83HFvPi4WA8kE/09ekWe7lsEsjkVMjsYkAgqoy9RI/1YjgU
	 2tKgPNP9SllfG/juK2qNpDc0GyUIWsKMe3CvR2QrEO+oFiC+0AsD/sFuiT0FG87uWn
	 cFc9buRFv0CA7K2kWa59CUJljyGYf8Uu5HFpfA20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/332] iio: consumers: Fix offset handling in iio_convert_raw_to_processed()
Date: Mon, 27 Oct 2025 19:31:50 +0100
Message-ID: <20251027183526.124466605@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 03581a3487751..ae85cf4c05278 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -600,7 +600,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		 * If no channel scaling is available apply consumer scale to
 		 * raw value and return.
 		 */
-		*processed = raw * scale;
+		*processed = raw64 * scale;
 		return 0;
 	}
 
-- 
2.51.0



