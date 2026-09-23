Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9702B53358B;
	Wed, 23 Sep 2026 14:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173630; cv=none; b=DG7+D5/ebBmS1cnQchzlsgThY94xqhar1h7F18L9T2lubwCZJnAk6hzCf8k+iRt5GfD77PJ34IUh7VhpMTzKVZUuFKPBqPfdYpMCZHXOJ2Dc6oTG+sDi++lFaZ7UZ7wK3CioA+Pjnj6Z72/D3+eALfWfYA3299osepdS5q7FXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173630; c=relaxed/simple;
	bh=5aqIDoZRXkKUnPJCkeZKjDyte1xsLV/1XviH1kBDHC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRy/ILbUUJ2H+sTfL4baVAp9WUXGTocSgdJjWurvkJagmdhjsfDV+orbz95ycIz7S9I9AtaPaF4ESor4GWIBRUbGGuCS8JlyQE/Uy3gZdWvI5LTya7BFbNPGSqXptp8BVdKCs2oxUM3KQBqrgMQ8DW8BV0C6zx0b9LiRNV46bTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejZfj45x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejZfj45x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22471F00898;
	Wed, 23 Sep 2026 14:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173629;
	bh=olca7KzQrffNa43JpCV6mc5rB9n16Xpo33JXlcNUGno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejZfj45xoOqURITE2Lb0D2a3Fqu/y0E9lzGBTJ5h5j/DYvBWvECBQMNd1aMMT43Us
	 z92VdtjNu4zRCR6fLZg7M8Qz52S7x1ECzQ74EQXOeoNtPM+Grf486lnRQP3CYos20c
	 Or3ghODwhNRX4xTdmM9GjlakBYJN4N8ZPXJ7POG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <fourdizhang@tencent.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.2 307/438] xfrm: use hlist_del_init_rcu for state_cache and state_cache_input
Date: Wed, 23 Sep 2026 16:05:28 +0200
Message-ID: <20260923140652.731827794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <fourdizhang@tencent.com>

commit 2afb8dc1f4390f164db8352f8e685e126e9db566 upstream.

Commit 14acf9652e56 ("xfrm: defensively unhash xfrm_state lists in
__xfrm_state_delete") converted bydst/bysrc/byseq/byspi from
hlist_del_rcu() to hlist_del_init_rcu() so that a second
__xfrm_state_delete() on the same object becomes a no-op rather than a
write through LIST_POISON pprev. It missed state_cache and
state_cache_input, which kept hlist_del_rcu():

- hlist_del_rcu() leaves pprev = LIST_POISON2 (non-NULL), so
  hlist_unhashed() returns false.
- hlist_del_init_rcu() leaves pprev = NULL, so hlist_unhashed()
  returns true.

A second __xfrm_state_delete() therefore enters __hlist_del() on the
already-deleted state_cache/state_cache_input nodes and does
WRITE_ONCE(*pprev, next) through LIST_POISON2 — a write use-after-free
once the slab is reused. The corruption can in turn cause a subsequent
hlist_for_each_entry_rcu traversal to follow a dangling next pointer,
producing the read use-after-free reported in xfrm_input_state_lookup().

Switch state_cache and state_cache_input to hlist_del_init_rcu() to
match the other four lists, closing the write use-after-free and, with
it, the read use-after-free it spawns.

Assisted-by: CodeBuddy:GLM-5.2
Fixes: 0045e3d80613 ("xfrm: Cache used outbound xfrm states at the policy.")
Fixes: 81a331a0e72d ("xfrm: Add an inbound percpu state cache.")
Cc: stable@vger.kernel.org
Signed-off-by: Siwei Zhang <fourdizhang@tencent.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -826,9 +826,9 @@ int __xfrm_state_delete(struct xfrm_stat
 		if (!hlist_unhashed(&x->byseq))
 			hlist_del_init_rcu(&x->byseq);
 		if (!hlist_unhashed(&x->state_cache))
-			hlist_del_rcu(&x->state_cache);
+			hlist_del_init_rcu(&x->state_cache);
 		if (!hlist_unhashed(&x->state_cache_input))
-			hlist_del_rcu(&x->state_cache_input);
+			hlist_del_init_rcu(&x->state_cache_input);
 
 		if (!hlist_unhashed(&x->byspi))
 			hlist_del_init_rcu(&x->byspi);


