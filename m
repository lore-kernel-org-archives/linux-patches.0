Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B434C30E84F;
	Mon, 13 Oct 2025 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367806; cv=none; b=J6zNYiWj6DhkDglg7yDvPkdBefexYgBj45Xwa5FsoH4U0wKHkUnzUM/uZ8pdPTTcR1CvWj8bv3/JnEpkxeB8ISY3psFXZXFAlt4bw4ABjoVfYR786bD7P44SsvQZQDRS/jRusxPF194/+M876UoQKYIfBfSAMQqzu/i4CQMJ6S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367806; c=relaxed/simple;
	bh=G9o6cOaDCMhWRv6vt3w6FKTqxS5vn76l20Yh0mXO8Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd9pS/Eeqa/+1xB+m9bYCZ5ZmENAOxZt0/PiEo/pzek2NtvEgCqsFwXQkhndXfkVwIyZNMBc+jKONN/WZaCbWxzQ7y7lswHdOSvdwW0W6nirvsJqDHF4fKrWMuFL5hOr8gPCwu007XL+2qBX3GD5sMKDDdgsP24i3ZEz9juFKJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3w0YRzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3w0YRzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4E7C4AF0C;
	Mon, 13 Oct 2025 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367806;
	bh=G9o6cOaDCMhWRv6vt3w6FKTqxS5vn76l20Yh0mXO8Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3w0YRzIwqczB788efDYZEK4YXAnIIG+JafKVEq1qutU299W7Y0iizW4VpW2q6ZBV
	 bMZUKBfaoKhK3vQN7f+RvXKrauO3BVxHjwIkuWM+zJ3JC9nkHbBDa6l2Rm6MgbEBQ4
	 9r+cZOU7IuoiNjL4mcNr0vAN3OaeHGXll0R4EzUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Martelli <matteomartelli3@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/196] iio: consumers: Fix handling of negative channel scale in iio_convert_raw_to_processed()
Date: Mon, 13 Oct 2025 16:44:58 +0200
Message-ID: <20251013144319.184718775@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 0f85406bf830eb8747dd555ab53c9d97ee4af293 ]

There is an issue with the handling of negative channel scales
in iio_convert_raw_to_processed_unlocked() when the channel-scale
is of the IIO_VAL_INT_PLUS_[MICRO|NANO] type:

Things work for channel-scale values > -1.0 and < 0.0 because of
the use of signed values in:

	*processed += div_s64(raw64 * (s64)scale_val2 * scale, 1000000LL);

Things will break however for scale values < -1.0. Lets for example say
that raw = 2, (caller-provided)scale = 10 and (channel)scale_val = -1.5.

The result should then be 2 * 10 * -1.5 = -30.

channel-scale = -1.5 means scale_val = -1 and scale_val2 = 500000,
now lets see what gets stored in processed:

1. *processed = raw64 * scale_val * scale;
2. *processed += raw64 * scale_val2 * scale / 1000000LL;

1. Sets processed to 2 * -1 * 10 = -20
2. Adds 2 * 500000 * 10 / 1000000 = 10 to processed

And the end result is processed = -20 + 10 = -10, which is not correct.

Fix this by always using the abs value of both scale_val and scale_val2
and if either is negative multiply the end-result by -1.

Note there seems to be an unwritten rule about negative
IIO_VAL_INT_PLUS_[MICRO|NANO] values that:

i.   values > -1.0 and < 0.0 are written as val=0 val2=-xxx
ii.  values <= -1.0 are written as val=-xxx val2=xxx

But iio_format_value() will also correctly display a third option:

iii. values <= -1.0 written as val=-xxx val2=-xxx

Since iio_format_value() uses abs(val) when val2 < 0.

This fix also makes iio_convert_raw_to_processed() properly handle
channel-scales using this third option.

Fixes: 48e44ce0f881 ("iio:inkern: Add function to read the processed value")
Cc: Matteo Martelli <matteomartelli3@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250831104825.15097-2-hansg@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 8255035ff124f..34abbf46916cc 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -9,6 +9,7 @@
 #include <linux/mutex.h>
 #include <linux/property.h>
 #include <linux/slab.h>
+#include <linux/units.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/iio-opaque.h>
@@ -635,7 +636,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 {
 	int scale_type, scale_val, scale_val2;
 	int offset_type, offset_val, offset_val2;
-	s64 raw64 = raw;
+	s64 denominator, raw64 = raw;
 
 	offset_type = iio_channel_read(chan, &offset_val, &offset_val2,
 				       IIO_CHAN_INFO_OFFSET);
@@ -679,20 +680,19 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		*processed = raw64 * scale_val * scale;
 		break;
 	case IIO_VAL_INT_PLUS_MICRO:
-		if (scale_val2 < 0)
-			*processed = -raw64 * scale_val * scale;
-		else
-			*processed = raw64 * scale_val * scale;
-		*processed += div_s64(raw64 * (s64)scale_val2 * scale,
-				      1000000LL);
-		break;
 	case IIO_VAL_INT_PLUS_NANO:
-		if (scale_val2 < 0)
-			*processed = -raw64 * scale_val * scale;
-		else
-			*processed = raw64 * scale_val * scale;
-		*processed += div_s64(raw64 * (s64)scale_val2 * scale,
-				      1000000000LL);
+		switch (scale_type) {
+		case IIO_VAL_INT_PLUS_MICRO:
+			denominator = MICRO;
+			break;
+		case IIO_VAL_INT_PLUS_NANO:
+			denominator = NANO;
+			break;
+		}
+		*processed = raw64 * scale * abs(scale_val);
+		*processed += div_s64(raw64 * scale * abs(scale_val2), denominator);
+		if (scale_val < 0 || scale_val2 < 0)
+			*processed *= -1;
 		break;
 	case IIO_VAL_FRACTIONAL:
 		*processed = div_s64(raw64 * (s64)scale_val * scale,
-- 
2.51.0



