Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EC7350A0D;
	Tue, 21 Oct 2025 20:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077157; cv=none; b=SzQzowvt3D17bqiDqCtUdYocasNbu2VR0yr3qXL93QoJN0XI8wlJ0VNKwcWGbuDZpY3MpE3nSyYnOyKzT+DTvYPLI2V6PbI6srww+nP620eK3v2v2bWc4eqybpI6XOTSH3JCIH/mQ4yR/4hJ12iVbieRruF3yJxz02sQOa9dgMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077157; c=relaxed/simple;
	bh=IEL86cIiwjT8wLyAsMTKcacOLRcekKgDRc+pjkli5Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puwEjrKZ+F4DRg0VQEkfS+1AJhPYZqMOuoeeSzvspi1J7M8ZaQJsGwvDVtGAuKyK3wmEyl3N40FNCF/J0+Qw2LGMFY6NqM95pCSWUJWQo+VHBlo3i6hIWJ4YfUezVfsL85WtO33jxketON+hzEB15qJ8WzWYauD2fRixzMMuuzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oUm07dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oUm07dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29A6C4CEF1;
	Tue, 21 Oct 2025 20:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077157;
	bh=IEL86cIiwjT8wLyAsMTKcacOLRcekKgDRc+pjkli5Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oUm07dwcZB+XM2GSYAXHusSfm0HmfGHbS9QwBfF28E/yagUE+6uv6Dg2PiZaoFy6
	 UkdV3NXHabYvzq0wDo9BIvnFOGuWSwVz1tvjC3069WM4Uv7aFra1UfgzdkuOsbPp2m
	 seyHrPU8r9TxiT1JlUPe2sH6VBz7QyOZTW14stHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.17 018/159] net: usb: lan78xx: Fix lost EEPROM write timeout error(-ETIMEDOUT) in lan78xx_write_raw_eeprom
Date: Tue, 21 Oct 2025 21:49:55 +0200
Message-ID: <20251021195043.625192667@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

commit d5d790ba1558dbb8d179054f514476e2ee970b8e upstream.

The function lan78xx_write_raw_eeprom failed to properly propagate EEPROM
write timeout errors (-ETIMEDOUT). In the timeout  fallthrough path, it first
attempted to restore the pin configuration for LED outputs and then
returned only the status of that restore operation, discarding the
original timeout error saved in ret.

As a result, callers could mistakenly treat EEPROM write operation as
successful even though the EEPROM write had actually timed out with no
or partial data write.

To fix this, handle errors in restoring the LED pin configuration separately.
If the restore succeeds, return any prior EEPROM write timeout error saved
in ret to the caller.

Suggested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Fixes: 8b1b2ca83b20 ("net: usb: lan78xx: Improve error handling in EEPROM and OTP operations")
cc: stable@vger.kernel.org
Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1174,10 +1174,13 @@ static int lan78xx_write_raw_eeprom(stru
 	}
 
 write_raw_eeprom_done:
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
 
 static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,


