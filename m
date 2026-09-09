Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2FC353A82;
	Wed,  9 Sep 2026 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963448; cv=none; b=mBKm8czYCBY/fJW7uHxfrjnpC6gpAlLOYlIaROe30b08FeTLDp1KUQ1NCfMdNWSzc4cFL+RnU5AaoKfHNly1JJ0z4bGLbIhBVxxwVj/APZA0v4pkjloBbRTW6l4P8nL4EgMC3Noh2BiswtE5Xcwml+WXNOa+uXFfz4p1ykoV13Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963448; c=relaxed/simple;
	bh=T8UVojdV06oP9hTMaxdR19RPkkK+G3gXgsX/P1dcmvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glwgfUOFx6GkXyJPQ/9I80/4ioKZvCyZK94sgKI10TYC2VJvkAejQks1SnGRBA/Lo6D8H0hOARtP3+FCYq8uNdAKBQ8+j2AtgJRszkQo54y/eI+NueKk+s6LWrHcqDDLfc9n73KfE5CNnv+DcBBSykIgW9oeO6pHHITqnlFrVqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2nlujwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2nlujwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D31B1F00AC4;
	Wed,  9 Sep 2026 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963447;
	bh=8TawFIW+3ntyd28U2QnyK5S6DaLOZrngh4/OxnCWuBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2nlujwaTw96ZKjtrqR3Ao8C4PBcLOFZ65xArt+Ij67skxfThizywkD+9XJsXaHgj
	 wiUrq4hYKJg9s++ednsd3933zKzKoo8NgP/jcUUUpImV2IJ15wZs0oJNDATTyjCXrn
	 6mbBwjgwfE9IVanXcZui1jYh07U/VTAmtOEJ8Ryk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 6.18 033/583] staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()
Date: Wed,  9 Sep 2026 15:35:18 +0200
Message-ID: <20260909134238.982733477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1152,6 +1152,9 @@ int rtw_action_frame_parse(const u8 *fra
 	u8 c;
 	u8 a = ACT_PUBLIC_MAX;
 
+	if (frame_len < sizeof(struct ieee80211_hdr_3addr) + 2)
+		return false;
+
 	fc = le16_to_cpu(((struct ieee80211_hdr_3addr *)frame)->frame_control);
 
 	if ((fc & (IEEE80211_FCTL_FTYPE|IEEE80211_FCTL_STYPE))


