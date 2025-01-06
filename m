Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AD2BA34;
	Mon,  6 Jan 2025 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179121; cv=none; b=pMEbDZpvKyA+91qBfxH7IBqacI8lIjkJ/fjYe2d0/PME+cYnfWYNXKRkRUmkd81ojlK0kYhlJ0OI6tBPiEzV+Q+wr5BE2tL0RpKm2upYo7LkGobtqq8uU6u1wYHjFYu0DGf4OUyi2HensS+jso8EufCtmSqY7PpVFQfRlrtib3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179121; c=relaxed/simple;
	bh=blMGlsdyjCTi/qeEagjtA4EklLZurvz80FDON+ZlHm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rieRMGhkatTZuha5viFfqVXM7SfufDMzEIUEHRfqbtCh39RfMOw0XRmuZclIrE4By6c1FXR6WzaHXMzxBhHcmos06V19ZFBOZkI4oqJjiWUZRw1eFXQfNT79mBRqva7hMHH0Xo8PCzn1VyNkH4eYKKr2//n/0DR3rBWFZfe6KmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MicplEMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MicplEMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71734C4CED2;
	Mon,  6 Jan 2025 15:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179120;
	bh=blMGlsdyjCTi/qeEagjtA4EklLZurvz80FDON+ZlHm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MicplEMKo5XTOjluiXy7BlWJK5UzVzRWvobWbMg6vbKeyCNPfNOibCqviFfdGpDTf
	 C5Eg+26dWnn/MeYnrQMLSYO6lpHqXpHzoaizTYOVNhzRk38d81D7CPFwNI9bG9FdOK
	 4HRM24DTaLNVGTVfJcR/nhrzsm4CbwiyABRN/zyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c88fc0ebe0d5935c70da@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/93] media: dvb-frontends: dib3000mb: fix uninit-value in dib3000_write_reg
Date: Mon,  6 Jan 2025 16:17:09 +0100
Message-ID: <20250106151129.953776175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 2dd59fe0e19e1ab955259978082b62e5751924c7 ]

Syzbot reports [1] an uninitialized value issue found by KMSAN in
dib3000_read_reg().

Local u8 rb[2] is used in i2c_transfer() as a read buffer; in case
that call fails, the buffer may end up with some undefined values.

Since no elaborate error handling is expected in dib3000_write_reg(),
simply zero out rb buffer to mitigate the problem.

[1] Syzkaller report
dvb-usb: bulk message failed: -22 (6/0)
=====================================================
BUG: KMSAN: uninit-value in dib3000mb_attach+0x2d8/0x3c0 drivers/media/dvb-frontends/dib3000mb.c:758
 dib3000mb_attach+0x2d8/0x3c0 drivers/media/dvb-frontends/dib3000mb.c:758
 dibusb_dib3000mb_frontend_attach+0x155/0x2f0 drivers/media/usb/dvb-usb/dibusb-mb.c:31
 dvb_usb_adapter_frontend_init+0xed/0x9a0 drivers/media/usb/dvb-usb/dvb-usb-dvb.c:290
 dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:90 [inline]
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:186 [inline]
 dvb_usb_device_init+0x25a8/0x3760 drivers/media/usb/dvb-usb/dvb-usb-init.c:310
 dibusb_probe+0x46/0x250 drivers/media/usb/dvb-usb/dibusb-mb.c:110
...
Local variable rb created at:
 dib3000_read_reg+0x86/0x4e0 drivers/media/dvb-frontends/dib3000mb.c:54
 dib3000mb_attach+0x123/0x3c0 drivers/media/dvb-frontends/dib3000mb.c:758
...

Fixes: 74340b0a8bc6 ("V4L/DVB (4457): Remove dib3000-common-module")
Reported-by: syzbot+c88fc0ebe0d5935c70da@syzkaller.appspotmail.com
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20240517155800.9881-1-n.zhandarovich@fintech.ru
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib3000mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib3000mb.c b/drivers/media/dvb-frontends/dib3000mb.c
index 282cdcf9f21b..b7c729a5ab9e 100644
--- a/drivers/media/dvb-frontends/dib3000mb.c
+++ b/drivers/media/dvb-frontends/dib3000mb.c
@@ -51,7 +51,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,2=xfer,4=setfe,8=getfe (|-a
 static int dib3000_read_reg(struct dib3000_state *state, u16 reg)
 {
 	u8 wb[] = { ((reg >> 8) | 0x80) & 0xff, reg & 0xff };
-	u8 rb[2];
+	u8 rb[2] = {};
 	struct i2c_msg msg[] = {
 		{ .addr = state->config.demod_address, .flags = 0,        .buf = wb, .len = 2 },
 		{ .addr = state->config.demod_address, .flags = I2C_M_RD, .buf = rb, .len = 2 },
-- 
2.39.5



