Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E702D73AB;
	Mon, 27 Oct 2025 19:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592331; cv=none; b=HjeEa6WtVmU61DKHfhQ3JQxq2c62WSDcgxEfvIXtw3+SE2yHTAs+eWvHvxK4ELmfCq3mZXDBEA9p73gEsWRIPpuGhkHm5f34SAQ6e0cI2Ok7QmTrFHsGyadnHY+PexCGfZN+8PwfgOupgAUXDvs6isqTxLLq0d0om+iuHuQ828g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592331; c=relaxed/simple;
	bh=i7XAx8y1riwbK/G9oNafJleQFBzZnHJBnDkg6UUl/KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQLL8wEOTalTpdGUBNvBz/UpnHuyN0C1KR37AhxvdKG0eyHZDkMhLG2IvrIGKB20m/BFtrLKXP0z/WYAecxrbR2cu0RtcXWbtGvOpZBFtFehMsPymFVTaRbYyYX4zVhDQzym7aO/YF7F403GOL448aE7UrwqPas1priU+BpLmTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnToOTsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnToOTsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715A4C4CEF1;
	Mon, 27 Oct 2025 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592330;
	bh=i7XAx8y1riwbK/G9oNafJleQFBzZnHJBnDkg6UUl/KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnToOTsrFSDHcSE112MiaT2fuVv8/G46pP3CeaVB/RmS8MLkThXYr3oAPibnWJAHp
	 I49CyxHh8jjSo1VfYkRdg87UqFBlJGnBS4bCdR47P/lk76DPuR0VFVkPcr26613Ru9
	 Or9Z5/ltBCcwN5XX6vTKv4sW8AC1Xw3w37l2Up6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Khalid Aziz <khalid@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/157] net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset
Date: Mon, 27 Oct 2025 19:35:12 +0100
Message-ID: <20251027183502.660425194@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 08fb03bcf4952..42f8fc71baee8 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2928,10 +2928,6 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		}
 	} while (buf & HW_CFG_LRST_);
 
-	ret = lan78xx_init_mac_address(dev);
-	if (ret < 0)
-		return ret;
-
 	/* save DEVID for later usage */
 	ret = lan78xx_read_reg(dev, ID_REV, &buf);
 	if (ret < 0)
@@ -2940,6 +2936,10 @@ static int lan78xx_reset(struct lan78xx_net *dev)
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



