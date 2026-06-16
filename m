Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FC82F12AE;
	Tue, 16 Jun 2026 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633105; cv=none; b=P9IgJC/j+CDSY1VRmCdRR0orsWMneR/4/kN/ASC+4Z6Qxhedlt0eQ2PGhte1hLFGULvLloc1uOb/gxVc4e/UEIPXPuZMkUU/gZbjiTLHThKfaSlawuMQxWoXy9v4Dup8fS9WmUpdxItl7qixRzgbkQ6F+/UoEld0j6IUg4RwIAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633105; c=relaxed/simple;
	bh=HsDr0dDIfbXsNMLaZfiOmJ2qfst33Ovl5dJZXWTpSk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsfXd5aE5flvYw1vqX7xESyopo8UZeHQNd0lhmEfkZV/VnotS3UU5YBBuBBQOxrFpOSPr8BUy5vQTxdrwpqO6QtWeKGfT8r3pGzwyZ2EqFMPCmp9/tOtnMkiq68Y+hJOPsRITsF3ZDWMsnDoJ+EY7fIgGg6f0Z9ZHC54Em6ox+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mox8byjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mox8byjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E101F000E9;
	Tue, 16 Jun 2026 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633104;
	bh=X2To3wm4F2VaCcW0j2HbERfPgTF/fS0kbXD28rUuoe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mox8byjwNL66gIJOk+XkqJdCIZX3hpLtPlW2ctObnQ99HR0WyiBMUfNeXGGDTyjBd
	 LrDWvKQSO07zrkILiT5lc13tW67svzlAltchZNyV2gcEyALg5dJbEYeokqZXi5Ul1V
	 EZ3aazkE2G/6XgMb922NhFetdvB2FCoiaMrGeFO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/411] netfilter: synproxy: refresh tcphdr after skb_ensure_writable
Date: Tue, 16 Jun 2026 20:24:10 +0530
Message-ID: <20260616145101.018928370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
index 049a88f0380117..cdb2c3e23af7ee 100644
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



