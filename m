Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ECF328604;
	Mon, 27 Oct 2025 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592447; cv=none; b=ollS8LVTIF6MSNlU90C57XXueNMXflSkdhrb+TIhTe7Gr3koS9kzX7G0ZQk9SdnLjuRtBEVspn0nGwd2rPAN5STN9HH2Nao299UOHldeay5iNVMS5+IxAZB3WJnGfWM6cjshrEd7iMjYhWlFaYidkQW0J8WFnH+wTgKLQKm6chE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592447; c=relaxed/simple;
	bh=RAChbIuzvPMtqjiRwf62ZOX48tpgL1/flaeo2W3neSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qorgck+W3y/Cslt4HydhDA76husiJSpc4zTsdVurrfMyDY788BGmHkFiTR9+GDgm6TSJdHqqc15H/dqaOu2Ra/doOt5VOr5Lq5/sU3Gbv5JGUudkdqTITTH/jt1Wn2ygEhVul2auHfhfvGG4xn/IAxLlEhwY72rk12GTxah3vsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWS8s8D4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWS8s8D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F696C4CEF1;
	Mon, 27 Oct 2025 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592444;
	bh=RAChbIuzvPMtqjiRwf62ZOX48tpgL1/flaeo2W3neSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWS8s8D40C9EnOyqsaodJ8EFc6g+HJIpeNTyAk48hsxqe6ehPWZvHtnXF0VMQ+tuA
	 VXfc04T4rXH5qvSH22UBXcRPi0dyLI9Kihjk+ZFRugai8Ql46mlne8ULQD22C9dr1c
	 WTT22i0PS5bxgENIQNMcoW0eFFWQf+Zxmh3Qqa+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/157] iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended
Date: Mon, 27 Oct 2025 19:36:25 +0100
Message-ID: <20251027183504.576585116@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ adjusted context for suspend/resume functions lacking APEX/wakeup support ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -670,17 +670,15 @@ EXPORT_SYMBOL_GPL(inv_icm42600_core_prob
 static int __maybe_unused inv_icm42600_suspend(struct device *dev)
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
@@ -712,10 +710,13 @@ static int __maybe_unused inv_icm42600_r
 	struct inv_icm42600_state *st = dev_get_drvdata(dev);
 	struct inv_icm42600_timestamp *gyro_ts = iio_priv(st->indio_gyro);
 	struct inv_icm42600_timestamp *accel_ts = iio_priv(st->indio_accel);
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&st->lock);
 
+	if (pm_runtime_suspended(dev))
+		goto out_unlock;
+
 	ret = inv_icm42600_enable_regulator_vddio(st);
 	if (ret)
 		goto out_unlock;


