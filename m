Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005D53AEB2C;
	Wed, 30 Sep 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788664; cv=none; b=XQ0uy4pLSA/kXDSrWqLQSNXqmJ63v77Qb02N1yOpuHwFYUuIms3zgYLviACsorINqSS9Hh9p4PvpN2hWBGwZtGtMMpnqT0cPPtYAD17L6Klklz0fLtQwtxuKfJR5Z/oIK0B6wY+lHLKY05jykHheCDMhdWT4WGpwJX3MO/2mdoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788664; c=relaxed/simple;
	bh=9aV6a5FXH4uMnsgSiPUWWeAOaHAxC8lHZGSQYvNZzwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lq3q4hGxwc/DO011TlQgiafr7RxYEELvYmRD6TyqKXwIaoeIpPEsVDLvEeDHNA6HizQ8gXjAHijad1+UcwVrb9O+4s84F6ZAehk4NghejIXlNNuCUyR3belcgj7ANznTgDPe+qfqwZ+6IIACpd9AQaenG8etDRhwb5lfsqjhe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzV3j39i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzV3j39i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2F61F00898;
	Wed, 30 Sep 2026 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788662;
	bh=Yr+MljLTpZ9K5TTIwAU4yBAKMOGmGMkL16tFvneagWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzV3j39iQfR6NFnSQlzjC43cfDQ+qjw1Ojq6BzmUUs0zdbLv2RVUg2XT1rFG0K5nm
	 n+UEYLpQOdQUdgCEAA3tKs4DgVQr4v6WTTgSnhnq4hQwY0o1IV5zppHNp8etzZkTe1
	 /1mWjMThh59ZLq8ZC4PCtDvoUanB04aTxGkdkYXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <fourdizhang@tencent.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 202/877] xfrm: use hlist_del_init_rcu for state_cache and state_cache_input
Date: Wed, 30 Sep 2026 17:18:33 +0200
Message-ID: <20260930152419.083502103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -763,9 +763,9 @@ int __xfrm_state_delete(struct xfrm_stat
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


