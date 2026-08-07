Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F1827466A;
	Fri,  7 Aug 2026 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116134; cv=none; b=Dl/jOAkstVk1gpCeELDUaVSRBzHX/Y9QfsIo22NxJW4oR1LRnzBBG3HtCg5zHR40kTbHHtEe+jnuulvtxcX5ueLluahwvfl9tWaIhdawt7oZRlr8e2cOpb5jXEizhNJKYC76Xyfj9UGQGsugStBYIJU7pHbUnOdOuhskyGeFy2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116134; c=relaxed/simple;
	bh=eT9Mi0pBiOIJAEofYHruSIzIlc1h+R9ydPb09zpP9ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSq7GpK0KE/hfqI0FJj6fWgvzHatx/LFn8eMAnfcEHQUe5+nck12L7i0JtZ6AmcBsqOyPG+T2ua3+8nfhyNw6gQqbtEw8xw4cVrREw/CIjwdtLosQAxpaWf+Jx9HyONy6qnuNAnKapfea1fBNZ9f16NWowH+WCvljQu0YL7TlSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JysNzmGE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JysNzmGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4481F000E9;
	Fri,  7 Aug 2026 15:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116133;
	bh=kwC5KjHLAslBYPYHPFtIk7uKSa45KY84Pm+s4JFbO2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JysNzmGEN6EMFhyG4BF+GQ5rVMnEP+f0lq91jwLtP+H6PwtvmKgHgZuk7AJQqHi5y
	 Wm5s1yEfSIiPelgIXV7swPlYsz9QnOIC/35Vz7Gg6lJSuOI6kP1ltJeySbHK7TDxew
	 RnSt/NecjGuAGyIC0t52XeTPU6arxivAfDRuybr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 125/261] netfilter: ipset: do not update comments from kernel-side hash adds
Date: Fri,  7 Aug 2026 16:38:02 +0200
Message-ID: <20260807143418.064418384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: David Lee <david.lee@trailofbits.com>

commit f30415929be8aeb002d557c8d3f7ab2d2188003a upstream.

mtype_resize() copies comment pointers with memcpy(), not the comment
objects themselves. During the window after an entry has been copied but
before the table swap and backlog replay, the old table is still
published for packet-side updates while the replacement-table entry
already holds the same ip_set_comment_rcu pointer.

If xt_SET --add-set ... --exist hits that old entry in this window,
mtype_add() calls ip_set_init_comment() even though packet-side adds
carry no comment payload. That call frees the shared comment through the
old entry, so the replacement-table entry now holds a stale pointer.
When the queued add is replayed on the new table, mtype_add() calls
ip_set_init_comment() again and strlen() dereferences the stale pointer.

Fix this in mtype_add() by skipping ip_set_init_comment() when
ext->target marks a packet-side add. Userspace adds still update
comments, while packet-side adds can no longer free comment storage
shared with a resize copy.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -983,7 +983,7 @@ overwrite_extensions:
 #endif
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);


