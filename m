Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF42563FBD;
	Wed,  9 Sep 2026 14:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962408; cv=none; b=eHpFdydxPHKYu6cec7uhFWaBfYRWbYSmSc3MFn+GCaMNpPcJ10u1+ohd1zJnAp/q0J6Wbm1ds+Wj+tmxf1Sv3lHnbtipGOtORWxRfqeJB9ww4o+ljI3ipYctPNdyCuQm6/2yOECo4nrPwvFZZm9byTV0ZVFm+9Jm8wndlwxUlj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962408; c=relaxed/simple;
	bh=n9PW5jyuUtGxJlQg/ETsLLQtjGhODibL1Vq1xZFvgtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxdO3WR4aXcw2hDtzwRiP3MhXwKhLFlbkHmbnToJyI+GtjdvznmdRwXQkj1LlqSQpeKNrP7zcdX9EFSjyh8J+whV9Y2ypdqoYAdXpdHMEfqwSM+Z1y/BEGhJ3OFRx+UGqVfdo1f65CUoNkkOi7ComXyW1oOVWfSKk/LaepFWr/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DftUjg7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DftUjg7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FA01F00A3A;
	Wed,  9 Sep 2026 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962407;
	bh=tSbgA39VJaJWvX2OmUJ3wiWAZ1Qy1ONnM0bSzOB7kbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DftUjg7CA85BgN8oQttVaFJaFl8SlV2uYQR3Mr3wyEzDXr6Wy8NmsWLG3aMZ6jv74
	 cS14fpaY8XzkCQqAWnDG0TwEKyF6Wm974wRji6FLiKlonutO1Y+s8ek/nz2pVdptcg
	 7nktPTahKvROr39mdmZAyKgr2GbrvtpmDUeEQzng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 280/556] iio: pressure: dps310: fix NULL pointer dereference on ACPI probe
Date: Wed,  9 Sep 2026 15:39:20 +0200
Message-ID: <20260909134240.498714919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rupesh Majhi <zoone.rupert@gmail.com>

commit 26e9213898fc949923188ef0aeea31fc87708836 upstream.

When the device is enumerated through its ACPI HID (IFX3100),
i2c_client_get_device_id() returns NULL: the ACPI-derived client name
does not match the driver's i2c_device_id table. dps310_probe() then
dereferences that NULL pointer in "iio->name = id->name" and crashes the
kernel during probe.

The IIO device name is always "dps310", so set it directly and drop the
now-unused device-id lookup.

Fixes: 72ff282819d0 ("iio: pressure: dps310: Add ACPI HID table")
Cc: stable@vger.kernel.org
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/dps310.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -845,7 +845,6 @@ static const struct iio_info dps310_info
 
 static int dps310_probe(struct i2c_client *client)
 {
-	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	struct dps310_data *data;
 	struct iio_dev *iio;
 	int rc;
@@ -858,7 +857,7 @@ static int dps310_probe(struct i2c_clien
 	data->client = client;
 	mutex_init(&data->lock);
 
-	iio->name = id->name;
+	iio->name = DPS310_DEV_NAME;
 	iio->channels = dps310_channels;
 	iio->num_channels = ARRAY_SIZE(dps310_channels);
 	iio->info = &dps310_info;


