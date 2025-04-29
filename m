Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AC024C083;
	Tue, 29 Apr 2025 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948901; cv=none; b=Xr+tDoGnsXK39/PktaLnqtBeONhlb+jPV3pqnFbMeA53bxZIygEcdKGOO8wD3+L05oEgvnTvTX7Y2xiRJqhkb376lrpR6JV+IkJH5YgzTpJgZ+iPRLr9pxiCNISczSoJEbfJUhQpkkOvlBp+oOuB0DmWK1xf3Zk4GI2sdIPvp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948901; c=relaxed/simple;
	bh=E62zkaxVxfzAfgfmXFENG8eYnmqkPTX2FqcO0cyc7Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZVpXyt5uTIe7GLhmzyzEqmp76qsb1M+s5rrHYqg+jqf0SrgyybE9phnHMWtc6gEOi7iAdRT+zXrKvxvPq2MHfyVkHwFkObLlHVrA7HqXrbhTk1d5RLWn2ETBAshI77EX0QtyUvHz4MDZLYzyQDZyqvatpYJGuW43Ozdvmk2Gc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDvtdnr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDvtdnr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D257C4CEE3;
	Tue, 29 Apr 2025 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948901;
	bh=E62zkaxVxfzAfgfmXFENG8eYnmqkPTX2FqcO0cyc7Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDvtdnr0M4KAUey6vwpIp7DLs7pObBkjQgTJVUfHlKi+Jcv3UQdADFchWIwN01v5f
	 rSWUcC8+ZADXVh17a78xX+cRf6E6mzedJ8douzslv98XsUcBkCA0JsPnTpbRYEhWUf
	 e6ZFpkJjyBmUWO06zpRnYUiC4A4cvBMG83QT2o+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/373] wifi: at76c50x: fix use after free access in at76_disconnect
Date: Tue, 29 Apr 2025 18:40:04 +0200
Message-ID: <20250429161128.396953101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7582761c61e2c..26953dcffe193 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2553,7 +2553,7 @@ static void at76_disconnect(struct usb_interface *interface)
 
 	wiphy_info(priv->hw->wiphy, "disconnecting\n");
 	at76_delete_device(priv);
-	usb_put_dev(priv->udev);
+	usb_put_dev(interface_to_usbdev(interface));
 	dev_info(&interface->dev, "disconnected\n");
 }
 
-- 
2.39.5



