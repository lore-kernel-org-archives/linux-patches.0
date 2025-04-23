Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A03B28C5AB;
	Wed, 23 Apr 2025 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421895; cv=none; b=BcOJfnOwy0vD8woMjml7tZqhl/Jeu3bbmhA9XVIRJwnW5WU9LX5cSCc1z1INhpKh62+HtPcrzPoF9S2vqG4NnR/pLonCVGwjOJZcvDmwpn1YQQgAmUWu6ipTSgo2ZeTCOehgyj30gk7lXqVbyENWt+mkCe8tCGumDE+2Z41CxBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421895; c=relaxed/simple;
	bh=jj4LtM9lvuUYwCEmzLmESCq7yf9H42KMsnVONV4qNTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7bebiia/+cNXI7WyHNlfNAvzpG4oDfMNfE40ZoMfHcuovR9VSUIQVycup6LHigXt98KahxwM5k2V7M0mO2wHiscYoyJ/2OOtgAFtlOwt5Mlp5yM3/KaH8SRivRoW7/ELF44nuwkLvd1HmahQk9n7QNOJPC+Umj9GIZA8lwCbgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V87e8/rP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V87e8/rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EB5C4CEE2;
	Wed, 23 Apr 2025 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421894;
	bh=jj4LtM9lvuUYwCEmzLmESCq7yf9H42KMsnVONV4qNTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V87e8/rPQV9xTPrfuKhKJVtMs/QCE+6Kyc0kXzpnlVuu6FyG2rEOuK/qTaNCAI6hq
	 f586gYmo9aGsQopv/h130zR1yb2IyCfbwTnAGMulGsvg5Y7vwP50KELX7xytLukZJT
	 dN6CdxBW7Dmx2rfl4LYN198yUMkjybizU/pD3Uew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/393] wifi: at76c50x: fix use after free access in at76_disconnect
Date: Wed, 23 Apr 2025 16:42:17 +0200
Message-ID: <20250423142653.340437892@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 447b51cff8f96..c1a92c7f0f8e8 100644
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



