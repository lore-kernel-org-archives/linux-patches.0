Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E437B43E48C;
	Tue, 16 Jun 2026 15:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623548; cv=none; b=U4pdREPy5PFh5moP3v7eVprXEEed15/93FIkAGiUw3qALjCMJQ4BhQKkhfVjRaEkkP2hjuj2T0VX20xbw8vPBJmQFSJtoBt/tn5OLpYhqBqIJV1h1+6HzVpgK51HAU7I+LmHCoEaI64/a7GlUeif862PVaYGnJAhtaG0wqs5Lv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623548; c=relaxed/simple;
	bh=/QUKqUdKAfBicvaBYiKtRlZChQ1zRtG9GBiB93OVT/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4/ZD6znMp3CGtDQ8avTGhgYWHGk2CFyNlMH53Eow5mEMtBzZ/lfSbfWe7ZHoFZHWINsT0A3u6tQeQnuwhqL/WshBHUiKDv0qUqYt3FpqdFiNKpkrkOnSku4XCi4NNZIrfqWtGKUhaYD1Vs0wpf7ycbDfmYbDr5KAMG5jSUz6kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEtnjwyk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEtnjwyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B851E1F000E9;
	Tue, 16 Jun 2026 15:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623547;
	bh=9j6P6rSBfRX32iNMfqBbKwrbrwBoTtU8ir/jaerloUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEtnjwykZR4tb/zZhzD/b0zjdQU4NyY2ZOL9lp4hSiD2vI4SNuix0vduijZVhUhtb
	 GWvo0lT83xKJoW825JhzelT4RWYOuJabQWgnwBy1++c/21KTVezkYTHV5Cmx8poGBz
	 rCWgw9YO66laHzjbUpT4CQTZ7r5ZxI+Vm5+mh5rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.0 169/378] netfilter: nft_tunnel: fix use-after-free on object destroy
Date: Tue, 16 Jun 2026 20:26:40 +0530
Message-ID: <20260616145119.211912533@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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


