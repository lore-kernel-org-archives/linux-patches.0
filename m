Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0CE1ADC83;
	Mon,  4 May 2026 14:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903781; cv=none; b=LqIQ3ruyCKGSu5RA78j2eHPtkAKBHTveZIiINnrclvMeHVtaHG5bSmjkgvMJi+a5mQHHJFnIPiAmuov8MtBD4PAVgSHmbg0nmoppGAb3bovY7EMG7eg2KzhRIjEndttSvqmYOT4nfaPyKkwH80Ms39ifQMyYCyenDix/0UfvpUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903781; c=relaxed/simple;
	bh=qwW0R1iSaaC9y73sCITf5w8wGPJLOoxhs6B4t5ljCiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FS4A6G3PW4b1jn0lo1Kr69RedPdAY7oo9WCXr6klr+J2cewEM0lMs6axyGVk12SkW4o94Ct3CeFlbCb+IB91Np0Ov+spAyLXu+w04ERFx1efdhCf5n8p7x9v3Ob767v6DDArMDc+MOnj/2uq9qBnDXSEf8+Cb4WwB+A5J7R6OY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WniD3s9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WniD3s9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D4FC2BCC4;
	Mon,  4 May 2026 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903781;
	bh=qwW0R1iSaaC9y73sCITf5w8wGPJLOoxhs6B4t5ljCiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WniD3s9X/ZLqbyxGp3n87nNrIRAOOHp4fYUWjSZcrFlingGu5M2Ss2gqAGJMXrpSC
	 MfAaRbtcFakmpd6tJlTxMiBI7n3mTMauEReOhUMF24hkGd8/KTAUFUi9HdSbSYaYj5
	 D0dlWVtu0cS2AwsKxR1PrngX868I4f8sAXe4q/8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 052/275] crypto: atmel-sha204a - Fix OTP sysfs read and error handling
Date: Mon,  4 May 2026 15:49:52 +0200
Message-ID: <20260504135144.868749118@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 635c3a757a567b2479639237f5f0d4d9439015f1 upstream.

Fix otp_show() to read and print all 64 bytes of the OTP zone.
Previously, the loop only printed half of the OTP (32 bytes), and
partial output was returned on read errors.

Propagate the actual error from atmel_sha204a_otp_read() instead of
producing partial output.

Replace sprintf() with sysfs_emit_at(), which is preferred for
formatting sysfs output because it provides safer bounds checking.

Cc: stable@vger.kernel.org
Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Lothar Rubusch <l.rubusch@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/sysfs.h>
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
@@ -120,21 +121,22 @@ static ssize_t otp_show(struct device *d
 {
 	u16 addr;
 	u8 otp[OTP_ZONE_SIZE];
-	char *str = buf;
 	struct i2c_client *client = to_i2c_client(dev);
-	int i;
+	ssize_t len = 0;
+	int i, ret;
 
-	for (addr = 0; addr < OTP_ZONE_SIZE/4; addr++) {
-		if (atmel_sha204a_otp_read(client, addr, otp + addr * 4) < 0) {
+	for (addr = 0; addr < OTP_ZONE_SIZE / 4; addr++) {
+		ret = atmel_sha204a_otp_read(client, addr, otp + addr * 4);
+		if (ret < 0) {
 			dev_err(dev, "failed to read otp zone\n");
-			break;
+			return ret;
 		}
 	}
 
-	for (i = 0; i < addr*2; i++)
-		str += sprintf(str, "%02X", otp[i]);
-	str += sprintf(str, "\n");
-	return str - buf;
+	for (i = 0; i < OTP_ZONE_SIZE; i++)
+		len += sysfs_emit_at(buf, len, "%02X", otp[i]);
+	len += sysfs_emit_at(buf, len, "\n");
+	return len;
 }
 static DEVICE_ATTR_RO(otp);
 


