Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194DE3DFC7D;
	Tue, 31 Mar 2026 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974869; cv=none; b=dfr/GbwAgD2NfV/JAIsLc87bciJpX0v94I92AzS4SSZrU8zPluQXiLjeDjc80Rt4B6Ze3anAwe3jXwX/rooYzJUwJ6UHQOqa4wWpOa5Qk9Q8p1djZyPiNECSh2fpMc+3VSVEqkJLF+QWSvQ+7t4cMN/XhvqvWl/ifHmB3RcN5Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974869; c=relaxed/simple;
	bh=FcO+aGKHnlhJXFHaL6/1NVzuliFA2PUv/6rbg81ReyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7I4+GH2hFivaxqBZ13fyVbYJTrUhyxy0LUgf4UHClpOAOYgIoEkAk1KR1ZEp92RcSYGeaD+eKhWNTcVPEu53ioi4ja/KndIYg0Q4I85b6oLL+Wc2qVbceKokvp2SpElo8bfBAJqOAmB/O59G+fBco81sp81gLcAkiiS2JePwOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNI8MCB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNI8MCB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E79BC19423;
	Tue, 31 Mar 2026 16:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974868;
	bh=FcO+aGKHnlhJXFHaL6/1NVzuliFA2PUv/6rbg81ReyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNI8MCB3hEwiJXff1GsV3zP6KgGgVgngsxvse5Q7cNEJzP0et7LeGy5XwxzDOXtf/
	 MvnQzlZby6UQGwp/io8eJJVqMAzgyDjq/uMa/XqEhpbcGU06K4N6u+uGZFr+UqLp4s
	 8SL361K4ur3ttEBh6BMBDI/jpVaLfW+EVRk4iMnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 075/342] ALSA: usb-audio: Add iface reset and delay quirk for SPACETOUCH USB Audio
Date: Tue, 31 Mar 2026 18:18:28 +0200
Message-ID: <20260331161801.653765326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit 5182e5ec4355dd690307f5d5c28cbfc5b2c06a97 ]

Setting up the interface when suspended/resumeing fail on this card.
Adding a reset and delay quirk will eliminate this problem.

usb 1-1: New USB device found, idVendor=0666, idProduct=0880
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: USB Audio
usb 1-1: Manufacturer: SPACETOUCH
usb 1-1: SerialNumber: 000000000

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB6217ACC80B70BE25D87456B0D247A@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index caca0e586d832..d87b988516bbf 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2239,6 +2239,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IFACE_DELAY | QUIRK_FLAG_FORCE_IFACE_RESET),
 	DEVICE_FLG(0x0661, 0x0883, /* iBasso DC04 Ultra */
 		   QUIRK_FLAG_DSD_RAW),
+	DEVICE_FLG(0x0666, 0x0880, /* SPACETOUCH USB Audio */
+		   QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x06f8, 0xb000, /* Hercules DJ Console (Windows Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
-- 
2.51.0



