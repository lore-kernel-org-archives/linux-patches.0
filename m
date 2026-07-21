Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A793B42CB;
	Tue, 21 Jul 2026 22:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672048; cv=none; b=KqL0+pUVg6VrPSllrIC5BogbaacUgEgEFLe946XA8Sc3Kd9sfnLrhKBDX0WvSSdIknwTFOK7R4Ytnv+aoGh2TJt50rvR+rQaOmtnVLcnpVsXa1t7zZru34506u+uZ6L6lDZyVna2TflpSsHDVJ+pzQGZuJbpvgYm7IO4WE+uaRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672048; c=relaxed/simple;
	bh=V9VCNn/rx5iKea3CwUAmIii6IhYR7Te9QhXazQM4A30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syW7klSFU0+30Zer8DR4AICHNv9fe6KdtBQTk8517L18NC45N57Htacsn8zMMh6jEPIBqc1e5oTOjB14VBf+ImA9iPlsQZ2MWi7ByqIIk4KFL5PYs6ZBRfq7lSAIZA0qwn1cpc1CdRrEtYcgkFs6W6ez9YedH1WAN3CeFle0lW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZQamBKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZQamBKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D171F000E9;
	Tue, 21 Jul 2026 22:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672047;
	bh=fzLv7PteF9/N/OGWGlkiTiHLY7yZ8W9IFmzDMLX3W1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZQamBKJrGaCxMrJ7OUpuTSQLqJz1C53+TW+nmBwPFff2MvuX4zswtVd49fXF3HtC
	 trk3imnNuZIMPdG5L7Exep6CuSIdM7TuXNTnmeH1rabXaWlE512Ms/8CIxd8rVpm5Z
	 Y6klxV8ehrstiFpXS2zkOprTSc0JrLNonlQCp0Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/843] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Tue, 21 Jul 2026 17:21:25 +0200
Message-ID: <20260721152416.152926078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 3ca9982a8882470aa0ac4e8bb9a552b181d1efcd ]

Sashiko pointed out that kfree_rcu() was called before
rcu_assign_pointer() in handling the comment extension.
Fix the order so that rcu_assign_pointer() called first.

Fixes: b57b2d1fa53f ("netfilter: ipset: Prepare the ipset core to use RCU at set level")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index b5cb9ef6b2a284..34d5c973c4ee03 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -351,8 +351,8 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 
 	if (unlikely(c)) {
 		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-		kfree_rcu(c, rcu);
 		rcu_assign_pointer(comment->c, NULL);
+		kfree_rcu(c, rcu);
 	}
 	if (!len)
 		return;
@@ -393,8 +393,8 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	if (unlikely(!c))
 		return;
 	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-	kfree_rcu(c, rcu);
 	rcu_assign_pointer(comment->c, NULL);
+	kfree_rcu(c, rcu);
 }
 
 typedef void (*destroyer)(struct ip_set *, void *);
-- 
2.53.0



