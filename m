Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45CC3AEF54;
	Thu, 17 Sep 2026 17:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665379; cv=none; b=mFavhRU3C2pjGOiIZuaYryGZn3tQWMF6qI69yDxGXRkrZvHekGLMa0W1wTMyMC4g7446Znlo2piiEzHApgooDfQmxbwJOSo2RDvOTpmh9qYjM0tmBw4IUFkaAI9OJsgo89LWWDjx7JiyGn2DqIdsCgQC7MHqdGjhx61xu2K1IPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665379; c=relaxed/simple;
	bh=T0rynIhZBFQkiOdtNmRa1GDZJXm+D2ASnDStx4Bewdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/XdSi2RXa020QTTeo2Oq2TutedCLo5zfFl95d6zc5b76cfFQEm4qi8USD/0XEMzeL9OGfCbr6mgwo+w62wxtXErgaeSPRmX8OrO5j/z98WkaiVBRxIN7BqzmeinCakfT87CNWui6nbyBTevn4dARB06Do9gIG3t4gegepnX/gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UP5cRjeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UP5cRjeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442531F000FF;
	Thu, 17 Sep 2026 17:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665377;
	bh=yWxrqQHNUpksUi4csZYVCJ4ay7OqjbPTsPxDKQTA0JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UP5cRjeFN+SSQL7BY4iYZccXjHvbg5vnWC7ZhsEi6dgo6OpLwfwf5M1oYFVmlFwZY
	 cVTBeVEJqcPqHUwcHOHA/58m+aqIBqZHbHsI3Cj7C/L6nYG9Tv1nZHvZCP1JtEMuWL
	 2Z4lxWIabyKy9qIem8Dahmg8tXRzRLGneyF4L7m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0684/1250] ipv6: mcast: fix RCU list diversion in ip6_mc_del1_src()
Date: Thu, 17 Sep 2026 16:07:59 +0100
Message-ID: <20260917151610.426704845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index c63f97c79c49b..fabf7ff977acd 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2350,14 +2350,18 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 
 		if (psf->sf_oldin && !(pmc->mca_flags & MAF_NOREPORT) &&
 		    !mld_in_v1_mode(idev)) {
-			psf->sf_crcount = idev->mc_qrv;
-			rcu_assign_pointer(psf->sf_next,
-					   mc_dereference(pmc->mca_tomb, idev));
-			rcu_assign_pointer(pmc->mca_tomb, psf);
-			rv = 1;
-		} else {
-			kfree_rcu(psf, rcu);
+			struct ip6_sf_list *dpsf = kmalloc_obj(*dpsf);
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



