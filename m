Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A5F443A81;
	Tue, 21 Jul 2026 22:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672609; cv=none; b=t+yJeZ5i4YOERtsYFOqi91ytgZ1bQZF1GVwr+k9wMpGJUo3H9JWCH+Nxqdo7vUSKT6H7dSfC50gZzRu5txzFQXJmR9V5hFzDYoWzCrka+FnfCCbEVEE4JtMFd6Gn+GxK3wlHSWhuP/9plWzmVqdw7bLgE38XIZEPCrIvJQ8DZvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672609; c=relaxed/simple;
	bh=9LHooJxn5H1ZItFJgGAnwE+edpVa0oxPy7edzdSFNSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlq7B+kK9o6k8FtiICOo2XgejNmfbOtq1lFJG0tpH3tVws4R1jKK+0vraH6Fv9ajnovQT3443u3uMXIqXqA91XAYKwew+LVgrPytXbOjFvkOmZeBrJqvjkp1Gq6vUJvDAKceJm/6BhDZ8nvldzT+Td7fipGFVm5M0ZKleejYjxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKzzfCtK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKzzfCtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76241F000E9;
	Tue, 21 Jul 2026 22:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672608;
	bh=6zzIXBlGr2lT6l9eiYoxGuc2lR+VKhNyzv0sN/w6qTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKzzfCtKycGt67sQMJeQPtdLNwB3kNZTBC9U4S/C/umCcrNk1LjFcp//wmffhbRro
	 KRYiLiEcn/kxzxmZekzVPPWiCT9dptoKvZcrpo/VEJcK6bCAyl1gOIop2OkNiIHuWq
	 m3tEwdGEgSs+ITNPFq6OnFGNWUh63aDFJ4v6o1Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 690/843] batman-adv: ensure minimal ethernet header on TX
Date: Tue, 21 Jul 2026 17:25:25 +0200
Message-ID: <20260721152421.575895533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 21297af54e4ea7..bdd6dd7fa77588 100644
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



