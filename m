Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DD336B059;
	Wed, 20 May 2026 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294664; cv=none; b=JYLvXVVfF09PhjWU5FXgm5XriWud02zdDN4H+LrecdbAjTSJ7etjxqZFCV0re89G1M7QCVsHI8SmjReJQTh6Re69TW0dnrd5jy0XUSRiGDC/x1F4nhRg43vvPt1bfEyxE4hmyy0DTj2uO0ON9qxls4pUB1fD1UNarR3WSQwDX0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294664; c=relaxed/simple;
	bh=LjtMzoDhXS0SyOLSrA/QAgFGb2gRdLgcu9SSshiprjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIgxj9ACKXmDGCH7MHkrbBpgFy67UUa+aPBATZlAa6QjJzREhPEW81I/Uc7gIyVDoiFmeRfYdQauSv3mPa6Zcj5nPHIctI8IjoIgc8G4d/eU7/6XzhMU7MF3PsZaedjspGEt1GiCZgv2zQELNVsSPoBj6UxhjhFWabPUWpvp1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgHPFqUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgHPFqUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255761F00893;
	Wed, 20 May 2026 16:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294663;
	bh=N1ucq7SrilVB0nPV9apc0JsmbdoAn4LEYKEIIhIYixY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgHPFqUBSnXrULBonS/HxyLtF0UPK1Q4Oz/5zBlDepty0tu+VrOIfDVQ31tIr69Ec
	 N9ccXrrpBHNdo7glXceJk7IZOsjX4BQvSF7lDX6CUP0Bj3eO+ZzVrCMl4JA0DnrKtI
	 RtWWbbit2GrwAjcAX19wG4YwuL0uOtA/5EhsXELA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+74afbb6355826ffc2239@syzkaller.appspotmail.com,
	Heitor Alves de Siqueira <halves@igalia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0085/1146] wifi: libertas: dont kill URBs in interrupt context
Date: Wed, 20 May 2026 18:05:35 +0200
Message-ID: <20260520162150.275959205@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heitor Alves de Siqueira <halves@igalia.com>

[ Upstream commit 7c5c2b661bdb78c1472b8833265c9ed1ee880039 ]

Serialization for the TX path was enforced by calling
usb_kill_urb()/usb_kill_anchored_urbs(), to prevent transmission before
a previous URB was completed. usb_tx_block() can be called from
interrupt context (e.g. in the HCD giveback path), so we can't always
use it to kill in-flight URBs.

Prevent sleeping during interrupt context by checking the tx_submitted
anchor for existing URBs. We now return -EBUSY, to indicate there's
a pending request.

Reported-by: syzbot+74afbb6355826ffc2239@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=74afbb6355826ffc2239
Fixes: d66676e6ca96 ("wifi: libertas: fix WARNING in usb_tx_block")
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260313-libertas-usb-anchors-v1-2-915afbe988d7@igalia.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 11cd1422f46a3..d3b9f7619a1a0 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -429,7 +429,12 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb
 		goto tx_ret;
 	}
 
-	usb_kill_anchored_urbs(&cardp->tx_submitted);
+	/* check if there are pending URBs */
+	if (!usb_anchor_empty(&cardp->tx_submitted)) {
+		lbs_deb_usbd(&cardp->udev->dev, "%s failed: pending URB\n", __func__);
+		ret = -EBUSY;
+		goto tx_ret;
+	}
 
 	usb_fill_bulk_urb(cardp->tx_urb, cardp->udev,
 			  usb_sndbulkpipe(cardp->udev,
-- 
2.53.0



