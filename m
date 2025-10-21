Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A339350A07;
	Tue, 21 Oct 2025 20:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077533; cv=none; b=NHMfH+PymC+4BmEtV6lyXSFKeFgHco/0ih7gWzKfCTCRTQzps32uDrbqVtUMOJ6w+idJ0xQKg4q3dlMRAjM8qmW7b5Gbb/JlkJlYVPzERwaLo/3ybLjicT2+92DMvRHhE8ZXd91gt2vOZR3hIbr+6cK4Up1Xsl9IRRMBK7gGJZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077533; c=relaxed/simple;
	bh=rJekpz0B7fZlbZtjyC+f4MIVRAE+aHiufvrPYZj8E4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFTfHMhFaXv6gZ+bVi4F3C5TV75fegDP24Gxrlt3N3QVqJA9slgvyb0jHwzTjTC/5XMmhmfnAapFmjH9W9+s/Hx70XNHpyB3hsyzxeD70LxabTGYk4l6HXHGUaowMYmCVN8QoFwqFqQ1IS+5kVTferg4LZ1SxGs27srccHgt8BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU4gpna/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU4gpna/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B070CC4CEF1;
	Tue, 21 Oct 2025 20:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077533;
	bh=rJekpz0B7fZlbZtjyC+f4MIVRAE+aHiufvrPYZj8E4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU4gpna/iFvEzcrBvx9wYtI/xrwjaJHBIpjkLl/s7V6c+FCaFdpHhkaotGAaxoQIG
	 juPScpNwM2B3s3lCojv9ci1bBzJrrGjt9ey5oMPPV4Zw+lyjyIDoxgwOnIuPCNjqFe
	 bRayyyTSgOBjegDmFHdkNdAtYPMkGGRQp/faIUOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Khalid Aziz <khalid@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 091/159] net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset
Date: Tue, 21 Oct 2025 21:51:08 +0200
Message-ID: <20251021195045.376727051@linuxfoundation.org>
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

From: I Viswanath <viswanathiyyappan@gmail.com>

[ Upstream commit 8d93ff40d49d70e05c82a74beae31f883fe0eaf8 ]

dev->chipid is used in lan78xx_init_mac_address before it's initialized:

lan78xx_reset() {
    lan78xx_init_mac_address()
        lan78xx_read_eeprom()
            lan78xx_read_raw_eeprom() <- dev->chipid is used here

    dev->chipid = ... <- dev->chipid is initialized correctly here
}

Reorder initialization so that dev->chipid is set before calling
lan78xx_init_mac_address().

Fixes: a0db7d10b76e ("lan78xx: Add to handle mux control per chip id")
Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Khalid Aziz <khalid@kernel.org>
Link: https://patch.msgid.link/20251013181648.35153-1-viswanathiyyappan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 5ccbe6ae2ebe9..e0c425779e67f 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3244,10 +3244,6 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		}
 	} while (buf & HW_CFG_LRST_);
 
-	ret = lan78xx_init_mac_address(dev);
-	if (ret < 0)
-		return ret;
-
 	/* save DEVID for later usage */
 	ret = lan78xx_read_reg(dev, ID_REV, &buf);
 	if (ret < 0)
@@ -3256,6 +3252,10 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 	dev->chipid = (buf & ID_REV_CHIP_ID_MASK_) >> 16;
 	dev->chiprev = buf & ID_REV_CHIP_REV_MASK_;
 
+	ret = lan78xx_init_mac_address(dev);
+	if (ret < 0)
+		return ret;
+
 	/* Respond to the IN token with a NAK */
 	ret = lan78xx_read_reg(dev, USB_CFG0, &buf);
 	if (ret < 0)
-- 
2.51.0



