Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4563EEAE2;
	Mon, 17 Aug 2026 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974390; cv=none; b=dziLsDSmM1GZJDaP7GI88s/7nby+wr2oMfJz+5xmjVEH4DbFiT0vtt3tfuww+R1oUnc3OTFR/XPSTDtMrtP0aOTdWh9SaD8rQtg+ww9MecSAVwQBEqLecAx0uUIotdNHtN8sNTW7AIrQV3d1aSV5EUm4ChADjn48spMZ4cKlZqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974390; c=relaxed/simple;
	bh=iAmrk4p8vTm5eAY5C36CLA2khu7tBstfdUEaM7qlO90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1cD2b1dKaClwFfxTVAOvMrE+gv48jf5yLmh96GQe9XZ+VkKfBNtZNMBrEl8Jlsqy/eccJGmzj/4ILtPprLXhi57TrWfxMNyCBoQaiNirGlLL814ILHNREnC7ELCz/tYkh6ZNCL0vttOkZlJJSeM+kek5MT9OYPmHt8eX63cUp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBboMq7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBboMq7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ABC1F000E9;
	Mon, 17 Aug 2026 13:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974385;
	bh=cxgrMXTccqQV8jfvj1GrWOlISybU34cW4cqHElqtQh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBboMq7peGHFIPpEvuRbplzk25NPgiqR+7vb7S3VO+Lzj2v6Wc/I7vTPpsWDnoCPH
	 Ia6w5GluNZWZRwKvFtVK9YB/EUVXAI3t2779cNgiZrEnUvBLY6xRG3npDbt640P9DC
	 nj8kOwU9ObTDsgAw7yEh/t5+y9d+CwWTIWK4Y38M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH 7.1 187/271] staging: rtl8723bs: validate monitor transmit frame lengths
Date: Mon, 17 Aug 2026 15:31:52 +0200
Message-ID: <20260817132544.500812080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2032,6 +2032,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 
 	/* Skip the ratio tap header */
 	skb_pull(skb, rtap_len);
+	if (skb->len < dot11_hdr_len)
+		goto fail;
 
 	dot11_hdr = (struct ieee80211_hdr *)skb->data;
 	frame_control = le16_to_cpu(dot11_hdr->frame_control);
@@ -2044,6 +2046,8 @@ static netdev_tx_t rtw_cfg80211_monitor_
 			qos_len = 2;
 		if ((frame_control & 0x0300) == 0x0300)
 			dot11_hdr_len += 6;
+		if (skb->len < dot11_hdr_len + qos_len + snap_len)
+			goto fail;
 
 		memcpy(dst_mac_addr, dot11_hdr->addr1, sizeof(dst_mac_addr));
 		memcpy(src_mac_addr, dot11_hdr->addr2, sizeof(src_mac_addr));


