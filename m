Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AD4347FEE;
	Thu,  2 Jul 2026 16:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009560; cv=none; b=AppBtEd/mIHpxT+YBcn1QRTzyxim5J4CjyHOu5tv5nqXm0JzaRPd7emu0DoDI1VU7K20/Q7D/3GOJkZozKZyyKt4DCDAKF6GOt/YKDKcKUYALuXEeh97pIdWwXIYpr4sHd66t5mwTMLv1Y8LbUVVv8mLBmsnONCALRjIa9z07Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009560; c=relaxed/simple;
	bh=7ELelgBpU/UIOMe4hby3v47VCZ++pB/ESE5W36hz9Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKQ9xkSahDB0EOk3QgWw9s0FPD4vcEwd+/PYBLNPQ9x1BsWlKOiMSkUzRoyDmyPt5VfYWpIrwOD+TmkkhbN4TL5TYS6BmP6h/3XrhXyGGE7zMKvWpJ2wVX+o40UbJP5tpeKjn0tDbv3BFieNmacbNchAoZFCs6gpKvRvWA/pOiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EprhclzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EprhclzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2F31F00A3A;
	Thu,  2 Jul 2026 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009557;
	bh=XhHc3NoQVbkJ02fgOTsQS3F4uos3stmyjak+5Wy4L3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EprhclzNli/+3cnKwNBumAtOxRKmFzjFhx6ddhe5LUFRZvB9CmDt30p/rpNqr2lwB
	 bYDub+0Giy4aFsbZ6aK1sRgWdEDh+/LpKF3tQ8wSrgCKW6dLebOGhwH/w/zBZDHbRR
	 BB686R3ueEP0GJ/Z1IGdwEsDlX/O8rs+NE2wxSI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/96] batman-adv: tt: dont merge change entries with different VIDs
Date: Thu,  2 Jul 2026 18:19:44 +0200
Message-ID: <20260702155110.076901639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 79da90b9cf0659..c323660897d43d 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -486,6 +486,9 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
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



