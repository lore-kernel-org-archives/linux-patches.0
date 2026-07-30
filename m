Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEB635BDAA;
	Thu, 30 Jul 2026 14:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422106; cv=none; b=sDGq9Dg15YAw0Oc8cp2Z770ndob/qZ6lMhVbODvo0oW1SqUEvTTFp1dyAFqT96reeaiRJkuNw1XMtP1fPS2K+AOlRspvnllXgMBFZCeoCY+YlXaf3kyEoq/v8mrx4/6rxQmUnwa3zk6dpxVng9MSnxcRhliKcYc1QAwnRZ6KYrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422106; c=relaxed/simple;
	bh=MB7+bUYdTUXB4rnl2gdTPPk2UZKs41brKZPOBsUKKGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwYIhPuRGZ93OSB9O3m9SNGS06a1kVVPv8LNHgISl43G7fEkng9CjTDqO/pSfobve0FONlFm0xRXLnAE4bZwnbuAuzm4sBPw/sA8iHOMt4M7dGDZtddW9GbTrOiUi8rvvQXDvGPVCxlNZiZ3fNSkSsLfN9PC8eOeBXs2MSRNOeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdFAN6tZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdFAN6tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF1F1F000E9;
	Thu, 30 Jul 2026 14:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422104;
	bh=jn1nNBKHCiia0M69YIVq4/koS4eVhQsFipcUxfv6AWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdFAN6tZCpD7qIjMQOr7FpT8jeQQ1ZA8xdMavff69MlJ3VZKX4rjyPopalgyMZuux
	 2BQ0ZnJp8nhd9l0R1bMfgqJkRtJuBgwg85QXNMxWbhTuq4XiIuIDvaxlcfnXCXYNst
	 +FsDKxOQhVc3r/IXdXDKCy66lDg4CDNX/sJRVvNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Doeraene <anthony.doeraene@uclouvain.be>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 327/744] mpls: Set rt->rt_nhn just before returning from mpls_nh_build_multi().
Date: Thu, 30 Jul 2026 16:10:00 +0200
Message-ID: <20260730141451.234782174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 3671f0419d90b98a02f313830595ab958c8b2025 ]

Commit f0914b8436c5 ("mpls: Hold dev refcnt for mpls_nh.") added
change_nexthops() loop to call netdev_put() for the nexthop devices
before freeing mpls_route.

Then, mpls_nh_build_multi() was also changed to avoid iterating
uninitialised nexthops in mpls_rt_free_rcu().

However, setting rt->rt_nhn to 0 at the entry of mpls_nh_build_multi()
makes the following change_nexthops() no-op.

Let's set rt->rt_nhn just before returning from mpls_nh_build_multi().

Fixes: f0914b8436c5 ("mpls: Hold dev refcnt for mpls_nh.")
Reported-by: Anthony Doeraene <anthony.doeraene@uclouvain.be>
Closes: https://lore.kernel.org/netdev/036a0c95-f5d4-46ab-88e7-1eab567d7a84@uclouvain.be/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260716170609.804629-1-kuniyu@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index b64a8b1bac0961..35069183f59c3e 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -922,8 +922,7 @@ static int mpls_nh_build_multi(struct mpls_route_config *cfg,
 	struct nlattr *nla_via, *nla_newdst;
 	int remaining = cfg->rc_mp_len;
 	int err = 0;
-
-	rt->rt_nhn = 0;
+	u8 nhs = 0;
 
 	change_nexthops(rt) {
 		int attrlen;
@@ -959,12 +958,15 @@ static int mpls_nh_build_multi(struct mpls_route_config *cfg,
 			rt->rt_nhn_alive--;
 
 		rtnh = rtnh_next(rtnh, &remaining);
-		rt->rt_nhn++;
+		nhs++;
 	} endfor_nexthops(rt);
 
+	rt->rt_nhn = nhs;
+
 	return 0;
 
 errout:
+	rt->rt_nhn = nhs;
 	return err;
 }
 
-- 
2.53.0



