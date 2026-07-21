Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022B47125A;
	Tue, 21 Jul 2026 18:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657646; cv=none; b=K74sOOmO3wy8ZnBLMMpLRy69mhfh1oAN++lmQ2cA9CGl2g9u9nUQg7rINls6A1bMcckvX67Z8fBQIOQFVc96RemQRBP1WZCupB+iex7t73qh/mQoPNHa2QNfiQa1kzwJ4i4+G0HhaHf2s2X3b8EhBakGUYa/oLLb1jRLejwp4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657646; c=relaxed/simple;
	bh=GlypB/m1JDsBNUfVgS9mKp345zcSucTv2WqJTGcGUto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kicnufYGgutwjSnRNozvBKzT3SKogTXKIn7q0EBtuQ9YCoGAx+7UHaB9V/At8OJDcZAHzzXUD8eeaaDic+atGcrnWYJVPsKyzo1bsBoyFjgvSDhcuYPoqrelTWWl19mBnfH7F1e8A9mQXPCs3MeHphDr0bht818BNf3cHemrJM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/g4hW2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/g4hW2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF0E1F000E9;
	Tue, 21 Jul 2026 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657645;
	bh=ZH4gVzo4JnY5rRHV38HnjBiWbcoK8iehCCF3WrpjgXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/g4hW2StvpNs05tLCGr5QmrSXtfLyq2h92efQ1GFj4SSMmjjb9GtH/8EHswE+KdJ
	 YwSEw+IOt0dFGC4gShqNI7jlD6J/XBaHfTyVa0E2ovtfcRRK29vDnZ+ST35jXwmj7f
	 0RGAsupq1hKp38pQCGPUC0dfytW+m2wq8OF0go88=
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
Subject: [PATCH 6.18 0836/1611] netfilter: ipset: Fix data race between add and dump in all hash types
Date: Tue, 21 Jul 2026 17:15:52 +0200
Message-ID: <20260721152534.191766266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 4e56269efef28e..5f493124c15903 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -844,7 +844,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old = ERR_PTR(-ENOENT);
-	int i, j = -1, ret;
+	int i, j = -1, npos = 0, ret;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	bool deleted = false, forceadd = false, reuse = false;
 	u32 r, key, multi = 0, elements, maxelem;
@@ -889,6 +889,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
+	npos = n->pos;
 	for (i = 0; i < n->pos; i++) {
 		if (!test_bit(i, n->used)) {
 			/* Reuse first deleted entry */
@@ -962,7 +963,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 copy_elem:
-	j = n->pos++;
+	j = npos;
+	npos = n->pos + 1;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -985,6 +987,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	smp_mb__before_atomic();
+	n->pos = npos;
 	set_bit(j, n->used);
 	if (old != ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
-- 
2.53.0



