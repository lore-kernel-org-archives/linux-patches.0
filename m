Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961B2216605;
	Tue, 29 Apr 2025 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946982; cv=none; b=idX4zIwzlybWKg8gu4Yg349SRNhPkUP9Xh8MhIlPvmUt+GdE1Bd/YDRqI4QTG9PFCYdfBgS4wp8xzk0bdlyM68TfNT0S60nzgwjzAltSPMsCZDG5hYdY9D7e7xLFRIT99pjs9B6yPKaRyZBXRQl8xUaeTGpQRSvaCx0Tz4PO6T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946982; c=relaxed/simple;
	bh=T3ma/iRZ/D2EQz5Nkpy2kMRVMJ4Fvqd2QthQNncjcDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoqoYHTSEMw7yWdyOcjog2YBolqg9OhNQthnqnbb8aXUazdz186SiZzgZtl461J4HKh6rm/+CrxbM2CGTEkBoJZWuVbAZN/JUcpVzIu0zJjqIGiPsW6gvKreyWCO+k/ZehzcKwqifAs0U+kQr/sKA7udJIuRpkKEb1ytcvW6yLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NMZvrvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NMZvrvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB35C4CEE9;
	Tue, 29 Apr 2025 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946982;
	bh=T3ma/iRZ/D2EQz5Nkpy2kMRVMJ4Fvqd2QthQNncjcDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NMZvrvD0vliatIAZDH6eqlNmMiAg5yz9ovW0PxkhPyxPeZ2VmTqw1Ozhs+GdE3y/
	 OtGzBgkr0hsJ/bj19Iw1oVzN2OrcU1/ijefObWxadHU4UcH8yOsMckzKJrA6UGn6uy
	 6obO1R/sq6kU4DjfZDwHIEjNWOdOvRP4GSdedcC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/286] wifi: at76c50x: fix use after free access in at76_disconnect
Date: Tue, 29 Apr 2025 18:40:06 +0200
Message-ID: <20250429161112.052038931@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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
index 4042578000331..706de33d0ed49 100644
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



