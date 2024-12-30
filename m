Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D10015E8B;
	Mon, 30 Dec 2024 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573697; cv=none; b=r/aPVxJAD5MwB+5ww4VhdtgBtU3121SswKyDhv2PMPC8ssZrdH0HbZVZbfXcYq6AMiv4OcqYeSH51nqHluBSONGuLwAlv/eI/nLH02dcs7Vno/fVD0/iBe6Rakx7DNzORRN4XPTctfyIGPtqQHnyy7EX67T56mziPVVR9gkoZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573697; c=relaxed/simple;
	bh=rILZxPX2amvWyJYjMmcP9qIf2gEzSWiWJQqzTUON41I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDGGzlpwqdoJcnh3C0jX/MzbibNq1/yAjEgulc6gwpx4FVgNLYcHI4vFzK+culHhh6n9JLz5dT1T07AdLB2UPWiEZhtAq7FRuUFru2T5C8aAKrJhE5f18CnR6AL9ZZBSReUVSIE2R7tqP0dFfqWOgKpgJlsgINXeZPZxtNO0dhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqfCNNqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqfCNNqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98686C4CED0;
	Mon, 30 Dec 2024 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573697;
	bh=rILZxPX2amvWyJYjMmcP9qIf2gEzSWiWJQqzTUON41I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqfCNNqS+NGUTwI/uUHLCZiyycGFpuOR1dSonbm0lYgyicbQ/bbieTnmgy2zypdhR
	 LOX2DbRTbPgEckT8J4MeLOe/h90TXcVCxJq346d2+jd4PGIaOIRN2hx9por/8jWgt9
	 69wzldCYzpdeJaL4Y5tNK4+bYYn6ODebwws00tSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c88fc0ebe0d5935c70da@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 01/86] media: dvb-frontends: dib3000mb: fix uninit-value in dib3000_write_reg
Date: Mon, 30 Dec 2024 16:42:09 +0100
Message-ID: <20241230154211.770832033@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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
index c598b2a63325..7c452ddd9e40 100644
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



