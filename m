Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7611C5F27;
	Sun,  7 Jun 2026 10:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827993; cv=none; b=UJtVDDbtRTgqszCQRw54yeXqzq/2yR52QHdGAlc0Bp7sdMM8CAbqKOl2Lua6EumYFlUsiZQttr2OGPxCz+jYwe0yedGG4v2Zo5adg8On2f0y1I9nbBp3FhnycprByXrIVGU8RjZ7sZn2/Ghp60qcfVEYecCqAUU3e8/qAbFdn7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827993; c=relaxed/simple;
	bh=3axEpx2MmhcVEZFpLa/XpRYjtFxpgAHj5xych7E/muw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXgPCljynnAaewkF1AUZG4GDCqKw5B27YI7jV+1gK+jFeLqDEpsklemIJU2Zn5TbIuuSp6kM69TibtCW+tfJvtg5Thb2BWIiIxpBsTalANMqK2u2doLHocHsHUanNZI9WDebM1po9PNsbRlc9rC6O9+fzMdf3JRHEtXtfdIp0h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ19HJOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ19HJOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E41F00893;
	Sun,  7 Jun 2026 10:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827992;
	bh=1DhUpT3n9jLA1L7sJG8TvAG9gRI3sUHjeBjU8ojYP8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZ19HJOhnJ2ump+k8NNyD49vsn+hM8tQo5IEcsLK6PsCix3/QT2aKq4u+9Ql/hxki
	 Lwo4XZmrbHGsOVn8V1NsUO2hEXLZZ2AcYSwC4XCUWrpT9l4ccTHDv5lrexy+TTz6DS
	 tvN/fVwgJ8TtIrVZS8cbrdhvzWWr8ohk9H0DuVvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 106/315] iio: pressure: bmp280: fix stack leak in bmp580 trigger handler
Date: Sun,  7 Jun 2026 11:58:13 +0200
Message-ID: <20260607095731.540239441@linuxfoundation.org>
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

commit 387c86b582e0782ab332e7bfcd4e6e3f93922961 upstream.

bmp580_trigger_handler() declares its scan buffer on the stack without
an initializer and then memcpy()s 3 bytes of 24-bit sensor data into
each 4-byte __le32 field.  The high byte of comp_temp and comp_press is
left uninitialized, and the channel storagebits is 32, so two bytes of
stack are pushed to userspace per scan.

This is a regression from when the buffer lived in the private data, the
move to a stack-local struct dropped the implicit zeroing.
bme280_trigger_handler() was fixed up to handle this bug, but this
driver was not fixed because there was no padding hole, but rather a
short-fill issue.

Fix this all by just zero-initializing the structure on the stack.

Cc: Jonathan Cameron <jic23@kernel.org>
Cc: David Lechner <dlechner@baylibre.com>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Andy Shevchenko <andy@kernel.org>
Fixes: 872c8014e05e ("iio: pressure: bmp280: drop sensor_data array")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index d983ce9c0b99..9b489766e457 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -2616,7 +2616,7 @@ static irqreturn_t bmp580_trigger_handler(int irq, void *p)
 		__le32 comp_temp;
 		__le32 comp_press;
 		aligned_s64 timestamp;
-	} buffer;
+	} buffer = { };
 	int ret;
 
 	guard(mutex)(&data->lock);
-- 
2.54.0



