Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F426B961;
	Tue,  8 Apr 2025 12:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114749; cv=none; b=AZJLX9ep2EhwZtmhJArq6TX0CJAGzzlZK4HRSO4ir0BC26GRAwOIzQzDDU2eJwuQi4E4S2Fsb/ZjKAFBuU3e4Vfo4dsCMOmmR4Kf+i3ebUQCfqeFdnRLRqZhlVaHtNhmmCpBFmA6ky+HxipxmqeVrmJWXlNF6NIKRt5waKhTit0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114749; c=relaxed/simple;
	bh=f5/xJGWW6g9ulhkXDGbCuqOBFMqgeofNAf1vV9Ox1Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ncm4Sb0nbHUKquu+3Khb0HdFbeE9GY9vG/ffmco5q8J+98oHj+9zzONFi4a9msk1MsaRY8nCfQUoFL3fzqLHnyW8aOTgiIkBLv160LcKnLQ6/9SvRPprRruRW4ArHSRiecyk2Bn1XIC088r7XQwftaGhSxDSzaLMlvTJo2qeYSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP/SKyUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP/SKyUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E358C4CEE5;
	Tue,  8 Apr 2025 12:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114749;
	bh=f5/xJGWW6g9ulhkXDGbCuqOBFMqgeofNAf1vV9Ox1Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP/SKyUQ/svQ43NqWeMfIXnkkFRhy0FT/B1mYH/jDY3LdyAttcF2c+V3mfG5k2Bzo
	 mKfCGWRACyJ/UbkxlrhsU/iw17/P2t2lPNBEzwY4DJ0HZwkFepdJVUy45Hcmf4O0bw
	 pQocfZE6wKMmNN81rL2QuNv4cUsQ0bi4ObQCsP1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 222/499] iio: accel: msa311: Fix failure to release runtime pm if direct mode claim fails.
Date: Tue,  8 Apr 2025 12:47:14 +0200
Message-ID: <20250408104856.746945934@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 60a0cf2ebab92011055ab7db6553c0fc3c546938 ]

Reorder the claiming of direct mode and runtime pm calls to simplify
handling a little.  For correct error handling, after the reorder
iio_device_release_direct_mode() must be claimed in an error occurs
in pm_runtime_resume_and_get()

Fixes: 1ca2cfbc0c33 ("iio: add MEMSensing MSA311 3-axis accelerometer driver")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250217140135.896574-7-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/msa311.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/accel/msa311.c b/drivers/iio/accel/msa311.c
index e7fb860f32337..c2b05d1f7239a 100644
--- a/drivers/iio/accel/msa311.c
+++ b/drivers/iio/accel/msa311.c
@@ -594,23 +594,25 @@ static int msa311_read_raw_data(struct iio_dev *indio_dev,
 	__le16 axis;
 	int err;
 
-	err = pm_runtime_resume_and_get(dev);
+	err = iio_device_claim_direct_mode(indio_dev);
 	if (err)
 		return err;
 
-	err = iio_device_claim_direct_mode(indio_dev);
-	if (err)
+	err = pm_runtime_resume_and_get(dev);
+	if (err) {
+		iio_device_release_direct_mode(indio_dev);
 		return err;
+	}
 
 	mutex_lock(&msa311->lock);
 	err = msa311_get_axis(msa311, chan, &axis);
 	mutex_unlock(&msa311->lock);
 
-	iio_device_release_direct_mode(indio_dev);
-
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 
+	iio_device_release_direct_mode(indio_dev);
+
 	if (err) {
 		dev_err(dev, "can't get axis %s (%pe)\n",
 			chan->datasheet_name, ERR_PTR(err));
@@ -756,10 +758,6 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
 	unsigned int odr;
 	int err;
 
-	err = pm_runtime_resume_and_get(dev);
-	if (err)
-		return err;
-
 	/*
 	 * Sampling frequency changing is prohibited when buffer mode is
 	 * enabled, because sometimes MSA311 chip returns outliers during
@@ -769,6 +767,12 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
 	if (err)
 		return err;
 
+	err = pm_runtime_resume_and_get(dev);
+	if (err) {
+		iio_device_release_direct_mode(indio_dev);
+		return err;
+	}
+
 	err = -EINVAL;
 	for (odr = 0; odr < ARRAY_SIZE(msa311_odr_table); odr++)
 		if (val == msa311_odr_table[odr].integral &&
@@ -779,11 +783,11 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
 			break;
 		}
 
-	iio_device_release_direct_mode(indio_dev);
-
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 
+	iio_device_release_direct_mode(indio_dev);
+
 	if (err)
 		dev_err(dev, "can't update frequency (%pe)\n", ERR_PTR(err));
 
-- 
2.39.5



