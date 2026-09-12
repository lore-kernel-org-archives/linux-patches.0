Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C53CDBB5;
	Sat, 12 Sep 2026 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237372; cv=none; b=orSPHbscBxTNcxDa56/aqKakAU9SiYJmSvGma7MvOmxcEF10lA9EtPgEJI9neN6ShFdfqk/Lxr+lBp3oRyy8ckkoe4Qj/ZQDMUMWRh4fnFZspYBY45eyKo0DstfE//LmHg0oZqArlYylToBFezSbPqEX19xGsfcVeRjkPyTvDM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237372; c=relaxed/simple;
	bh=bn997AExHbMvk6pDT0Gt6q8FfF7CjMk9e4o0kAJW9Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DohiYscSu/Qxno4X328KWzXemh5gNcK0oM6X+QR79J6NE2oCQWoi46jERJFNxtglQrQrv7xJMY9MGDc1oJPCp6mgEaPQp6CSBmjqXcsSZdvgfclOuMIyBxhEFdeB63uGKcboIkAIxY5TTWouJtn8JJzFEBP2xLXjGTS/2Sn2L7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sy2O4CcE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sy2O4CcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51B31F00893;
	Sat, 12 Sep 2026 18:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237371;
	bh=4ChJI6YHXv/V2pnlW0ssOJ7nxBs/2MF8s+JD7zB2wKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sy2O4CcEouwF5iS+eN3FWQQx6sDYs4LyJ6oWnqVn2dBsIBkXRFyLd8AoPCpTXu2Js
	 OFlrNAdh/fgYg+IXM7Z2ZdUw6bsCUb6XAGEYbJhXL6hIfp+/SPjgX6Z2g2gKADI3I9
	 V9jvVk1ckBOtaXoHaHsyVsJqKoztQpb+G+TVEbz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 5.15 244/935] staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()
Date: Sat, 12 Sep 2026 08:54:34 +0200
Message-ID: <20260912065532.421336092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1169,6 +1169,9 @@ int rtw_action_frame_parse(const u8 *fra
 	u8 c;
 	u8 a = ACT_PUBLIC_MAX;
 
+	if (frame_len < sizeof(struct ieee80211_hdr_3addr) + 2)
+		return false;
+
 	fc = le16_to_cpu(((struct ieee80211_hdr_3addr *)frame)->frame_control);
 
 	if ((fc & (IEEE80211_FCTL_FTYPE|IEEE80211_FCTL_STYPE))


