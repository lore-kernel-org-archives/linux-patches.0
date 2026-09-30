Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D6F51C048;
	Wed, 30 Sep 2026 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788369; cv=none; b=r7Acy4HXfNtREYUyiPg1mhJUE4E+J+IPaIsKsuhREOEWWqcc2PsA3bdZeOzd4vYmJVgaBhprvsdPLwNJQ0gzhFEm5LAe6jMlFRtxos9jGiRV2wgv+gwS6cy7voCmIqqGX1QHF8iVpjLInUlWn7PVPD50k5jbNg48NHwxP5dIOA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788369; c=relaxed/simple;
	bh=t1HDh8r9IDPNVjYi05UFak7MqKThVi5vLxjWCeiVKps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge+yGLDzdO5m1V34xBnIx4bihk214kC+KMeQcgTG/ASeExsqZVz6jRsjOMQFFdiJSVHRdP3eNqKQoLWVO+70b6/E25PNGjC4qmMrRsXZW7NCGJwReSOV8TnqX/485JO9rgIc1ysecMgygo34AlpAqb3/gRI1pPMQyKPfj9omlL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+Uisq/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+Uisq/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C541F000FF;
	Wed, 30 Sep 2026 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788368;
	bh=286zYi3WTIr0zrnldEzokTH0CRpkuApiSABT5frmmD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+Uisq/nOby3SLuwG6byGlU4etZ8Q/oaCBYLtYPi0n8QD6pEF+374txAjgjF1F06/
	 VUfv92Wn64sp4df+J6emEPnyHbOlSHwTF4JrQKDXREouN0M5QYMyy9qcqdB+k7Ak0a
	 l1WPc2LWh56Glk8f+E0soi1kJuJo2ce/tcM2DsBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/877] neighbour: Add missing RCU annotation for neightbl_dump_info().
Date: Wed, 30 Sep 2026 17:16:50 +0200
Message-ID: <20260930152416.873706986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 764dcebb033764633700a036c7351a7c6350eec6 ]

neightbl_dump_info() fetches the first non-default neigh_parms
with list_next_entry(&tbl->parms, ...) and iterates through the
list with list_for_each_entry_from_rcu().

However, list_next_entry() does not use RCU helper.

Let's use list_for_each_entry_rcu() and skip the default parms.

Fixes: 4ae34be50064 ("neighbour: Convert RTM_GETNEIGHTBL to RCU.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260909233143.2401847-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index d38c309e7fa61..c9d848085dad3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2539,11 +2539,14 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 			break;
 
 		nidx = 0;
-		p = list_next_entry(&tbl->parms, list);
-		list_for_each_entry_from_rcu(p, &tbl->parms_list, list) {
+
+		list_for_each_entry_rcu(p, &tbl->parms_list, list) {
 			if (!net_eq(neigh_parms_net(p), net))
 				continue;
 
+			if (!p->dev)
+				continue;
+
 			if (nidx < neigh_skip)
 				goto next;
 
-- 
2.53.0



