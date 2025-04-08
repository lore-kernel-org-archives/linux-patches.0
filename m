Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A426A1A8;
	Tue,  8 Apr 2025 11:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113599; cv=none; b=Osx5wQI5LMTDHJ1Xp2iZh3KIimVqy3nvI2hcKTJtKqj7LW2i8m0kE0e/kH3Nb7Q71WFHehVTpqWBZuTAtszSNm4hhJP1LFJv+6FjuanjYfWLQCTB/XGxsKM9mgcLP3kc9XOsD3FCXijCnZfz21Ej1DOee4DROZOdkv1lJMF3xhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113599; c=relaxed/simple;
	bh=eQkidr9Mrok5aSThNUpnfxeRWj/OHNzlwnL7YsAwPjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRNE9gdq9mCIe47gH2G/B8gx3qtPf+K7X3HqjLcJNx4WDCPDi8cLAN2DhG0v+1YnOM7dnBnIItVdD2Q5DVUYw7lACVg3TJtj6NVsVfSqKX2X+DaxxaZDzQicDf5V+/uGxQUKmhziVOInpFbyKVBaPyKgJBDg+cN4LBfEJOqCJYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ktygy+Q7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ktygy+Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ACDC4CEE5;
	Tue,  8 Apr 2025 11:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113598;
	bh=eQkidr9Mrok5aSThNUpnfxeRWj/OHNzlwnL7YsAwPjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ktygy+Q7SIPRitVjSdCQKenDAC/Ax9BZMnw5ERGW+aNIZomAv7iHq6jWZQJpUTxn/
	 SSOD5/CkSdpvJr/JA1O3ZM7mC4+CCtfPCveMmJ9sW8ZvXYbHUJTdtdtT4nSjSMOWx3
	 tnv2EE3Ljg2+50BRmwJ++KtR7RHh+ru4l9IPT9Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/268] ipv6: Do not consider link down nexthops in path selection
Date: Tue,  8 Apr 2025 12:50:30 +0200
Message-ID: <20250408104834.490586829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8b8e0dd357165e0258d9f9cdab5366720ed2f619 ]

Nexthops whose link is down are not supposed to be considered during
path selection when the "ignore_routes_with_linkdown" sysctl is set.
This is done by assigning them a negative region boundary.

However, when comparing the computed hash (unsigned) with the region
boundary (signed), the negative region boundary is treated as unsigned,
resulting in incorrect nexthop selection.

Fix by treating the computed hash as signed. Note that the computed hash
is always in range of [0, 2^31 - 1].

Fixes: 3d709f69a3e7 ("ipv6: Use hash-threshold instead of modulo-N")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250402114224.293392-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8f8a6970b9b7a..2e98531fa51a3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -444,6 +444,7 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 {
 	struct fib6_info *first, *match = res->f6i;
 	struct fib6_info *sibling;
+	int hash;
 
 	if (!match->nh && (!match->fib6_nsiblings || have_oif_match))
 		goto out;
@@ -470,7 +471,8 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 	if (!first)
 		goto out;
 
-	if (fl6->mp_hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound) &&
+	hash = fl6->mp_hash;
+	if (hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound) &&
 	    rt6_score_route(first->fib6_nh, first->fib6_flags, oif,
 			    strict) >= 0) {
 		match = first;
@@ -483,7 +485,7 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		int nh_upper_bound;
 
 		nh_upper_bound = atomic_read(&nh->fib_nh_upper_bound);
-		if (fl6->mp_hash > nh_upper_bound)
+		if (hash > nh_upper_bound)
 			continue;
 		if (rt6_score_route(nh, sibling->fib6_flags, oif, strict) < 0)
 			break;
-- 
2.39.5



