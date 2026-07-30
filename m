Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8B244604E;
	Thu, 30 Jul 2026 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423909; cv=none; b=iR7v9xEEXG6PTmvePLoHe2h3OfJSYLJmS6d90v1aIue5jtTVYWUbZGFNzfpSF8NQ3SclkFsRYLJrUopfwffyHK7eXELyrTj/VY8gUL9mQtxLvO6JpGstpHZVGkspBSbMcKkjQOu4MjIGEbeiSQ+l3x/I3ZmQXTWkbgjovIyfypk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423909; c=relaxed/simple;
	bh=V1WPO9vtKt8bafUCsU+fro20hXVpWP1F95iUIFlbhoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUs1LPsgGh28Q0BoK6ZpJB6qF8bFOFJJWbVqnTwDPatPoJzFB3AK0wqvahBbBh0aS/s2CaQy2xxoyQMExADwn74d59m716+ORTiR7Kc7nrjCqfqqC5tfuvjoApvC1EfkkxRhcwbvbZOqv6H9/RoWRg6ReAPFezPmnGhcHyu61sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/xWplzo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/xWplzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2131F00A3A;
	Thu, 30 Jul 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423907;
	bh=/SXiEtaSLUmoSQTS7+NXmECt9+N4k42obeDYt3+UemA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/xWplzoc39ZzbMS6Kt/z04FvyhNuIUxXBk8GSHMhejnc1icj+/0u9O30L3jMAGpX
	 tvmHBE4ndITrpDs6W+gYRygclAbCMfGsHstxTUAgcx9zRRET8cpHWPNB7KKC4DPzNi
	 GGzjGBZXwX6Ujp+/X7Hj8uwtMIKBg0fXRUNWfGuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Baffo <marco@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/675] ovpn: fix use after free in unlock_ovpn()
Date: Thu, 30 Jul 2026 16:08:57 +0200
Message-ID: <20260730141449.544280164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Baffo <marco@mandelbit.com>

[ Upstream commit e1ad6fe5db719874efa45b2caf9934552e09fc43 ]

unlock_ovpn() iterates over the release_list using llist_for_each_entry()
and drops the peer reference inside the loop body via ovpn_peer_put().

If this drops the last reference, the peer is eventually freed. However,
llist_for_each_entry() reads peer->release_entry.next in the loop advance
expression, which runs after the body. By that time the peer may have
already been freed, resulting in a use after free when advancing to the
next list entry.

Fix this by using llist_for_each_entry_safe(), which caches the next
pointer before executing the loop body.

Fixes: 80747caef33d ("ovpn: introduce the ovpn_peer object")
Signed-off-by: Marco Baffo <marco@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 795741645e5eb0..7e7ccae1325179 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -26,11 +26,12 @@ static void unlock_ovpn(struct ovpn_priv *ovpn,
 			 struct llist_head *release_list)
 	__releases(&ovpn->lock)
 {
-	struct ovpn_peer *peer;
+	struct ovpn_peer *peer, *next;
 
 	spin_unlock_bh(&ovpn->lock);
 
-	llist_for_each_entry(peer, release_list->first, release_entry) {
+	llist_for_each_entry_safe(peer, next, release_list->first,
+				  release_entry) {
 		ovpn_socket_release(peer);
 		ovpn_peer_put(peer);
 	}
-- 
2.53.0



