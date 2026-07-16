Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5B93F482E;
	Thu, 16 Jul 2026 14:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210520; cv=none; b=aNh72NKgVnBQUUN6QYeIQCbrS8bfx+6vgAlx5YsBV8w/hxmCM4+YIsbVH94zTfpQF5Ash2KjZHuKJhvXjtpKCttgmGXn51F1o8PASoFCIPXNbcpq7pvSlOYQA0sUHDQz+nwrveISywCJyRv2omUzV4KnUx02oWd24T1pIKLJUto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210520; c=relaxed/simple;
	bh=moCbJrG9EEAJG55RkVLRakfXSsO35kvDaZxFCuZuzH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dI1I3RgerPmQzuDas1JFd8YUdKkQi0aRpuNzB/lQWtfbID35cs3OhB5Ip/uC0S7PJXkt7t3/6bFlifDDvOJqHT/2n82RMrRvpMMrQoI/xPz9TdDLExmTeShgl4Lakf27b0XVawNiZUKlGg5M9xRqHgYDiuXN/zqajgZ0thXu8Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAfsDGF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAfsDGF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4213A1F000E9;
	Thu, 16 Jul 2026 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210518;
	bh=m+EAXid6VaAgcLllF1/Lom3GKFfsTRMo+l5HlSjxrW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAfsDGF5YsMV+b4MAojv/LBI1KIj2wyOhKSsEkMOymmmKrm1hLrJ2XcCtfRJez5SD
	 TL7bOUNyyAiNHeAQkowzn2VWNmbC1YE4tD11u6k2NKm+q2SAszFSkV2N2fSpuXNS8U
	 Z6ysICEWwHuwaITy5inAqwfp4juug5DSU5JPaJp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 077/480] iio: light: al3320a: read both ALS ADC registers again
Date: Thu, 16 Jul 2026 15:27:04 +0200
Message-ID: <20260716133046.378409758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

commit 744bccc2647c6b2206290e8e40890a23812116b3 upstream.

al3320a_read_raw() used to read two adjacent registers
until the driver was modernized using the regmap framework.
That cleanup accidentally replaced the 16-bit word read
with a single byte read. I'm reverting latter.

Fixes: 1850e6ae7f91 ("iio: light: al3320a: Implement regmap support")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/al3320a.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/al3320a.c
+++ b/drivers/iio/light/al3320a.c
@@ -135,7 +135,8 @@ static int al3320a_read_raw(struct iio_d
 			    int *val2, long mask)
 {
 	struct al3320a_data *data = iio_priv(indio_dev);
-	int ret, gain, raw;
+	int ret, gain;
+	__le16 raw;
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
@@ -144,11 +145,12 @@ static int al3320a_read_raw(struct iio_d
 		 * - low byte of output is stored at AL3320A_REG_DATA_LOW
 		 * - high byte of output is stored at AL3320A_REG_DATA_LOW + 1
 		 */
-		ret = regmap_read(data->regmap, AL3320A_REG_DATA_LOW, &raw);
+		ret = regmap_bulk_read(data->regmap, AL3320A_REG_DATA_LOW,
+				       &raw, sizeof(raw));
 		if (ret)
 			return ret;
 
-		*val = raw;
+		*val = le16_to_cpu(raw);
 
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:


