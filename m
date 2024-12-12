Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03495241F2C;
	Thu, 12 Dec 2024 16:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021393; cv=none; b=eCICWPdbnFGNTJxXgxePDBIZ1fsa1PwXiBlLlzoGgZvRY/RxGoDwQajAvyrkjSOPfLuNPx0sdJV1iBbY5k122AbTzmuNo9VRtX45U8y9fn8NTCf2PbUoMpOdiUsht5DGtpguDr/iZgDDfa5eiq6ETa9YH7BtoKt3KlVb7pI6umU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021393; c=relaxed/simple;
	bh=Dnq4+UiVG61FBKM5mEiZw9Ig1kYHnV17Hq6X/A87NRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyphebPTiSqGFWABZXD8ODW3VkBBT9pSm8aHz5Zp+AARudySt8ByzE5uiWuoNeYGlvO7F/Qh6XVuuVbZd+54Q69YijrpcGan2m4iW6oGB3MWJ1GTe/hjXET/oqpiSsanQ53lqD0ci2TkKHtg0Es7WQd8VrSc6TchH242Xz8FviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0ZL78fV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0ZL78fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6785BC4CECE;
	Thu, 12 Dec 2024 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021392;
	bh=Dnq4+UiVG61FBKM5mEiZw9Ig1kYHnV17Hq6X/A87NRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0ZL78fVub4hJ2GkOKXZakNNtkZ+jz9rEZBEvoG+HZAZj+tmSd7Z2qTWpcCnTYyhO
	 4dBD/nQ5OdJQfytKTkwI0US4pLnhCqdMOl3+NdKfsMeSySrRW3ueW++xoW6GSNjz9G
	 7skTxmkRzITMoLLfMKIEMLgTYavk54JLdZaV1Y7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 726/772] rtc: cmos: avoid taking rtc_lock for extended period of time
Date: Thu, 12 Dec 2024 16:01:11 +0100
Message-ID: <20241212144419.888836551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 0a6efab33eab4e973db26d9f90c3e97a7a82e399 ]

On my device reading entirety of /sys/devices/pnp0/00:03/cmos_nvram0/nvmem
takes about 9 msec during which time interrupts are off on the CPU that
does the read and the thread that performs the read can not be migrated
or preempted by another higher priority thread (RT or not).

Allow readers and writers be preempted by taking and releasing rtc_lock
spinlock for each individual byte read or written rather than once per
read/write request.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Link: https://lore.kernel.org/r/Zxv8QWR21AV4ztC5@google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 542568cd72b32..5f43773900d18 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -645,18 +645,17 @@ static int cmos_nvram_read(void *priv, unsigned int off, void *val,
 	unsigned char *buf = val;
 
 	off += NVRAM_OFFSET;
-	spin_lock_irq(&rtc_lock);
-	for (; count; count--, off++) {
+	for (; count; count--, off++, buf++) {
+		guard(spinlock_irq)(&rtc_lock);
 		if (off < 128)
-			*buf++ = CMOS_READ(off);
+			*buf = CMOS_READ(off);
 		else if (can_bank2)
-			*buf++ = cmos_read_bank2(off);
+			*buf = cmos_read_bank2(off);
 		else
-			break;
+			return -EIO;
 	}
-	spin_unlock_irq(&rtc_lock);
 
-	return count ? -EIO : 0;
+	return 0;
 }
 
 static int cmos_nvram_write(void *priv, unsigned int off, void *val,
@@ -671,23 +670,23 @@ static int cmos_nvram_write(void *priv, unsigned int off, void *val,
 	 * NVRAM to update, updating checksums is also part of its job.
 	 */
 	off += NVRAM_OFFSET;
-	spin_lock_irq(&rtc_lock);
-	for (; count; count--, off++) {
+	for (; count; count--, off++, buf++) {
 		/* don't trash RTC registers */
 		if (off == cmos->day_alrm
 				|| off == cmos->mon_alrm
 				|| off == cmos->century)
-			buf++;
-		else if (off < 128)
-			CMOS_WRITE(*buf++, off);
+			continue;
+
+		guard(spinlock_irq)(&rtc_lock);
+		if (off < 128)
+			CMOS_WRITE(*buf, off);
 		else if (can_bank2)
-			cmos_write_bank2(*buf++, off);
+			cmos_write_bank2(*buf, off);
 		else
-			break;
+			return -EIO;
 	}
-	spin_unlock_irq(&rtc_lock);
 
-	return count ? -EIO : 0;
+	return 0;
 }
 
 /*----------------------------------------------------------------*/
-- 
2.43.0



