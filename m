Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5DE350A2A;
	Tue, 21 Oct 2025 19:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076607; cv=none; b=NhveIdxrhUEAw4FXA+9pQ0DbF0iH79+mbZnLMwUsNyMfqs6gMIJ9hP5VbJyEYUj+8dXWhdW07e7M8ldlI5S/3mkuU8DxlU/O3vs5WHvh3UcAd82HVYyBxTNCAv9uakVwbu3Qm0mQZ+9Ixbdh5WYH5IW026aZrGRrvodmuTy1QHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076607; c=relaxed/simple;
	bh=2Prqgprh4/K7ZHlJwGDs1BzBxfR1vEv0376I1+uzzhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbNRF8rJUXuXErSIaS5i04iIsKkybWgSQ32y4VDjfLbHhVJxTUH/4p+nzUcRELG4x55EXbsiUbMiLAzbNk6pwFB/dd62tAhIFtpBN5NN772xMHzg7607o3en5S7fYizsgdz1tG3dXl6cNeKKhTd61BJOgyQVG+jRIeNpa/4Wgl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIg1K70N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIg1K70N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FE6C4CEF1;
	Tue, 21 Oct 2025 19:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076607;
	bh=2Prqgprh4/K7ZHlJwGDs1BzBxfR1vEv0376I1+uzzhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIg1K70NMbMz2gBgG/zEiu2FPXSA6WMm+h6N0nxUJPLHOuzF+iQaccw0kSzLwRc5v
	 vZRzXQu7+Ucm4/gmW6GhsSFXDQsr9f/PRaq9bE3cpFYrYWrrScCpC2ojckVF6014mW
	 /JzXEiMe8lz5MTFJOSHL7MSgLEq3cu80gIlv4z0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/105] iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended
Date: Tue, 21 Oct 2025 21:51:35 +0200
Message-ID: <20251021195023.693162764@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 466f7a2fef2a4e426f809f79845a1ec1aeb558f4 ]

Do as in suspend, skip resume configuration steps if the device is already
pm_runtime suspended. This avoids reconfiguring a device that is already
in the correct low-power state and ensures that pm_runtime handles the
power state transitions properly.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250901-icm42pmreg-v3-3-ef1336246960@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ adjusted context due to missing APEX/WoM features in older kernel version ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -687,17 +687,15 @@ EXPORT_SYMBOL_NS_GPL(inv_icm42600_core_p
 static int inv_icm42600_suspend(struct device *dev)
 {
 	struct inv_icm42600_state *st = dev_get_drvdata(dev);
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&st->lock);
 
 	st->suspended.gyro = st->conf.gyro.mode;
 	st->suspended.accel = st->conf.accel.mode;
 	st->suspended.temp = st->conf.temp_en;
-	if (pm_runtime_suspended(dev)) {
-		ret = 0;
+	if (pm_runtime_suspended(dev))
 		goto out_unlock;
-	}
 
 	/* disable FIFO data streaming */
 	if (st->fifo.on) {
@@ -729,10 +727,13 @@ static int inv_icm42600_resume(struct de
 	struct inv_icm42600_state *st = dev_get_drvdata(dev);
 	struct inv_sensors_timestamp *gyro_ts = iio_priv(st->indio_gyro);
 	struct inv_sensors_timestamp *accel_ts = iio_priv(st->indio_accel);
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&st->lock);
 
+	if (pm_runtime_suspended(dev))
+		goto out_unlock;
+
 	ret = inv_icm42600_enable_regulator_vddio(st);
 	if (ret)
 		goto out_unlock;


