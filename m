Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E2F1E522;
	Thu, 30 Jan 2025 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247241; cv=none; b=W4mhU+r+zKko+SHo5wcL0fit8pLPGs2eGiqQ4dpDUqm1SCEtaTyqJvSY2KqzZGigKiE3IunzaKpdbCwzIlb3O2d3HTFXmzGTrMCNAHiE/B+UvMV3Ru7x1h9aE9LEGcS+bL8y5z9n+L+KY8YjzrF7h87qLsqU5hwxOJygELjI1yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247241; c=relaxed/simple;
	bh=mpGYR+qz+ySDUX2aaHfk3nnR1ya20Xxh6TnH/QwJId8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1SrXJD0syvww2h7/mOtsIJWh9RRHsmcES9x0qQOAaNwZ01eSozmpanfbcKoOi8nwoQjE3hKDCrtZNXS0jtPqyaXC5iNjPqboj3asWveceyjtfpDi/nNoV/neBqkD52X33C49nw5cpikqcFaBQH68+BC72KyTeEAE8BzfEWe8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9rdYdcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9rdYdcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44693C4CED2;
	Thu, 30 Jan 2025 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247241;
	bh=mpGYR+qz+ySDUX2aaHfk3nnR1ya20Xxh6TnH/QwJId8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9rdYdcKk4lupASJiIsP1uy7neurvUaBQN9DiG04sKVJkIDiPc7Avg8Ph9aI19K0I
	 VxtUptj/MtQ77k+G9Et+EjWRYG6B7xfZSJrWVKMJE78CehmoahK9WS9PHBtKeTaRS3
	 /ivUJIUvE4MRfW77ESca4sWpStiHx4DCkwWXrPf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 101/133] iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on
Date: Thu, 30 Jan 2025 15:01:30 +0100
Message-ID: <20250130140146.604760015@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 65a60a590142c54a3f3be11ff162db2d5b0e1e06 upstream.

Currently suspending while sensors are one will result in timestamping
continuing without gap at resume. It can work with monotonic clock but
not with other clocks. Fix that by resetting timestamping.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20241113-inv_icm42600-fix-timestamps-after-suspend-v1-1-dfc77c394173@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -720,6 +720,8 @@ out_unlock:
 static int __maybe_unused inv_icm42600_resume(struct device *dev)
 {
 	struct inv_icm42600_state *st = dev_get_drvdata(dev);
+	struct inv_icm42600_timestamp *gyro_ts = iio_priv(st->indio_gyro);
+	struct inv_icm42600_timestamp *accel_ts = iio_priv(st->indio_accel);
 	int ret;
 
 	mutex_lock(&st->lock);
@@ -740,9 +742,12 @@ static int __maybe_unused inv_icm42600_r
 		goto out_unlock;
 
 	/* restore FIFO data streaming */
-	if (st->fifo.on)
+	if (st->fifo.on) {
+		inv_icm42600_timestamp_reset(gyro_ts);
+		inv_icm42600_timestamp_reset(accel_ts);
 		ret = regmap_write(st->map, INV_ICM42600_REG_FIFO_CONFIG,
 				   INV_ICM42600_FIFO_CONFIG_STREAM);
+	}
 
 out_unlock:
 	mutex_unlock(&st->lock);


