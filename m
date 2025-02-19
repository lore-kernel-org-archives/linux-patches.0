Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BB51DE8A8;
	Wed, 19 Feb 2025 09:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956152; cv=none; b=P/KG0RT6yd2MC6HR6YIqzANn8SfP6I5Jq0s+nA1p3a7oQCYZtPWxlbf/N1tr1n76pcWMYS5HkfIKLOaX5sxVHhQ13gmMoNjmVtRbA28IwRNA2cTbEZzrGgKkoX1QOPAovJnVP+xFgR+LfhnGh6iTGQ+aYVQLDaF5+3B8QLUJf2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956152; c=relaxed/simple;
	bh=2pZyvf6wHfQSX/B57gMRQpse5sCgoCi6RuJ0gtSWaEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TNMm+ysbQKnOymGeTuCXVpgWq4+gBTtQ4prMJdV/1aCXFYIbxyiHRk5XwBDXPURaB1Ov2EqKm/6QvFI9xmWwwI+K5MRdStUsYONOJ6jVwSrLP6rw8GiO2qE1OhdDV+CA3bKDzC5x6m1hf4PD43jch7w+fZH0VPK2b0o8JA5cvOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZEFRSoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZEFRSoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F82AC4CED1;
	Wed, 19 Feb 2025 09:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956152;
	bh=2pZyvf6wHfQSX/B57gMRQpse5sCgoCi6RuJ0gtSWaEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZEFRSoDfdjMCN0Mx/Eh8k+y4UgaKul5MRu+kT8OYoRwwr3/yipFwV30kUcJOywck
	 R3sbGCv958pTzog2NCCF6QOvpDUt3YOO63QcaB3SpujBBICbDVO0ib1ClnwTyrlwKV
	 LIU5+IuPDxcW1YnF+391dUD0AatzYGa5uJ3QfJeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/578] wifi: mt76: mt76u_vendor_request: Do not print error messages when -EPROTO
Date: Wed, 19 Feb 2025 09:21:27 +0100
Message-ID: <20250219082656.228235300@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0597df2729a62..1e2133670291c 100644
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



