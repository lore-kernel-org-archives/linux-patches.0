Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F8151CF76;
	Wed, 23 Sep 2026 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174877; cv=none; b=ZEl1/MUDS7mnybuhsj2LHULKVP+nhzX+b/OlxHnleUP0oEzWS3O+DZ1+KxWd6TbPEkxwjFwznkVRZH2B68kGLL37JveRooKenS6TdlCS2cCsx6iLsOppcqFIx9OthZtDrqLon2e10Vd26yUD7X97luvmTqwjKnIxNrA3h1iLu5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174877; c=relaxed/simple;
	bh=nBqMIs4KLke9tW0Lq2No0jGaFEKxWX21YozgH5aOPM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3ECOHYpYbtoJNAIILAF76e/lYNMvYZhqEkA2OPi9ilJv1W2rKENA1JP3AjbF6siLpkSKYbNyVkIuwmIaLO9H5u7bfUrWcZagt3jMUY5VNaYyf8ov/se4pTen4dAHfmdzN7polWHUHLxLxZcdiCvT0r/SJQxG5BW+3fHtwbd9xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSeEJZA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSeEJZA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6641F000FF;
	Wed, 23 Sep 2026 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174876;
	bh=ZxqvYLhtn1yvM7AJXDuA5ocpLW1arEKr3RUtUHa6bQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSeEJZA2eJrRzPDF9CepNYd5dAiLsaQAdczc018gfUDbCbF9JpCwrJruoVtwPkFq4
	 Pxojfu4ma0WQGM/AlI/IGXrkNMnUQ/AXy8gRvZhOlFFgB8Kj/xy/rT3UHQC5lFHE/f
	 CxbkMAxx5VFS54qZ4ptHF62A18maRKC4/cC2uzEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <fourdizhang@tencent.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 255/398] xfrm: use hlist_del_init_rcu for state_cache and state_cache_input
Date: Wed, 23 Sep 2026 16:05:29 +0200
Message-ID: <20260923140650.025208001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


