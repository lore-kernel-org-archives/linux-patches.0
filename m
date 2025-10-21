Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177C8272E7C;
	Tue, 21 Oct 2025 19:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076499; cv=none; b=GiTwX2Xn3hz8hd+9mSKuvxVRP96dczbFDaAwGNkulo1YtrIN9MktNPBUckSRwAU552EL0Om96xCYdP0GeBPUGCzJJ9vhoI7VI0LUj0E8cR4feO7dl/AsRhIMklDXiXOr5qTwUnMplv0iv7TMUXU87aCXu5YmN3VBJ/orM3t1p68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076499; c=relaxed/simple;
	bh=XmCcVR0gxM0rNEpBYPYZGBaBhSNxsab3c1zTaZI0dNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiXHo1zrmn2YNPyGtWvCJKJbl/KoLl4hqTGbthB1mta6KtotOeIejdQcQv4Xgy46C6G1KpCWcf0obJPgZJoy+HWb/2JdbR5XrX59SCHYfZXtILfv/sdGd4X6YKGP+0yOF01jQHMN36rCMP4Poet/6nYn0aerVMnYZRv2W2x3vGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19+bbJ0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19+bbJ0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCEAC4CEF1;
	Tue, 21 Oct 2025 19:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076499;
	bh=XmCcVR0gxM0rNEpBYPYZGBaBhSNxsab3c1zTaZI0dNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19+bbJ0LGqbsonJQSr0NAfgHQbLLZGmhVZtqDuT1unf/cjOctxHl4vh0eJHVUCdpH
	 0oW77DR96RC4+XaUJGmLfPzqoezrLroQIoPucMeJEwDpNTswEYh3r0Jj1wE8xutDxh
	 U4j4u6fky/HgMg+Obrbc/Z4AGUvff7Sf7vJYj7fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Khalid Aziz <khalid@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/105] net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset
Date: Tue, 21 Oct 2025 21:51:00 +0200
Message-ID: <20251021195022.894125677@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 712530d6738fa..121f1c15c6793 100644
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



