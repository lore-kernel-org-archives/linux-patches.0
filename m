Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5DC35C6AC;
	Tue, 21 Jul 2026 22:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673236; cv=none; b=TuQOXCDEsRYBBYADLnu8p3zdly3G14lCBm4EPLGraTjH/sP31gIJVq1yJ4PYczVh/wKecJIQGk7D+825q9gJLG88mi91BM3U+tO2wktGwHPq5ye9e+vojpdoMUtu1368GNXXClhKCqbRlx+3Kx+nQ4Migo+GIWYdvaREvH/+voU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673236; c=relaxed/simple;
	bh=5X0jQJLwgpWDkNwuGJ6e0BYO+OKSYD2QmJZGTeHTStE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZCXc8tiWbhQDHIy9yOByfYcQF6uvTKsbZYP3nUPQkYAm5pJF+BNm8zN/ZBioFFvMlNlq4EtKr7UHly1d9RMzbJyKLpNGRQY6iDyfeTUeB+PZ7nXP3WZf5Ngyy95gQBDDYH4UPLyEpUlJ8689eVCSpYIW7KWut/FVZKj1mV5pfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/k6zLIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/k6zLIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A105F1F000E9;
	Tue, 21 Jul 2026 22:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673235;
	bh=AVQGomyNHtdD89lUWpkyubgZosOzI6RJmxBC90oHOBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/k6zLIne6FpwFU4qe+fluyRlv6t/fV+udZBRH7gKA1F34ISOfZIBIw2QnilOBUiH
	 szN5/vzZAJF/FIeuyt2A0c/MfPiubvrn3W6wHZXzYnWFIA26IRJ5ktLwxDb6KFJ3v0
	 j583Zlo4XB0ePwXUXSLMHoKV/7K08X30fjr2UzW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 042/699] iio: gyro: bmg160: wait full startup time after mode change at probe
Date: Tue, 21 Jul 2026 17:16:41 +0200
Message-ID: <20260721152356.659317252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -266,8 +266,14 @@ static int bmg160_chip_init(struct bmg16
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


