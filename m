Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EE227FD59;
	Wed, 23 Apr 2025 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419568; cv=none; b=qheWEC6z9BmnGbWZTQS2YZzsU9ZAohJBFiNVtY2Wr6OZl9oVJ7HeyMGrPZ/e6J1tEvv3D8kgoqVcvWRmF0D/S0kogueH/rz/IgQ8AVK6lpx7AiLGjozRfZND0QNjnisPZOggNypIuyqdM49FXTs19RuMsH1uVfgYAXD7egeTxYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419568; c=relaxed/simple;
	bh=myNolpVq09Ylg1g8aVTwIEDqCLj/MBjA6HRhgE6juVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwEiUL6EIpO0h4f+bQ+hX5SRonko8vYCSgeFxqLNgZ3x+KTo90yEhvmDG1QhGlbRjROtKcmz1ofZGwlbCZig+X6FJ2/MPMQSrZDK4DxB83hRRcq+ZLMi3ez4yUuAlpDZaGQkXelHypvRml/bVtcDOxPGlX25D8+Z8L8kfR3HaC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQ4Xa8Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQ4Xa8Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC25C4CEE2;
	Wed, 23 Apr 2025 14:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419566;
	bh=myNolpVq09Ylg1g8aVTwIEDqCLj/MBjA6HRhgE6juVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQ4Xa8Kpe5gZJloJGOOE1i16T9l29pdWR6/av8G9H9DQNzXZ+mIhqYX9GI0tqqQcF
	 Qf5LwrtxCAlr7gwZGv2D5noqHusy6Eqij2rjOwiul4FI+gqX4UumUzt343L7yQO9rx
	 gDrglo/H8F/4xrNExBfWrbREnP6THoG9aLOASh80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 002/241] wifi: at76c50x: fix use after free access in at76_disconnect
Date: Wed, 23 Apr 2025 16:41:06 +0200
Message-ID: <20250423142620.627883432@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 504e05ea30f29..97ea7ab0f4910 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2552,7 +2552,7 @@ static void at76_disconnect(struct usb_interface *interface)
 
 	wiphy_info(priv->hw->wiphy, "disconnecting\n");
 	at76_delete_device(priv);
-	usb_put_dev(priv->udev);
+	usb_put_dev(interface_to_usbdev(interface));
 	dev_info(&interface->dev, "disconnected\n");
 }
 
-- 
2.39.5



