Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E523C1081;
	Tue, 21 Jul 2026 22:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671707; cv=none; b=TdhSs11V2dClE3NO4vWRy5XYaWLv6FtE4lYA69jPpDfQjGV5SGf90sMeLYRWxkfsWhtb3JX7H3R0LGrkAQ/27v3wwRLZXHRGzTp2fyALtV0h/LHM/7Uv0WdvzMMDdhSN3vIcDa6KnRNqMxnfb5YFlmSz2YhiMCSW41o66pQo77E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671707; c=relaxed/simple;
	bh=b4LH4Td3+8OerxnVAnXEV85G2Kv708QliX+oLVhgYP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkFR4CpjI/nhK4Gc8/oaVJmY96byjld2hmdTe1v+MY5QB2VE/ZlFdKkdAoidpyhklq3+bqkprZQU32a+D3ZL0fH1YgoMGyt0gbvVbCgC1D7QNQPAyXzNJz7DABEEDq7k2D32S81RAbEsmxLuH5OrRlopp2tH1FkY1b/GqK7NwvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0csEQvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0csEQvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A7D1F000E9;
	Tue, 21 Jul 2026 22:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671706;
	bh=3U0sTZPmkLu0NfPAW+ydLOt3sAJCb9/OCAdfdnMRgCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0csEQvvzeP2KT4ollAbi3K/zNwQqxI57JPOVeZ4GGQEExkrhWjzXStGbr7d+RaEX
	 qf8kfzqoyF6TWF9XZl3uFTqEUKQbx5WaMnnUnftk8nSubNebqp1Cx7v5V59VQUi4ES
	 OBJ51XG+c6ATHRLNHki5huuc2DyvWND6Ms/LucE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/843] tipc: reject inverted service ranges from peer bindings
Date: Tue, 21 Jul 2026 17:19:42 +0200
Message-ID: <20260721152413.837061350@linuxfoundation.org>
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
index 8267b751a526a4..c575dc78ef061c 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -288,12 +288,21 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
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



