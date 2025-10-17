Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C4E32C951;
	Fri, 17 Oct 2025 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715050; cv=none; b=PsFn6ub6sX72MwyzDJ5dFgbWxtcTu/bbLQSqqrONr05uiZe70U5bkhKy9uzwUGybsekxt7XvDFboMdRSW93yovVp7/WBN4M61BndtqT/NOOyoG7+gojYkFilXtHOVwOmeJjluiBaDVdxwHCA3lGeqVf8U6TOPS0OGZZckbW/PUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715050; c=relaxed/simple;
	bh=cVmkrE9woRDMgW15j+B/ZgO1ksUIRhI9gd125U0twNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXOdORlNSecnbPqQfzebvw1WGGxG1113bW67OWAoCRmniEhxCvaGRPg/iLdGxGviO6teWRz8W4KopLqeirysOWQn+6cnZH4dVt7guytKoOrSVVaD3Ofz+i++oZNwtNShJK/zRI5D+OT1/XZkbetzfOMHb3C7mlMuFEPevpRGBnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeegNrwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeegNrwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BD7C4CEFE;
	Fri, 17 Oct 2025 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715049;
	bh=cVmkrE9woRDMgW15j+B/ZgO1ksUIRhI9gd125U0twNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeegNrwbe6S59X6Vjgzt2rJD/v1qtIB8XkljlPiOxni1MknBIQmRMQp39RO32FDf2
	 wxr4eXk/9D0KZXZfVa30183CETL5hkD8O3jZK0/uNuOXH/U7cv0T7q62AWgv0iMNE9
	 GPXKqWZPBjd6ECpb/cW4UPdZcSV77wG7fnZvD8gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+62ec8226f01cb4ca19d9@syzkaller.appspotmail.com,
	Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 080/371] net: usb: lan78xx: Fix lost EEPROM read timeout error(-ETIMEDOUT) in lan78xx_read_raw_eeprom
Date: Fri, 17 Oct 2025 16:50:55 +0200
Message-ID: <20251017145204.833916264@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>

[ Upstream commit 49bdb63ff64469a6de8ea901aef123c75be9bbe7 ]

Syzbot reported read of uninitialized variable BUG with following call stack.

lan78xx 8-1:1.0 (unnamed net_device) (uninitialized): EEPROM read operation timeout
=====================================================
BUG: KMSAN: uninit-value in lan78xx_read_eeprom drivers/net/usb/lan78xx.c:1095 [inline]
BUG: KMSAN: uninit-value in lan78xx_init_mac_address drivers/net/usb/lan78xx.c:1937 [inline]
BUG: KMSAN: uninit-value in lan78xx_reset+0x999/0x2cd0 drivers/net/usb/lan78xx.c:3241
 lan78xx_read_eeprom drivers/net/usb/lan78xx.c:1095 [inline]
 lan78xx_init_mac_address drivers/net/usb/lan78xx.c:1937 [inline]
 lan78xx_reset+0x999/0x2cd0 drivers/net/usb/lan78xx.c:3241
 lan78xx_bind+0x711/0x1690 drivers/net/usb/lan78xx.c:3766
 lan78xx_probe+0x225c/0x3310 drivers/net/usb/lan78xx.c:4707

Local variable sig.i.i created at:
 lan78xx_read_eeprom drivers/net/usb/lan78xx.c:1092 [inline]
 lan78xx_init_mac_address drivers/net/usb/lan78xx.c:1937 [inline]
 lan78xx_reset+0x77e/0x2cd0 drivers/net/usb/lan78xx.c:3241
 lan78xx_bind+0x711/0x1690 drivers/net/usb/lan78xx.c:3766

The function lan78xx_read_raw_eeprom failed to properly propagate EEPROM
read timeout errors (-ETIMEDOUT). In the fallthrough path, it first
attempted to restore the pin configuration for LED outputs and then
returned only the status of that restore operation, discarding the
original timeout error.

As a result, callers could mistakenly treat the data buffer as valid
even though the EEPROM read had actually timed out with no data or partial
data.

To fix this, handle errors in restoring the LED pin configuration separately.
If the restore succeeds, return any prior EEPROM timeout error correctly
to the caller.

Reported-by: syzbot+62ec8226f01cb4ca19d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62ec8226f01cb4ca19d9
Fixes: 8b1b2ca83b20 ("net: usb: lan78xx: Improve error handling in EEPROM and OTP operations")
Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250930084902.19062-1-bhanuseshukumar@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 1ff25f57329a8..d75502ebbc0d9 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1079,10 +1079,13 @@ static int lan78xx_read_raw_eeprom(struct lan78xx_net *dev, u32 offset,
 	}
 
 read_raw_eeprom_done:
-	if (dev->chipid == ID_REV_CHIP_ID_7800_)
-		return lan78xx_write_reg(dev, HW_CFG, saved);
-
-	return 0;
+	if (dev->chipid == ID_REV_CHIP_ID_7800_) {
+		int rc = lan78xx_write_reg(dev, HW_CFG, saved);
+		/* If USB fails, there is nothing to do */
+		if (rc < 0)
+			return rc;
+	}
+	return ret;
 }
 
 static int lan78xx_read_eeprom(struct lan78xx_net *dev, u32 offset,
-- 
2.51.0



