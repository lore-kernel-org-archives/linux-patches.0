Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490A413FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adD4FnD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9457C433C7;
	Mon, 23 Oct 2023 11:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059195;
	bh=WuE6VwuJ73eaaHKPp7k1GD5D29SNXCdQEk3ns3awc4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adD4FnD4GbLYEb4j4ZH1DGOWz2yKtrBF/UStt6kens765Jkp5nKB/xqIHRVCvEQyT
	 m0T2NqdNMx3CWxWc0U8ukFFbQT86M6m7rHgnrUATIszmrmGcFZUQHgzlvtoS454fAa
	 6KkEDOI9GWy1Cnczw2awEgCYXp6ClYH/VfFDjJuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 096/241] iio: light: vcnl4000: Dont power on/off chip in config
Date: Mon, 23 Oct 2023 12:54:42 +0200
Message-ID: <20231023104836.241982129@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mårten Lindahl <marten.lindahl@axis.com>

[ Upstream commit 7e87ab38eed09c9dec56da361d74158159ae84a3 ]

After enabling/disabling interrupts on the vcnl4040 chip the als and/or
ps sensor is powered on or off depending on the interrupt enable bits.
This is made as a last step in write_event_config.

But there is no reason to do this as the runtime PM handles the power
state of the sensors. Interfering with this may impact sensor readings.

Consider the following:
 1. Userspace makes sensor data reading which triggers RPM resume
    (sensor powered on) and a RPM suspend timeout. The timeout is 2000ms
    before RPM suspend powers the sensor off if no new reading is made
    within the timeout period.
 2. Userspace disables interrupts => powers sensor off
 3. Userspace reads sensor data = 0 because sensor is off and the
    suspend timeout has not passed. For each new reading made within the
    timeout period the timeout is renewed with 2000ms and RPM will not
    make a new resume (device was not suspended). So the sensor will
    not be powered on.
 4. No further userspace reading for 2000ms ends RPM suspend timeout and
    triggers suspend (powers off already powered off sensor).

Powering sensor off in (2) makes all consecutive readings made within
2000ms to the previous reading (3) return invalid data.

Skip setting power state when writing new event config.

Fixes: 546676121cb9 ("iio: light: vcnl4000: Add interrupt support for vcnl4040")
Fixes: bc292aaf9cb4 ("iio: light: vcnl4000: add illuminance irq vcnl4040/4200")
Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Link: https://lore.kernel.org/r/20230907-vcnl4000-pm-fix-v2-1-298e01f54db4@axis.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/vcnl4000.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index 7c7362e288213..66433886b7b03 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -994,7 +994,6 @@ static int vcnl4040_write_event_config(struct iio_dev *indio_dev,
 
 out:
 	mutex_unlock(&data->vcnl4000_lock);
-	data->chip_spec->set_power_state(data, data->ps_int != 0);
 
 	return ret;
 }
-- 
2.40.1



