Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB2D352FFF;
	Tue, 26 Aug 2025 14:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218384; cv=none; b=F8MgqDR5E0uWgtZo6suhfhCVYQ8oV3O4LScfhoys+6uuTyhSmOmSt1hG4hLArn7MwNaJYI1zeIl26MBLTZmXQ18TyrU1QAQYFITOBhfyuUanTg2UVRxhHgdwaWFnRxu5ckvb06cVxxmMGn0cEii8yFNUZ5Z9vhe+1L7prB0//Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218384; c=relaxed/simple;
	bh=rOL7SMgwNeWDyPpdW6X0uRWobSIn5BNiX5iOPvc4JnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8A1eOujIyTsrllOp7GyePR4HyQApY4dnI4n0T/ZmCIeY0KYVBGX3P/eZrSZhMDdYhdJODnsR8jPeuS/Er9iAj+jG+fkHas+CnzNs3fM7o1p5SR55yf15k9RVrJE/5ar9bM4ygtCyQ2iN+PMEcrsXWDU0nhG2dHCo3r5ESI4e84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSjOy5tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSjOy5tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AA6C4CEF1;
	Tue, 26 Aug 2025 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218384;
	bh=rOL7SMgwNeWDyPpdW6X0uRWobSIn5BNiX5iOPvc4JnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSjOy5trpnax4m5SlF0a41xdKs0XtfPqzMH+7Pbvat8aosUkblkjSFXmBPqKQmyG8
	 RYYszFQ0VxS6GgUmd66HMSierYOp24lcsGZ2OnY/1BEbWNTXbF+NWqwFZRaAZhi6dT
	 bJjzx+jIKka2KCGB5PDJGadciH5bO9mgQL35bGg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armando Budianto <sprite@gnuweeb.org>,
	Simon Horman <horms@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH 5.10 500/523] net: usbnet: Fix the wrong netif_carrier_on() call
Date: Tue, 26 Aug 2025 13:11:50 +0200
Message-ID: <20250826110936.773440242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1071,6 +1071,9 @@ static void __handle_link_change(struct
 	if (!test_bit(EVENT_DEV_OPEN, &dev->flags))
 		return;
 
+	if (test_and_clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags))
+		netif_carrier_on(dev->net);
+
 	if (!netif_carrier_ok(dev->net)) {
 		/* kill URBs for reading packets to save bus bandwidth */
 		unlink_urbs(dev, &dev->rxq);
@@ -1080,9 +1083,6 @@ static void __handle_link_change(struct
 		 * tx queue is stopped by netcore after link becomes off
 		 */
 	} else {
-		if (test_and_clear_bit(EVENT_LINK_CARRIER_ON, &dev->flags))
-			netif_carrier_on(dev->net);
-
 		/* submitting URBs for reading packets */
 		tasklet_schedule(&dev->bh);
 	}


