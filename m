Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FDF32D7DE;
	Mon, 27 Oct 2025 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592137; cv=none; b=rTmlmXm3EzFyBQKG+153CuywOt4MwZV+4rAzW6mO+mD4y9YqUp2hlSi3pwJCYnrEM9s7OG2tRCRbCI0SSFuvT9C62umCt0LiDvRpF9SjoFy5RrOND0EuBbf7jMv0HMRmmjOjuBPtQA/oaCji0ahb0cASrIf+NMFKgxY5bFiOcbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592137; c=relaxed/simple;
	bh=hnw+b0o7KHIfSqz8PwgC+HA2+kIKtqV1Pzwy/6f9HSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yp1s7USC3xIbf9RYSQlwAnU9KSwGycDA5VSp9noyw0AmFYzP2oA1vzyrAZavjECcv9E2a6gfYsJhr6/xtxPHnPcQ0TZ6ruzngPYYkB7SNn0OL9hgHIK58OPf+GtU7ohhsWzQiUXVSbb1yofdEWeqV10DX+6OgrwpZLM6nUbULmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbNDF+jJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbNDF+jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22370C4CEF1;
	Mon, 27 Oct 2025 19:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592137;
	bh=hnw+b0o7KHIfSqz8PwgC+HA2+kIKtqV1Pzwy/6f9HSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbNDF+jJEThZ4tKRIX7F0ovqqMUWoLfzcTKDzq9id+GN5rdPa5fuDpWynbruGoFCP
	 Y4jU+wTNUXmJQIB52qNiAIpv+ufqfJX6kHW8T70sA7KDeSxeSbTpQ9HgkVt86iW6yD
	 FerOJ8EQCBHUPoQLNXp67w1CAOxhB9k6hnR8SgeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/123] iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended
Date: Mon, 27 Oct 2025 19:36:16 +0100
Message-ID: <20251027183448.958386487@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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
[ Placed early return before regulator enable instead of APEX wakeup logic ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -680,17 +680,15 @@ EXPORT_SYMBOL_GPL(inv_icm42600_core_prob
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
@@ -722,10 +720,13 @@ static int __maybe_unused inv_icm42600_r
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


