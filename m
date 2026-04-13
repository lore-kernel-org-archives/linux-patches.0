Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F331619A;
	Mon, 13 Apr 2026 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099042; cv=none; b=lmNfxr0wTCTCnFe9Q048bNHwNdpbBAyba9utNE5QKQtadEI1WUrt5VVQUy/DSt5dmX6rf/NBdClRfvpvGwHaimRJMA0PKDWQWorkdSEctDY9cAFkVowykM4ydnFGkGTRL6TuIc9qeCr0DBo2NmszSjPaHoiuzl8RLO6I1buIgU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099042; c=relaxed/simple;
	bh=sOa6B+7BBNJmnTz9OuV6oQSObcGj0NX1U/o97eG0dgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vq4taWdq1DrauKAmaQyeZHTrFsDudyNeyKCfzANlHesCdUAM0byl19I8bwojGqVjJJi6l0GUknQ7yCkWzsh+vmfZdB2oQWdX1hVpJgrr3cesWWmKzN90P9TF5XgN3zazEQ8hwI0FDMUfuIGMhIvTBN2TmX+BEDigQW4MAUQWHJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+ClW2pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+ClW2pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2134C2BCAF;
	Mon, 13 Apr 2026 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099042;
	bh=sOa6B+7BBNJmnTz9OuV6oQSObcGj0NX1U/o97eG0dgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+ClW2pQSaDMvZkjBpHRSdrcqb9CV83a5cbflh2P4D9mDf0Bh0SIN5rZm0oSlU+c6
	 fGxyDhKd0+jfzYzcq5MNyX1epvWpHEMaiE/loIeZKsqxFWuBUT5ZeH5OXrIHr7UL3c
	 C3EeQHUbck5GfYnSp0sZ1eLMsRIs1tK/JZQ7cc5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 188/491] iio: imu: inv_icm42600: fix odr switch when turning buffer off
Date: Mon, 13 Apr 2026 17:57:13 +0200
Message-ID: <20260413155826.105681827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit ffd32db8263d2d785a2c419486a450dc80693235 ]

ODR switch is done in 2 steps when FIFO is on : change the ODR register
value and acknowledge change when reading the FIFO ODR change flag.
When we are switching odr and turning buffer off just afterward, we are
losing the FIFO ODR change flag and ODR switch is blocked.

Fix the issue by force applying any waiting ODR change when turning
buffer off.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c
@@ -377,6 +377,7 @@ out_unlock:
 static int inv_icm42600_buffer_postdisable(struct iio_dev *indio_dev)
 {
 	struct inv_icm42600_state *st = iio_device_get_drvdata(indio_dev);
+	struct inv_icm42600_timestamp *ts = iio_priv(indio_dev);
 	struct device *dev = regmap_get_device(st->map);
 	unsigned int sensor;
 	unsigned int *watermark;
@@ -398,6 +399,8 @@ static int inv_icm42600_buffer_postdisab
 
 	mutex_lock(&st->lock);
 
+	inv_icm42600_timestamp_apply_odr(ts, 0, 0, 0);
+
 	ret = inv_icm42600_buffer_set_fifo_en(st, st->fifo.en & ~sensor);
 	if (ret)
 		goto out_unlock;


