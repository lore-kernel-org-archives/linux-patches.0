Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320AE3E2777;
	Wed, 30 Sep 2026 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796540; cv=none; b=hU7xlXH0YV+1LZVYeHmAhCXgXT6MeJb+6+FANxIUC7FTMro4RRWAXFvleKzMrwo8q1lDut7NY6W9QulqTF2N0eE/5khzKuFk5S9TuRomTYf7HsRvWxhA1jGETzTxgc6VPZ+nRC7LtC3z4DYuUWlh09LENp74jI0u6bs+yPlr2yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796540; c=relaxed/simple;
	bh=4MqyCiVnHeroGcoZ85M/jdZETZyo3lUY+Rhgyba/UuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfHVQyk9MaPdMcrPYMwPrWCszvGf/Iz1VBIwa74lBOUFb+5Lf1iam6EhE5trouJvzNv5gnYEkCy0b5AGtIEM6+pVt0/LbZwt3tyI4smuUHuJlNbryMu4HJQdb2ZAhUWpvKpopOjDort1BlvZRMi5Z6fA50gFjjbX9tBwuh+qZ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sedXQDnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sedXQDnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8508F1F000FF;
	Wed, 30 Sep 2026 19:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796539;
	bh=w7Ob4oLL8RQ6Uk3SrU4AJDBvCsPPaUy8KaoK8fPPpyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sedXQDnCS7/yUrVWAb4PXoYAL7a9BeLlgWaNyuKWjOjzFCOIcOmN8+oYdTxXFkNN9
	 00C2hDLplpr7YW6yyDgjJusl6zTNCabNwQqy28wTsbrs6KJ93+vUD9CmnQ5fLXMgBk
	 +7WCcdKzahwHK8zuv5iO420ibH2rAOtuT7v0JqXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0947/1193] ipv6: mcast: fix RCU list diversion in ip6_mc_del1_src()
Date: Wed, 30 Sep 2026 17:27:11 +0200
Message-ID: <20260930152455.280003441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 93b49239840b91313adbd77b8b52993eff2d08c1 ]

When removing a source filter whose count reaches zero, ip6_mc_del1_src()
unlinks psf from pmc->mca_sources. If the filter was previously active,
the code moved psf directly into pmc->mca_tomb by updating psf->sf_next.

Because pmc->mca_sources is traversed locklessly under RCU (e.g. by
ipv6_chk_mcast_addr()), mutating psf->sf_next before a grace period
elapses diverts concurrent readers to the tombstone list. Consequently,
readers miss remaining active sources in pmc->mca_sources and improperly
examine deleted tombstone entries.

Fix this by allocating a new tombstone node for pmc->mca_tomb (as done
in sf_setstate()) and retiring the original psf via kfree_rcu().

Fixes: 4b200e398953 ("mld: convert ip6_sf_list to RCU")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828084531.1826790-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 30c8af655db1b..9d8908c7cfa74 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2367,14 +2367,18 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 
 		if (psf->sf_oldin && !(pmc->mca_flags & MAF_NOREPORT) &&
 		    !mld_in_v1_mode(idev)) {
-			psf->sf_crcount = idev->mc_qrv;
-			rcu_assign_pointer(psf->sf_next,
-					   mc_dereference(pmc->mca_tomb, idev));
-			rcu_assign_pointer(pmc->mca_tomb, psf);
-			rv = 1;
-		} else {
-			kfree_rcu(psf, rcu);
+			struct ip6_sf_list *dpsf = kmalloc(sizeof(*dpsf), GFP_KERNEL);
+
+			if (dpsf) {
+				*dpsf = *psf;
+				dpsf->sf_crcount = idev->mc_qrv;
+				rcu_assign_pointer(dpsf->sf_next,
+						   mc_dereference(pmc->mca_tomb, idev));
+				rcu_assign_pointer(pmc->mca_tomb, dpsf);
+				rv = 1;
+			}
 		}
+		kfree_rcu(psf, rcu);
 	}
 	return rv;
 }
-- 
2.53.0



