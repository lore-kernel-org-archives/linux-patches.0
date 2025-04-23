Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9982BE101;
	Wed, 23 Apr 2025 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421684; cv=none; b=YGhujwZSjhfhPvZ8wAizmlZFinHYv5SQweJmOSNd6Bvh61YZLb8fa8bCEwxEtsYLqjt2q83EX1Qrzgs0yGlVB5DP/oWR9ZOWmXaXKYieJVpxCPg++yJHfVC7smSWFYK2/3EIHi8tK8r+SW7UVbLejlXP4rXtrNZgHj/K0rSpw9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421684; c=relaxed/simple;
	bh=a2A8L4/XOW/fEuYDj8yb2VNOFIdqTgfbQIagIYouRDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhiFn7aKiQj+18TjU7bcfz/TlUL3ds7UDYNRoDVBv4qeaf3On3IkSBGbe/sY48XlkjAuayUgVv5uvnD2vGJrlBWHuhg6tZjRroZU+uazn66C7LyeUb7sRsyovYyuVSiMjP+/DJ9ymWRGl01WYJiIO5mcpp8xLS1mJBweNGjjwjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQXzSzeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQXzSzeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A1AC4CEE3;
	Wed, 23 Apr 2025 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421684;
	bh=a2A8L4/XOW/fEuYDj8yb2VNOFIdqTgfbQIagIYouRDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQXzSzeTGY/F/p9ryzQjfK76Q3K61Tuzm5EowWDrEhdbdgPO3VKPHqGu91nBAtOUs
	 xFQlk9dE0NJzjj5smk38PJF8/dyBEn1PIwm6MFgk6JangbBDgTCgoMDTBw85uacV4K
	 ussJGzXQH5vVEI4MWeVyv74RaA6LekumeUYYJ9yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/291] wifi: at76c50x: fix use after free access in at76_disconnect
Date: Wed, 23 Apr 2025 16:42:35 +0200
Message-ID: <20250423142631.174740977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 24e609c1f5231..4a15c22cf348d 100644
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



