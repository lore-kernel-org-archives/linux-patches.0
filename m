Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997AF3BE641;
	Tue, 21 Jul 2026 21:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670445; cv=none; b=cu02qm8TkLpNEIZlvcZqa9d41I9JMH/nW3uQ2jWHe7YaBhKKWcKWyEZwMUmvMeBljIqtimp1W3CxzTsPj/eoIgdq4SQFiKGLcn6vo8HjG/7EGWPsW2YyUgrT3JlpRkYMCVsQQ4PEgt9wF3BoPHBtViasHThX6yjqyOB9KvN6KOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670445; c=relaxed/simple;
	bh=CIIfnAhbdRIQNpMmx996Jb4EQ9fyDJVhlb8qSr5mjU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oefOUdH74yh9NiUFX+7rhWq+XvhoRnmC7DScl1y9Yc+uUz7eH5bcdGH4HUEd3IhAj+fEBLm30dvpGqV8oDdINTtJEqFuN5sapfQ3Mpn/oShWqlvE/GPhV3M6aIpfmZ+VaVAAGugaJyfQ1pgEtl4AKAklEbv3BJSbvyGY4VAUvHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgMmzGQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgMmzGQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3AB1F00A3D;
	Tue, 21 Jul 2026 21:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670444;
	bh=XflKVaqYPD+LX4+IqEX9qex3Iy37cjGO8ZUAxFPaUrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgMmzGQCEz0d/0hQtW2naIe1MEaWl2mob+oSv+UWoKHIXpk2I2Gry3Lw3AXCmiyPz
	 YRJbAoUpakUsqRoXExFcosuQYoyVgEvjHod39l7IQk/zayjRdle17rCES/FpuwJzHJ
	 271whMdrkIAshCDLtJ4K6PGBev2s+ZshIZhdZUDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0891/1067] batman-adv: ensure minimal ethernet header on TX
Date: Tue, 21 Jul 2026 17:24:52 +0200
Message-ID: <20260721152444.464507227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40354da5c5b555..a8239902b4428c 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -208,6 +208,9 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
 		goto dropped;
 
+	if (!pskb_may_pull(skb, ETH_HLEN))
+		goto dropped;
+
 	/* reset control block to avoid left overs from previous users */
 	memset(skb->cb, 0, sizeof(struct batadv_skb_cb));
 
-- 
2.53.0



