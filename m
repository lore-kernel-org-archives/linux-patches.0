Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078114A4E9;
	Wed,  5 Feb 2025 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763987; cv=none; b=IaWPWdsf6n9ubVoIoj4gdzTl1i5aRRsRkPo3Unn2/6n6Kj04CXSABKCuclXiQOxv9oK31raaVTFcHF3wzZrylh6OI/93pGRf5o2iBY5POrmWsVdRTE6OzjIOTnsjOmVHwY4wr1GlOzB+og+ovs+kDqX5+rmQzCLsNkbhlbR40ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763987; c=relaxed/simple;
	bh=NRtOCY3QQt1DhvyPtpuWMQZ/l5GZbm7UpfkVbxoAjnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpSTByhrkdQIm7kppnr0JrDHc5Y6Yag+riX0o3xUrG3vhEx3mX+miUxeCZqFuxnGy5iMzHVc2HI40FMVNWubIfWq5Nzb6pPbMSnr7ZqQFwE7oZ1oG8diCiEbB3jazCYWm5EY24vhjzELALRJ688bcLC5Rx1Tq5v0i0O+0hX3dKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXl+yOeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXl+yOeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D75C4CED6;
	Wed,  5 Feb 2025 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763987;
	bh=NRtOCY3QQt1DhvyPtpuWMQZ/l5GZbm7UpfkVbxoAjnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXl+yOeOHQ5L+y6/YzTPH3XXLnEDW91IoTPuvew0dkUt3Pp+aoGfnLAt6t2IPRssU
	 OesB8YR/6RgaJg8zAHXOXPxKbnfZ0fY6eRAmIhqtMxgUzDVkbOORORjw7J+ZIvu6la
	 ifeLUkZsvnsNgwi+jUZo/yXU3srgMTiSn7VZcK1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Strohman <andrew@andrewstrohman.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/393] wifi: mac80211: fix tid removal during mesh forwarding
Date: Wed,  5 Feb 2025 14:40:29 +0100
Message-ID: <20250205134424.504799089@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andy Strohman <andrew@andrewstrohman.com>

[ Upstream commit 3aaa1a5a9a2ceeb32afa6ea4110a92338a863c33 ]

With change (wifi: mac80211: fix receiving A-MSDU
frames on mesh interfaces), a non-zero TID assignment
is lost during slow path mesh forwarding.

Prior to this change, ieee80211_rx_h_mesh_fwding()
left the TID intact in the header.

As a result of this header corruption, packets belonging
to non-zero TIDs will get treating as belonging
TID 0 by functions such as ieee80211_get_tid().
While this miscategorization by itself is an
issue, there are additional ramifications
due to the fact that skb->priority still reflects
the mesh forwarded packet's ingress (correct) TID.

The mt7915 driver inspects the TID recorded within
skb->priority and relays this to the
hardware/radio during TX. The radio firmware appears to
react to this by changing the sequence control
header, but it does not also ensure/correct the TID in
the QoS control header. As a result, the receiver
will see packets with sequence numbers corresponding
to the wrong TID. The receiver of the forwarded
packet will see TID 0 in QoS control but a sequence number
corresponding to the correct (different) TID in sequence
control. This causes data stalls for TID 0 until
the TID 0 sequence number advances past what the receiver
believes it should be due to this bug.

Mesh routing mpath changes cause a brief transition
from fast path forwarding to slow path forwarding.
Since this bug only affects the slow path forwarding,
mpath changes bring opportunity for the bug to be triggered.
In the author's case, he was experiencing TID 0 data stalls
after mpath changes on an intermediate mesh node.

These observed stalls may be specific
to mediatek radios. But the inconsistency between
the packet header and skb->priority may cause problems
for other drivers as well. Regardless if this causes
connectivity issues on other radios, this change is
necessary in order transmit (forward) the packet on the
correct TID and to have a consistent view a packet's TID
within mac80211.

Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Signed-off-by: Andy Strohman <andrew@andrewstrohman.com>
Link: https://patch.msgid.link/20250107104431.446775-1-andrew@andrewstrohman.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 604863cebc198..5eb233f619817 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2957,6 +2957,7 @@ ieee80211_rx_mesh_data(struct ieee80211_sub_if_data *sdata, struct sta_info *sta
 	}
 
 	IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_frames);
+	ieee80211_set_qos_hdr(sdata, fwd_skb);
 	ieee80211_add_pending_skb(local, fwd_skb);
 
 rx_accept:
-- 
2.39.5



