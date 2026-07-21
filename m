Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179593B47E2;
	Tue, 21 Jul 2026 20:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666291; cv=none; b=pHl+YbLsj8wsqe99jniD64Qsp9/GgxlnY1SfKukkdWtj/CmrhGXIXSOOlrskVh1NIs+PxU+mCekk3kvzVSw+fARcT8aBSWDG1rhZ1jeSEcQ/DFR2iGadu0RZxTLfxUyMQnd1SNpj10oSa+2DZbi3pl1kRflDgnABQaJYbAqpYdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666291; c=relaxed/simple;
	bh=TwPHQGmo4MrYyDE7jtx63L2519Buxl1FTgHbvmpdOog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSfcJtbvk9zHZlWHTwJa0a+RAhBF3hf0xk64KNVxazY4lEgZwtJZZleBM8cM9prCabcAQdOojw5803XeZULJ1Q4tasotyTQdymWmFkXoszjTfd90dALzdAF9jzHy38AM1WNa+aH1bSEfqohy2wYF+ZI36eb8MqhejVSZWcuQZ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc+xbmPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc+xbmPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBD71F00A3A;
	Tue, 21 Jul 2026 20:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666285;
	bh=4iaAdRHO375qi6wAy9VZgW/BkgH+hy8M+XeOBuz5rjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tc+xbmPg5qKed7QCmGwEhqvhIuhJEg1A6AfA7KCPErF6go8maEVIFNhiQHWlw2Nqm
	 gMNd3wOP6Cel2R94lXhOk1NyQx4pHvbT7eFBkl3/9oAEZEBDT2z9WXOZoJXvvP9XMU
	 szFNACtxu9VhllX+b956rf8s3s5O3ilLTMLPSKiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0625/1266] iio: magnetometer: ak8975: fix potential kernel stack memory leak
Date: Tue, 21 Jul 2026 17:17:42 +0200
Message-ID: <20260721152455.848360787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index e8c52179b3315d..547a4738cf1dd0 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -464,6 +464,10 @@ static int ak8975_who_i_am(struct i2c_client *client,
 		dev_err(&client->dev, "Error reading WIA\n");
 		return ret;
 	}
+	if (ret != sizeof(wia_val)) {
+		dev_err(&client->dev, "Error reading WIA\n");
+		return -EIO;
+	}
 
 	if (wia_val[0] != AK8975_DEVICE_ID)
 		return -ENODEV;
@@ -580,6 +584,10 @@ static int ak8975_setup(struct i2c_client *client)
 		dev_err(&client->dev, "Not able to read asa data\n");
 		return ret;
 	}
+	if (ret != sizeof(data->asa)) {
+		dev_err(&client->dev, "Error reading asa data\n");
+		return -EIO;
+	}
 
 	/* After reading fuse ROM data set power-down mode */
 	ret = ak8975_set_mode(data, POWER_DOWN);
@@ -719,6 +727,10 @@ static int ak8975_read_axis(struct iio_dev *indio_dev, int index, int *val)
 			sizeof(rval), (u8*)&rval);
 	if (ret < 0)
 		goto exit;
+	if (ret != sizeof(rval)) {
+		ret = -EIO;
+		goto exit;
+	}
 
 	/* Read out ST2 for release lock on measurment data. */
 	ret = i2c_smbus_read_byte_data(client, data->def->ctrl_regs[ST2]);
@@ -848,6 +860,8 @@ static void ak8975_fill_buffer(struct iio_dev *indio_dev)
 							(u8 *)fval);
 	if (ret < 0)
 		goto unlock;
+	if (ret != sizeof(fval))
+		goto unlock;
 
 	mutex_unlock(&data->lock);
 
-- 
2.53.0



