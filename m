Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB832AAB5;
	Fri,  9 Jan 2026 12:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961156; cv=none; b=g+uP6Ui9jpVamCxfYlQdNJCE7uCwA5UuYIkrhjhTTm/P0I4RY94S6E+YdES/ATlQKtZi79dq28taVbLeJzNwAZyPJyk1eoISST+0D54N5PIHzfFNJ6wk2OEjxA6pwN6la0h3vi1ngXUviiB8T/MTKE8hQbD0aZvcCwyEVsiUF40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961156; c=relaxed/simple;
	bh=HV9leL2PqK/rIsl6w30qKhflwPrLupHIJg5HQvdoX1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8n440VbB7OzMTiV9Dti348OgPUWA+meSZEzsPxuhnmEQ6/F8di1lWoUujvOlF7JqfJKYSpgT1iituR4jfdd+a8kpF23K/la+NTa+iWFohkpuCBy5+9OFVQcTmOo1zXZHm7tcjxK2n+4dGewDZrvOamzwncAOf9OHedFIbgowwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpI6FIhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpI6FIhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA444C16AAE;
	Fri,  9 Jan 2026 12:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961156;
	bh=HV9leL2PqK/rIsl6w30qKhflwPrLupHIJg5HQvdoX1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpI6FIhco9v+KF1svvLSYZlo7orOTEbeqoY11tmO0zeajkVsJy5v2E1qdonRdw1y+
	 ajTUjsF3z9HcqQpU6Prtjw76F2FvnEVIQxPSl3bcjQiYWojFPRg5ZmvWRkR4laaQxM
	 EHBtGny21q87bsBO+dBHAS45jPWuONu5oe4fGtLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <jouni.malinen@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 655/737] wifi: mac80211: Discard Beacon frames to non-broadcast address
Date: Fri,  9 Jan 2026 12:43:14 +0100
Message-ID: <20260109112158.664129332@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Jouni Malinen <jouni.malinen@oss.qualcomm.com>

[ Upstream commit 193d18f60588e95d62e0f82b6a53893e5f2f19f8 ]

Beacon frames are required to be sent to the broadcast address, see IEEE
Std 802.11-2020, 11.1.3.1 ("The Address 1 field of the Beacon .. frame
shall be set to the broadcast address"). A unicast Beacon frame might be
used as a targeted attack to get one of the associated STAs to do
something (e.g., using CSA to move it to another channel). As such, it
is better have strict filtering for this on the received side and
discard all Beacon frames that are sent to an unexpected address.

This is even more important for cases where beacon protection is used.
The current implementation in mac80211 is correctly discarding unicast
Beacon frames if the Protected Frame bit in the Frame Control field is
set to 0. However, if that bit is set to 1, the logic used for checking
for configured BIGTK(s) does not actually work. If the driver does not
have logic for dropping unicast Beacon frames with Protected Frame bit
1, these frames would be accepted in mac80211 processing as valid Beacon
frames even though they are not protected. This would allow beacon
protection to be bypassed. While the logic for checking beacon
protection could be extended to cover this corner case, a more generic
check for discard all Beacon frames based on A1=unicast address covers
this without needing additional changes.

Address all these issues by dropping received Beacon frames if they are
sent to a non-broadcast address.

Cc: stable@vger.kernel.org
Fixes: af2d14b01c32 ("mac80211: Beacon protection using the new BIGTK (STA)")
Signed-off-by: Jouni Malinen <jouni.malinen@oss.qualcomm.com>
Link: https://patch.msgid.link/20251215151134.104501-1-jouni.malinen@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ changed RX_DROP to RX_DROP_MONITOR ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3388,6 +3388,11 @@ ieee80211_rx_h_mgmt_check(struct ieee802
 	    rx->skb->len < IEEE80211_MIN_ACTION_SIZE)
 		return RX_DROP_U_RUNT_ACTION;
 
+	/* Drop non-broadcast Beacon frames */
+	if (ieee80211_is_beacon(mgmt->frame_control) &&
+	    !is_broadcast_ether_addr(mgmt->da))
+		return RX_DROP_MONITOR;
+
 	if (rx->sdata->vif.type == NL80211_IFTYPE_AP &&
 	    ieee80211_is_beacon(mgmt->frame_control) &&
 	    !(rx->flags & IEEE80211_RX_BEACON_REPORTED)) {


