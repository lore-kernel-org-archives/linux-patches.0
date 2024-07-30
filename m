Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B9E18C915;
	Tue, 30 Jul 2024 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359278; cv=none; b=COs2KsdcWQ/XU29ObfBu+SjKwEyFHg5CRu2zCjanPqP+1Rxt3Z+Z6PmG+/O68lMf8ena3oCG/oD3f7fmuass3D5s8C5k2VyFHaYelKrdVIA74TXYKzGJMUY201eP/fDm72703y9jZ/s/d+19rdK1TTUwNQJdGdD5dChzBeRTPys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359278; c=relaxed/simple;
	bh=KXtu/QOHalU7pWg8kXmb9YmWWqNfZco33QO39rWhpYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYXaNpC9kaKqLbc+TA8zDzfYoTl138nC1zPjT6DaUy11Usq1cm4a0WVcj6XtcYHdui0ArIzwn85K4fbM0oDCt8NO1ER/n1D0G5N5t8Euu25wbPWBK/0Q9X7Z0fhmAs4LGZvSBdEBcyt3D7Db4Awz6ouMu9sHoEcg9V8VUQ/mf+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uw6XCJh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uw6XCJh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C153C32782;
	Tue, 30 Jul 2024 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359278;
	bh=KXtu/QOHalU7pWg8kXmb9YmWWqNfZco33QO39rWhpYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uw6XCJh5liyNbZ3dOrTMRCkTQS6Uv3xweKg2EqIzP6DbxlwVAUuWEvUTjshFcniJl
	 2SMBAQKnuaMsThwuHaifTFIsOZvQBMsfHC9WUYqbtRG0d4a4WTGfAWlZ9+cw+iB87l
	 gfS8zeyESuifnjsmw7ihKQdhC4U6N76SWin1KwMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 457/568] rtc: cmos: Fix return value of nvmem callbacks
Date: Tue, 30 Jul 2024 17:49:24 +0200
Message-ID: <20240730151657.882755482@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Joy Chakraborty <joychakr@google.com>

commit 1c184baccf0d5e2ef4cc1562261d0e48508a1c2b upstream.

Read/write callbacks registered with nvmem core expect 0 to be returned
on success and a negative value to be returned on failure.

cmos_nvram_read()/cmos_nvram_write() currently return the number of
bytes read or written, fix to return 0 on success and -EIO incase number
of bytes requested was not read or written.

Fixes: 8b5b7958fd1c ("rtc: cmos: use generic nvmem")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240612083635.1253039-1-joychakr@google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -643,11 +643,10 @@ static int cmos_nvram_read(void *priv, u
 			   size_t count)
 {
 	unsigned char *buf = val;
-	int	retval;
 
 	off += NVRAM_OFFSET;
 	spin_lock_irq(&rtc_lock);
-	for (retval = 0; count; count--, off++, retval++) {
+	for (; count; count--, off++) {
 		if (off < 128)
 			*buf++ = CMOS_READ(off);
 		else if (can_bank2)
@@ -657,7 +656,7 @@ static int cmos_nvram_read(void *priv, u
 	}
 	spin_unlock_irq(&rtc_lock);
 
-	return retval;
+	return count ? -EIO : 0;
 }
 
 static int cmos_nvram_write(void *priv, unsigned int off, void *val,
@@ -665,7 +664,6 @@ static int cmos_nvram_write(void *priv,
 {
 	struct cmos_rtc	*cmos = priv;
 	unsigned char	*buf = val;
-	int		retval;
 
 	/* NOTE:  on at least PCs and Ataris, the boot firmware uses a
 	 * checksum on part of the NVRAM data.  That's currently ignored
@@ -674,7 +672,7 @@ static int cmos_nvram_write(void *priv,
 	 */
 	off += NVRAM_OFFSET;
 	spin_lock_irq(&rtc_lock);
-	for (retval = 0; count; count--, off++, retval++) {
+	for (; count; count--, off++) {
 		/* don't trash RTC registers */
 		if (off == cmos->day_alrm
 				|| off == cmos->mon_alrm
@@ -689,7 +687,7 @@ static int cmos_nvram_write(void *priv,
 	}
 	spin_unlock_irq(&rtc_lock);
 
-	return retval;
+	return count ? -EIO : 0;
 }
 
 /*----------------------------------------------------------------*/


