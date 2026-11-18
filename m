Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038007;
	b=atmOsJovywQYLrkOeDw1xopNVOhAO1Ib0peGh/WWDV9ZUIbeFoaXZ0rOTuStBfDdzJc2
	 psQplH+H270C4cU76q/y0sXSMqeD3Lf/wsk/d8t8DAUypy5rwwGxqUpd/wAC61kVKSPGh
	 Mh1H7yHlr2Ci3eJH61DlHKywR8sW+bJLaEVyylPV+6ImOP5IPlf3ZDvd8+FyevSuq6xw1
	 psXb8EyjRNf2CtxSH9tfpEQpXd02cMZUDE1SyHdIEg9AyJGUYK/LO2RpG/UUyp39dlbKf
	 6500/QEmOpYeFBk3bCnFoJKVXuPMothI2NSVeADLpdmqOuG9PtJLQSjiB6oHe4PFfAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fF9KPBmR7zUA6yjWBoTNSjOoLkQjq/2G7mVIObaTtGc=;
	b=Au0j7maZrVdlrwD+D7tzUkWC2NYGUEkS1LL340cLnfTBS+Rv5R/3nk7OeSo0lziI7eiu
	 ygHujAyvUFZgQgRRLClgCokujKTONYmXEoopq23b+/fOyy5XsYXZKYho1vX34zCeTiYHG
	 T+8KwQwrJrTaOzPXI+2KUz5gV99GM+f5foDBmEdUxOG4gvWbuS2bUBe3/A66GSaupxOt0
	 oaBudJmMQ3v7HJIjax8U5RSyjcWeaXVc79FQNcNn3P2ZElcqFcsH+Ys3wQDSw5HlxBawy
	 HwJ/KE1Sw54N6mEV8tR6PVrgACVbAQU1YHfvfKeMOO9i8ayx8Ycs1gQ5mt0HDt04afA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8BdP5nr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5956C606A32A;
	Wed, 18 Nov 2026 21:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8BdP5nr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3461F000C5;
	Wed, 18 Nov 2026 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038007;
	bh=fF9KPBmR7zUA6yjWBoTNSjOoLkQjq/2G7mVIObaTtGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8BdP5nrbukPlRMqnPFDzgGmebKP9oEP2NhaJF0w9Wm8F7Jp80DjoiVrYXtJjEV6Z
	 Sr5tL1MO+4JZXQqjCCvrdhBTjVhNPP4cGkA4KbaTX2OM2vfKZKnzO7GLkNcLNmYVHW
	 ifHOmp3UidvZeNvB+pnRvRSX0Wms12WkZsw6L3O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1593/3318] batman-adv: tt: clear ROAM flag when re-adding a pending local client
Date: Wed, 18 Nov 2026 15:36:55 +0100
Message-ID: <20261118150408.939030961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



