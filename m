Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0950478864;
	Tue, 16 Jun 2026 16:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628155; cv=none; b=iafmkLOMKEjLexCHkKZrSlxgf2iO2MMR4bAi42zfqIoYQ4xHtrTzmU6DTh+L/OFO8NGPBJJo/DUMOntjrb9F7PweI/XUnhEYLwbs6x/dV9SPwy8qQA72tG1xv1w7G7apReBkzoViH9nB4RuFdhfHsxzXvAwWju7bxqaGK246Bew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628155; c=relaxed/simple;
	bh=KcGQGMIsjFjevofc6nu81omylDENer1iWCv2UdeG7VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YP6qCX5Du8U4Ngvj3GZ65hc86kVkwg3CLQSakAn9mHWmgpC0F8QaKFMV1keRkTdpksj485n6i4Y+4hFTRXfgYV00XckbJ5SplR/0SoeVX8BpW/GuE2/gRZABee/lae1seeuFJpQTqC43c4vDcxulNZAxbOh5w72JhTHQaQxcWAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4dhK5nv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4dhK5nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E441F000E9;
	Tue, 16 Jun 2026 16:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628154;
	bh=MglUFf5Wgg16dmeCUJKUGURRTT/YeZD3WOxLIJrzV90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4dhK5nvY1/K41ff5fMxfmKV6cPzSRJRos9aaJJekxfWOG9yrLm3BKgKPzWXu+p+y
	 HMbQrOftox2ptVARL+pzV03qWOr1CfqWiBFPeDFn8D1LKZ19y/NRCz/tB/RmnGV2bO
	 brUPkcdnZKCAudW+JD2LxwM9qna79UT09anqQR5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/452] netfilter: synproxy: refresh tcphdr after skb_ensure_writable
Date: Tue, 16 Jun 2026 20:23:59 +0530
Message-ID: <20260616145118.446586143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16915f8eef2b16..f5a52075691faa 100644
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



