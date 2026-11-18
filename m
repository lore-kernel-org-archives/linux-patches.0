Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046614;
	b=4vnYqYwyHlT+P+KZfp1V5eP4wp4MR21nnRT81mYUtrJMGqPoDJ6fyLGr8ip4Tu3uORNb
	 rM1zpmLU4E1XcyIjois89YRp7JSmA7xgDrmoSGibzDaw5fV5cuikM1ayF/GXbvuzvpRYt
	 4Oq2kthRlcRGuCU6y5rVnbu428zIPszzSzHU1uRNNH/MOa+FUigAsnViEVD5IzcqD8NH9
	 fu6xLa64Go4V/qDWSUFufdeQsrOkytmHfIRAaobBs/v7UxX1IQGq4eBU2nheAJvVGTw7/
	 sw9Hs4r55mGjqcsyB4NDSWD0M537YWrUxFvXiDa3CL3bG63xvGE9JIRq/KMoon3ENyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=slWdQsS2EgiXUWTQNiYIoNVnJOZGV9GmgylAnWOnxA0=;
	b=OoE5hhN1qqURUWVzovkRhrcABWYEiee40Q9EsTBQcEZE4UT4Q703UQB5uK2PYg8i7llZ
	 pY6fAnV7Y3CbpPSdzhCMxWrfgzuTDIJ1RNaVaUKgl027xUihMUIF+QOKfwsJhhMv+GfPr
	 GB0IjjuI6bpoeLaObhyZQvzrGSFU/HvpdjVThGdFBQ5Je9IQNtFBbVCamncKewvo420lU
	 pSVed3diKjBZZ/kCsg+zJalUVLxzkUQcMyxShizZQIdmfseDJahxVF+8F/p+dohhipCCB
	 a0jpadLjdl5BG6qlUg+oXYb6O8WLmAz3OzPTLHTndluV9byGYUp6WxZ5kmFFpNBpzzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjJ5EJnO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEED606A33E;
	Thu, 19 Nov 2026 00:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjJ5EJnO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080A71F000C7;
	Thu, 19 Nov 2026 00:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046614;
	bh=slWdQsS2EgiXUWTQNiYIoNVnJOZGV9GmgylAnWOnxA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjJ5EJnOSAl/WH9KdrdOLf+pxH8yKmOYG2Gd8cPkaboURNNj3CzVYgtkkRZC9vEwG
	 ruW0LdpGRoNQHISl1u0HEKP1tDzmZPglkzChvuw3HbDvs85mhKRzKlhrR83wpie2BK
	 rRK2lV0qfBtiMnj1F3ny8BmrltbqrDj2BrvT2egI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1345/2857] batman-adv: tt: clear ROAM flag when re-adding a pending local client
Date: Wed, 18 Nov 2026 15:39:39 +0100
Message-ID: <20261118150249.848623382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 86e066e56e820..6e41824db11c8 100644
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



