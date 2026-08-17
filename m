Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA772EEE73;
	Mon, 17 Aug 2026 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980545; cv=none; b=FTGpD7D0R2YqeY/F5aOMupt1pTBQ1pQLJP0AXrCIukEgffGAsqVRBSQOxN/EyNaPEJbT4Im/Es7hLQxUGcubhQw7ZAGPdNLrc3DFr/q3geT9BlZtS7fM94gJuOwhMRUjC6SY1ypKOdTm5AO0sr0e74ysCwryrbO+XCf3tNJfMo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980545; c=relaxed/simple;
	bh=ufQMn4eU40oh+hF+781OslDUPtyqYegsYGQ6HB+XGSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYPi3/orFP+128ViDt+iDb25uj8gk7wDd7KT2nNq5/jvS05BBgEkySx91pv1n76KVLIXbqPHdeIxBe6CD43BCmDuVzZPGZA/8SR/r0fdZc5ohccQrsC21Vn+6bxErp1MVGFlc2qhr8MddCbQxbQqAgl/hCYtcC5TGa2IpEQ/rdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFxSd0mI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFxSd0mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104C71F000E9;
	Mon, 17 Aug 2026 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980544;
	bh=h1IAEn6uekmhSlvJlPoDLsC+FFPGx+zqMvzyFdTdaRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFxSd0mIv85LNoUB9mwiiwmcAmxEN7Gzlq3Xq5kGT4KZoNYeG0QuiEY9bLOvxMfcY
	 bquWqVJz+MBXYDBazA3+AtDuiKi+Panso6ptB9u/3SIp6afXy8mMnm7cYNRWv7jG7z
	 tG7h2yl6kVCYRAAWuww34VV83Ap1CxXN4mPA/MGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH 6.1 573/609] staging: rtl8723bs: validate monitor transmit frame lengths
Date: Mon, 17 Aug 2026 15:34:29 +0200
Message-ID: <20260817132602.898697969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mariano Baragiola <mbaragiola@linux.com>

commit 6829665d050983907b560173e49dcc6c11cb2730 upstream.

rtw_cfg80211_monitor_if_xmit_entry() removes the radiotap header and
then reads the 802.11 frame control field without checking that a base
802.11 header remains.

The data path also pulls the calculated 802.11, QoS and SNAP header
span before confirming that the skb contains it. A truncated frame can
therefore cause out-of-bounds reads or leave insufficient data for the
Ethernet address writes.

Reject frames that do not contain the base 802.11 header and data
frames that do not contain their complete calculated header span.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>
Link: https://patch.msgid.link/20260727160859.1917096-1-mbaragiola@linux.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -2075,6 +2075,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 
 	/* Skip the ratio tap header */
 	skb_pull(skb, rtap_len);
+	if (skb->len < dot11_hdr_len)
+		goto fail;
 
 	dot11_hdr = (struct ieee80211_hdr *)skb->data;
 	frame_control = le16_to_cpu(dot11_hdr->frame_control);
@@ -2087,6 +2089,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 			qos_len = 2;
 		if ((frame_control & 0x0300) == 0x0300)
 			dot11_hdr_len += 6;
+		if (skb->len < dot11_hdr_len + qos_len + snap_len)
+			goto fail;
 
 		memcpy(dst_mac_addr, dot11_hdr->addr1, sizeof(dst_mac_addr));
 		memcpy(src_mac_addr, dot11_hdr->addr2, sizeof(src_mac_addr));


