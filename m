Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2F01C6881;
	Tue, 27 Aug 2024 15:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772809; cv=none; b=oySynY0N49Id38X7flktSx7hWRsSwDcLrNCng/7e6Vg56Hc5PupfRRzndqXnwV92wMuEe4/0+3ekyygqo/UrUzt4cb2PgImNoCL39mr0Qnsv0cG8oNYrxPZ9LNvV0EFqS7XZAA2YasqUtd/AWnEy998yY4+QXRitH5+hQuB+qaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772809; c=relaxed/simple;
	bh=IzzHiOllqwOsViX8uIsVTFo1i3CPPim8gVAy8EOj/l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LMKYj2N7//7PA9qVI9bBQt65rqSXQ9BihlfhPrn1anKBVGo30FI5pBS5g7vt/PAfrR34nKSSi/IRb350ftTM9t7O0+ToXx6TRc47xZUc86KLuez2IAdu8KSVb1oyOeP1KjMls97oAPfvAxdqSF2eaZvAfTGl98EL+AglVGU2sUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWe1kh6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWe1kh6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9DCC61050;
	Tue, 27 Aug 2024 15:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772809;
	bh=IzzHiOllqwOsViX8uIsVTFo1i3CPPim8gVAy8EOj/l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWe1kh6i+naFEO0Wo6mJVTRE3jO9dIHZL+dw+cwicFbm+5MJCWPP4KtKTABNv5z3O
	 PQbzMFlor9+TohU4pT11uT81BjAwW8T3Kkzgvf8tjRORJJFP0N/3yEIbF4F/GTXfxK
	 sLc8LNtQQ5IwIWlrnuqM4ATeJHKpzajtLWkAow2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20H=C3=BChn?= <thomas.huehn@hs-nordhausen.de>,
	Nick Hainke <vincent@systemli.org>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 308/321] wifi: mac80211: fix receiving mesh packets in forwarding=0 networks
Date: Tue, 27 Aug 2024 16:40:16 +0200
Message-ID: <20240827143849.980689391@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

commit e26c0946a5c1aa4d27f8dfe78f2a72b4550df91f upstream.

When forwarding is set to 0, frames are typically sent with ttl=1.
Move the ttl decrement check below the check for local receive in order to
fix packet drops.

Reported-by: Thomas Hühn <thomas.huehn@hs-nordhausen.de>
Reported-by: Nick Hainke <vincent@systemli.org>
Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230326151709.17743-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2774,14 +2774,6 @@ ieee80211_rx_mesh_data(struct ieee80211_
 	if (sdata->crypto_tx_tailroom_needed_cnt)
 		tailroom = IEEE80211_ENCRYPT_TAILROOM;
 
-	if (!--mesh_hdr->ttl) {
-		if (multicast)
-			goto rx_accept;
-
-		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
-		return RX_DROP_MONITOR;
-	}
-
 	if (mesh_hdr->flags & MESH_FLAGS_AE) {
 		struct mesh_path *mppath;
 		char *proxied_addr;
@@ -2812,6 +2804,14 @@ ieee80211_rx_mesh_data(struct ieee80211_
 	if (ether_addr_equal(sdata->vif.addr, eth->h_dest))
 		goto rx_accept;
 
+	if (!--mesh_hdr->ttl) {
+		if (multicast)
+			goto rx_accept;
+
+		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
+		return RX_DROP_MONITOR;
+	}
+
 	if (!ifmsh->mshcfg.dot11MeshForwarding) {
 		if (is_multicast_ether_addr(eth->h_dest))
 			goto rx_accept;


