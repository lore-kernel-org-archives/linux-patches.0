Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5E41DFDE;
	Thu, 15 Aug 2024 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731417; cv=none; b=H6KpiBET1n4+B8tTLUibuLoSJapLQobV73Ccew9wr6+1oDIsLeZkDDnl7Bw1zqygsJGY1eRFym6by0UDxNmwM87LFGpZH1lV/vHS2cAoKX9yxeAiHYrqgruzVmRm7TVAv2o7D+jRAh3OwXwQNRm05Z6ezb8+R4A40N5aWvcEb/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731417; c=relaxed/simple;
	bh=CgXbnyHfJJqGmyukvWnWkupXTjBlS9ABfxlds9W5syY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGjOOAuoyM0mX1kajhD94hYqxUCC3DHZo3aP24A8lDcmw+R1VUBmVHayRG4gtqxVGZkxsD2aGTIiDc2iKe7/vHfXY3uJBg63XcF2/nCHFt9M3e3wi1KicraodYeWVsH1qvYio6ghwWdmPrK6hM7VWVcfojZ4xvRFM70VZRsZYr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxjwg3BG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxjwg3BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D5FC4AF0E;
	Thu, 15 Aug 2024 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731416;
	bh=CgXbnyHfJJqGmyukvWnWkupXTjBlS9ABfxlds9W5syY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxjwg3BGp9xdbrAXmBzpO+/rA1NCQrBLBAnQ67CYK/G1GrSF3SsUM7+HV1K9KqzDV
	 geIEgo5DGVovJz45/ExOTW1Ib/dkwaLX0mBvyy2pN59bfxd8WW/Uv9zXgnCdxEEwtg
	 0MjuLieQXpx+bJGSUH1O1Idk25uZelqYydu03n+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 122/259] rtc: isl1208: Fix return value of nvmem callbacks
Date: Thu, 15 Aug 2024 15:24:15 +0200
Message-ID: <20240815131907.507945917@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Chakraborty <joychakr@google.com>

commit 70f1ae5f0e7f44edf842444044615da7b59838c1 upstream.

Read/write callbacks registered with nvmem core expect 0 to be returned
on success and a negative value to be returned on failure.

isl1208_nvmem_read()/isl1208_nvmem_write() currently return the number of
bytes read/written on success, fix to return 0 on success and negative on
failure.

Fixes: c3544f6f51ed ("rtc: isl1208: Add new style nvmem support to driver")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Link: https://lore.kernel.org/r/20240612080831.1227131-1-joychakr@google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-isl1208.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -743,14 +743,13 @@ static int isl1208_nvmem_read(void *priv
 {
 	struct isl1208_state *isl1208 = priv;
 	struct i2c_client *client = to_i2c_client(isl1208->rtc->dev.parent);
-	int ret;
 
 	/* nvmem sanitizes offset/count for us, but count==0 is possible */
 	if (!count)
 		return count;
-	ret = isl1208_i2c_read_regs(client, ISL1208_REG_USR1 + off, buf,
+
+	return isl1208_i2c_read_regs(client, ISL1208_REG_USR1 + off, buf,
 				    count);
-	return ret == 0 ? count : ret;
 }
 
 static int isl1208_nvmem_write(void *priv, unsigned int off, void *buf,
@@ -758,15 +757,13 @@ static int isl1208_nvmem_write(void *pri
 {
 	struct isl1208_state *isl1208 = priv;
 	struct i2c_client *client = to_i2c_client(isl1208->rtc->dev.parent);
-	int ret;
 
 	/* nvmem sanitizes off/count for us, but count==0 is possible */
 	if (!count)
 		return count;
-	ret = isl1208_i2c_set_regs(client, ISL1208_REG_USR1 + off, buf,
-				   count);
 
-	return ret == 0 ? count : ret;
+	return isl1208_i2c_set_regs(client, ISL1208_REG_USR1 + off, buf,
+				   count);
 }
 
 static const struct nvmem_config isl1208_nvmem_config = {


