Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCD743E4BC;
	Tue, 16 Jun 2026 17:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629533; cv=none; b=D/8F5l//gVawjfigB6f3kzy4DcTbjAR+7WQPDiatuPWoGCjfo8GHCnUw9IOdRl+mZmMNMrFdwkm9pHfhQ0qxjBJYo0epbwCXEbjass+WzSCBU65Ee9GKvbHb4aYw8UTPOvzXxm4Sc2CmBtyzC3LHqpytEofevnkzEFRMQkAqEt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629533; c=relaxed/simple;
	bh=wj81f2oU60DddLlmVQoGI8sceuYYAHayymcz7uyyWRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4YYUaKPba9o61FzY7JKfMT0XJx2a/1AMHyzukyR/0LzblNsiXYUQKDJ1Yxk5EYtyB6PcE6SrugL+aMGRAYJvrnqq9Gsns3Pd3EcsSYLBZVJKGlBqvs+kfZVxGfMMjHBEI/xf3dv24XbJUsWw7tlBhoBPqPD3JgJkhO+5vWIctQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObbMWhDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObbMWhDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88F31F000E9;
	Tue, 16 Jun 2026 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629532;
	bh=0WN9SxrZqgi7TmMZI941yhGlD10SwdW9+Un7+/dHRoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObbMWhDqD/gNTR6I78HIpx5cZXob2lIMW7Bun0nmkv0RVy03SJ5dSIEHpo27TKbRQ
	 YncpnH7voq/BR//J00N9EG68VVigrqY16yL3zYzSVKPnjbQckARMR/z7orwA9EG0Zf
	 b4VGghYoS+CVsCYquGE7ib+HQnUR3bnu4FzUS+1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 291/452] netfilter: nft_tunnel: fix use-after-free on object destroy
Date: Tue, 16 Jun 2026 20:28:38 +0530
Message-ID: <20260616145132.852126441@linuxfoundation.org>
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
@@ -699,7 +699,7 @@ static void nft_tunnel_obj_destroy(const
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 
-	metadata_dst_free(priv->md);
+	dst_release(&priv->md->dst);
 }
 
 static struct nft_object_type nft_tunnel_obj_type;


