Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38DC54781;
	Mon, 17 Aug 2026 14:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976498; cv=none; b=h1wrFXO4pnlPw9iLJY2J60w59nLUKgz0F2SRzXRckAns5/MjS1nZ0YvfW3SiAaJ9Q75bWULIbJUwD5N9cgACk88d61o4i7VuskCkx8L3ldQFi4KpptrKIbedU66/WNqDTp0DlRADwj7APDDFBHRCRmzeSKXODaD9996sAk4FX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976498; c=relaxed/simple;
	bh=eCrLLtVVUzFCA20piLzHszJovDtKyl2MmgLebyvmRD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1y60UuklS5pdhnYwJsXY72/U0B7nPjbk6sdywYzh9ux8do+bVz7WcYHCfrPECJPCTrcbO++kufX8ZfK0BNFPDoUTpAExBEvcJzRKDQWTaeWEeob95zMXIczPNartfJDsCh3sXFm4Ze1eNcKWmaw8J37kh0N+T9NlI+7J5CYkIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MW1Ja/1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MW1Ja/1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3749A1F000E9;
	Mon, 17 Aug 2026 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976496;
	bh=9OXQhgZUTfhzSY1q3adsIILv1O1luNGheEhKSPCvJ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MW1Ja/1gnKv2jSnndbeuQkQ5ZIPohcGRRajP7kXcId8qMMZXc9RpCPcyslZMWEhCd
	 mjdsHCPzXQqvJtFmOPvnbp1iz9x7C94x6y64rGiWR9gKIBLu19L8BP81otaDTKdkXl
	 FOSXjA0BKk9ZnRQeCj0AxH+mzRxyrg+bl4j3UKw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH 5.10 367/389] staging: rtl8723bs: validate monitor transmit frame lengths
Date: Mon, 17 Aug 2026 15:33:26 +0200
Message-ID: <20260817132553.027467301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2451,6 +2451,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 
 	/* Skip the ratio tap header */
 	skb_pull(skb, rtap_len);
+	if (skb->len < dot11_hdr_len)
+		goto fail;
 
 	dot11_hdr = (struct ieee80211_hdr *)skb->data;
 	frame_control = le16_to_cpu(dot11_hdr->frame_control);
@@ -2463,6 +2465,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 			qos_len = 2;
 		if ((frame_control & 0x0300) == 0x0300)
 			dot11_hdr_len += 6;
+		if (skb->len < dot11_hdr_len + qos_len + snap_len)
+			goto fail;
 
 		memcpy(dst_mac_addr, dot11_hdr->addr1, sizeof(dst_mac_addr));
 		memcpy(src_mac_addr, dot11_hdr->addr2, sizeof(src_mac_addr));


