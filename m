Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D311F1E98EF;
	Sun,  7 Jun 2026 10:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827204; cv=none; b=EcTs0Rcyuhvvcnmc/gfLYyX38OT0hvWgJfhTzZmFv1guX0OXsoGCdHElAb7aT8F54GLK7HqBrIZpJDbIVcTj81tnfmo2iPixzhsZ98Zxw7oJjvqGOsvSZFkcy/b11tzjfWYRXrHkq0nuEQf1T56iGEepRa3fvzpQVGZC2IpQvok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827204; c=relaxed/simple;
	bh=kx81DdNKRSEBKPo7bYD7uMkbtzQ9/WCoxphOUh9QC9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrsAwh+XC7BSW1OEgYerf9oXHmUmLA6OZqA5XFdr5kvSzhWxdhZ+XPY/4DzfLMaZcTTobkXCTQkqosS7GtGrx0wsWylJtASOBGCMlD/EyCa5QGjv+BgBZk33CPoBCwiSNB++2mWTtlmRB0RaU8W+gieeAPEYNxi0qn8igLKH4GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LID8t1P/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LID8t1P/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BA41F00893;
	Sun,  7 Jun 2026 10:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827203;
	bh=+GfJc0pfqeyAzlwZBQu0mloYlcQ7d6N772/8BmznS+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LID8t1P/d4tRnQM0kC3UHhU4pEemvbcZbQZCZw7GKekH3vt2ChOxebiPXVU7YH6tC
	 FFW8EkU9TDB422shxQazXo7wpduFhku/MQOdnuP+1TKmWGE+RbAjeufsla9bkHnzcs
	 D2YFjwkGK0H/PdXDKhF1Hxsh6mWWT4g8jimKsOcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/307] netfilter: synproxy: refresh tcphdr after skb_ensure_writable
Date: Sun,  7 Jun 2026 11:57:08 +0200
Message-ID: <20260607095728.805736313@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

[ Upstream commit 92170e6afe927ab2792a3f71902845789c8e31b1 ]

synproxy_tstamp_adjust() rewrites the TCP timestamp option in place
and then patches the TCP checksum via inet_proto_csum_replace4() on
the caller-supplied tcphdr pointer.  Both ipv4_synproxy_hook() and
ipv6_synproxy_hook() obtain that pointer with skb_header_pointer()
before calling in, so it may either alias skb->head directly or
point at the caller's on-stack _tcph buffer.

Between obtaining the pointer and using it, the function calls
skb_ensure_writable(skb, optend), which on a cloned or non-linear
skb invokes pskb_expand_head() and frees the old skb->head.  After
that point the cached th is stale:

    caller (ipv[46]_synproxy_hook)
      th = skb_header_pointer(skb, ..., &_tcph)
      synproxy_tstamp_adjust(skb, protoff, th, ...)
        skb_ensure_writable(skb, optend)
          pskb_expand_head()        /* kfree(old skb->head) */
        ...
        inet_proto_csum_replace4(&th->check, ...)
                                    /* writes into freed head, or
                                       into the caller's stack copy
                                       leaving the on-wire checksum
                                       stale */

The option bytes are written through skb->data and are fine; only
the checksum update goes through th and so lands in the wrong
place.  The result is either a write into freed slab memory or a
packet leaving with a checksum that does not match its payload.

Fix by re-deriving th from skb->data + protoff immediately after
skb_ensure_writable() succeeds, so the subsequent checksum update
targets the linear, writable header.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 3fa3f5dfb26444..6a851ac4dd048f 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -199,6 +199,8 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 	if (skb_ensure_writable(skb, optend))
 		return 0;
 
+	th = (struct tcphdr *)(skb->data + protoff);
+
 	while (optoff < optend) {
 		unsigned char *op = skb->data + optoff;
 
-- 
2.53.0



