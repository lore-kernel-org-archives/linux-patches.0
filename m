Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95293ACEE9;
	Thu,  2 Jul 2026 16:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009991; cv=none; b=GAHrOROl4kjkdm6F1xrGiHs/i8fBTbYF1u0/NwTYRkPNU9fQKM9mR5e3APr/IgXBeDl0OmgmSbOBWXAh2x2I64Khcw+WKQ8R4PtJlDHFLnbBloLdD3HViuuGUnpZPSZIXPBsdkH9qd03L56fia4cfN65Rx10iF2og2ttjUuUf4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009991; c=relaxed/simple;
	bh=syG5bgLpmI1H/B10K/P8AsgBnrmk3UJaSldTFMlUV3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/eSMtngaZf0KU5dEaYasxg1dggHDhHfxnrkHTTwIYo6gxHKsun/ThnVVY7/0qWhcwQuaNB9JqGHnXhXpat8CQ6zSY93uLfLZCug2AfUuSCRVQH/ojMjVokX+AybFJRxdNkAJV/i7qWnMMqSUkMhkxJoHfHBZQU5NtRPh/5Tcgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9dfCMA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9dfCMA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE441F000E9;
	Thu,  2 Jul 2026 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009990;
	bh=b11wqchb751V9T8VzTMrk6ypXv8k5YbQP/vaK+P/WUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9dfCMA59AE+U8jtCRQponl+TN6VtBTiqEC+u3jKhIum8/YO6HpZ+Z80IEYATSHdg
	 AwNe4a3gu9lEtBJBzOzDp2COiWHvbcxeScd62G0yt2Tf50s/GolHCeC+rRB2ETN1H1
	 Y8mEbeo25AU96N+8pu3oAQb6OAtLAeLT1Xae4PWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/129] batman-adv: tt: dont merge change entries with different VIDs
Date: Thu,  2 Jul 2026 18:19:49 +0200
Message-ID: <20260702155113.594065060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit f08e06c2d5c3e2434e7c773f2213f4a7dce6bc1e upstream.

batadv_tt_local_event() merges/cancels events for the same client which
would conflict or be duplicates. The matching of the queued events only
compares the MAC address - the VLAN ID stored in each event is ignored.

If a MAC would now appear on multiple VID, the two ADD change events (for
VID 1 and VID 2) would be merged to a single vid event. The remote can
therefore not calculate the correct TT table and desync. A full translation
table exchange is required to recover from this state.

A check of VID is therefore necessary to avoid such wrong merges/cancels.

Cc: stable@kernel.org
Fixes: c018ad3de61a ("batman-adv: add the VLAN ID attribute to the TT entry")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 53d2aadcafa154..c3d62df9e2b87d 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -485,6 +485,9 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 		if (!batadv_compare_eth(entry->change.addr, common->addr))
 			continue;
 
+		if (entry->change.vid != tt_change_node->change.vid)
+			continue;
+
 		/* DEL+ADD in the same orig interval have no effect and can be
 		 * removed to avoid silly behaviour on the receiver side. The
 		 * other way around (ADD+DEL) can happen in case of roaming of
-- 
2.53.0



