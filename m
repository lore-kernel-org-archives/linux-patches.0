Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EE4471268;
	Tue, 21 Jul 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657732; cv=none; b=GLdx6vDhQrXMzL+kTEffw/icp5HQ+1u1vNno388MaDDWoXUpmbsvL7Kmg3H0CJbzvJT2A8MuJxUhjMFvvDlyQOBvvnmhvqqF4fP3DidHPDgoot33IdOhArusstapw8VvRpRcsO2yh2+9jX3B6MSKfGdwrlMO4+LRQNOj6IGOOeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657732; c=relaxed/simple;
	bh=HJwkJNzumlF8ZpQoVXhQXRw4CzPjNQMTbXQX+VYnH+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCNXpxgDBdoDr1diJZyzjBAVI26c0keGHrQKbIpEaazjm7PO6ac+rhiOupdD31cYfONmkcJdTfTAY4w4MIrpAMoZ1cZDFGR4I3yYLGZWuBdwh5OQ3QD61e0+ky0zrO3IHZMBzf6JThSpAGvbdVFvycNKxDCYP6VOKWzAgOO0G/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmllEEI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmllEEI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8527B1F000E9;
	Tue, 21 Jul 2026 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657731;
	bh=CwEWwassGlBqikXn8oT2Dha3tFofNSkqQwZkU1staeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmllEEI7Db9DcIFtIIVr6xZlyZ7GDA5DwQXS8AW98BSS052aW9K9b5ADHu+GudTto
	 fcPpr7KicsXSHd7yRBok83ZnqU48sQqAJshOCN8blMmLZmWQ0mL017foUpJktLRnWc
	 V16pa7YqPcRvU0+e1lYwLT3jWqBzeaNW/V1vkI44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0839/1611] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Tue, 21 Jul 2026 17:15:55 +0200
Message-ID: <20260721152534.259711502@linuxfoundation.org>
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



