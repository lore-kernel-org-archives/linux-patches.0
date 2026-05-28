Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5868402B8F;
	Thu, 28 May 2026 20:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999227; cv=none; b=ZNIngj4Po6DIjJYVz2EJAqttLfIVQEDgAuggUqM+SFLDA3dPx8Ickd1gsnRzRuI3YpTmh60njt+lqPv14Om/k8TU/2kyGH+V4JiCUeacRNjcFsxNPRUTywyQ43/4OWGHuwOfXh9k3liogfVyTek4CMY1sR5ahUHpFeUTAkJnd+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999227; c=relaxed/simple;
	bh=oMbbMO/EwMeCvFHyYbWzJcyTzHQNH+dMOTI/N6iSGdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu+LhA+oyhMlxcI5AqSaAhTacUTK2IGulijNNXSGlbl8LIch/40X2jcC9U1JQRCDNpd5Y76MivPi3eRqtCqWsuzVv0RfKVorST97XJlFtRJkt4DanTQ0Vl99nimzD22poc1/TiQ9Xakjo1PF/m1nq6LmVEhutXwfLLqFQWrv1rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H40F9tNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H40F9tNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED2D1F000E9;
	Thu, 28 May 2026 20:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999226;
	bh=z9MpXg3JPPLRt2jF0wXsntwmTeDEyaN7wTvyI5tCKvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H40F9tNXYyxEi5T87mr2+eu57JPi574UwjjihpbX2QIfuqoADKvHJA61nSPJDkUWk
	 orAZAJIpnefbWYMJ+Tl1sxGeejruqug90wS/U1NXoAv7S46yqgtEAq0b58Vkh52juC
	 BpiBnTSC//Hcf+aPTyVjzAB4m4MxF5otOhCtW20w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huzaifa Sidhpurwala <huzaifas@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 453/461] net: gro: dont merge zcopy skbs
Date: Thu, 28 May 2026 21:49:42 +0200
Message-ID: <20260528194700.652010613@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 4db79a322db8c97f7b73b8a347395ef4d685eb40 ]

skb_gro_receive() can currently copy frags between the source and GRO
skb, without checking the zerocopy status, and in particular the
SKBFL_MANAGED_FRAG_REFS flag.

When SKBFL_MANAGED_FRAG_REFS is set, the skb doesn't hold a reference
on the pages in shinfo->frags. Appending those frags to another skb's
frags without fixing up the page refcount can lead to UAF.

When either the last skb in the GRO chain (the one we would append
frags to) or the source skb is zerocopy, don't merge the skbs.

Fixes: 753f1ca4e1e5 ("net: introduce managed frags infrastructure")
Reported-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/c3b7f906bbfcbdfd7b4fa9d6c18a438870df85be.1779307748.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index 9f8960789b2cf..a847539834679 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -109,6 +109,9 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	if (p->pp_recycle != skb->pp_recycle)
 		return -ETOOMANYREFS;
 
+	if (skb_zcopy(p) || skb_zcopy(skb))
+		return -ETOOMANYREFS;
+
 	if (unlikely(p->len + len >= netif_get_gro_max_size(p->dev, p) ||
 		     NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
-- 
2.53.0



