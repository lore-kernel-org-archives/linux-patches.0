Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591297;
	b=0WQo07guaf3Et75mnSH9fq1cxKLekCElvfA7/UwPFWD1aZQ46Mw2YWP5371I9qFxtW37
	 vAK7XN/8T2k3V3ijBf54AKPs6W25/dhoIs6QDTw/ON/9/KcYr6XwFlYb2L2rFNU6EoCrj
	 cC63/Nm1sKWWFsxlyJkn9oTCjcRlJ/J/GQuG3OX/abvze5eob6EKoqN9e9G+KGKLg11Vs
	 UOPm+nMlgrfktLEoRHH33+EKS63O8YpmFW/i9koYkHHV25xc9lIeJTr0oD9yvFHotL2PP
	 l/1RItgi9np9lT3ItWJTyzo+obheQrm1mu31muZmYOJdpjKgA8EorpI1N58ao59KuGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZzhdM1u6oue+turwa8Yri0Cj/qBQcwVJo+hOzP+f3hw=;
	b=zYDIpkMmtbv8kIVGyWIpRMXjeyS9TI2p0fakxGHtsa3fIbHmEDKoW1bJSex8dmArQKPV
	 EFy+UL27l46WF3HTIq2JCZrBSoVr0Qgl9u8FWKsRGH0TYRWsHo/707f7zlSekWPb47H+W
	 XlhkLuJeLiB8J7JS1g4k3bQqjbeSBZiJ3MzGzVwubelq1os7qPdwjuQ15ABtrkhUkabV0
	 30WqqbNAZi7sqceK1UUjEl+ID8YSwXrkTdb41/arWxN5rAN9Ww9yy+eLhtg4mgq9ARhTC
	 R21cMvq35GTPmAyz7cRbDmqFwFAT353GVEaB5zJwFZJRbF9qVhcoakkvuQLNF/3LJag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RD2/xr5K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0E260A6F44;
	Fri, 13 Nov 2026 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RD2/xr5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184171F000C5;
	Fri, 13 Nov 2026 17:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591297;
	bh=ZzhdM1u6oue+turwa8Yri0Cj/qBQcwVJo+hOzP+f3hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RD2/xr5KZARhN4f46dL877DnKp9fxWperkskK4CBi5SFuelPTvoO104yxGSOahNss
	 I/jYJhqmdSmLO3qnON/A4WgsMF6ZszNmajxBQwEYa2+L6uOBkfIMl/8sasXEmOcsun
	 oB2a0uzGXEcboLd6CT+CaS56IBH3GLwfskqJYNN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 413/670] batman-adv: tt: clear ROAM flag when re-adding a pending local client
Date: Fri, 13 Nov 2026 10:49:37 -0500
Message-ID: <20261113153825.741482898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b4c98ac6d338d..c148127799c1b 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -658,6 +658,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 	int hash_added, table_size, packet_size_max;
 	bool ret = false;
 	bool roamed_back = false;
+	bool added = false;
 	u8 remote_flags;
 	u32 match_mark;
 
@@ -684,7 +685,7 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
 			 * flag can be reset like it was never enqueued
 			 */
 			tt_local->common.flags &= ~BATADV_TT_CLIENT_PENDING;
-			goto add_event;
+			added = true;
 		}
 
 		if (tt_local->common.flags & BATADV_TT_CLIENT_ROAM) {
@@ -765,10 +766,12 @@ bool batadv_tt_local_add(struct net_device *soft_iface, const u8 *addr,
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



