Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C143B6352;
	Tue, 21 Jul 2026 20:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666705; cv=none; b=FYew6SxTmJtMX3OI2++TcWxR2KeOSpazj7+GJ5zF0w+4JVXAXllFIQ4tsQhpcE+EvwkrF0csgsiNa/e2kLT/R3j9kRCkeG3z/DD81pqjtIt04w3BosnlrZRDfE/Qmidao2ZBcUiC+Ikdr1QGIfeM20KEBd9OdZdsemRWmzXoM+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666705; c=relaxed/simple;
	bh=Tp758CgGMm4cWP+HIkXSDts0MLJu1BpDnLGJR7uitgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GELPiAp6oVPw9Hd/zVb2iZPNEP/5dR3vH+8IfP1G/m+G03X0AWQPafOKT6xotHInd4cmOs5Z/f7z6imTx7EnjK83iYRljGXUU/Ov7yse218X+6te4yJ1iswTNe5Ym1TSSYS1s0VTvCPccxnW9+TPHKQxc0HBVGfZ5+K7WWR7NtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOqXI48A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOqXI48A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4F51F000E9;
	Tue, 21 Jul 2026 20:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666704;
	bh=5TzeLkc8TXXTsBGIkUs0qiKDMt9uC8Jwx23AnGit690=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOqXI48AA1Tzsw0kWGUgjN5zmDxondevnM2LyqLlRlFBrGdQBaNeK2NcftFYt/mFR
	 cUSjWdNo2ICKp4RWlsLPSiix5hGkui7z6zPSCCs7UBhMkQzTeJXAmPc/fRl1gBxxfj
	 kJRJrYBCllKef6YaOIN7JWS9bO+uE0pbaNoGcDCY=
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
Subject: [PATCH 6.6 0741/1266] netfilter: ipset: Fix data race between add and dump in all hash types
Date: Tue, 21 Jul 2026 17:19:38 +0200
Message-ID: <20260721152458.454424826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 9da9420703216b..a41b50489e227e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -843,7 +843,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old = ERR_PTR(-ENOENT);
-	int i, j = -1, ret;
+	int i, j = -1, npos = 0, ret;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	bool deleted = false, forceadd = false, reuse = false;
 	u32 r, key, multi = 0, elements, maxelem;
@@ -888,6 +888,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
+	npos = n->pos;
 	for (i = 0; i < n->pos; i++) {
 		if (!test_bit(i, n->used)) {
 			/* Reuse first deleted entry */
@@ -961,7 +962,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 copy_elem:
-	j = n->pos++;
+	j = npos;
+	npos = n->pos + 1;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -984,6 +986,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	smp_mb__before_atomic();
+	n->pos = npos;
 	set_bit(j, n->used);
 	if (old != ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
-- 
2.53.0



