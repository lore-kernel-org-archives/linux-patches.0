Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5DE388890;
	Tue, 21 Jul 2026 18:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658594; cv=none; b=XtntVqvi8Wh6UtuWEvgKy9oDvzajAL0ntpzYEeuzht+umGm97xRTKGVc1PralyEfgKZ+DgXu9Nl49t9rEtXC/wP9WsKXKkrLEyv0n6khbgysAGE9w8Pgv+KmSpdugi9Vf/FUmUUbRMJUSrLpIJeYFWB6DYFWF3csHqjK97lvbBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658594; c=relaxed/simple;
	bh=CSCtqBUV4EXOwAWh/6XG6kNd+lAg6RO1Z57G356AJH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJilCHU2Jq8QnpaCUKPZGukuZ0fKZdNfKJj82DguHRzKzU43bEJTrREHMQjG+s1y7ZAD21lHRe1mysTK2YDhYvcBDOdE+PizPyLq+izDzG8PEEnZP8/RZl0N0iNKqWrWqbg2ClCYDw1SAxGgjeC2yM1GbQ1KpVtv1nLxEbDwgTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWBUvnlI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWBUvnlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E7C1F000E9;
	Tue, 21 Jul 2026 18:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658592;
	bh=ZqLXmeUbEblpEaxoRauNN8YFKmRktdXwXBCEJH58YDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWBUvnlIyIDsln/HdFICeGjIWvdUm7tkWLHYHwrbUoUgm+7efnrGyS/0Yga984GO8
	 GvKyMXxCHYsT/atrltmqXl5CQijgxBFuh0sEzHluQoxs1lJxkkIdVcQcDTtsethJfT
	 cWko0o5swKS0UcnosueSd81j1NBALj54iHyfzNsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1200/1611] batman-adv: ensure minimal ethernet header on TX
Date: Tue, 21 Jul 2026 17:21:56 +0200
Message-ID: <20260721152542.423902881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/mesh-interface.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/mesh-interface.c
+++ b/net/batman-adv/mesh-interface.c
@@ -193,6 +193,9 @@ static netdev_tx_t batadv_interface_tx(s
 	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
 		goto dropped;
 
+	if (!pskb_may_pull(skb, ETH_HLEN))
+		goto dropped;
+
 	/* reset control block to avoid left overs from previous users */
 	memset(skb->cb, 0, sizeof(struct batadv_skb_cb));
 


