Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFEE51020;
	Mon, 11 Dec 2023 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UygvAsG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FC6C433C7;
	Mon, 11 Dec 2023 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319240;
	bh=hgVslg1qUbqpTCF/GMcTLmJS/FjDcrEr/xGGavGEZz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UygvAsG0k+ZUZNju8ALcnoSvPMzo8NPKjnVo9P72FJWRlTwFwjk07aPu8AC7kKXcy
	 hMFhODnBkZEdQF6R8IMYR/StY8/Bs7mpXfTh4X9JV+mXNnn9iZn3Hs2CPO4NFXz5LM
	 9jy3PT8MYP4ff0pcljEOk9R6jn7yQeDyWbZSGFm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Grundler <grundler@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/244] r8152: Hold the rtnl_lock for all of reset
Date: Mon, 11 Dec 2023 19:18:45 +0100
Message-ID: <20231211182047.249151478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e62adaeecdc6a1e8ae86e7f3f9f8223a3ede94f5 ]

As of commit d9962b0d4202 ("r8152: Block future register access if
register access fails") there is a race condition that can happen
between the USB device reset thread and napi_enable() (not) getting
called during rtl8152_open(). Specifically:
* While rtl8152_open() is running we get a register access error
  that's _not_ -ENODEV and queue up a USB reset.
* rtl8152_open() exits before calling napi_enable() due to any reason
  (including usb_submit_urb() returning an error).

In that case:
* Since the USB reset is perform in a separate thread asynchronously,
  it can run at anytime USB device lock is not held - even before
  rtl8152_open() has exited with an error and caused __dev_open() to
  clear the __LINK_STATE_START bit.
* The rtl8152_pre_reset() will notice that the netif_running() returns
  true (since __LINK_STATE_START wasn't cleared) so it won't exit
  early.
* rtl8152_pre_reset() will then hang in napi_disable() because
  napi_enable() was never called.

We can fix the race by making sure that the r8152 reset routines don't
run at the same time as we're opening the device. Specifically we need
the reset routines in their entirety rely on the return value of
netif_running(). The only way to reliably depend on that is for them
to hold the rntl_lock() mutex for the duration of reset.

Grabbing the rntl_lock() mutex for the duration of reset seems like a
long time, but reset is not expected to be common and the rtnl_lock()
mutex is already held for long durations since the core grabs it
around the open/close calls.

Fixes: d9962b0d4202 ("r8152: Block future register access if register access fails")
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index be18d72cefcce..77408265e612a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8364,6 +8364,8 @@ static int rtl8152_pre_reset(struct usb_interface *intf)
 	struct r8152 *tp = usb_get_intfdata(intf);
 	struct net_device *netdev;
 
+	rtnl_lock();
+
 	if (!tp || !test_bit(PROBED_WITH_NO_ERRORS, &tp->flags))
 		return 0;
 
@@ -8395,20 +8397,17 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	struct sockaddr sa;
 
 	if (!tp || !test_bit(PROBED_WITH_NO_ERRORS, &tp->flags))
-		return 0;
+		goto exit;
 
 	rtl_set_accessible(tp);
 
 	/* reset the MAC address in case of policy change */
-	if (determine_ethernet_addr(tp, &sa) >= 0) {
-		rtnl_lock();
+	if (determine_ethernet_addr(tp, &sa) >= 0)
 		dev_set_mac_address (tp->netdev, &sa, NULL);
-		rtnl_unlock();
-	}
 
 	netdev = tp->netdev;
 	if (!netif_running(netdev))
-		return 0;
+		goto exit;
 
 	set_bit(WORK_ENABLE, &tp->flags);
 	if (netif_carrier_ok(netdev)) {
@@ -8427,6 +8426,8 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	if (!list_empty(&tp->rx_done))
 		napi_schedule(&tp->napi);
 
+exit:
+	rtnl_unlock();
 	return 0;
 }
 
-- 
2.42.0



