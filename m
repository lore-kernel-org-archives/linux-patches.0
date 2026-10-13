Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA7D1A0B0E;
	Tue, 13 Oct 2026 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895606; cv=none; b=Q3HO8ZdSaUWJEO9MUvKhH0s3xxzsPFfBG9BI8tjHn2OVDZOLhmhk2sgQ8x2d4S/iGhvHq3L3FBEJtJ0xIc3Smfwj6fXym2bScGb/C/feq0BzNcV1StnJZmbsdexQY+Pt13HJ7HN6oDOncRUMh3MPBCk9RRDE4v5mMP8MPMhv+hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895606; c=relaxed/simple;
	bh=vnexU5HgWSSQK3LNKP+yrovIYtcJbM+WJt5t8m7bOpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4OcKPx4Uc3DCoic8VMefgaqk/KF/2aA7Tn3bEYiy95RKkg1BUvGgQozibFJEIw+mOL+SNbuYDkwVPxRJ79X5mHnpq5YvnZbkpymRkF4q4bIdMd8FuJQlcjNYsDNod0YJCBc3MdfAkUCrTmRd2YhAmSI1QapMn4HWQOr0w3rCXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azO+E5Y/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azO+E5Y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCEC1F000FF;
	Tue, 13 Oct 2026 12:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895605;
	bh=OKfb4pxYrGNL+uNTTNQLD3HQJ7km1roj1MOzidhrjGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azO+E5Y/syrlMjYU/PqMvbUGklCaZe0sbwKoUhWe1uvjc/gRvEN6B/2Ox+u57nTOi
	 QRC108otexZPS3YqJ8XP0G8mshuESY+HqKU9blEwtBhW11rz4Rvu1cqGhM1cqs+KSj
	 J/G8Ruf0e5B9GYcpLjpulVhFYSJZCeA1DjFwnFPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/497] iio: adc: max1363: sign-extend bipolar differential channel reads
Date: Tue, 13 Oct 2026 13:38:19 +0200
Message-ID: <20261013112915.784679262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 91908c0a78baddc8572aa3ab69e62ee2eb496ba4 ]

MAX1363 differential channels are bipolar, but max1363_read_single_chan()
masks the raw value to the ADC resolution without sign-extending it.
Negative differential readings are therefore reported to userspace as
large positive values (e.g. -1 as 4095 on a 12-bit part).

Sign-extend the masked value from the resolution bit for differential
channels. Single-ended channels are unipolar and are left unchanged.

Fixes: d1325cf45077 ("Staging: IIO: max1363 ADC driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Adjusted indentation to fit the existing iio_device_claim_direct_scoped() block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1363.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index c9d531f233eba..e5d7cefef414f 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -402,6 +402,14 @@ static int max1363_read_single_chan(struct iio_dev *indio_dev,
 
 			data = rxbuf[0];
 		}
+
+		/*
+		 * Differential channels are bipolar and the device returns the sample
+		 * in two's complement, so sign-extend it from the resolution bit.
+		 */
+		if (chan->differential)
+			data = sign_extend32(data, st->chip_info->bits - 1);
+
 		*val = data;
 
 		return 0;
-- 
2.53.0



