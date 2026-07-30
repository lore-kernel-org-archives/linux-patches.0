Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DAA376A0B;
	Thu, 30 Jul 2026 16:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427395; cv=none; b=f+0DIaeu8V2eX1E145PBJWgSbj6J7QYF9mvaTU/DX1huCVqjptFEJ4zrTF5DOiuAwK2ZTLq2IvzGrN5IjG33VnWMcvph7GJYiNFft8c7aI4jvhHSpxtlllwrYb6C1dBSuwHWIaAc1vSECGtxwKSvbn4yt1krI529HEsQdcIhO28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427395; c=relaxed/simple;
	bh=q17ivQePbq2MoUbZ/7UNTkphAh5ByV2WS14OvWIahjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQ9f2QIEhhbs5DT8PScY16SM67ZMCl8c0g9HlsHEU3IeRl876Jgi5Cqme9YmZLRVX8RyLGqyjtO+Hux9tdg/wQSaqFnN9YX1282rvfo3dHs76PlgyQwDbYMJof8P0I2fe7zH5X9qZFRpY90Ns/gy0651JEW3JfhaeC6IEHH3p3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02TgK7IB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02TgK7IB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9087F1F000E9;
	Thu, 30 Jul 2026 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427394;
	bh=CRejrliKBPgp8Hte+n0ilMOai/NZGFFyGl4SNqhMjUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02TgK7IBpRDaq3N0anf4QbAZOgpva0At7wavdP1xPiSUiGdyFtWmuAy45XnzT2Ta1
	 4JFuvSc1MnpxIK8pmSJZULYfM/n3eBTj5gg1HY4ikTQiRqExUrlzOlyUPjCu4ZXQKK
	 ZVHZN3Dih1mQAzrgxEi4eDij5FoJANb/JWt6sIg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=20 ?= <skyexpoc@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/484] wifi: mwifiex: bound uAP association event IEs to the event buffer
Date: Thu, 30 Jul 2026 16:10:52 +0200
Message-ID: <20260730141426.830130660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58ef5020a46a73..c7383abf064f50 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -123,11 +123,31 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
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



