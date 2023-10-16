Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849CB19465
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7WbVom4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68211C433C8;
	Mon, 16 Oct 2023 08:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446159;
	bh=sN4LaBx+uVWuWRvBUGQ4o4NvCDB+QURU76RYTP0yumM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7WbVom4DgMuurYTtfC5Ijf9HgBqLISwkCvP6Ql8HRue3QhhER7u7ahyLuvBrvvo1
	 cq2Sj8AFgUlSRx+5nKRsGpU/rgM3m6H/aOgyqV2MKKfHNobr0CLS0VTLw561yXZw4P
	 q6fs5nuxrmLY6no2M0y/ys6lUYabc4OMmfJL1Mr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Zangerl <az@breathe-safe.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 057/102] iio: pressure: ms5611: ms5611_prom_is_valid false negative bug
Date: Mon, 16 Oct 2023 10:40:56 +0200
Message-ID: <20231016083955.219725433@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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


