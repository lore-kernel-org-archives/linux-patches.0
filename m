Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B32043B498;
	Mon, 17 Aug 2026 14:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978180; cv=none; b=fUGSd1mymp2TmyT+Jq5nHNLWzE5w2VpElUAvfK7ajPFg2BqhDXOd1rnc/U92g3jv7JE3hAWb08Y+W5Zz6ON8CYo6JhvRPiKRyXewluz912/KQ99XrixA6Ab6+kGfQd2w5jKTDad/620s9tvBFTToDd3NWyNf1PGmOLRPFG75ZtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978180; c=relaxed/simple;
	bh=gc7Cm72dTZnxyth4fECh5STxLtp41Rae2jBZpauh6r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXBAS1gFN5nXIxpJYTtzGG3oRXQHmSsgKKIszmjxtjUOzrKJwIQHlmIitKvFrEALLbnL28BVDTDnP0EhUWkm7T7Qekv35GqqQxbIJ7b9BeJO3NRKfwnhSWVJB6g7WETUyk1noIgYzpGdq0HJpJ2D/h/qmuOJ4yxaLbAxdZxs8WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuO6GjUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuO6GjUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777CA1F00A3A;
	Mon, 17 Aug 2026 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978177;
	bh=2jD+gLA0xJRQCtY/tvdD2Z0B6jj/L5Ms09GyHoZqAKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuO6GjUKFbHXlXZPUAk0wieM8rc1N3DdkYie/PRPFRLF/2iRg3mZ7kAXBx6pM4KwP
	 RHv8313SedctWzyZZcED04qENY7kxQkHR7Ryt39onxx5filDUtKBe5yLWUc1slPrVd
	 nhazibCIEFheNCyt4hwPX2+Q7Q3sTaVZKLV5W1Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH 6.12 129/181] staging: rtl8723bs: validate monitor transmit frame lengths
Date: Mon, 17 Aug 2026 15:33:43 +0200
Message-ID: <20260817132540.669895895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
@@ -2041,6 +2041,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 
 	/* Skip the ratio tap header */
 	skb_pull(skb, rtap_len);
+	if (skb->len < dot11_hdr_len)
+		goto fail;
 
 	dot11_hdr = (struct ieee80211_hdr *)skb->data;
 	frame_control = le16_to_cpu(dot11_hdr->frame_control);
@@ -2053,6 +2055,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 			qos_len = 2;
 		if ((frame_control & 0x0300) == 0x0300)
 			dot11_hdr_len += 6;
+		if (skb->len < dot11_hdr_len + qos_len + snap_len)
+			goto fail;
 
 		memcpy(dst_mac_addr, dot11_hdr->addr1, sizeof(dst_mac_addr));
 		memcpy(src_mac_addr, dot11_hdr->addr2, sizeof(src_mac_addr));


