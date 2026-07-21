Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9545546F484;
	Tue, 21 Jul 2026 19:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660893; cv=none; b=VqJBpHGfylIyCAdVy7khUkgYDl7AAUUyUFvtdrRM5IIEz9ayAbfsLSmhcVNFfQewZqwrqiGw50TmCesCBFEqsfeJkPmiEgFVzZJpc+obvwQCiKBp/5W/ByV7BAvKoZXiDedJt4Y9EhOoWmVO/65hZ2D954KaLalRAK2gPTUHtkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660893; c=relaxed/simple;
	bh=lRSuBDIm3XstC8Rq2yggBApRaXqS1WFoHij8atPZKs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrDuh9ASI1s6YR17aqwWn/sCtHvUilCTOEquWg7TEY/Jy0GAF0xdBTobsnRE0aOvdzUvOMHhcjednxz9YIXwgZLM+CjYJjGD4l0MZNQXb5c7jRamH59R1+9yZ3ludX3lfSXRNUC4jQRLzEcbqWrCGAhpTsHp9/SazzpGZUtjv+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zm2cjpPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zm2cjpPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63A81F00A3A;
	Tue, 21 Jul 2026 19:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660888;
	bh=kw7L/4lMJfpzQ2HqpRPoZAi9hVM6Pb/SvBLbC+rBX0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zm2cjpPEUbuHFBWCuVP9kjZzQcX6CnNvopDzTtdb+SphlPjHzb5pXSHgsqN4Nso95
	 nNISCXZyIjLO42Z6zSakDSuLriaJ8i3XJvtKsq84RgaoQwRd+AwFrUkOwv0D2cZbjd
	 KJaFmxSaSjOwdK4r5v18/OlvHyXpvl5s0VogQ1R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1148/2077] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Tue, 21 Jul 2026 17:13:41 +0200
Message-ID: <20260721152619.899183796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 955556513eeb61..6cfad152d7d1ba 100644
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



