Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D4537F00C;
	Thu, 20 Aug 2026 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247239; cv=none; b=iafdWu8oLkvtw5byO5kyoLOCGluPjSaP2oNQchYjkkIBxLyNnPZaG8EsyWDisxbA2DW33EhZoUsLZ/9PJBRkoF2e77S5fA9Un/hXH8ehUIYWrYmO3SvQ+SIxMjI1DG6LYcplZ9/la5wNBFK7GtqCtZfdOG1hNbQOMVpr6VZF/RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247239; c=relaxed/simple;
	bh=jvqoxAGMxaJ9eMrESw3jkGldZPnA/h17ltrRAQXo01k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWurP89XXO5GdxZPWwN5NjVKe0LNljBlvJlBz67Y4pMDgly/zqhVTQ/46qimVk7QqP6ip0l2ljmM5JKP1ZoMvqUtIi4NND47k4HSvB/5OobMO7vWuB3zRUfJm+W+fJrr/UzkHOE2hxD8NmwHPZoYURZ3Au3gtPJWJ4z6Awt00Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9oVtFgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9oVtFgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2C21F000E9;
	Thu, 20 Aug 2026 17:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247238;
	bh=jW5LUTpaCnUi5BN340+ZhqyoSmvLPBqdRKS5JD+RQTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9oVtFgcRBvZlAr7l55QxqjE5VNJz1zH5qOeQ3RZ1EjFd01mAPORTirU0YGcEO43g
	 ggQtUUIXOifOuGgPvP+tMbjclP6pRPCjJq1+F+6KiMQcq2FjrfJdDGxSJj6wHQcL4t
	 QDlmLMWvgNyMeqifxKWXyoKTEAWoEgaa/aWbNjKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/220] netfilter: ipset: fix list type element drift bug
Date: Thu, 20 Aug 2026 16:56:28 +0200
Message-ID: <20260820145229.463019614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4cbd69766b35a089664cadb1f613bb85f7ef77a9 ]

If list_set_uadd() calls list_set_replace() to swap an expired entry,
the element count remains the same, therefore the increment must be elided.

Fixes: 702b71e7c666 ("netfilter: ipset: Add element count to all set types header")
Link: https://sashiko.dev/#/patchset/20260806101947.2802-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 9d6ab69ca1a37..e417ab37b69c7 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -301,9 +301,12 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	e->set = set;
 	INIT_LIST_HEAD(&e->list);
 	list_set_init_extensions(set, ext, e);
-	if (n)
+	if (n) {
 		list_set_replace(set, e, n);
-	else if (next)
+		return 0;
+	}
+
+	if (next)
 		list_add_tail_rcu(&e->list, &next->list);
 	else if (prev)
 		list_add_rcu(&e->list, &prev->list);
-- 
2.53.0



