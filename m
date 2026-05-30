Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2AE3AA182;
	Sat, 30 May 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163077; cv=none; b=KhR5WMmBBS8xhCbRnlmWmUD7yf1S7KR1qTYHa4axmwo2G9l09/6x79RP1i5gku54fmFa4WH5z9DhPQlJSQAtkFSplV1su2cfJSwkW4HPS5+58Xuj7XmSeTD7A4cWlxAhb/6qWbkA4hgq9jlhCDe/Wv7iaGvr1PprExP4FQvpGRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163077; c=relaxed/simple;
	bh=5CEERwxLFWm2aOgnfnl+0O0tHTEbij0/Ch36OsQ6xxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/rbw/R9R0pe65bsKEPivcwvEkQyApX9TpD5SB61AhVGI0NGHilz3ut7qF9bIu2wth9DjEEZ+cZdCJnY6rjK7ExelnfbGRiY/VFgGR10al8nN9spj24/eeqHol+XkvX/lsH/+mpKK3QsIL/2A41etu3U/+5dAGk5ks/Y/iTf7s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkiO/46y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkiO/46y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8DC1F00893;
	Sat, 30 May 2026 17:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163075;
	bh=VIwFizWpR5V61nO1JgbumISQbx+OchFfpsyVTYtMEEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkiO/46y8pciig5EXCoH69w9vkShDmV8Nyxipdi9qkvdSfZ0sZXWizjZz3mxv36JR
	 5cInpqChOGo3Cg9k22dH8jsGxsSJHRmR+ODqbEYYZhb69qk3GZmp9bL5bauvUWx8Ij
	 zLhseXQV1oJuThuyTOWbBzJDdQ7su+ZjUPSkwiMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 147/776] iio: imu: inv_icm42600: fix odr switch when turning buffer off
Date: Sat, 30 May 2026 17:57:41 +0200
Message-ID: <20260530160244.249752088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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


