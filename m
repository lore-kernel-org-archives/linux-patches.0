Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9EC317146;
	Thu,  2 Jul 2026 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010462; cv=none; b=JNzEnMDxH7+KCoY8V89wk42GxA9y/mN6w2zQtqzvOL1e0UmR2jwgcxswmslFEYr5Rr7FRR7Wc8uoW+JYHuO4TicF2Aqj5X9Gbk3k+dtAYpbDOa6BWDhTQde5Wxn7Zn82tmGvpJ46oEgp8WdxdLjVGBDh0gII5djRE7k/JsG78BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010462; c=relaxed/simple;
	bh=Y02875ymtVrQyvs/3HtHHhOoQe6hdHBlmhTLeMgL7kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkOgW0HN6gysRuJcIkjDBjt9+uh/81DdgGe1vvMeGAGn/9uOy1PBkGE2rqa57rXmvd7canpxqSnAFfj54RgXV0G8KP0TCV0IqNbw0aEPRPTnJUF+fAngnNuAkdOaMWoHO0r+GJTb1TnBWqjSKxivn82DIZoYiIaRgAOrxZQAoCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NS3mP6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NS3mP6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EDE1F000E9;
	Thu,  2 Jul 2026 16:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010461;
	bh=gz9eyRMK72H6iHrI7zeEnT9cGTsEPxpCNBAKFo4l49s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NS3mP6fJ3rDrdKMG7VLz8dqnNIIzfp8XoTsh8NhUnOGUKkm3kkDSytatPrq9yr1w
	 oSlcY6cRM92zg2id0d2vNm8bya5nOC0Fbm7afAzWcO1nPHElso0DhTyElElHCJ0yPa
	 ka95ftf49zk64e8Bnm77zBRJR/BwmthUjG5DpCCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/204] batman-adv: tt: dont merge change entries with different VIDs
Date: Thu,  2 Jul 2026 18:19:36 +0200
Message-ID: <20260702155121.152926412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7041cd69e20070..69a42bc3fa02e6 100644
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



