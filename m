Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07EF3B4417;
	Mon, 17 Aug 2026 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975582; cv=none; b=KymSdI48fa13KpU+FeT7VChPEvMxM8cxXhmvgIazyLpCFLERwmOTmHZ7yvzx+3aTtQK42rLt3CN8rPRMfoBP821oOZhtluJ9bsJqf2rn23+Fa4t23XRfy6VJ3BaYPlB0Lh2WjnrjKf7jxa8cXPMGYY/3BgtKXoOzJF2gwxmBdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975582; c=relaxed/simple;
	bh=Cqy9k/yznjYnATwuLp6ePoyEXyRLhNb+MDfQf/XQfV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7WRLT+c1hAhIogrohWnaRBMs3PzWQ4LYDcagYcytB6ytLZNtJ6FeIqAyagVAMNV9ULB7MBCHgVc+nHMXJ/ho4LsY9gy5iqoRf0Fqq37vyPbVdljuPy48pbsp0L4w+aUgdtkxu+ggKr/pZ04abtOinAQ8Zqy1k863oLMaIU0YbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNl8yv1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNl8yv1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076661F00A3A;
	Mon, 17 Aug 2026 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975581;
	bh=o7/974N3GK3h90HHORk5dwold6LR9VO3KgoisBTpfhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNl8yv1lisik8RL3o67/9Prys/aCRtjtdw3E3U53MgSDenA+ZL66gfAl+nNcOKNIT
	 yyePJUFvBr6/L7nlcj4C3TJzFukn4TcaVsMC4d1PvHTNK72XHewZyFJMWFULmcXv4B
	 6wQ7glOnZS6Ud4jHVMtNIj61J28iSiCX61Kj+0Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=20 ?= <skyexpoc@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/389] wifi: mwifiex: bound uAP association event IEs to the event buffer
Date: Mon, 17 Aug 2026 15:28:37 +0200
Message-ID: <20260817132542.142444318@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HE WEI (ギカク) <skyexpoc@gmail.com>

[ Upstream commit f0858bfc7d3cab411a447b88e3ef970e575032c9 ]

mwifiex_process_uap_event() handles EVENT_UAP_STA_ASSOC by exposing the
(re)association request IEs that the firmware copies into the event:

	sinfo->assoc_req_ies = &event->data[len];
	len = (u8 *)sinfo->assoc_req_ies - (u8 *)&event->frame_control;
	sinfo->assoc_req_ies_len = le16_to_cpu(event->len) - (u16)len;

event->len is supplied by the device firmware and is never validated,
and the subtraction is unchecked.  assoc_req_ies points into
adapter->event_body[MAX_EVENT_SIZE], a fixed-size array embedded in the
kmalloc()'d struct mwifiex_adapter.

On the ap_11n_enabled path mwifiex_set_sta_ht_cap() walks these IEs with
cfg80211_find_ie(), whose for_each_element() loop dereferences each
element header.  A firmware-reported event->len larger than the bytes
actually received makes assoc_req_ies_len describe IEs that extend past
event_body, so the walk reads out of the adapter slab object, a
slab-out-of-bounds read (KASAN: slab-out-of-bounds in cfg80211_find_ie).
An event->len smaller than the header instead makes the int subtraction
negative, which wraps to a huge size_t when stored in assoc_req_ies_len.
The same length is handed to cfg80211_new_sta(), so a more modest
over-claim can also copy stale event_body bytes into the
NL80211_CMD_NEW_STATION notification.

A malicious or malfunctioning mwifiex device (USB/SDIO/PCIe) can deliver
such an event while the interface is in AP/uAP mode.

Validate event->len before use: reject a length that underflows the
header or that would place the IEs outside the event_body[] buffer the
event was copied into.  event->len here is struct mwifiex_assoc_event.len,
a payload field internal to this event, not the transport frame length,
so it is validated in this handler rather than at the generic
MWIFIEX_TYPE_EVENT receive path, which only sees the event cause and the
transport frame length.  The bound is against event_body[MAX_EVENT_SIZE]
rather than the actually-received length because the transports store the
event differently (USB and SDIO leave the 4-byte event header in
event_skb, PCIe strips it via skb_pull), whereas event_body is the single
fixed buffer all of them copy the event into.  This is the event-path
analogue of the receive-path bounds checks added in commit 119585281617
("wifi: mwifiex: Fix OOB and integer underflow when rx packets").

Fixes: e568634ae7ac ("mwifiex: add AP event handling framework")
Signed-off-by: HE WEI (ギカク) <skyexpoc@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260715135711.34688-1-skyexpoc@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/marvell/mwifiex/uap_event.c  | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index 9121447e270184..eebfc0eaf9056f 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -135,11 +135,31 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 				len = ETH_ALEN;
 
 			if (len != -1) {
+				u16 evt_len = le16_to_cpu(event->len);
+
 				sinfo->assoc_req_ies = &event->data[len];
 				len = (u8 *)sinfo->assoc_req_ies -
 				      (u8 *)&event->frame_control;
-				sinfo->assoc_req_ies_len =
-					le16_to_cpu(event->len) - (u16)len;
+
+				/*
+				 * event->len is reported by the device firmware
+				 * and is not otherwise validated.  Reject a
+				 * length that underflows the header, or that
+				 * would place the association request IEs
+				 * outside the fixed-size event_body[] buffer the
+				 * event was copied into; otherwise the IE walk
+				 * in mwifiex_set_sta_ht_cap() reads past
+				 * event_body and out of the adapter slab object.
+				 */
+				if (evt_len < len ||
+				    (u8 *)&event->frame_control + evt_len >
+				    adapter->event_body + MAX_EVENT_SIZE) {
+					mwifiex_dbg(adapter, ERROR,
+						    "invalid STA assoc event length\n");
+					kfree(sinfo);
+					return -1;
+				}
+				sinfo->assoc_req_ies_len = evt_len - (u16)len;
 			}
 		}
 		cfg80211_new_sta(priv->netdev, event->sta_addr, sinfo,
-- 
2.53.0



