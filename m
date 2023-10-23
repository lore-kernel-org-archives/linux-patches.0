Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A15915EA7
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ja2/nXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FD5C433CB;
	Mon, 23 Oct 2023 11:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061501;
	bh=6nb3abyDVNvK4jcZiQWjq9FE8otC6BS++dJrlCol/ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ja2/nXeNArZ603zmTVlURc5FGHPY0z2P1OhqItzG6A6yB6JzSCY0eCD/zfs0wB6o
	 Uthx9rXao/k83aIOy55dvBUK62ulBroCMi1XuTgEbKHhBGlTvwbH4eAh3nw8m4xzJz
	 QQyTj8i/BFz5mPHxo8P0Op4j3BC8JvLUl5agsMCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Zangerl <az@breathe-safe.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 041/202] iio: pressure: ms5611: ms5611_prom_is_valid false negative bug
Date: Mon, 23 Oct 2023 12:55:48 +0200
Message-ID: <20231023104827.787119061@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

From: Alexander Zangerl <az@breathe-safe.com>

commit fd39d9668f2ce9f4b05ad55e8c8d80c098073e0b upstream.

The ms5611 driver falsely rejects lots of MS5607-02BA03-50 chips
with "PROM integrity check failed" because it doesn't accept a prom crc
value of zero as legitimate.

According to the datasheet for this chip (and the manufacturer's
application note about the PROM CRC), none of the possible values for the
CRC are excluded - but the current code in ms5611_prom_is_valid() ends with

return crc_orig != 0x0000 && crc == crc_orig

Discussed with the driver author (Tomasz Duszynski) and he indicated that
at that time (2015) he was dealing with some faulty chip samples which
returned blank data under some circumstances and/or followed example code
which indicated CRC zero being bad.

As far as I can tell this exception should not be applied anymore; We've
got a few hundred custom boards here with this chip where large numbers
of the prom have a legitimate CRC value 0, and do work fine, but which the
current driver code wrongly rejects.

Signed-off-by: Alexander Zangerl <az@breathe-safe.com>
Fixes: c0644160a8b5 ("iio: pressure: add support for MS5611 pressure and temperature sensor")
Link: https://lore.kernel.org/r/2535-1695168070.831792@Ze3y.dhYT.s3fx
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/ms5611_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/ms5611_core.c
+++ b/drivers/iio/pressure/ms5611_core.c
@@ -76,7 +76,7 @@ static bool ms5611_prom_is_valid(u16 *pr
 
 	crc = (crc >> 12) & 0x000F;
 
-	return crc_orig != 0x0000 && crc == crc_orig;
+	return crc == crc_orig;
 }
 
 static int ms5611_read_prom(struct iio_dev *indio_dev)


