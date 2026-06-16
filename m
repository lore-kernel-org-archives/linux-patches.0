Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2016644D686;
	Tue, 16 Jun 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625470; cv=none; b=URFWMdXGSpzPxisyq97OlZO56A6IP5O3AMgyWC1lEjCaERQzJxXOFmIC9ICQtGuv+0Kg5G1PtHpGuTBy8hhD661nhCrLAcyfBjwc3VOIogbYcI4EKISl6Nfi1mCm8w0KQvm8XvIJyXik+p0aqImlzfhFFr7yhUcQa6AW8zwFO7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625470; c=relaxed/simple;
	bh=vgZ9qGtxv0VTAKDuMcEPtL9sHOuUq60GONqZb4upNsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUxahe+8Gxc0qbAjaf4HEPJtz5ocCbNr13Px771RehBY+lhsR/k7me2/or8/1PmF76wjfi0v7Xgzt8WSWCCRXH7IU/oz7QqaEskNAnzgvyjd3Hfv18HJohwUE9ih/4SnmDY3bQFwXv8HB1QMg4VmWUrp1WJIG9qy9jlUhlUd+Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiHm5dMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiHm5dMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1951F000E9;
	Tue, 16 Jun 2026 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625467;
	bh=3FaTIOBMXzVYVHHFDS6qXeKJG6jqPSwIjEC2CtxSl4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GiHm5dMeyFLlf880zrFJef8584OkfOcbD6nwGt2vabx3Ny0Y+w6HJvR8ew/NN661o
	 uPEZYveU/hyHY25Og89C9aE4CCmeFT/gI6S2vHe/kXabmmMwpw9xUpnZDeGftW6G0W
	 k0TyGHDh9YL1R7pQgHyEJmyEEO6pAGoCJ928uEbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 147/325] netfilter: nft_tunnel: fix use-after-free on object destroy
Date: Tue, 16 Jun 2026 20:29:03 +0530
Message-ID: <20260616145105.046087269@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit c32b26aaa2f9216520a38b3f4bfeec846eb3eb8a upstream.

nft_tunnel_obj_destroy() calls metadata_dst_free() which directly
kfree()s the metadata_dst, ignoring the dst_entry refcount. Packets
that took a reference via dst_hold() in nft_tunnel_obj_eval() and
are still queued (e.g. in a netem qdisc) are left with a dangling
pointer. When these packets are eventually dequeued, dst_release()
operates on freed memory.

Replace metadata_dst_free() with dst_release() so the metadata_dst
is freed only after all references are dropped. The dst subsystem
already handles metadata_dst cleanup in dst_destroy() when
DST_METADATA is set.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -702,7 +702,7 @@ static void nft_tunnel_obj_destroy(const
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 
-	metadata_dst_free(priv->md);
+	dst_release(&priv->md->dst);
 }
 
 static struct nft_object_type nft_tunnel_obj_type;


