Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83212277CA8;
	Wed, 30 Jul 2025 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869033; cv=none; b=jdqcgKyhEYRujmRyZLogO5ED07lxA3wTCunVxrdyA0a5OX6/l+FbFPxUGYJpKo0A0BY9cAE4moxUGwdTII92sYS8SWtadN+Dkvzq9UQ/wLHZYGDaffJ1sJbLIy0gXKRhs7hZWPFquH9L4n2UzCGtgBhDKdN89jI9MEzoPqEdyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869033; c=relaxed/simple;
	bh=WNuQPfdiP3wDPud/Zzw4CgN3b1IJpDBOmyOYQeK/0OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6eOOvSqxoaEEv6xH7W0NCCRqtLSX+naA3SEGQePhe+jh7g2kiYD7yOhYCevphHwU+lLqugmI6uGqceme0r6STka09GYg9Yr3kGFDDUAB75WWj0weG4dvbKZs5ndztbbC0bX5SzUfeX1bFJ5I6zuXayYLr59kFK5qR8F3yjYo9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQ8HKTPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQ8HKTPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CA5C4CEF6;
	Wed, 30 Jul 2025 09:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869033;
	bh=WNuQPfdiP3wDPud/Zzw4CgN3b1IJpDBOmyOYQeK/0OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQ8HKTPDczfk+hySD6rxT3zThktSy+lDBS4OzPTI0BUdhF94E+0AIV0kZFiTcC5nS
	 JVHNfQCfsTFR0jXC6sOOoENI8tqJDuIsU+l+MhY5dFtJVWSZGj5vj6hFWRYqzOkw9u
	 tgQ9geR4ecX40D0chOugSLF41nJOtcBKYeswwTek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ed9d47e15e88581dc5b@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 20/92] xfrm: state: initialize state_ptrs earlier in xfrm_state_find
Date: Wed, 30 Jul 2025 11:35:28 +0200
Message-ID: <20250730093231.394949009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 94d077c331730510d5611b438640a292097341f0 ]

In case of preemption, xfrm_state_look_at will find a different
pcpu_id and look up states for that other CPU. If we matched a state
for CPU2 in the state_cache while the lookup started on CPU1, we will
jump to "found", but the "best" state that we got will be ignored and
we will enter the "acquire" block. This block uses state_ptrs, which
isn't initialized at this point.

Let's initialize state_ptrs just after taking rcu_read_lock. This will
also prevent a possible misuse in the future, if someone adjusts this
function.

Reported-by: syzbot+7ed9d47e15e88581dc5b@syzkaller.appspotmail.com
Fixes: e952837f3ddb ("xfrm: state: fix out-of-bounds read during lookup")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5ece039846e20..a5a3bf25fd1d4 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1389,6 +1389,8 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	rcu_read_lock();
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
 	hlist_for_each_entry_rcu(x, &pol->state_cache_list, state_cache) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
@@ -1429,8 +1431,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	else if (acquire_in_progress) /* XXX: acquire_in_progress should not happen */
 		WARN_ON(1);
 
-	xfrm_hash_ptrs_get(net, &state_ptrs);
-
 	h = __xfrm_dst_hash(daddr, saddr, tmpl->reqid, encap_family, state_ptrs.hmask);
 	hlist_for_each_entry_rcu(x, state_ptrs.bydst + h, bydst) {
 #ifdef CONFIG_XFRM_OFFLOAD
-- 
2.39.5



