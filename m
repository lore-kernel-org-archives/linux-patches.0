Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA9832143D;
	Sun,  7 Jun 2026 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827752; cv=none; b=prxikFdM39UKsiDzwBq1XZyDgmN8m/Ri+ylLtSfAv7PNgjHsQdwHfGUpzsXiNYbs5d9Vf+x7B6xoOr+wEtIQ8YuchIDWyvn+KmnG2EZx5EngbjiQF+Ecx+j5Jcfr7jv7ow1ABNa4epwTTq+kWN7igTk21vO07dta5h1jDc00OAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827752; c=relaxed/simple;
	bh=8Yez7Q5s08A6ezYFfwjfJFUIrCQdAdZXVmtq3BXpxzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/pXoiOIytFnfjIltjPx/oJHmRKxSXwjd2h4101/ogmyZdT89fckBA2bkAtHlVgVBNrwCG7cr7z4+zwmrv9cBjKONXLDUovV6DwCm2iyBNt8XvwJ9lq185nmMLas963t/aQAolbGYTHV1gwzMaFCAaqovZv9xGSxzYXiy/MiRwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1VYq+g2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1VYq+g2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E391F00893;
	Sun,  7 Jun 2026 10:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827750;
	bh=FfGu/DlmdDGzU02x3H671MCrhLj0560uTwMNjh4Z5Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1VYq+g2B51DnLBWraVCHXIFBvx9Q0WahVDzEGnkwdEh3560of59WBgN8Vy/08rTc
	 Y7PCoZ3wykXYunDJ2XK/kY25c9KmB7mpoPFYjnyRRB8iv4PJdozWd4AbVf2S0Pf6hb
	 C6q/IwVDYHxYOec34EQH9takebt7F2EaHF/mNxoA=
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
Subject: [PATCH 7.0 119/332] iio: imu: adis16550: fix stack leak in trigger handler
Date: Sun,  7 Jun 2026 11:58:08 +0200
Message-ID: <20260607095732.483634970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


