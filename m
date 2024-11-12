Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0922809E;
	Tue, 12 Nov 2024 10:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407861; cv=none; b=uDZeciPPZaYR5uWgG9fmIETBjChOLpjocKfc9FDSs0Jr3E8Wf7H1NocHoyOFclNOQJR/yPQgOaf97SlMDEu2dYOdOQVpOb7IfseV/FxMHzkE3b+vDSv9YqCFrJ7eROXmR8dsKhYRoUJAlAcgKCCW0sm4xVpCTqtDwwXxAntptms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407861; c=relaxed/simple;
	bh=wM/QUlVK7w6+nfEE+78DZjjgyI7rOYYsZTYbbVqJZTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtCY0xJiukQOPeqVZG87ASf0RwzsEBviE8+D532wJzRPK5pFRPrOTFaAQ256s+hAHobF/U2AWisfPYCj347r5DlJrQonjhUlxc75fY+5MbnlzgZXS9RBfHrny69VO180LyZoMmk6Qg3By1/ziKhAo8azzw6g/buJh3PBat74b6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6eHUwAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6eHUwAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB59BC4CED4;
	Tue, 12 Nov 2024 10:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407861;
	bh=wM/QUlVK7w6+nfEE+78DZjjgyI7rOYYsZTYbbVqJZTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6eHUwAPfm1skl+pzsvpH5kL8kAW0Yz7kFs90aO2nsRiRGMVXqts24HvSPx3fYpyu
	 xM3+hp5yaFLY1mcbr00eX3yoTFg++F1a0wOndA5zuz9Hg0Cs9UiEepzX2w+Dqj8E2A
	 YoGlaszZIwgsjQwQJum05GDwPXsR1Rj6wqEx7Aq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.6 106/119] usb: musb: sunxi: Fix accessing an released usb phy
Date: Tue, 12 Nov 2024 11:21:54 +0100
Message-ID: <20241112101852.772264661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 498dbd9aea205db9da674994b74c7bf8e18448bd upstream.

Commit 6ed05c68cbca ("usb: musb: sunxi: Explicitly release USB PHY on
exit") will cause that usb phy @glue->xceiv is accessed after released.

1) register platform driver @sunxi_musb_driver
// get the usb phy @glue->xceiv
sunxi_musb_probe() -> devm_usb_get_phy().

2) register and unregister platform driver @musb_driver
musb_probe() -> sunxi_musb_init()
use the phy here
//the phy is released here
musb_remove() -> sunxi_musb_exit() -> devm_usb_put_phy()

3) register @musb_driver again
musb_probe() -> sunxi_musb_init()
use the phy here but the phy has been released at 2).
...

Fixed by reverting the commit, namely, removing devm_usb_put_phy()
from sunxi_musb_exit().

Fixes: 6ed05c68cbca ("usb: musb: sunxi: Explicitly release USB PHY on exit")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241029-sunxi_fix-v1-1-9431ed2ab826@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/sunxi.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/musb/sunxi.c
+++ b/drivers/usb/musb/sunxi.c
@@ -293,8 +293,6 @@ static int sunxi_musb_exit(struct musb *
 	if (test_bit(SUNXI_MUSB_FL_HAS_SRAM, &glue->flags))
 		sunxi_sram_release(musb->controller->parent);
 
-	devm_usb_put_phy(glue->dev, glue->xceiv);
-
 	return 0;
 }
 


