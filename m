Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590530;
	b=0kwfpvv1376sINEN7c5eBDVN6OGoq66rM+LdDXENkO5x49JKbpsD56DW1YSLATZx9xu+
	 bn2q9A+jodQ9dGzyk6kntoO54ZqHcgqeDDygMXK+hUiRQiZTng2srQe0S0nOEcqrYFVXC
	 +fhfQ82ikmzxuAeA9owOc0x/BUKTGVrYLT1aLis+OxESvYugs/Yg1H03eiWWOhzkW9pLJ
	 65o7BNu+jEBWYZg8aaSmvJXOAJLRdPIk+OTbzuglXw3nxp4ScDf/XA3UflUQADHXptzSb
	 8k7NukRyaw3VQIUBvPEttPwOkC2cyxuVb4HsJ9KeEIe2mkfkkGVpB0xCe7UcxOHLNJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3DLg0oBdIPYK6oOfYSW0zCxSFPefAgG8IGmZs8jbIC8=;
	b=fj/mVVhYnRLfCvPSuilPpC64hxkknDMFYaMjznUTfYep63TCW1654pKZydPm+mobTNxP
	 NU1BROBAvsqWQ5nS52PIcAHs61yHb7pOiGy5LTPYTLAWOND3B1hXXizQGbDX4Fe0uK6V9
	 BS+IZskw1g+p39X7rfKi5A2bCiFuebGtYrm3uK6hEbJR/nA1H+17snvbfVaFS8K4DDQAK
	 gJsHNHVIe77I1uQtSXkUynduI9u6O7WEuf4kFHhqdhjDMcg+U8dYMqPVCS5HdCCGSztok
	 myYrOQZs1BSA9DkHt8JZHM68Lv1j+XA3uZlogF3r43UjeGN5U6TzJP8kf8Y2TlZAxyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQPB4+Q4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BD36073238;
	Fri, 13 Nov 2026 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQPB4+Q4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33321F000C8;
	Fri, 13 Nov 2026 17:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590529;
	bh=3DLg0oBdIPYK6oOfYSW0zCxSFPefAgG8IGmZs8jbIC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQPB4+Q4yQzq8TtOpy5PXPdbs69UEfCtmZQSVEK5WvYD1Lb3aOgAy3vC9/4hpjjId
	 y1HKFIuOTEFksIvwVRk6MMmteURxJ+ZOCrJ3oic2YmOU9MSQ59WFaxIjZNyTOg6wkN
	 78wabvWD+/I0PNj4xy24B8nK7iB5OYf7iQUV0dXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 473/686] batman-adv: tt: clear ROAM flag when re-adding a pending local client
Date: Fri, 13 Nov 2026 10:50:06 -0500
Message-ID: <20261113153836.967424582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit cc2186d7854785b30d423f5d43757b086b300e55 upstream.

When a ROAMING_ADV is received for an announced local client,
batadv_tt_local_mark_removed() sets BATADV_TT_CLIENT_ROAM, queues a
DEL|ROAM change and marks the entry as BATADV_TT_CLIENT_PENDING. If the
client sends a frame again before the next TTVN commit,
batadv_tt_local_add_existing() only clears the PENDING flag and returns
early. The ADD cancels the queued DEL, but the entry keeps the ROAM flag:

* batadv_is_my_client() reports the client as not served by this node
* batadv_tt_local_client_is_roaming() reroutes unicast frames for it to
  the node which sent the ROAMING_ADV

The ROAM flag is only removed with the next frame of the client.

Since BATADV_TT_CLIENT_ROAM is set together with BATADV_TT_CLIENT_PENDING,
it has to be cleared also at the same time with BATADV_TT_CLIENT_PENDING
when the client roamed back.

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ adjust code still in batadv_tt_local_add ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index c7ea317acc516..d1cc702e1f14d 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -612,6 +612,7 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
 	int hash_added, table_size, packet_size_max;
 	bool ret = false;
 	bool roamed_back = false;
+	bool added = false;
 	u8 remote_flags;
 	u32 match_mark;
 
@@ -638,7 +639,7 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
 			 * flag can be reset like it was never enqueued
 			 */
 			tt_local->common.flags &= ~BATADV_TT_CLIENT_PENDING;
-			goto add_event;
+			added = true;
 		}
 
 		if (tt_local->common.flags & BATADV_TT_CLIENT_ROAM) {
@@ -719,10 +720,12 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
 		goto out;
 	}
 
-add_event:
-	batadv_tt_local_event(bat_priv, tt_local, BATADV_NO_FLAGS);
+	added = true;
 
 check_roaming:
+	if (added)
+		batadv_tt_local_event(bat_priv, tt_local, BATADV_NO_FLAGS);
+
 	/* Check whether it is a roaming, but don't do anything if the roaming
 	 * process has already been handled
 	 */
-- 
2.53.0



