Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE05C320A37;
	Sun,  7 Jun 2026 10:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827847; cv=none; b=c3oeKrj1APR7q3arzjIaK7l1qTmKIGUdg7OSjiLtAiS9bdFmMZi9iOG++pT+EFOZp6JhywNROWpAMTYkdV9cg/fnoEcbG5Pxi8uSmv6MqlJJ0aUXwLcIHAZynfAsvolC+p+y87Qg+KG3giC6+u7ly6XcQ/9HAZNK8LROfsNr6qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827847; c=relaxed/simple;
	bh=FGzg3kRUoSzvSxNZ1eUmxVrz4bVkEgLKLLBkZeYYgFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MbIwSBUdT7L/QmOo3VKc8A1XP1C3epUQ/5DjmEhhRVuV+fd59e00CDwOeGMZrbbiG3KXL+sUG/kWG29VEe8rMo9kCYVBvpTGkdDzbzG3/OLiYIKKLlV7jkXYfb+jFawfOpJipIFozM2SJlE3gjHK+ky5gEpa529H6kZgW4C+2fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ks8578sZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ks8578sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9831F00893;
	Sun,  7 Jun 2026 10:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827846;
	bh=R7oOpDNWfQBGfV9aHBMRj3g6dcpQhCfLxGQg++QBhOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ks8578sZgHcc0wOSyoOXgS+0MzASk6pQA4s7b5kib0vJ6SlAzluPNsd9Io1z9AXQM
	 Iszq6Sdm+cjXR8Mu/WSf40D7+nSXt91IHyMqBw1T3VNmz2kQ+EIa8pzSBajiysJh0E
	 Eki3uY/I95dBU4PzEtiJuttM+1DZgveSf9UHmam4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 105/315] iio: imu: adis16550: fix stack leak in trigger handler
Date: Sun,  7 Jun 2026 11:58:12 +0200
Message-ID: <20260607095731.502250534@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 474f8928d50b09f7dcf507049f08732640b88b49 upstream.

adis16550_trigger_handler() declares the scan data array on the stack
without initializing it.  The memcpy() at the bottom fills only the
first 28 bytes (TEMP + 6 channels of GYRO/ACCEL data), and
iio_push_to_buffers_with_timestamp() writes the s64 timestamp at the
8-byte-aligned offset 32.  Bytes 28-31 remain uninitialized stack data
which leaks to userspace on ever trigger.

Fix this all by just zero-initializing the structure on the stack.

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Michael Hennerich <Michael.Hennerich@analog.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: David Lechner <dlechner@baylibre.com>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Andy Shevchenko <andy@kernel.org>
Fixes: e4570f4bb231 ("iio: imu: adis16550: align buffers for timestamp")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16550.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16550.c
+++ b/drivers/iio/imu/adis16550.c
@@ -836,7 +836,7 @@ static irqreturn_t adis16550_trigger_han
 	u16 dummy;
 	bool valid;
 	struct iio_poll_func *pf = p;
-	__be32 data[ADIS16550_MAX_SCAN_DATA] __aligned(8);
+	__be32 data[ADIS16550_MAX_SCAN_DATA] __aligned(8) = { };
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct adis16550 *st = iio_priv(indio_dev);
 	struct adis *adis = iio_device_get_drvdata(indio_dev);


