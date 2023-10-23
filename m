Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10E415E82
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBaBmuPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACB4C43395;
	Mon, 23 Oct 2023 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060187;
	bh=8AnoS63ji/WHO5GBqi57KIcOH8iKlNGbvMqX2IRMHzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBaBmuPM8DvCRwYysonjvorNtJWf7nHcUHUQB5XgZLARZLZX5Ii3n50S1m8f/g+5B
	 iRIrOzvJf6fjftkLRcCAMcuuaXWbtK4XL/Nf+quOdv+eaRnpAXI4ILqhNTOc/44JX4
	 93LTJ6ftKuBbPOQ8+hzNh1Dq7YbX7x6Jr5UK6+So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <groeck@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/196] iio: cros_ec: fix an use-after-free in cros_ec_sensors_push_data()
Date: Mon, 23 Oct 2023 12:55:53 +0200
Message-ID: <20231023104831.029102713@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 7771c8c80d62ad065637ef74ed2962983f6c5f6d ]

cros_ec_sensors_push_data() reads `indio_dev->active_scan_mask` and
calls iio_push_to_buffers_with_timestamp() without making sure the
`indio_dev` stays in buffer mode.  There is a race if `indio_dev` exits
buffer mode right before cros_ec_sensors_push_data() accesses them.

An use-after-free on `indio_dev->active_scan_mask` was observed.  The
call trace:
[...]
 _find_next_bit
 cros_ec_sensors_push_data
 cros_ec_sensorhub_event
 blocking_notifier_call_chain
 cros_ec_irq_thread

It was caused by a race condition: one thread just freed
`active_scan_mask` at [1]; while another thread tried to access the
memory at [2].

Fix it by calling iio_device_claim_buffer_mode() to ensure the
`indio_dev` can't exit buffer mode during cros_ec_sensors_push_data().

[1]: https://elixir.bootlin.com/linux/v6.5/source/drivers/iio/industrialio-buffer.c#L1189
[2]: https://elixir.bootlin.com/linux/v6.5/source/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c#L198

Cc: stable@vger.kernel.org
Fixes: aa984f1ba4a4 ("iio: cros_ec: Register to cros_ec_sensorhub when EC supports FIFO")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230829030622.1571852-1-tzungbi@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
index d98f7e4d202c1..1ddce991fb3f4 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -190,8 +190,11 @@ int cros_ec_sensors_push_data(struct iio_dev *indio_dev,
 	/*
 	 * Ignore samples if the buffer is not set: it is needed if the ODR is
 	 * set but the buffer is not enabled yet.
+	 *
+	 * Note: iio_device_claim_buffer_mode() returns -EBUSY if the buffer
+	 * is not enabled.
 	 */
-	if (!iio_buffer_enabled(indio_dev))
+	if (iio_device_claim_buffer_mode(indio_dev) < 0)
 		return 0;
 
 	out = (s16 *)st->samples;
@@ -210,6 +213,7 @@ int cros_ec_sensors_push_data(struct iio_dev *indio_dev,
 	iio_push_to_buffers_with_timestamp(indio_dev, st->samples,
 					   timestamp + delta);
 
+	iio_device_release_buffer_mode(indio_dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cros_ec_sensors_push_data);
-- 
2.40.1



