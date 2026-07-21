Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5879E3C1081;
	Tue, 21 Jul 2026 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671813; cv=none; b=p24D5Qux9shVisx582BvGmhXwbogMMFeMOegYAiCh14n23nmPFKht5vFc/S1XvuVHZDPg37zln/a1PrvvsI+Xh5OHblUJKrmgvxunCB2OsWr5P9zgCv9HmtMl04gn7httC06bQ2RdXwKxXYxTBGxqKnr+9voL9hq5EGhrXYBOEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671813; c=relaxed/simple;
	bh=Zj/ADYhAGRkMH6ePpPgZji9UzXSPiJzmSRwb+So56F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgmdDLYtXCSIV3y9/B5k9B0torx2OC3IANRIAYkwUjiDMZz1vZQlBAYMJSu+KDmqHVci+1gB22FT5niUpiQy2H8h/Mtze/vppuJgOnYlg3zzuDuRvNcmzm29u7Xuv7EumbhfDy1XQxCtUBJ5I1EETA1kEblrVekDiiHmW35SeOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nmw66ww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nmw66ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB911F000E9;
	Tue, 21 Jul 2026 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671812;
	bh=wUcolHell8YtKk+HKf92Nr3JyRlwDCIqiuYpRFFzfcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nmw66wwe5ifY4+hRpORsYQfBATyQ4AKGSQEchmcDBWhqhZe0ACpK6at/p8ti36SR
	 tT8Iu8UbSa33BCEnLwhZM1snquWyeOWQ8TDws0+yVCm09xof7BC3Dv6yemgn3QdUxC
	 AmgsUUevS/Plj/8eq/2aNDuBlq2hdTP2oU+RUge8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 387/843] iio: magnetometer: ak8975: fix potential kernel stack memory leak
Date: Tue, 21 Jul 2026 17:20:22 +0200
Message-ID: <20260721152414.743468898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

[ Upstream commit a9a00d727b7bbc5e913a919530a9dd468935bf95 ]

Currently in the AK8975 driver there are four instances where potential
uninitialized kernel stack memory leaks can occur. If
i2c_smbus_read_i2c_block_data_or_emulated() returns a value less than
the size of the buffer, uninitialized bytes are retained in the buffer
and later the buffer is passed on to IIO buffers, potentially leaking
memory to userspace.

Fix this by adding checks whether the return value of the function is
equal to the size of the buffer and subsequently if the value is
lesser than zero to distinguish from a returned error code.

Fixes: bc11ca4a0b84 ("iio:magnetometer:ak8975: triggered buffer support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260513-ak8975-fix-v1-1-104ea605dd54%40gmail.com
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/ak8975.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 03c25316e67e08..1987683ffa76ed 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -437,6 +437,10 @@ static int ak8975_who_i_am(struct i2c_client *client,
 		dev_err(&client->dev, "Error reading WIA\n");
 		return ret;
 	}
+	if (ret != sizeof(wia_val)) {
+		dev_err(&client->dev, "Error reading WIA\n");
+		return -EIO;
+	}
 
 	if (wia_val[0] != AK8975_DEVICE_ID)
 		return -ENODEV;
@@ -549,6 +553,10 @@ static int ak8975_setup(struct i2c_client *client)
 		dev_err(&client->dev, "Not able to read asa data\n");
 		return ret;
 	}
+	if (ret != sizeof(data->asa)) {
+		dev_err(&client->dev, "Error reading asa data\n");
+		return -EIO;
+	}
 
 	/* After reading fuse ROM data set power-down mode */
 	ret = ak8975_set_mode(data, POWER_DOWN);
@@ -688,6 +696,10 @@ static int ak8975_read_axis(struct iio_dev *indio_dev, int index, int *val)
 			sizeof(rval), (u8*)&rval);
 	if (ret < 0)
 		goto exit;
+	if (ret != sizeof(rval)) {
+		ret = -EIO;
+		goto exit;
+	}
 
 	/* Read out ST2 for release lock on measurment data. */
 	ret = i2c_smbus_read_byte_data(client, data->def->ctrl_regs[ST2]);
@@ -817,6 +829,8 @@ static void ak8975_fill_buffer(struct iio_dev *indio_dev)
 							(u8 *)fval);
 	if (ret < 0)
 		goto unlock;
+	if (ret != sizeof(fval))
+		goto unlock;
 
 	mutex_unlock(&data->lock);
 
-- 
2.53.0



