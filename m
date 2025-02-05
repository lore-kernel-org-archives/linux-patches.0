Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0891547D8;
	Wed,  5 Feb 2025 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765439; cv=none; b=cs+ccWsuOfEz/jrYm8fnvyJ4ovNXO7NN/cDUHmT5m9iDFWCjTsGFRuU3XMGqV/q/U6EwEARMDnUXaMERtQBfBxq8w8msMuF2bnzNbtSCYKQHQ5RTb41nsGsdM29tQw9xmF9FL3sVL2zlegLXnOWcf7k5KbrpiCjzdTcnn9a/nl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765439; c=relaxed/simple;
	bh=aGsScEKeX/Urbc22KJyEdoNaJz8oEQ+uVi/FtPx1EYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IexXG2d0Jy80uZZUsH1dHkF7fMY1jHPVK0Qhi4hRnPdlfUfdbBbiuoGaD/FnU+Aj3N5uO9+0sbK3eLitaMTt0rf7bMAz+8vxTmNXRelElpE2uoOqyIuq8VOBnA7dk9itWclFbAMKZ5O/tHhFsWle80juwTw2Zk6XmhY6rYvCucM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHBvIJrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHBvIJrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AE8C4CED1;
	Wed,  5 Feb 2025 14:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765438;
	bh=aGsScEKeX/Urbc22KJyEdoNaJz8oEQ+uVi/FtPx1EYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHBvIJrrpkFE2jR1qTl/SgiZMB5g7s9dZMp9abHK/PHv9Hs2IjbvSGdcWVVuESLUM
	 onA3K5NUV9anhK1Dumm9h7nWl98n4/O1uqvZdt8KjPwXlQgf9zWZQUDtt+G7h66+Ul
	 ygs65uAGmJb5svNkTBnz3EEhl0ighnqYEXm6zXr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 178/623] wifi: mt76: mt76u_vendor_request: Do not print error messages when -EPROTO
Date: Wed,  5 Feb 2025 14:38:40 +0100
Message-ID: <20250205134503.044017952@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit f1b1e133a770fcdbd89551651232b034d2f7a27a ]

When initializing the network card, unplugging the device will
trigger an -EPROTO error, resulting in a flood of error messages
being printed frantically.

The exception is printed as follows：

         mt76x2u 2-2.4:1.0: vendor request req:47 off:9018 failed:-71
         mt76x2u 2-2.4:1.0: vendor request req:47 off:9018 failed:-71
         ...

It will continue to print more than 2000 times for about 5 minutes,
causing the usb device to be unable to be disconnected. During this
period, the usb port cannot recognize the new device because the old
device has not disconnected.

There may be other operating methods that cause -EPROTO, but -EPROTO is
a low-level hardware error. It is unwise to repeat vendor requests
expecting to read correct data. It is a better choice to treat -EPROTO
and -ENODEV the same way.

Similar to commit 9b0f100c1970 ("mt76: usb: process URBs with status
EPROTO properly") do no schedule rx_worker for urb marked with status
set  -EPROTO. I also reproduced this situation when plugging and
unplugging the device, and this patch is effective.

Just do not vendor request again for urb marked with status set -EPROTO.

Link: https://lore.kernel.org/all/531681bd-30f5-4a70-a156-bf8754b8e072@intel.com/
Link: https://lore.kernel.org/all/D4B9CC1FFC0CBAC3+20250105040607.154706-1-wangyuli@uniontech.com/
Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Co-developed-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://patch.msgid.link/9DD7DE7AAB497CB7+20250113070241.63590-1-wangyuli@uniontech.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 58ff068233894..f9e67b8c3b3c8 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -33,9 +33,9 @@ int __mt76u_vendor_request(struct mt76_dev *dev, u8 req, u8 req_type,
 
 		ret = usb_control_msg(udev, pipe, req, req_type, val,
 				      offset, buf, len, MT_VEND_REQ_TOUT_MS);
-		if (ret == -ENODEV)
+		if (ret == -ENODEV || ret == -EPROTO)
 			set_bit(MT76_REMOVED, &dev->phy.state);
-		if (ret >= 0 || ret == -ENODEV)
+		if (ret >= 0 || ret == -ENODEV || ret == -EPROTO)
 			return ret;
 		usleep_range(5000, 10000);
 	}
-- 
2.39.5



