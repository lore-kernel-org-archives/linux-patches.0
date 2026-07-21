Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44A23B6BF0;
	Tue, 21 Jul 2026 20:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666298; cv=none; b=Ymkkes98ZgPzOzTKI9wEeSwQwBrp/kncopvGXngHrcVsUItfONF63PVfp8V7Gdm5M2gudQmF0d+Pbf3PVqG+SiEagXbMiYukTXHqhWbl5/GbExOpnBfIx/NRQNQuwGkyHdONORUZu0pa6IqJ44UxE6nMcszH+2cjyx/H42Pj+ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666298; c=relaxed/simple;
	bh=7SQxo1E2jhKCu1LvDvE8U0mDBcxJbuxrxjc7f+0EJ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXj7x33C+XhDuabhZ/aIW1kvfLXg7qFHhXVoi4CzeoHFVeRl/6LBg+X5+05taNz2nIglsYv3k6raB4KUIJp8Uavnen2sAs5cQLuT7sCMRNU23uf3E75qkNROXSddVVrYy5vpsOxjyaFFhjKv6m18IfJ0VlEAhZvmnDJRrDL+R44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NThsdIyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NThsdIyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42A11F00A3A;
	Tue, 21 Jul 2026 20:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666293;
	bh=x3tZ/0fNO4u02x76cuxO/iUYEH7DLrjqJbXyH4IU0tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NThsdIyE9EeBEySr+X1W8y94ux2niqBXCEr8vC8dLutYnPJze0n/iXpT5dcBBjUNk
	 jfeikrpfI5q58tXTKNTFiFnUo7BQwWZwD7PXObqdIX7dnnyBtuOJlHPsDsId15GnJt
	 yDU7A+A5zy8f5QdntxLnri1oR5Q7gV9UnClZ2eoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0627/1266] iio: accel: mma8452: handle I2C read error(s) in mma8452_read()
Date: Tue, 21 Jul 2026 17:17:44 +0200
Message-ID: <20260721152455.892282087@linuxfoundation.org>
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

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

[ Upstream commit 5bdff291d20c31b365d9ddfe9c426fbfb41da5bb ]

Currently, If i2c_smbus_read_i2c_block_data() fails but
mma8452_set_runtime_pm_state() succeeds, mma8452_read() returns 0.

As a result, the caller mma8452_read_raw() assumes the read was
successful and proceeds to use a buffer containing uninitialized
stack memory.

Add proper checking of the I2C read return value and propagate errors
to the caller.

Fixes: 96c0cb2bbfe0 ("iio: mma8452: add support for runtime power management")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 16a0de6002be05..b7ffdbfe2f0942 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -254,6 +254,8 @@ static int mma8452_read(struct mma8452_data *data, __be16 buf[3])
 
 	ret = i2c_smbus_read_i2c_block_data(data->client, MMA8452_OUT_X,
 					    3 * sizeof(__be16), (u8 *)buf);
+	if (ret < 0)
+		return ret;
 
 	ret = mma8452_set_runtime_pm_state(data->client, false);
 
-- 
2.53.0



