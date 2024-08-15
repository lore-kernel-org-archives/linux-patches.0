Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED49014AD0A;
	Thu, 15 Aug 2024 14:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732386; cv=none; b=hy3JnUpws8h502kS91HHsXU3alA0F+iKZcaB9pvZdLaZNoaKbdsuDerNaC2PDyd8oFCn0E7BLGTKZ9lIh38PyamFS9cXFQLrQThNHa2GhI2I2nQsxXwZbTgVmqZha3YJt7wY3+YJyhTK/7iokcUXG4QnpIVp+Qhn9Bq4L53bTXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732386; c=relaxed/simple;
	bh=OjRzaH/SPqNWVs/rfsHhhrNacdQRdrfSknWzMA9THj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcUICVXDRdPWG6lMZycLhscePyPE9m9eNsd18ut2k11+hKEPN1jUeKH+9HW/uFY57bSzcgresSqcVTTay+NFaQic0YFtjA01zPnA5vMkpxTSkCmv3KrJ9BiZY0oj7eJqR9r2r9g7Hnh6hkZ76N/B4NVnmUDhfOwNIImmuRqnnWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rliQUgb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rliQUgb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F770C32786;
	Thu, 15 Aug 2024 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732385;
	bh=OjRzaH/SPqNWVs/rfsHhhrNacdQRdrfSknWzMA9THj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rliQUgb3vZhLJ5jJenIxmfLEyYjn8Zm9/xerwvFbaS6ANKr2HyGTUtWlSPysctvVl
	 pLgLgJT629UFmJTaYhsHmEr8Y2B3xrmazoNWrYpwTx6OPTcGNvQigKQEs0dE9/hME2
	 d8QRNedVvQf5urs1fkLyyS0/13+mkptCIQI+F2s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 164/352] rtc: cmos: Fix return value of nvmem callbacks
Date: Thu, 15 Aug 2024 15:23:50 +0200
Message-ID: <20240815131925.610028593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -649,11 +649,10 @@ static int cmos_nvram_read(void *priv, u
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
@@ -663,7 +662,7 @@ static int cmos_nvram_read(void *priv, u
 	}
 	spin_unlock_irq(&rtc_lock);
 
-	return retval;
+	return count ? -EIO : 0;
 }
 
 static int cmos_nvram_write(void *priv, unsigned int off, void *val,
@@ -671,7 +670,6 @@ static int cmos_nvram_write(void *priv,
 {
 	struct cmos_rtc	*cmos = priv;
 	unsigned char	*buf = val;
-	int		retval;
 
 	/* NOTE:  on at least PCs and Ataris, the boot firmware uses a
 	 * checksum on part of the NVRAM data.  That's currently ignored
@@ -680,7 +678,7 @@ static int cmos_nvram_write(void *priv,
 	 */
 	off += NVRAM_OFFSET;
 	spin_lock_irq(&rtc_lock);
-	for (retval = 0; count; count--, off++, retval++) {
+	for (; count; count--, off++) {
 		/* don't trash RTC registers */
 		if (off == cmos->day_alrm
 				|| off == cmos->mon_alrm
@@ -695,7 +693,7 @@ static int cmos_nvram_write(void *priv,
 	}
 	spin_unlock_irq(&rtc_lock);
 
-	return retval;
+	return count ? -EIO : 0;
 }
 
 /*----------------------------------------------------------------*/


