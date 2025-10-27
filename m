Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029A33081B0;
	Mon, 27 Oct 2025 19:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591969; cv=none; b=piCPlG4zdGp0vVNJ0SFUIAgV/kfYMB91ehsvH1z8U2uA0OLy30Fv98oINtiI/nAvO8fwuwSgOvsmpzhO0qbeJdWCkASKk4gamYpLAE3laUFrqXNlDK94KHl2EJKxiLUT6DpoYwGc0qn28V07nUaKWzf9iunYWiK1o9HL5PEvDhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591969; c=relaxed/simple;
	bh=/ULkh4MxxgGfiZLa2gE6RxzHfbwD9Y/LEqnhuQgZa34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/tZmHB9rVuT0/FmRef43P56DQhwnjhKMtmKVtg+/zWX9OL4DKUeJF70N3kCnG0DOlCmdvcXrcTo6oeRqRNsgoap7dvwyzRyKsyhHBK/NeHHK3imub4HwGNwHpTThWFIdTthlX2s8ii6JZuZGfygvu01l8j8Dw32Y73rCfWB5lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e21K5tUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e21K5tUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896E1C4CEF1;
	Mon, 27 Oct 2025 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591968;
	bh=/ULkh4MxxgGfiZLa2gE6RxzHfbwD9Y/LEqnhuQgZa34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e21K5tUUOPqd/XGKMFIlOyoFczo6AeuRTqeqfV1x8diXGnPMal0A//DcsDyRQ6jqJ
	 ej8FJTH+uGIwZFy+EtII5PClD0CNR4/DTF6PgWlbzU+t8D3k6USZ5PVXh0gsFt0jIL
	 4WSn2rkCkvB4je5xDMsJYeb5AJjnkXRy1HFcXKqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Viswanath <viswanathiyyappan@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Khalid Aziz <khalid@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/123] net: usb: lan78xx: fix use of improperly initialized dev->chipid in lan78xx_reset
Date: Mon, 27 Oct 2025 19:35:11 +0100
Message-ID: <20251027183447.233138358@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 182a4dbd8cf26..174d94bdaae64 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2736,10 +2736,6 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		}
 	} while (buf & HW_CFG_LRST_);
 
-	ret = lan78xx_init_mac_address(dev);
-	if (ret < 0)
-		return ret;
-
 	/* save DEVID for later usage */
 	ret = lan78xx_read_reg(dev, ID_REV, &buf);
 	if (ret < 0)
@@ -2748,6 +2744,10 @@ static int lan78xx_reset(struct lan78xx_net *dev)
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



