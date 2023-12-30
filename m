Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6605B79DE;
	Sat, 30 Dec 2023 12:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVs+zDPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E384FC433C9;
	Sat, 30 Dec 2023 12:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938183;
	bh=41SyahsVS+dQ6adikv9jM+bKcX/nNNIGD+Ljgn+U5Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVs+zDPRmLXfv1quGV6qEvO81FgbemrG+YSd3xD3ZEPgM3HjLL+tlcdch6QcnZd1L
	 c+RG/14bKTAzE00pZggFYxpE1+XanRBfeWYEuZNzrorXQwHnGvO7YY6WMTS+vS9zFI
	 W74AqB+Mc9tyZZkamrFj0m7Iu3O6zYi8fcyVzU90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 059/112] iio: common: ms_sensors: ms_sensors_i2c: fix humidity conversion time table
Date: Sat, 30 Dec 2023 11:59:32 +0000
Message-ID: <20231230115808.597776906@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 54cf39ec16335dadbe1ba008d8e5e98dae3e26f8 upstream.

The HTU21 offers 4 sampling frequencies: 20, 40, 70 and 120, which are
associated to an index that is used to select the right measurement
resolution and its corresponding measurement time. The current
implementation selects the measurement resolution and the temperature
measurement time properly, but it does not select the right humidity
measurement time in all cases.

In summary, the 40 and 70 humidity measurement times are swapped.

The reason for that is probably the unusual coding for the measurement
resolution. According to the datasheet, the bits [7,0] of the "user
register" are used as follows to select the bit resolution:

--------------------------------------------------
| Bit 7 | Bit 0 | RH | Temp | Trh (us) | Tt (us) |
--------------------------------------------------
|   0   |   0   | 12 |  14  |  16000   |  50000  |
--------------------------------------------------
|   0   |   1   | 8  |  12  |  3000    |  13000  |
--------------------------------------------------
|   1   |   0   | 10 |  13  |  5000    |  25000  |
--------------------------------------------------
|   1   |   1   | 11 |  11  |  8000    |  7000   |
--------------------------------------------------
*This table is available in the official datasheet, page 13/21. I have
just appended the times provided in the humidity/temperature tables,
pages 3/21, 5/21. Note that always a pair of resolutions is selected.

The sampling frequencies [20, 40, 70, 120] are assigned to a linear
index [0..3] which is then coded as follows [1]:

Index    [7,0]
--------------
idx 0     0,0
idx 1     1,0
idx 2     0,1
idx 3     1,1

That is done that way because the temperature measurements are being
used as the reference for the sampling frequency (the frequencies and
the temperature measurement times are correlated), so increasing the
index always reduces the temperature measurement time and its
resolution. Therefore, the temperature measurement time array is as
simple as [50000, 25000, 13000, 7000]

On the other hand, the humidity resolution cannot follow the same
pattern because of the way it is coded in the "user register", where
both resolutions are selected at the same time. The humidity measurement
time array is the following: [16000, 3000, 5000, 8000], which defines
the following assignments:

Index    [7,0]    Trh
-----------------------
idx 0     0,0     16000  -> right, [0,0] selects 12 bits (Trh = 16000)
idx 1     1,0     3000   -> wrong! [1,0] selects 10 bits (Trh = 5000)
idx 2     0,1     5000   -> wrong! [0,1] selects 8 bits (Trh = 3000)
idx 3     1,1     8000   -> right, [1,1] selects 11 bits (Trh = 8000)

The times have been ordered as if idx = 1 -> [0,1] and idx = 2 -> [1,0],
which is not the case for the reason explained above.

So a simple modification is required to obtain the right humidity
measurement time array, swapping the values in the positions 1 and 2.

The right table should be the following: [16000, 5000, 3000, 8000]

Fix the humidity measurement time array with the right idex/value
coding.

[1] The actual code that makes this coding and assigns it to the current
value of the "user register" is the following:
config_reg &= 0x7E;
config_reg |= ((i & 1) << 7) + ((i & 2) >> 1);

Fixes: d574a87cc311 ("Add meas-spec sensors common part")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20231026-topic-htu21_conversion_time-v1-1-bd257dc44209@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/ms_sensors/ms_sensors_i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/common/ms_sensors/ms_sensors_i2c.c
+++ b/drivers/iio/common/ms_sensors/ms_sensors_i2c.c
@@ -15,8 +15,8 @@
 /* Conversion times in us */
 static const u16 ms_sensors_ht_t_conversion_time[] = { 50000, 25000,
 						       13000, 7000 };
-static const u16 ms_sensors_ht_h_conversion_time[] = { 16000, 3000,
-						       5000, 8000 };
+static const u16 ms_sensors_ht_h_conversion_time[] = { 16000, 5000,
+						       3000, 8000 };
 static const u16 ms_sensors_tp_conversion_time[] = { 500, 1100, 2100,
 						     4100, 8220, 16440 };
 


