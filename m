Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDE043CEF9;
	Tue, 21 Jul 2026 22:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674438; cv=none; b=lLCXY9fi/iS+1JLi6Ppyxm4Po17iitSwlHseSWEwHFo83sCI28pLipFiIWoi5TU3NPqIi7ywUvPX+sqqDu5/jmyYPgcAkKrM66dULatdZk5tF5VEUx0qvpJl910Ty2YTpC3jUYBeIZTAAiowXXTkGGc0FyyzoF64dKmrewIxflw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674438; c=relaxed/simple;
	bh=PVyWWRtFWOFJbI93VtrDffLo/IDZ+9V1l7YuemunqOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1G2gFXZuGDtbUtL3Kl1wz+QXq9jlaqx3neUahEUE0toGUmR/oSpQ3iq9DcJD+p2egvzxhLiEZfW0mD1WwlFPbyB92D8sJmSW3nd8MUeyRa2P0mA5v6TkkZJ3veyYC6ye0b/9GdXyuhxhpthHw35AKwLyD4VbnX5PdCSZVGq0C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a56iJxQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a56iJxQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C881F000E9;
	Tue, 21 Jul 2026 22:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674437;
	bh=EZCofgBemTI6BhR3k5ICBXuhyhEth4HYgUnm7ozJIZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a56iJxQKQaaqMrnHRNa/2y6s2fUbqZl1MTpLkzQLM8S32eEzPRw4p+TypRlkHah3V
	 EmKInXgx5yctgjta4SBbia+exD21FILI8KdovpeVvmS2oSrkCLxvR1/5lGjTHboF08
	 qR0Ak6j/JKBOZX7nk1tvhQWOvfslBXE90rMrPON4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 539/699] batman-adv: ensure minimal ethernet header on TX
Date: Tue, 21 Jul 2026 17:24:58 +0200
Message-ID: <20260721152407.857735584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

commit 49df66b7993c80b80c7eb9a84ba5b3410c8296a0 upstream.

As documented in commit 8bd67ebb50c0 ("net: bridge: xmit: make sure we have
at least eth header len bytes"), it is possible by for a local user with
eBPF TC hook access to attach a tc filter which truncates the packet and
redirects to an batadv interface. But the code assumes that at least
ETH_HLEN bytes are available and thus might read outside of the available
buffer.

The batadv_interface_tx() must therefore always check itself if enough data
is available for the ethernet header and don't rely on min_header_len.

Cc: stable@vger.kernel.org
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Reported-by: Sashiko <sashiko-bot@kernel.org>
[ move from mesh- to soft-interface.c ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/soft-interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 8b4a8e80c0a320..c044d0d46bf808 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -210,6 +210,9 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
 		goto dropped;
 
+	if (!pskb_may_pull(skb, ETH_HLEN))
+		goto dropped;
+
 	/* reset control block to avoid left overs from previous users */
 	memset(skb->cb, 0, sizeof(struct batadv_skb_cb));
 
-- 
2.53.0



