Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726403B71A7;
	Sat, 17 Oct 2026 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257084; cv=none; b=mF8sfnJlbE1FWJ53Bf6t7wGTMDUPI1wwdqUAj64KaE1MCPul/nh5BdMUEaoTLURFlhRVBI4YCoxWmn+ISLa6jlZfLZCcesPRsJxs+yQXgErAJCAVArG/0qEEnNDXYMt87TylOPzgFnJDXUT2DmEUc3J3tml78wV/4i0g8doAlI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257084; c=relaxed/simple;
	bh=Tj59p8yWs8d2dc5M4Oa9TlkoJsrDT3yQfErjjHrLaog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBaHedstlOMQEg2xsxDigHI9Q/dA928Tpu4K241q7y/IHMRSHIvWcKiatDZ7a2P1QsDpx79lCxjJmNHIdPKDUaTTQbI/ryV924VjdtXtni3vQ4qEfO+UcDOEmzojr0jIdxo6Z/Fy4YuKJULxglqcdd9HUCCUv74ixhJzCMrgPto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZD16mBvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZD16mBvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0AE1F000C4;
	Sat, 17 Oct 2026 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257082;
	bh=r1CMYVqtvx+JxZASFd4R1G496rSvz3yQcqukmxpee20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZD16mBvR13Q6ayBavGy4Eoq8lgwv7SHz12blxEwp+JUPGfTTHdi/gDrPRECsgWYTY
	 ObCRE5M/x9dGJwaBhVVJVD+H7si9uOVUCyv1KtL3BQnGZfy5ari8CI5YkqX9fmelTh
	 CYv38bq1NRDoqpsSnp8+4md9ShWg8lRmoThAZKQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0447/1674] iio: adc: max1363: sign-extend bipolar differential channel reads
Date: Sat, 17 Oct 2026 17:45:19 +0200
Message-ID: <20261017160442.593766446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1363.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
index 5304235d733f1..d5afb9440d1b5 100644
--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -406,6 +406,14 @@ static int max1363_read_single_chan(struct iio_dev *indio_dev,
 		}
 		data = rxbuf[0];
 	}
+
+	/*
+	 * Differential channels are bipolar and the device returns the sample
+	 * in two's complement, so sign-extend it from the resolution bit.
+	 */
+	if (chan->differential)
+		data = sign_extend32(data, st->chip_info->bits - 1);
+
 	*val = data;
 
 error_ret:
-- 
2.53.0



