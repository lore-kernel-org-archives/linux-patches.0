Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E889381B05;
	Thu, 20 Aug 2026 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239195; cv=none; b=o2bRUaCSViamwNk+QfSTN8AlOHhVGf5GJXxjOMwZoa9Js0eN5sVIAreMLoXrQyZL9udza2NCFHHLiG3U6MZAX666mz2NRAMLohPbxfIARWZ0UzyQ3L83HXNf/X/KCNpkuNdwzSA/HpWQPaYcZhHwAaNreBD+xFq2QkjE0ksbpLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239195; c=relaxed/simple;
	bh=0SaAbndsPkuoS6OMeg4RK61cfzr2YUn73gGFbSECuVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAjIiaQGSeKyMNer2TkJg3wOWDPwcjtoWUequScY7G8UcpCDqxztxbvRA3H9TA+5tTwRV260eyPxWwvlqM8cnaKI7e7/y+VYSlhQsTFSkeQNdBliTk2Ig9tswSfpfp5gmexyIkxVrO/fcjdbBioA/K31cXZlR3/ISjaZ/5aNbos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPPtn7hN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPPtn7hN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94581F000E9;
	Thu, 20 Aug 2026 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239194;
	bh=aZEfDF2csSUmG4twXpwccfFC+R6Rmsrycsj2DO/6wx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPPtn7hNaPijma8VagqK0O2P2uoPQjWhad0gC89UKj2lG7VzgsgW1aFeWP/ab1sCn
	 5dPS9/Uva/wqsa0mIYmmrjbJXkFZqKR5k7hZiuJcbrfQ9C46EvXDFgLS9eFv/NU3xO
	 bJkspsnR9IkBbTNxmF/0EsRe/y7z3fTQe8Psxpqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 182/217] netfilter: ipset: let destroy callbacks adjust ext mem size
Date: Thu, 20 Aug 2026 16:55:50 +0200
Message-ID: <20260820145243.207534642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 490937b88cb592cc0c5367758edd700fd5abd15c ]

For bitmap this change makes no difference, because destructors are
called synchronously.

List type however calls them via call_rcu() so accounting decrement can
happen after list_set_flush() set ext_size to 0.

'set->elements = 0' can be removed for the same reason in the list type
case, it calls 'set->elements--' for each element.

Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 net/netfilter/ipset/ip_set_list_set.c   | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index d99e2e2e58559..ca1119f651efd 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -77,7 +77,7 @@ mtype_flush(struct ip_set *set)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(atomic64_read(&set->ext_size) > 0);
 }
 
 /* Calculate the actual memory size of the set data */
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 3710772ad8884..2f11814bd512a 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -423,8 +423,7 @@ list_set_flush(struct ip_set *set)
 
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
-	set->elements = 0;
-	atomic64_set(&set->ext_size, 0);
+	DEBUG_NET_WARN_ON_ONCE(set->elements > 0);
 }
 
 static void
-- 
2.53.0



