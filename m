Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4C043F8A0;
	Thu, 30 Jul 2026 14:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421177; cv=none; b=TGvjXGawyAPluBW6GAVymPF8d2SeoDiQrZaGEikdpGwR3gIkDr9mu/Jg/bh4Mt84fnPamg4gGzv8ge/Zq67O5hJAX90r3q6q/X1egLqmjHpPaBiCq4IBCQOMGyHg/paGjaGu79EZxgpVVIeF0aEQ02cS2XiWQ8HAUbLBzqmwvSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421177; c=relaxed/simple;
	bh=WAZQHO6F+D3EJx7zcfkVRQfmTt4vN65AmG5f3nO5NCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojtGutjMI3O9PvHDjglvltddH4Eh1apgCQksPqJVnulvkA8bW6TZPbvkTTV52pUMaxxD2mX50TIuDZDENb4vxOqdCrnC4n35ONiYfMiH+sRKfBfuNgYEgnbc0dfc2z0dmou80R8HLQhJxsmKEP7upkqEoIJZ1UnerQaBrXMo6wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2WujIqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2WujIqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1205F1F00A3A;
	Thu, 30 Jul 2026 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421176;
	bh=RqgT11kOk0/gSaR5j2jYYgrnGjILaFkScd+xhDIh920=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2WujIqntmYMyohuc3tZZ54rqAVixEkzmzqzFMHZrg3vdYN9fImq2N7bhSkpQNOKA
	 IFclyT7Uz2Svym1l01u6YcIox1zH6ng90F/jL6XnFAqzUysZzx+cKnx/DInOVAdASl
	 LYsB1nvIXq3mxitnWlLPp3tVwgzLMsA99u68HBJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Wozniak <petr.wozniak@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 017/744] xfrm: fix stale skb->prev after async crypto steals a GSO segment
Date: Thu, 30 Jul 2026 16:04:50 +0200
Message-ID: <20260730141444.649140610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Wozniak <petr.wozniak@gmail.com>

[ Upstream commit 3f4c3919baf0944ad96580467c302bc6c7758b00 ]

skb_gso_segment() leaves the segment list head with ->prev pointing at
the last segment, an invariant validate_xmit_skb_list() relies on when
it sets its tail pointer (tail = skb->prev).

When validate_xmit_xfrm() walks a GSO list and some segments are stolen
by async crypto (->xmit() returns -EINPROGRESS), those segments are
unlinked from the list but the head ->prev is never updated.  If the
last segment is the one stolen, the returned head still has ->prev
pointing at it, even though it is now owned by the crypto engine and may
be freed.  validate_xmit_skb_list() later does tail->next = skb, writing
through that stale pointer -- a use-after-free.

Repoint skb->prev at the last retained segment before returning.

Fixes: f53c723902d1 ("net: Add asynchronous callbacks for xfrm on layer 2.")
Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 8b526e3676389a..4719aba331cd66 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -224,6 +224,14 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		pskb = skb2;
 	}
 
+	/* skb_gso_segment() set skb->prev to the last segment, but async
+	 * crypto may have stolen it above without updating ->prev.  Repoint
+	 * it at the last retained segment so validate_xmit_skb_list() does
+	 * not chain onto a segment now owned by the crypto engine.
+	 */
+	if (skb)
+		skb->prev = pskb;
+
 	return skb ? skb : ERR_PTR(-EINPROGRESS);
 }
 EXPORT_SYMBOL_GPL(validate_xmit_xfrm);
-- 
2.53.0



