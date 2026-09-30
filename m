Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B2514779;
	Wed, 30 Sep 2026 16:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785169; cv=none; b=qfB55m3zeksdfrFJ1KUCUyp1xdlT15sXNjJcbQ67T/xX7N1nmRrBp93b/PM3qIVJOgm2b0/DsGgeY4MYsZ9UJXujuB6eQojZa5Fa+HABI7X8W/oupvc1phDDVY/QhK1y2i10R43JPFAxL+mZ0ML1cZRGH0PpWE0Hpse0nvtaHaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785169; c=relaxed/simple;
	bh=p1OMyqsxZyvjcArUjmBGtFdXbSIhElaGmYTYzDoYCS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruxqzmLug6ob5+88ff+RWk1jtjAH+/uPQZ7Il9ija0qmyXjfHiHv23U5MWyWh0kBOk/9pyoFbec04zHA0wJRxkc54h3MCSSJi1NN0vzAlo6ZdOt3evqIPuWB04KH3yQB+ss7YgMIfnRixLB5/22mMpz0QRRAnvDDtwlTmDjQVos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KbjT2PX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KbjT2PX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A161F00898;
	Wed, 30 Sep 2026 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785164;
	bh=59PM5q57Twb4d/K0FTcGCchLdyi/y0ye/SCgGCVersw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KbjT2PXTgWAw4SrkntDOudbDk7jVmOKN5i0cXweuMjRNNnRayl0Ulw9UBR+6Vg92
	 4Q2UKUmOQC9IlvF3qyTLUkqzcUKciPW1WOFSmyP5/qND81fvnOKoq0Qe3yGke6ySrp
	 WG5s3yRt/IrmFYWP/F6WokBEVOcKOi0XTGVElEfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Winter <jjx@live.nl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 413/982] net: usb: cx82310_eth: drop URB after 0xffff reboot sentinel to prevent partial_data heap overflow
Date: Wed, 30 Sep 2026 17:19:09 +0200
Message-ID: <20260930152425.677561816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Jason Winter <jjx@live.nl>

[ Upstream commit 5d50e90add8b4a978395e893e81954d19d58a7c5 ]

The 0xffff length sentinel detects a router reboot and schedules
re-enabling of ethernet mode, but then falls through to the rest
of the loop body.  The next check is

	} else if (len > CX82310_MTU) {

which is the else of the just-matched if -- it never fires for
len == 0xffff.  The MTU bound that normally caps the
incomplete-packet save path is silently bypassed.

With 0xffff > skb->len always true (rx_urb_size is 4096), the
incomplete-packet branch saves dev->partial_len = skb->len bytes
into dev->partial_data.  partial_data is kmalloc(hard_mtu) =
kmalloc(CX82310_MTU + 2) = 1516 bytes, but skb->len after the
2-byte header pull can be up to 4094.  A device that sends a
4096-byte URB starting with [0xff 0xff] therefore copies 4094
device-provided bytes into a buffer allocated for 1516 bytes,
exceeding its requested size by 2578 bytes.

The next URB then reads dev->partial_len (4094) back from the same
1516-byte buffer and dev->partial_rem (65535 - 4094 = 61441) from
the new URB's ~4KB skb, both well past their allocations, and
delivers the spliced result as a 64KB "frame" to the network
stack.

Bail out of rx_fixup after scheduling the re-enable work; the
remainder of a reboot-marker URB is not meaningful packet data.
This restores the invariant that partial_len < CX82310_MTU + 2 on
the save path, since every other route there has already passed
the MTU check.

Fixes: ca139d76b0d9 ("cx82310_eth: re-enable ethernet mode after router reboot")
Signed-off-by: Jason Winter <jjx@live.nl>
Link: https://patch.msgid.link/BESP194MB283265DDDC63B6B78D8D34FBB8B72@BESP194MB2832.EURP194.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cx82310_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index 79a47e2fd4378..840d014ac1aa8 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -282,6 +282,7 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		if (len == 0xffff) {
 			netdev_info(dev->net, "router was rebooted, re-enabling ethernet mode");
 			schedule_work(&priv->reenable_work);
+			return 0;
 		} else if (len > CX82310_MTU) {
 			netdev_err(dev->net, "RX packet too long: %d B\n", len);
 			return 0;
-- 
2.53.0



