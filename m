Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F3F25E82D;
	Tue, 11 Mar 2025 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706407; cv=none; b=GuukeJt0Tww+9eleHoMoXymc/p3ZeQkgicxGfpYllRJTNPO6N4Owyslyierj8+xrkgVNfusin4rlMlWs7gZzJqJ999+sFPH7OePQyLmsBRHzh4or+BUFe7BYjAZ3RGDHTeBuDKIobtjSQfl3yuB9UW907/hd7ElPu20Dg6wMgiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706407; c=relaxed/simple;
	bh=C9qbXkImqAMkLSQ4YpuFYk5YiOv2iGhAYQSD70gNB3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xe4R09IOmiE1YA5Xn7QrOA4LGMn/iYp8d0ZzwlTzueLw2eLmwVf8hvV6Q666gZi5+pTwjMCh9QBsaEKfBcuMPfzRpz7geLAj2voxhI2KzvX81yL6ledTszlunA4rWld1acGGjYRFNTAYGaktuyf4Zn6gycgKRGlzL3G6xT9EXJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tW3FlOKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tW3FlOKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01C4C4CEE9;
	Tue, 11 Mar 2025 15:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706407;
	bh=C9qbXkImqAMkLSQ4YpuFYk5YiOv2iGhAYQSD70gNB3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tW3FlOKBXJ2dd69nxzaFHa4FDUisCXjGnQAZ8ifMdz7xjbQGHkAln0+bLOJQkc9g/
	 hKp0REtdeYmqNH996mUfCPw2/ee9LgMRTRQAf2RW2pZFxT4Zb7ySuIqJ/AfAOcKpVz
	 vRyNDM//B9CwYpZXOVA7qHk9fiew4JbzwiqwHVtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/462] wifi: mt76: mt76u_vendor_request: Do not print error messages when -EPROTO
Date: Tue, 11 Mar 2025 15:55:03 +0100
Message-ID: <20250311145759.818856101@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1ae9ff835b23..07a563df6d6d3 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -34,9 +34,9 @@ static int __mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 
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



