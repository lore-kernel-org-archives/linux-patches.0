Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0166471438;
	Tue, 21 Jul 2026 20:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664147; cv=none; b=JxUYsptjgSgo3lN2DfJTUxeQ8uCYyYy8IoNGHaWKVNwcePLniGuKyImreW04KTTWHFWou9kcgvjDxd1BhQm4TY6NLMG7dR/LI0UpbDrb4eB4L3di4dzNilMqLovxEn7Wtphm9F09gzh1AvDIOGXxUdg5P1XxoQ1IbJMQH22E138=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664147; c=relaxed/simple;
	bh=krSGuejSLWishtnRZtQD5EQYJ3YspFfphnNR+1UsCco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8iUEl9wrBJb9WFQG+SDfrZ023nLiNO5qWE1PzbiqfmK77CLIxbu3xhvE7rGT7RVOZWAJc0FmpEB1i5MF0XqnVK/mEIWZvECACnHyAXP6sk8udSEJtxfrEeAk/giu3OllfOvC6ggRzL38PerAD2PTybGawzJXMFBBl+7DvoyqF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nR35YOMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nR35YOMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B21F000E9;
	Tue, 21 Jul 2026 20:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664146;
	bh=zY3Up+GQGVxF3qzpWDN96uHxeBGfTCOAoKVWnE/uOk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nR35YOMX66NYpug4iEp7NM4yKQEuZgYUFG9bhz5mgf6ZzCfZdQ16a31fbDdceVHNf
	 KmvgBGS1l5JlWk31gc19FqvW1W88/EurMcYRxUTUlo0mXs6G96appZF94ja7fskkf0
	 d2Z1jwo/XTpwMSyU4rvyP8wQdNyGTNQTu/K5qxtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1063/1276] batman-adv: ensure minimal ethernet header on TX
Date: Tue, 21 Jul 2026 17:25:06 +0200
Message-ID: <20260721152509.774834031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 42ad04d356904f..bc72238e7a08c3 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -206,6 +206,9 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
 		goto dropped;
 
+	if (!pskb_may_pull(skb, ETH_HLEN))
+		goto dropped;
+
 	/* reset control block to avoid left overs from previous users */
 	memset(skb->cb, 0, sizeof(struct batadv_skb_cb));
 
-- 
2.53.0



