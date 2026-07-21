Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75FF356A12;
	Tue, 21 Jul 2026 20:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666597; cv=none; b=EWhGUXLD2wHOFs/QSuxb/fb5kH5WximSEs6aOy95jGlRNVSxT88WY0QfZN2bJ6Ic6XoovMjiBr0beLdetK30xX0Qk7UcOjnhaWX1Q2D3vXmgpGi1ie/IYV30oyfxRIw1qkY1bzaFxqR9mvfYvbDh6Sgr3yRD8fJQJRV9ArNCwhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666597; c=relaxed/simple;
	bh=hB0ofe5LGklVE0l3jnR/O1RCMtJrqDxceGKq3sJk/iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhfMWAuOUnIcHcLkIratkVXK83qeafYcbnPjpEoIBkSQ94RMea8aNXqow9eQ+ZurAmjuwgcfljouukS7hyxK7ghRrkBllcplVosWl+kwDefNnnp8dNTwZY6A4J9DHkPM9ExrLXUB41hsjpj2e1INQ0EvMCI3dNhtx1cRrBpRNcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBUfPwKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBUfPwKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D041F000E9;
	Tue, 21 Jul 2026 20:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666596;
	bh=prqFeqhAkz1qHIImVE2poMIbDct0qIsgkHxKifLy9To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBUfPwKsvyw9ZK8kcghiY/fSBEF5Pir9Q8ZSwZuCBavpVeFBakGTsM0YM5+defLdT
	 NIY16fKByr7umFM4rlHI+8AEorzAfWYxdjGE5/kqJ4M5OsgXKNYaQVuhFZ3jT5tvYh
	 YY0X4TcfF3D2BcVYkiG72UB9sU/CHBnKQczhLb3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0744/1266] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Tue, 21 Jul 2026 17:19:41 +0200
Message-ID: <20260721152458.520750343@linuxfoundation.org>
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
index 94157104d85a95..f51a1af31513cd 100644
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



