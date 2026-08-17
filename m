Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272E6317144;
	Mon, 17 Aug 2026 13:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975129; cv=none; b=NqZnoQPQT8yhuNb13qf6ga9VBpoTYg3he3mibKXkmcmA6lw8jBDRu/1gTKLDC9OPrR60QnoN88ez0EaV9wBgMLpJBE5K5O8hUkhu8IJCrMGC0dx1qKQCsezcNQvKb+NnvwB2eQqU5LzL+zFXe+ctb3szO2oIlif3LreVi3r6Ywo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975129; c=relaxed/simple;
	bh=I89NKeHYiKpD23/Md4k4FaqPZxNOQ+w1VCCnvruyED0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqAoJFqjuPntEEnluyHkqxDIH5kABR3gbh1YvlJZG+JkRR+PM3QGK4yC7fNUK8oX1lYYooeDU7bwTmEFm92CxGoMVsjii48eKEmflYBP6DVwMsSOWxhfPGveJsBPUFytablcFlckmWPMpAYDIVKa4C5UNRy/AJh71xBPdTHStlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8JvGjuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8JvGjuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8001C1F000E9;
	Mon, 17 Aug 2026 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975128;
	bh=DZb/tR/QTbsGvAzEXpG8LG6rxK1lo3W1fbS6k/8UqvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8JvGjuV03LVoh2wWxBId1Ske3Sg/1HkHwGDNxnhnCprNBoGW/h4T+AERc/SQFeCH
	 oV9zbISDBJj4QNfR49azMrMGaVUsLRM56GNIsLNNxV2y1uldobOFj50/9T6W4nXnjI
	 fR1TRkyuy3KqVysOFzI0mshEH6ciyrcSwmwszhhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH 6.18 173/250] staging: rtl8723bs: validate monitor transmit frame lengths
Date: Mon, 17 Aug 2026 15:32:14 +0200
Message-ID: <20260817132543.688125546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
@@ -2034,6 +2034,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 
 	/* Skip the ratio tap header */
 	skb_pull(skb, rtap_len);
+	if (skb->len < dot11_hdr_len)
+		goto fail;
 
 	dot11_hdr = (struct ieee80211_hdr *)skb->data;
 	frame_control = le16_to_cpu(dot11_hdr->frame_control);
@@ -2046,6 +2048,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 			qos_len = 2;
 		if ((frame_control & 0x0300) == 0x0300)
 			dot11_hdr_len += 6;
+		if (skb->len < dot11_hdr_len + qos_len + snap_len)
+			goto fail;
 
 		memcpy(dst_mac_addr, dot11_hdr->addr1, sizeof(dst_mac_addr));
 		memcpy(src_mac_addr, dot11_hdr->addr2, sizeof(src_mac_addr));


