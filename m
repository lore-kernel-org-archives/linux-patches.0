Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F017A35AAA0;
	Tue, 26 Aug 2025 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219313; cv=none; b=NiYR4VoW1sbKg5hdoFI9fBPITKKmp8ZjP91m4gOX3+1nmcLl2Edt4vxHJqRulpoKFoBkJWElGuPO/Fz9H6WQZQC1n0hg9TwSriY8MIL7m/ZpU+aeTmzZya1oX5RKIlPT8zk+KenCHG7KPNVnOCxE8PXSHEdTnwGhFG6pTdNVzTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219313; c=relaxed/simple;
	bh=/UsGdghGl0EmtRmxYCc7MR8DiV5dYQhY+xPXGTsv5uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df3/6/xwFe8/bMC6eQ6y3B/Mbr/NTYI6tVL+M3zctd1ovbdBA+33mJq5FsJ4XrOc5O7gMfBTCJ3OkItCuSAkmKLyVnQDZUI6LvO38MCVMR2Eiwe4qRcR5jFTXHeLVjrqBXnrfmveGkzmT8vYmbSYIZLdiZHwWXuYkzsj0i9OhnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n07wrqRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n07wrqRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BC1C4CEF1;
	Tue, 26 Aug 2025 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219312;
	bh=/UsGdghGl0EmtRmxYCc7MR8DiV5dYQhY+xPXGTsv5uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n07wrqRvhkRiUUYKJt5wZ245ip3OVmGAOcs9+t/59K7EvxsG2+WtlaFwHu9JkEtlc
	 j1MAIbUZ/inq9gDr6cDaVzCAc4uDgAJyVv/4lA7o+hhmA+FNE6RUk8FLRNqGoSzduI
	 uXZ6odgduRc/PYPL0Gk4qr+tdBX86v61y/LlTlEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armando Budianto <sprite@gnuweeb.org>,
	Simon Horman <horms@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH 5.4 334/403] net: usbnet: Fix the wrong netif_carrier_on() call
Date: Tue, 26 Aug 2025 13:11:00 +0200
Message-ID: <20250826110916.069220652@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

commit 8466d393700f9ccef68134d3349f4e0a087679b9 upstream.

The commit referenced in the Fixes tag causes usbnet to malfunction
(identified via git bisect). Post-commit, my external RJ45 LAN cable
fails to connect. Linus also reported the same issue after pulling that
commit.

The code has a logic error: netif_carrier_on() is only called when the
link is already on. Fix this by moving the netif_carrier_on() call
outside the if-statement entirely. This ensures it is always called
when EVENT_LINK_CARRIER_ON is set and properly clears it regardless
of the link state.

Cc: stable@vger.kernel.org
Cc: Armando Budianto <sprite@gnuweeb.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/all/CAHk-=wjqL4uF0MG_c8+xHX1Vv8==sPYQrtzbdA3kzi96284nuQ@mail.gmail.com
Closes: https://lore.kernel.org/netdev/CAHk-=wjKh8X4PT_mU1kD4GQrbjivMfPn-_hXa6han_BTDcXddw@mail.gmail.com
Closes: https://lore.kernel.org/netdev/0752dee6-43d6-4e1f-81d2-4248142cccd2@gnuweeb.org
Fixes: 0d9cfc9b8cb1 ("net: usbnet: Avoid potential RCU stall on LINK_CHANGE event")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1097,6 +1097,9 @@ static void __handle_link_change(struct
 	if (!test_bit(EVENT_DEV_OPEN, &dev->flags))
 		return;
 
+	if (test_and_clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags))
+		netif_carrier_on(dev->net);
+
 	if (!netif_carrier_ok(dev->net)) {
 		/* kill URBs for reading packets to save bus bandwidth */
 		unlink_urbs(dev, &dev->rxq);
@@ -1106,9 +1109,6 @@ static void __handle_link_change(struct
 		 * tx queue is stopped by netcore after link becomes off
 		 */
 	} else {
-		if (test_and_clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags))
-			netif_carrier_on(dev->net);
-
 		/* submitting URBs for reading packets */
 		tasklet_schedule(&dev->bh);
 	}


