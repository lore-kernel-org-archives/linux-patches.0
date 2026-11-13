Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585863;
	b=ETCpCb/TNOChad2p8ixTgiE1CZLRNjUCOVA35teHFSpmapAktLVZMEF94mQpTaAlrP1e
	 3Kq8+0IYrgP9HSB8QchvqQ+SK+6pWxMelFk1roBMnClWwTMZDA2ubLNbWlxqGh+BX7yH0
	 WRgGdNyhPIi71i0eh/wVCpfyzVIjS6d6aVYYPy2XHU1+ScUYzM7uEi+/loh8W6ddYTMCc
	 w6WhhqNI7/w5hYVEv3E3UmZv6oII49Gt+jBh/ZQiP4trO+CSmf7AO8nWL0MUVQk0J3uvj
	 8UBSjog6NxpIE+BYyN4mJgWvGL1/itnpyZF5J9gL+CbIdPrathDR2PVrU6yu7uOotUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1NAEWb8OTPaiDk59B1uwVlSJWNknFiB9QO93ppyJzw=;
	b=SjnBhMllPOmxysjAfRajEmMU/bT/hQjYn5f8P2KUwYAsBVpdlMo+GJP0O5K9xZ66umrH
	 mpPJt+t23p4LTQipS1GahWU7lT8sF6PSLcI1ZWJZRR1H0Ivtw/NZOJ8MI1pHp95jRIJT+
	 DWi1lSZYoCH2nYbr45CuA1UebrOnSpX4alieseb7VmBUA4MnbNwamZkIK+I3YV+Xikwmu
	 8ek8lgDkdPDkUdrpM1h/mkFCjC2EIVyPmueJfCsqS4PGAkqZrGLWQSS6EXIJ9AV5jPYWm
	 bV2zfKcyYkYJikyCaVhEhQPTxwDGfV9iV81qeTPEHubDlx68Ea7ZtsLYhOGdwPcAGdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQcaUDJ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFB46070200;
	Fri, 13 Nov 2026 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQcaUDJ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1D11F000C5;
	Fri, 13 Nov 2026 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585863;
	bh=l1NAEWb8OTPaiDk59B1uwVlSJWNknFiB9QO93ppyJzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQcaUDJ1AGCY0I0L3WcvO6rCM+mo6hUUwDOBQbdulzlGa4S1T6Kc4qUEwSjpsEVlg
	 Kwl5eAIhn2yuB0ZFQOpGlhntVhR+muNdqnDlL2+ZVxAFAoavB58vXgSvpAdtSsj7lb
	 6E9QLFFOz1URiTc8nGH40C/TYK5KCAsd3Sdr7ESY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 437/507] batman-adv: tt: clear ROAM flag when re-adding a pending local client
Date: Fri, 13 Nov 2026 10:52:21 -0500
Message-ID: <20261113153811.549236141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d1b1b8459279b..0be2f693d5955 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -632,6 +632,7 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
 	bool iif_is_wifi = false;
 	struct hlist_head *head;
 	int packet_size_max;
+	bool added = false;
 	bool ret = false;
 	u8 remote_flags;
 	int hash_added;
@@ -664,7 +665,7 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
 			 * flag can be reset like it was never enqueued
 			 */
 			tt_local->common.flags &= ~BATADV_TT_CLIENT_PENDING;
-			goto add_event;
+			added = true;
 		}
 
 		if (tt_local->common.flags & BATADV_TT_CLIENT_ROAM) {
@@ -745,10 +746,12 @@ bool batadv_tt_local_add(struct net_device *mesh_iface, const u8 *addr,
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



