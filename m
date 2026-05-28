Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE80A23C8C7;
	Thu, 28 May 2026 20:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001073; cv=none; b=qLiEJxPDowRZx8N3cBltOYKc7mUgWQDqwkdkOGnBwczNUjqce3/EDW1sXwemLLJSeEKq537cRuJMsQdQISe6UXo6KJF5b9E4etM6EltueM8j2OF5pCwIncB/qi+P0hx+EvggUbQggQVmugp/+MP7aK1ZAGCaY4vCCVMMzjxDJj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001073; c=relaxed/simple;
	bh=S0zbH37Z2KKxql1HAjQqY/KNpC/cUPlkUyoJF6j9Cqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqJDw7GOh1EPKp0b8oAziW28AW2XFCmvSrU+XR6bG05sJMRIaCwrJ680ZyU3j5jKgcgwpJjPbPsDryEvzpkmQYF1riBrIOYyAnur/2l5vdeApJdYqZnQxQnQaYyzswfQaQv4wske7Su1URfvOacnXey+i+cCZEshBnP4FtAaQLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhL0NpJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhL0NpJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CB01F000E9;
	Thu, 28 May 2026 20:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001072;
	bh=WpPt+IdzIscQmk6Axb38YAmMzxLklFQA/unMHR/CM8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhL0NpJZR+iUB7ZPo8csyo9Bl784pAePMSmLKpW4sC19IpDJD/f1UAMvP1aYHslxc
	 h0HgYDWGuG0aXsPuq9Dkj4z3QU+BAqYnJdypfRRMdhlDVPdIVTNE1PdlrDC9isnjP+
	 EGt/ZB4/Ln/p/XDi1KjqJGqGWNiXiG+/7K6WS1QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huzaifa Sidhpurwala <huzaifas@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/272] net: gro: dont merge zcopy skbs
Date: Thu, 28 May 2026 21:50:44 +0200
Message-ID: <20260528194636.633950751@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
index f5c80c2f69df7..e4cebf162efb7 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -108,6 +108,9 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
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



