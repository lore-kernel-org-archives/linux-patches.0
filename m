Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E37246326;
	Tue, 29 Apr 2025 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945356; cv=none; b=SIyIPxrzTY0uKTTsHYA8NKwhs7OSg3IMtwH7REn/4UlriLX/10TpvndHDiEXnveiypr+rCy4Jo24ihYtoA5d6yB9iQ6O9gCkY85ilKHFsxy+TnEuLRKn3QyUV6sInKI1WIff6Q2jEUxCuxq1a1CEMUJqZAZb8N6JYeMAPu38wMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945356; c=relaxed/simple;
	bh=zeFe5InySFGkN1fEOLpk5U4khUSFBb8ZW+NdQNH5XoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYMxECAbrQEwRp/EZ0waM9lRDd8RKkAwn83GHG3CEvG05pI635SsdCa/NT0dxdZDWN9zB3tD4EQwt28eBwWkr1IXBBhTaA04IMacW244yae+abGb2SC4+HQoJ2hd//ny2bn2tKnA+UGDHFgRjOLMmd1h4AN4q9j7A0Putezm+Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVbb+WxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVbb+WxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B70BC4CEE3;
	Tue, 29 Apr 2025 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945356;
	bh=zeFe5InySFGkN1fEOLpk5U4khUSFBb8ZW+NdQNH5XoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVbb+WxIVHJMhCcNGWAZcw54exqvtUhHhx4hGskqXHsZnSvSvhJ3TbLJMB0S49B8Z
	 nttIy/4yn/4Ho4/mirw7uurTLzpxRrhl5LrB75oqeoFq3I6cKkZhS62hruarbFoi5z
	 8xv5KgyicVgTlDmOp7NWcwRhoHFLrtosTsfa8ses=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/179] wifi: at76c50x: fix use after free access in at76_disconnect
Date: Tue, 29 Apr 2025 18:40:24 +0200
Message-ID: <20250429161052.763807045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 27c7e63b3cb1a20bb78ed4a36c561ea4579fd7da ]

The memory pointed to by priv is freed at the end of at76_delete_device
function (using ieee80211_free_hw). But the code then accesses the udev
field of the freed object to put the USB device. This may also lead to a
memory leak of the usb device. Fix this by using udev from interface.

Fixes: 29e20aa6c6af ("at76c50x-usb: fix use after free on failure path in at76_probe()")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Link: https://patch.msgid.link/20250330103110.44080-1-abdun.nihaal@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index db2c3b8d491e5..c9ee3d4c8fa61 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2554,7 +2554,7 @@ static void at76_disconnect(struct usb_interface *interface)
 
 	wiphy_info(priv->hw->wiphy, "disconnecting\n");
 	at76_delete_device(priv);
-	usb_put_dev(priv->udev);
+	usb_put_dev(interface_to_usbdev(interface));
 	dev_info(&interface->dev, "disconnected\n");
 }
 
-- 
2.39.5



