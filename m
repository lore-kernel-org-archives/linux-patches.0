Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851B733D6C0;
	Thu,  2 Jul 2026 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009802; cv=none; b=opZlGfEFYVPVjzlpPLyXDCy0UVTG0tX14tSMNo0mVkP2pnV3uau2otCW/VOWrrc0w+pmQAYHp0FMaYtHFFrHy76/kRgVyXSvJi9Tc53FB9ReMwsA1ZWtOsZ4HcseLoJvKHTuvIdt/TmajtyItkDWYbF/7o6vZAHTUJ2xeh5ae8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009802; c=relaxed/simple;
	bh=zEfdXiCh5b0TuABJukv7geoTso+GvOdK+LBZuJQZ0J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nvj6E7GFhEk9Ta8cpj0TqzaRP/r8WotXveyKmQgM5X7IJlcgd4v12WFat6GFSL9hAe1Tj/IdF+EzL+tiA1Gst8C8RGFVonU4Uueg1H35UvaX4ZqAq/ttxYbjPS9D4sKfeLbD72npo3Nsy8C/vqPb5gSh69PYoLw8rYqeMSJ5jXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KX9n1qFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KX9n1qFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4A51F00A3E;
	Thu,  2 Jul 2026 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009799;
	bh=IRWxuhIVdLumVAiFYXFEPLnkK8Xnjqi2Facie4olKcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KX9n1qFweVYiiJ6NmparT9hoph1qMkB4HflGxsArJd26ix/iKJXkLxvwJXoHvGOSH
	 g4hlLC354cMucE2q2N9UJYFlWPpIhJVfJ0ntXU32ahDxfiIVuUGm/LpJIdwhoY8Heu
	 6muY+r1Wq6dBRq3FWLCaBcpcx16nI9k1HjCeh6sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/95] batman-adv: tt: dont merge change entries with different VIDs
Date: Thu,  2 Jul 2026 18:19:51 +0200
Message-ID: <20260702155110.219256549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8ab1257bade048..4bc73aceeb89f6 100644
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



