Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851A841F5EB;
	Thu, 16 Jul 2026 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209093; cv=none; b=Nd/lLkmjvQvWnGG9eQu2M3f4yeJJ3OCVBJu8qwZgzNRfg4B+D0mUhUfgjbcrEtVHvuB9wsR3kJAtibbdD0RA6X7kYGFKOwDV/MC3w6H1FJ0ZVGafVY5p5m4lPr1bpgdW2vVvl+nZTGTsGqEG8XPpnwjYWVUhR6r+DiPQwylJZWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209093; c=relaxed/simple;
	bh=4ggz+BmJdFU21Mv7PfbfNjqjkzB7OIVdQMyVXBsXWeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R96h9sV0auvx6pJOwJOMvDbRNktyA6A7R9utUs37VsmoviObMly+EiAje4XSx8eyG0BxXKQe8COKvfYOTeFRV/42Xe6jipEVk+4y6QUplj7cDgWPRjQiFDPy5771QGBDiOwaCuvHxf+Ev009XLKmNmb6CKgR0Jrbu4a9uFbfxrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsIVELre; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsIVELre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CD01F000E9;
	Thu, 16 Jul 2026 13:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209092;
	bh=YUnifVVIOZ6hRmVS0JbGGtI/niTYC4N+Aa0+7PNGB1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsIVELre/xrZqi/Z8fRVa1YyqzXeVe7EbM32bzY+CupGRD3rrbiZeqcRsgDLAJUpQ
	 5hXgA0bdXhypvWP7EkuWF3+YQWSfb+tETY0EAPsuDz+PkokBX4V6lBuGqpARljyTV8
	 AWtXINIjwvRR60mU74g2FmHkhI2MGO08uHnd/oXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 054/518] iio: gyro: bmg160: wait full startup time after mode change at probe
Date: Thu, 16 Jul 2026 15:25:22 +0200
Message-ID: <20260716133048.970367198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -264,8 +264,14 @@ static int bmg160_chip_init(struct bmg16
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


