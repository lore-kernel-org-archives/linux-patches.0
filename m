Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4E9427A04;
	Tue, 21 Jul 2026 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656712; cv=none; b=bFBO2Rd6n0tkKcdwGN9GTfo8riRm8DYD/WFiRkaZnZC3O5S7aKdNhTVMMw90qA3dqotogfuBULlFFIl7yh27LCM/sKUEgmXnmlTGJbRRARchxKFHrAEgUs7dkTEK3Sj6fzThrw9qiS4G/AZRav9gCBOO7R+yKjCc5adzVc5gHO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656712; c=relaxed/simple;
	bh=PiRGAzj1Ttg04C0Jf25WncNfP8haOfMFxcju+MzcPW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvOGapy2aI5WC4QYdW4uFSE0MhCzfJ429H654DsXoyk28b64+cNestP+16i60KmV/3+IhS3jVeKh3JgCCfQO/vRxvoqQvIuj/okGwtOqwk/5KCMLbJOAZ7FbjxargLRK+8IJBq3laYVD2YG2OBZLTn2NCS5vnP8jFkM2qOprizQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOmz+ZCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOmz+ZCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3138D1F000E9;
	Tue, 21 Jul 2026 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656710;
	bh=a0mPhZpzjei+8PpmeWIebNjuhPNTGjB5YTWuyHWTIZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOmz+ZCOG2WYWCGdstsEA2FQzlOOmT9XwSDj1KwsVudoKbH0alPeTZJpRUF9tim3s
	 sLGL4axvQXn2m+vrY0l2woGMGSaZMdvIbPSjVHsnMa4NjjR6nG1wzkkjEF0O6J9lSY
	 WAP73Gsj0x7TeIiRef2Kycf/PPGcpcX2BgEJh5+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0490/1611] tipc: reject inverted service ranges from peer bindings
Date: Tue, 21 Jul 2026 17:10:06 +0200
Message-ID: <20260721152526.358548750@linuxfoundation.org>
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



