Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682573B388C;
	Tue, 21 Jul 2026 20:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666128; cv=none; b=CiJKXE8kJzSkF6zxobh46o9B9vxQT0YfErASnnspDDFJc2ZVPfkUgD8tcjbUWEw8wlHiD3wLt5GDuxuMnZg+X9eHIfwQ/hMi4ZU4ZSHsd7wz02cxHCJ+pNvnZzKbh7rfgp/o+Zlr9vte7BOxeWOz6e8vohTEolHCGwG5fYPOGH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666128; c=relaxed/simple;
	bh=HppViT+Ga97mjFAiDQsEO+ittaSgCQ2F+rm3slempIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdjlpcA3UfCDjMmrjJaqwjCZ7//uNmy4NqVoHNSGFUyyW+AhUhju6oeuZb2iaPxjxQEcH6z+3vKy5DvB3iW+58X7C8l0NziE8czMoJUSE/tYhS2ZFsh4NbmlWEoEsE48cYe4RnLp2zqFyxNEjvuIAFj8U/zWYYg6mqOfv96LrPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuFhKGtP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuFhKGtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6AD1F000E9;
	Tue, 21 Jul 2026 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666127;
	bh=dRNZ7FiftiBJaQfPInj8KgNZCVuA7blccu0Jq749mh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuFhKGtPD6OMl5s5NB2p1tNyo1hYKUUxmHwUEwidVt0Bxdmmzi7VD7skuPDBjQMNE
	 +576Pfa2329h1kezSj7G3MrpcptVQ2FV30kGkIxfqO7FHbx23ICOpUZZP0VyyQ/QnZ
	 liuQObqZA59L50/d+wMtN4Lu+7eV4/I5bTMrKBUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0566/1266] tipc: reject inverted service ranges from peer bindings
Date: Tue, 21 Jul 2026 17:16:43 +0200
Message-ID: <20260721152454.531543645@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 2afb648f7b99216c687db1f89739c995e1144153 ]

tipc_update_nametbl() inserts a binding advertised by a peer node using
the lower and upper service-range bounds taken directly from the wire,
without checking that lower <= upper. The local bind path validates the
ordering (tipc_uaddr_valid()), but the name-distribution path does not.

A binding with lower > upper is inserted at the far end of the
service-range rbtree (keyed on lower) where no lookup or withdrawal can
ever match it (service_range_foreach_match() requires sr->lower <= end).
The publication, its service_range node and the augmented rbtree entry
are then leaked for the lifetime of the namespace, and there is no
per-peer cap equivalent to TIPC_MAX_PUBL on locally created bindings.

Reject inverted ranges in the network path as well. A peer node can
otherwise leak unbounded binding-table memory by sending PUBLICATION
items with lower > upper.

Fixes: 37922ea4a310 ("tipc: permit overlapping service ranges in name table")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260610124003.3831170-4-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/name_distr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 190b49c5cbc3ec..ba4f4906e13b70 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -280,12 +280,21 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 				u32 node, u32 dtype)
 {
 	struct publication *p = NULL;
+	u32 lower = ntohl(i->lower);
+	u32 upper = ntohl(i->upper);
 	struct tipc_socket_addr sk;
-	struct tipc_uaddr ua;
 	u32 key = ntohl(i->key);
+	struct tipc_uaddr ua;
+
+	/* A peer-advertised binding with lower > upper can never be matched
+	 * or withdrawn and would leak the publication; the local bind path
+	 * rejects such ranges, so reject ranges learned from the network too.
+	 */
+	if (lower > upper)
+		return false;
 
 	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_CLUSTER_SCOPE,
-		   ntohl(i->type), ntohl(i->lower), ntohl(i->upper));
+		   ntohl(i->type), lower, upper);
 	sk.ref = ntohl(i->port);
 	sk.node = node;
 
-- 
2.53.0



