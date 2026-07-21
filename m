Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036203BCD29;
	Tue, 21 Jul 2026 21:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669286; cv=none; b=LYN5wIrbE46mASn6S/voay93fErnQzkCpvlj8zIrW2W+NSLWMgH/q/Iy3iB72Tqq/x0HtwLG65MP4JbjB0RT35IILHP/5L0RkARHN8Pgy9t69evP5luqVTln/1JLOwBAlAkJYotwCRpQu8i+xaxuJbM7t/zvtaYlyGzJO32zsDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669286; c=relaxed/simple;
	bh=+Y5G3JLKRnEjLUGgzVLceU1yImAekD8QrKMDfzp0lJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIPDgxpi/Se9wKIbDYaFU4Z/M28n1udkBMrj6WwSVDFs1bOAMZeJN+ZgQEsuT8StAjVF0tpHDIj+03Q4TYejvUR6edY8498Pm93xX/i8kuw6pWVfZFlv3zYMldDXaRvqo7Xsj+75yGonjeSFtH+xQ6l3Hd8NBSiMpkJEEF+cRV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sHSRRs9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sHSRRs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0851F00A3E;
	Tue, 21 Jul 2026 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669277;
	bh=bn0wL/24N2SxLS8PGdvhLF0zbjz/stVmM0fcA7ZO0qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sHSRRs9z3ZFqvEC/z9Q7AKHmuhxX3N1tR008Mnf/0WGJonuxgLZLo4+idTcXc6rq
	 xF5dl69qo41Xo5zDa2BNqe0EZosq7ncXQszUUGswSKlC4xbEGrks9PIcX43XS2DkX7
	 FkTpP7GLZTZeFzGEcI9HP+K0UfurRCLH5KG8lQFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0494/1067] iio: accel: mma8452: handle I2C read error(s) in mma8452_read()
Date: Tue, 21 Jul 2026 17:18:15 +0200
Message-ID: <20260721152435.663905339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index ad7b7770d52628..28002c714ea98d 100644
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



