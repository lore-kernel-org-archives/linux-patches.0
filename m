Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F239446EF94;
	Tue, 21 Jul 2026 20:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664973; cv=none; b=q8djsYR/tRaE9OzgKjeqphtfLBcvWeEQBNsKcEf6XSdmJq3v1Nd1bdi7oshGfB88YlJITGWiyloaIP6yqixXG3XNM1Vemxwx6rbaa8ozAgBJ5xxP+/CXqAYIL5nRZvbRDtqGy4Nuth6XyefsvOiMUB0hIMovjs5Dr0+7F4roN8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664973; c=relaxed/simple;
	bh=+vnfKOZ4nfAI3Ty0x4dlPXS5nSyOBazyRtJGJbjpF04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1SjF8IHuwyqtGtYbnkLJ1izo4R8rf+cz7+KrXuftDx84xNEVDx2ngvIiB4rfGCBh/Z4k0f4DLCea7p8CSOhgimxsM700Rfj8w01dgFsrgFVhYWepmcrLdCnYkLclQ3jfj5f3kW9QZHbKTRBWbhz7veXPpeX1wlcfjGxmIHFHCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhElh4PI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhElh4PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CE41F000E9;
	Tue, 21 Jul 2026 20:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664970;
	bh=x1bZu+KMa6styknAbtiaT6Cb7IMCkbzqpxzH5+gzmdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uhElh4PIk6vJGhNjIrYhpJvM82nirp4H705Wtl7YDH6G96TiyQqFTQNvZBDWCxiuG
	 vCmw9+ENnWF+HspsLyueCk0Jv4mJvRXvBEF56Lrgw84jQVxF2CuCtdcMerNAJXQq10
	 JgVO7EPlhlPQjDs06C0+jh3gnWWyBG3nIDOWuTGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0091/1266] iio: gyro: bmg160: wait full startup time after mode change at probe
Date: Tue, 21 Jul 2026 17:08:48 +0200
Message-ID: <20260721152443.841674494@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

commit 088fcb9b567f8723074ad9eb1bf5cb46f8a0096b upstream.

bmg160_chip_init() calls bmg160_set_mode(BMG160_MODE_NORMAL) and
then waits only 500-1000 us. Per the BMG160 datasheet
(BST-BMG160-DS000-07 Rev. 1.0, May 2013), the start-up and wake-up
times (tsu, twusm) are 30 ms.

The same file already waits BMG160_MAX_STARTUP_TIME_MS (80 ms)
in bmg160_runtime_resume() after the same set_mode(NORMAL)
operation. The 500 us value at probe was likely a unit mix-up;
the old comment said "500 ms" while the code used microseconds.

Reuse the same constant via msleep() and add a code comment
explaining the datasheet basis for the wait. Without this,
register writes that follow the mode change can hit the chip
before it is ready.

Fixes: 22b46c45fb9b ("iio:gyro:bmg160 Gyro Sensor driver")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/bmg160_core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -267,8 +267,14 @@ static int bmg160_chip_init(struct bmg16
 	if (ret < 0)
 		return ret;
 
-	/* Wait upto 500 ms to be ready after changing mode */
-	usleep_range(500, 1000);
+	/*
+	 * Wait for the chip to be ready after switching to normal mode.
+	 * The BMG160 datasheet (BST-BMG160-DS000-07 Rev. 1.0, May 2013)
+	 * specifies a start-up / wake-up time (tsu, twusm) of 30 ms; use
+	 * BMG160_MAX_STARTUP_TIME_MS (80 ms) as a safety margin, matching
+	 * what bmg160_runtime_resume() already does.
+	 */
+	msleep(BMG160_MAX_STARTUP_TIME_MS);
 
 	/* Set Bandwidth */
 	ret = bmg160_set_bw(data, BMG160_DEF_BW);


