Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41244F5E18;
	Wed, 30 Sep 2026 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792904; cv=none; b=SdxJaJu+8ZIYnmro2D5CkIEwAMK0zgJGsWz1CppQ1KCGtP3qOgKDx2hHCvymOrPUiVYlhbbldJqDxRBwvtS4wSLYojTaeYI/xTL/59G5Mt04DGQSvfdRfOE6qbypxPeY/5sf3DaG01KGkb5usYMRZ3RfGWdBjSqaBMKvIr1vdJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792904; c=relaxed/simple;
	bh=CQzgYRY2/oJ94SnmzZCFnof21GhFmcGLeQoitRfoqv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JN9n6dAf61hd/FANffhMENwD8kEsfJA4eTU5RgBkXWENEOYoK6BNCtxryQOILUSAYvfDt2xm96oqmCutsdip/tm5tyZdD1E2xeFYpS/tlL58r4ilP9BhGzCrN41ffhMFkSehw09+NLLRP/D2aBxNNZtRLr7tzzlLNWuPddrud1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wwgxb+i+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wwgxb+i+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5781F000FF;
	Wed, 30 Sep 2026 18:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792902;
	bh=OugAyg8uMjs7QtywSoTz1xehOvmLxieudje0G92S0bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wwgxb+i+PVn3aHbvxVToqcDorS/+toa5m84B0sPCPd4ff1QtCJu20KVEmMu76F0/r
	 JEXnYiybHgAQJK/i4JEtQQD73+htbvXboN6sONUW/ObL5Ik7kzIOn7cM9/3/Byp5+d
	 IioR2EsRHZ57m6hwvxlshsalY3vDaSsZ+rCHSrA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/395] ipv4: fib: fix data-race and stale genid check around nh->nh_saddr
Date: Wed, 30 Sep 2026 17:25:27 +0200
Message-ID: <20260930152342.042654445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Linkui Xiao <xiaolinkui@kylinos.cn>

[ Upstream commit 46bc52d13594848023e681860df8700c8db14354 ]

fib_select_multipath() compares nexthop_nh->nh_saddr against the flow
source address with no lock held, while fib_info_update_nhc_saddr()
stores a new value from another CPU as soon as the preferred source
address of the egress device changes.

Commit 195374d89368 ("ipv4: fib: annotate races around nh->nh_saddr_genid
and nh->nh_saddr") added WRITE_ONCE() on the store side and READ_ONCE()
in fib_result_prefsrc() after syzbot reported

	BUG: KCSAN: data-race in fib_select_path / fib_select_path

but it only covered that reader. fib_select_multipath(), reached from
fib_select_path(), is a second lockless reader of nh->nh_saddr and was
left bare.

Moreover, nh_saddr is only meaningful when nh_saddr_genid matches
dev_addr_genid, as established by commit 436c3b66ec98 ("ipv4: Invalidate
nexthop cache nh_saddr more correctly."). fib_select_multipath()
skips that validation, so it can score a nexthop using a stale source
address and skew the ECMP selection.

Annotate both reads with READ_ONCE() and refresh the cached source
address via fib_info_update_nhc_saddr() when the genid does not match,
mirroring fib_result_prefsrc().

Fixes: 32607a332cfe ("ipv4: prefer multipath nexthop that matches source address")
Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260916125316.988044-1-xiaolinkui@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2aba8c0b9b2b5..5ab23a1fa45f6 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2181,6 +2181,15 @@ static bool fib_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
 
+static __be32 fib_nh_saddr(struct net *net, const struct fib_info *fi,
+			   struct fib_nh *nh, int genid)
+{
+	if (READ_ONCE(nh->nh_saddr_genid) == genid)
+		return READ_ONCE(nh->nh_saddr);
+
+	return fib_info_update_nhc_saddr(net, &nh->nh_common, fi->fib_scope);
+}
+
 void fib_select_multipath(struct fib_result *res, int hash,
 			  const struct flowi4 *fl4)
 {
@@ -2189,6 +2198,7 @@ void fib_select_multipath(struct fib_result *res, int hash,
 	bool use_neigh;
 	int score = -1;
 	__be32 saddr;
+	int genid;
 
 	if (unlikely(res->fi->nh)) {
 		nexthop_path_fib_result(res, hash);
@@ -2197,6 +2207,7 @@ void fib_select_multipath(struct fib_result *res, int hash,
 
 	use_neigh = READ_ONCE(net->ipv4.sysctl_fib_multipath_use_neigh);
 	saddr = fl4 ? fl4->saddr : 0;
+	genid = saddr ? atomic_read(&net->ipv4.dev_addr_genid) : 0;
 
 	change_nexthops(fi) {
 		int nh_upper_bound, nh_score = 0;
@@ -2209,7 +2220,7 @@ void fib_select_multipath(struct fib_result *res, int hash,
 		    (use_neigh && !fib_good_nh(nexthop_nh)))
 			continue;
 
-		if (saddr && nexthop_nh->nh_saddr == saddr)
+		if (saddr && fib_nh_saddr(net, fi, nexthop_nh, genid) == saddr)
 			nh_score += 2;
 		if (hash <= nh_upper_bound)
 			nh_score++;
-- 
2.53.0



