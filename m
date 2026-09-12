Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0094248C6;
	Sat, 12 Sep 2026 11:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213010; cv=none; b=dOybZHzW9V/qq3eO3gY9e4B6WR8+EqoLFfrHh5m3sTtkUhjTtzN1Y7ON9T/lWAy0i73tVtYLmPrE0f9JcfrEQ7W5JeB8k1qyO5iqg+sdrYodqeGCV1M1xezBsxtqseK7ZUcHIeVklb1PMlikEv8sEV/az9kKjg4qgEwtlQJG3Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213010; c=relaxed/simple;
	bh=taCYChZi1CnIMKgv5Twsa0Nxgl7pn/aL/kFOy9TdXpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcpF3dTTJwb0tEhLK49k/SXBHyz9awn6oD4izoTFNowg7Ocgrr8On69cVHprgicRi6PohOoxcy2zLcp+TuxXm3MYQPUA8vDVUmzVE6lVj33Q+vNxlwhTk23V+3tkVcv+IY7gee4rP6VJK6/txzijdm/fFJC/Yzlb/fWdgTeOOlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJCf10MX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJCf10MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083D01F000FF;
	Sat, 12 Sep 2026 11:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213009;
	bh=XFbQUhU+TEMWYulv/iAyU2XlZvMmFdmKxaxPfCjt3gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJCf10MXjcBf/Sx+pR5zP3L8gBMujudYtHGcGkUT4Nf2ERfg3fByBXnBff/VexKRx
	 XVAN7ELJTpV1U8A4ItVIa7hc4rt5KCxZ32uy/vzk3LllJsIkPJ0W9CUhKm4bf0WTZM
	 yf998WnRABXMJZalR9DA7zvDX9S4x72pY5Ud6XrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 6.12 0033/1376] staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()
Date: Sat, 12 Sep 2026 08:40:59 +0200
Message-ID: <20260912065608.291388609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit ff917923f4fb9c83717ba135ee47d7e4c1567bb7 upstream.

rtw_action_frame_parse() takes a frame_len parameter but never
actually checks it before indexing into the frame body:

	const u8 *frame_body = frame + sizeof(struct ieee80211_hdr_3addr);
	...
	c = frame_body[0];
	...
	a = frame_body[1];

frame_body already points 24 bytes (sizeof(struct
ieee80211_hdr_3addr)) into frame, so reading frame_body[0] and
frame_body[1] requires frame_len >= 26. A management action frame
shorter than that (e.g. exactly 24 bytes, the minimum a malicious
peer can send) causes a 1-2 byte out-of-bounds read.

This is reachable from rtw_cfg80211_monitor_if_xmit_entry() and
cfg80211_rtw_mgmt_tx() in ioctl_cfg80211.c, both of which pass
attacker/user-influenced frame buffers and lengths straight through.

Add the missing length check before frame_body is dereferenced.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260728125456.32359-3-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -1153,6 +1153,9 @@ int rtw_action_frame_parse(const u8 *fra
 	u8 c;
 	u8 a = ACT_PUBLIC_MAX;
 
+	if (frame_len < sizeof(struct ieee80211_hdr_3addr) + 2)
+		return false;
+
 	fc = le16_to_cpu(((struct ieee80211_hdr_3addr *)frame)->frame_control);
 
 	if ((fc & (IEEE80211_FCTL_FTYPE|IEEE80211_FCTL_STYPE))


