Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610D83B9950;
	Tue, 21 Jul 2026 21:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669549; cv=none; b=CU429fuE8UvqYCISW9rJ5pSTWvP7ax+XuirHR6uOdMJWGH7tQCOpxYaHs3SsIlaceNKxdtInzKfp16wZQXAP97RqYLkhIsDJfKkm4QY6Ejg4rZxvXduWUcidEroTa9xwzQ3iNRh+jpdnR1KZGy/RbzUwZ7Q/WJMhxieW/Xp55Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669549; c=relaxed/simple;
	bh=1r3KadkpgDBL/2iXNDx6OcS+omfvcAZIlGXEPHpIRKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgXNFgH5NyNXELR/3oXEt6hCs7EhYsVGPc3JNW6TOExMgOOPtSu+5lPKdu8Ae4PHDfWTiGSad0ILzvwigstdXuGKHIxj1GNYqBuc3OVxBSBQ/HLqIOmrXIAPi31fI1x9Z8F9m6E8yP1d85U03kc1dwbm0weGtKWknOtpBR041TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPItIYGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPItIYGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27FB1F000E9;
	Tue, 21 Jul 2026 21:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669547;
	bh=5ad4mmwQeTbaUMlrfKann14jJwtBxp4PWrmslkSTRAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPItIYGYS5JIBUI/p32Sa8QIs2gHlH2xxXPckM2HUJqBv/yBbDL32pZuhLkR60R3F
	 OjPmcWE6SThMHJVyZp4Lkh5QXoybaXb08cC8CqS8FnRE84MjnocDUL68vd+EksYUIB
	 mzZpmIRVAuKvmcJTaU3Sf19nItNsX8tcWVgW6YqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com,
	syzbot+1da17e4b41d795df059e@syzkaller.appspotmail.com,
	syzbot+421c5f3ff8e9493084d9@syzkaller.appspotmail.com,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0595/1067] netfilter: ipset: Fix data race between add and dump in all hash types
Date: Tue, 21 Jul 2026 17:19:56 +0200
Message-ID: <20260721152437.915988276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 2358f7427ccd6ec8867a48205d8fcec973683a3f ]

When adding a new entry to the next position in the existing hash bucket,
the position index was incremented too early and parallel dump could
read it before the entry was populated with the value. Move the setting
of the position index after populating the entry.

v2: Position counting fixed, noticed by Florian Westphal.

Fixes: 18f84d41d34f ("netfilter: ipset: Introduce RCU locking in hash:* types")
Reported-by: syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com
Reported-by: syzbot+1da17e4b41d795df059e@syzkaller.appspotmail.com
Reported-by: syzbot+421c5f3ff8e9493084d9@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: e4b4984e28c1 ("netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index da7956e2f8d898..dea04887b8e699 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -831,7 +831,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old = ERR_PTR(-ENOENT);
-	int i, j = -1, ret;
+	int i, j = -1, npos = 0, ret;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	bool deleted = false, forceadd = false, reuse = false;
 	u32 r, key, multi = 0, elements, maxelem;
@@ -876,6 +876,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
+	npos = n->pos;
 	for (i = 0; i < n->pos; i++) {
 		if (!test_bit(i, n->used)) {
 			/* Reuse first deleted entry */
@@ -949,7 +950,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 copy_elem:
-	j = n->pos++;
+	j = npos;
+	npos = n->pos + 1;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -972,6 +974,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	smp_mb__before_atomic();
+	n->pos = npos;
 	set_bit(j, n->used);
 	if (old != ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
-- 
2.53.0



