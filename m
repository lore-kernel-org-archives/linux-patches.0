Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0262F2346;
	Tue, 17 Jun 2025 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176025; cv=none; b=kbnPK5JH4sNI8hUxsQv7JV85ktx55f/znrycZsq/wowKJEIOLQLgbHTJT0R9ne0YjRnh2z/jCjNu1jJk6PLULz9VNc2jMtgvtDlnHRHP5AufUeJ0MTZGb1/4iPiyjXKd18Xv2mk/qGSF564ooozb4ZZNuxxaf2xhSeFpmX+ZNhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176025; c=relaxed/simple;
	bh=72fRlqSn8QxVJonmzNRJM+8TyU4k3gXTIoMqMN8npVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/wUY8nE8YHfcArnzZhthAi/0hKl2cS68ftuPMioceRdc6KSwiGbp+RqGDXMsmmRD/uNyYKsrUF8/TNDVFVHbmuROWYhLlDEfDpFZW9NooDwV7j4HJ5H+a4FUXXNo8w1KRcLaWx4StXkwFBFYd9M3NC5XYrR57oVDC4+w6/tags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1ItIem3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1ItIem3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801C2C4CEE7;
	Tue, 17 Jun 2025 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176025;
	bh=72fRlqSn8QxVJonmzNRJM+8TyU4k3gXTIoMqMN8npVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1ItIem3OmuzPm+3GbzFu7VCxvUP1ouFV1ayeSf1qWmeFJqmtSte2LH502c+d6OIi
	 QP8VqNbECxPMh2LJ6HPdkt7v0jtthT4AvHUnyZbBlQu/cbOssttVdARbTWY4jTJBKG
	 NHTXs0dRbR+nC9hCHli2TQGUcyJzL/OnGK8ZH2x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Pellegrino <bpellegrino@arka.org>,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/356] iio: filter: admv8818: Support frequencies >= 2^32
Date: Tue, 17 Jun 2025 17:25:51 +0200
Message-ID: <20250617152347.702959390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Pellegrino <bpellegrino@arka.org>

[ Upstream commit 9016776f1301627de78a633bda7c898425a56572 ]

This patch allows writing u64 values to the ADMV8818's high and low-pass
filter frequencies. It includes the following changes:

- Rejects negative frequencies in admv8818_write_raw.
- Adds a write_raw_get_fmt function to admv8818's iio_info, returning
  IIO_VAL_INT_64 for the high and low-pass filter 3dB frequency channels.

Fixes: f34fe888ad05 ("iio:filter:admv8818: add support for ADMV8818")
Signed-off-by: Brian Pellegrino <bpellegrino@arka.org>
Signed-off-by: Sam Winchenbach <swinchenbach@arka.org>
Link: https://patch.msgid.link/20250328174831.227202-7-sam.winchenbach@framepointer.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/filter/admv8818.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/iio/filter/admv8818.c b/drivers/iio/filter/admv8818.c
index 380e119b3cf54..cc8ce0fe74e7c 100644
--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -402,6 +402,19 @@ static int admv8818_read_lpf_freq(struct admv8818_state *st, u64 *lpf_freq)
 	return ret;
 }
 
+static int admv8818_write_raw_get_fmt(struct iio_dev *indio_dev,
+								struct iio_chan_spec const *chan,
+								long mask)
+{
+	switch (mask) {
+	case IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY:
+	case IIO_CHAN_INFO_HIGH_PASS_FILTER_3DB_FREQUENCY:
+		return IIO_VAL_INT_64;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int admv8818_write_raw(struct iio_dev *indio_dev,
 			      struct iio_chan_spec const *chan,
 			      int val, int val2, long info)
@@ -410,6 +423,9 @@ static int admv8818_write_raw(struct iio_dev *indio_dev,
 
 	u64 freq = ((u64)val2 << 32 | (u32)val);
 
+	if ((s64)freq < 0)
+		return -EINVAL;
+
 	switch (info) {
 	case IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY:
 		return admv8818_lpf_select(st, freq);
@@ -571,6 +587,7 @@ static int admv8818_set_mode(struct iio_dev *indio_dev,
 
 static const struct iio_info admv8818_info = {
 	.write_raw = admv8818_write_raw,
+	.write_raw_get_fmt = admv8818_write_raw_get_fmt,
 	.read_raw = admv8818_read_raw,
 	.debugfs_reg_access = &admv8818_reg_access,
 };
-- 
2.39.5



