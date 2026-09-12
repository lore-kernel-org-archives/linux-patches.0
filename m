Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A19D325726;
	Sat, 12 Sep 2026 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221216; cv=none; b=pTVrIo3tFl7UWDhzzXfgsa+C3Hk/JwfQgs7zGqYeLf0/ISyMhIWZprs1SFdtvl9vL/u4lGH3dcSPF5lUBtLnEI1fqX9VizZw+fWJRYZjO8U8Atpci+gNyh5uzyvPTeuk2CZNKTCx3OalWa96UDrie0vhkV5xMTKTPV9Z/WaD75w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221216; c=relaxed/simple;
	bh=gFsNzthM4FRUjAVtL6Oe47nY2g7fKx+a0sOBTU7toCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1S50vd3bUqRW70VQkSNfOhGiIVyOFOOfnzKKh4wXCC+NKrAL9e7u4ZvHUK/ra6uhbNiyXl57OsW/1xXn9L0/JLQDoiTVNDX5mZXgm8Jqc0C01uGGsgSYA9r5JUFQ9KA9Am7lFp7RPQuDaRkI8+3xK/Kj7fwk7zFMK01v6FKLiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9YkYmsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9YkYmsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1D41F000FF;
	Sat, 12 Sep 2026 13:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221212;
	bh=p7WVKlvsi8HgT7YkWC7duPkhy1vWofQIUx5YGwogiPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9YkYmsUyjEBb6NcVyH53dDO10gwWXVxk8pP22bblIJWKSSAct3QOYezbsxfbK9Rk
	 ZT5UHZuFvQZNzbTfIXvMhyh5wv8iefrvzaj8MIgCojX/lVAXWi+3fccYOYdPpcdxSN
	 mqMQs+hpeKyZKCcF+tPDFHru+e2rzlax2eQWES2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 6.6 0335/1424] staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()
Date: Sat, 12 Sep 2026 08:46:07 +0200
Message-ID: <20260912065614.788202511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


