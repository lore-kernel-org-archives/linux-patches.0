Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8821224B05;
	Tue, 21 Jul 2026 22:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673928; cv=none; b=IQAjdos6JhDnszTDuYzYTsuBUO/iVeQ/TuVpFjEOUyyZ+Mn+e5NetdOs6kGvUA8YZCiTyevPjOb/DZHPMuNGKfgOPSF0XYs/GIV2u6lOBq9egxIntWdWz3k/3FykhsAndoDdUUawShSymPob1O+xWAfpoE9otZLPBtOSsBnh8M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673928; c=relaxed/simple;
	bh=RKdc7GjPkkaTe3kfUMIZAYqBA07psQHEdcHzwtvcTTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO2BKb6DfG5ZHbmoSP5cd7a8CPZeyl1BeOOf5ToYgyLnkKLiPNpJwiHJiA+O4Zdz/M/vWc31t4woZ2LsxqxUvzQCdmOhoTyJooBPf06Awka5QXK/d9WO3TxHUGxHu+L68N0wkK+YRtJy3UCAv41Xdc5BcKKiOt/4hUap8kR/QI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBx4/dJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBx4/dJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9571F000E9;
	Tue, 21 Jul 2026 22:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673927;
	bh=H399XBvKqR5Hd1wJkhEWpqwSGPkoj2tLqs5xWrVJgUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBx4/dJyab5e8PD1pxAMmTLI2XDNVGOKDeHykL+JILBbKUV/QqKcgwvjEXUuOWtgC
	 2ZLJjU6arbZXoJkVJ6mMyKY6sTdInBDAJIwhgALyckeK18CdNbRShfLpf16oXTa03T
	 xa7VXPctMeQqEnP2LNY4BNh3NjoMyym4Qs1XpL54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/699] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Tue, 21 Jul 2026 17:21:46 +0200
Message-ID: <20260721152403.519577768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d66a6fb2e448b3..11e5536d8b2637 100644
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



