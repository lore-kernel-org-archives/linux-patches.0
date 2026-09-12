Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD431DE4EF;
	Sat, 12 Sep 2026 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221655; cv=none; b=VnWiaJ4HNOVwzW5qBkZq/wTQxE7Wx7xX56aTEQQCdGz8uJlwGsFYL1uEkQ9ugkn1/zwlPMh8HFWB/C0urh7zm39lRNYyfVrlDPO6cRimT89xC9JDqYDFfu6/qSqu4NUeGvEzcJMA5P1pl34kYmg1pBttzjrhYumscnzxow+gjL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221655; c=relaxed/simple;
	bh=75aZb7gADsya4ZBP+E/upm7b6xnk2zd7dlRAvknaZ40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUF5XOqxJwmF5f+GpOODTVe9GPuYOxGSnOJdduFW0J4hEvnxPHmzFq4nJ8+bV8e4K/iORRnBmeKPpjS9LTQBEWrLbPFnJLQGYCMOe7L56URpmDrUvAnnhiiEk9iHNJ7thwlJTxcpQn5vMOT/265fWf4uKFlSDA+oqA5dBdmlSWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J88NowbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J88NowbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5761F000FF;
	Sat, 12 Sep 2026 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221654;
	bh=c0HogfwcCgrjnkXXlh6iblhvCIBRv1ZOLVbQ6fcyXoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J88NowbQHI5VAsW5ZU9dsDsnksU63RG7rVsRO2Qq99idOpq2VQQlP6fllEsXj7YT/
	 eRLNJuLCBEn8QdFO8uSXA+LJp+8t+aHES/uw9soFigQ6bIS3aQt1RejBcMJyf2jKVw
	 d323yLERwdiOahym0wZoikKdec6AzjSxDuKuUY/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0426/1424] iio: light: opt4001: Reject integration times with a non-zero seconds part
Date: Sat, 12 Sep 2026 08:47:38 +0200
Message-ID: <20260912065616.824323462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit d0f21621f8b2b46661ea066d20705dbf7253db87 upstream.

opt4001_write_raw() only looks at val2 when setting the integration
time, so a write such as 1.000600 is silently accepted as 600 us.
Return -EINVAL if val is non-zero.

Fixes: 9a9608418292 ("iio: light: Add support for TI OPT4001 light sensor")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4001.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/light/opt4001.c b/drivers/iio/light/opt4001.c
index 944923cb8f28..2448d6330489 100644
--- a/drivers/iio/light/opt4001.c
+++ b/drivers/iio/light/opt4001.c
@@ -269,6 +269,9 @@ static int opt4001_write_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_INT_TIME:
+		if (val)
+			return -EINVAL;
+
 		int_time = opt4001_als_time_to_index(val2);
 		if (int_time < 0)
 			return int_time;
-- 
2.55.0



