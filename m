Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C896D248891;
	Mon, 23 Jun 2025 13:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686099; cv=none; b=pksePn8huka5jEVeNlbPMjD7EK1TcXms9qe32mEpIsc3SsozAX2KfKufD+YBmmHoSZ454Hkumc2INzMmhF+H+8KiD8dKRLlwulZUewTD/DywbkDXcwp6/r7waaJvjAHn2keuQoDuRWh/Md5qs3YT1LoxhZPbSc3vRwWwmjYlpw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686099; c=relaxed/simple;
	bh=gl+uYTnazoNDKlMjsRcLVvKpjtOPnXtd+1xFPXz2NDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efqwDnzSOVmk7J/tQIMXgUC2A9sjQCcT+OGjlIjsmGaPKCbe4wcTQmhA8FW0YBbANUvQTJHsKx2zLYwvCznkBcWc5W6dcUJAWxu1s504mk1S/oawobdyDe0sE9HKJyY7fooDvgXtdHOUcOrwcJBrZg3w1pa9OHD/WczMd8feHfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZMi+T9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZMi+T9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C26DC4CEEA;
	Mon, 23 Jun 2025 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686099;
	bh=gl+uYTnazoNDKlMjsRcLVvKpjtOPnXtd+1xFPXz2NDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZMi+T9LDX6bprxgZT0nW6LcadPzIIXyoLQy5WIT6UmS9D3QYPyS+kEb0mxbcH5Yc
	 Zb6QI4r+NdSrnIOIOv4hLFa5rktjbY6uwCERnwNAu/zBCyQyljHoFHhfpoPzZdNb+9
	 gZAsBczJiGhPFeaGtS2ppV4aSNpnPoJLrkieie/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 022/290] wifi: rtw88: usb: Reduce control message timeout to 500 ms
Date: Mon, 23 Jun 2025 15:04:43 +0200
Message-ID: <20250623130627.651330827@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 490340faddea461319652ce36dbc7c1b4482c35e upstream.

RTL8811AU stops responding during the firmware download on some systems:

[  809.256440] rtw_8821au 5-2.1:1.0: Firmware version 42.4.0, H2C version 0
[  812.759142] rtw_8821au 5-2.1:1.0 wlp48s0f4u2u1: renamed from wlan0
[  837.315388] rtw_8821au 1-4:1.0: write register 0x1ef4 failed with -110
[  867.524259] rtw_8821au 1-4:1.0: write register 0x1ef8 failed with -110
[  868.930976] rtw_8821au 5-2.1:1.0 wlp48s0f4u2u1: entered promiscuous mode
[  897.730952] rtw_8821au 1-4:1.0: write register 0x1efc failed with -110

Each write takes 30 seconds to fail because that's the timeout currently
used for control messages in rtw_usb_write().

In this scenario the firmware download takes at least 2000 seconds.
Because this is done from the USB probe function, the long delay makes
other things in the system hang.

Reduce the timeout to 500 ms. This is the value used by the official USB
wifi drivers from Realtek.

Of course this only makes things hang for ~30 seconds instead of ~30
minutes. It doesn't fix the firmware download.

Tested with RTL8822CU, RTL8812BU, RTL8811CU, RTL8814AU, RTL8811AU,
RTL8812AU, RTL8821AU, RTL8723DU.

Cc: stable@vger.kernel.org
Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Link: https://github.com/lwfinger/rtw88/issues/344
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/1e35dd26-3f10-40b1-b2b4-f72184a26611@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -133,7 +133,7 @@ static void rtw_usb_write(struct rtw_dev
 
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			      RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
-			      addr, 0, data, len, 30000);
+			      addr, 0, data, len, 500);
 	if (ret < 0 && ret != -ENODEV && count++ < 4)
 		rtw_err(rtwdev, "write register 0x%x failed with %d\n",
 			addr, ret);


