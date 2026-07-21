Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354503C1400;
	Tue, 21 Jul 2026 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674209; cv=none; b=XmoTSKuBXzVXgiBgGkE0Uhoal/sMso02npcJaxHGi8A2trq9sOjoiOThRLOtgC+tPNirpol0FParkk4CDowfbEOwO5JtPHZieeLt/hon1DviM2AnWFbVCgoyghyPxl2O8KJXGhIj8bPQxBU/cksHo7gF955TRlmXjZ2C4a35fks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674209; c=relaxed/simple;
	bh=z4u5CD4I3BOI0d688jNL5OEbNHNkSp49M+YEIJKoAxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfhtSTJi1iHRmsjjWKdodPHYr0GA8vzSuevVnzJwMiGd/LvY5q7JhxfbX80J+hG4thwOf/K8u2TKpQGPSGwVlKS483q2icU39u3t/8t91b0mlOlce862Mk7uGZd8fs0dIsXD7J72FQsfJtswxPmVDf6J4o620G+S937i/POcx+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Df/JvmO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Df/JvmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4080C1F000E9;
	Tue, 21 Jul 2026 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674207;
	bh=BHSCxim/pF4li/2zPgINB600Af8L0kyhQNvLrt8fRIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Df/JvmOW5Fc7OYaXdGgd8Lw7KnkwYhuZhuwthoTC3aDrEs3VNCSy5MI0L7SjuzvZ
	 yTQ+7ya+tZRw0Jh1mhsABxMqzz41gHO5bAuJzXFVuXfatu3peJrtrrsr152ib9hoNP
	 wA28rjHa7tTZT3+GF97WPcVMglpW9otQnK/D5X3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Taehee Yoo <ap420073@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 411/699] mld: get rid of inet6_dev->mc_lock
Date: Tue, 21 Jul 2026 17:22:50 +0200
Message-ID: <20260721152404.963233604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit cf2ce339b401bc53ee131f0ce38bae32a949925e ]

The purpose of mc_lock is to protect inet6_dev->mc_tomb.
But mc_tomb is already protected by RTNL and all functions,
which manipulate mc_tomb are called under RTNL.
So, mc_lock is not needed.
Furthermore, it is spinlock so the critical section is atomic.
In order to reduce atomic context, it should be removed.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9b26518b6896 ("ipv6: mcast: Fix potential UAF in MLD delayed work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/if_inet6.h | 1 -
 net/ipv6/mcast.c       | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 0d2788bc65d28a..6ae15539d09d9b 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -171,7 +171,6 @@ struct inet6_dev {
 
 	struct ifmcaddr6	*mc_list;
 	struct ifmcaddr6	*mc_tomb;
-	spinlock_t		mc_lock;
 
 	unsigned char		mc_qrv;		/* Query Robustness Variable */
 	unsigned char		mc_gq_running;
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 023ff680ee6044..f5e01bfdfc46a9 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -752,10 +752,8 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	}
 	spin_unlock_bh(&im->mca_lock);
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc->next = idev->mc_tomb;
 	idev->mc_tomb = pmc;
-	spin_unlock_bh(&idev->mc_lock);
 }
 
 static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
@@ -764,7 +762,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	struct ip6_sf_list *psf;
 	struct in6_addr *pmca = &im->mca_addr;
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc_prev = NULL;
 	for (pmc = idev->mc_tomb; pmc; pmc = pmc->next) {
 		if (ipv6_addr_equal(&pmc->mca_addr, pmca))
@@ -777,7 +774,6 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		else
 			idev->mc_tomb = pmc->next;
 	}
-	spin_unlock_bh(&idev->mc_lock);
 
 	spin_lock_bh(&im->mca_lock);
 	if (pmc) {
@@ -801,10 +797,8 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 {
 	struct ifmcaddr6 *pmc, *nextpmc;
 
-	spin_lock_bh(&idev->mc_lock);
 	pmc = idev->mc_tomb;
 	idev->mc_tomb = NULL;
-	spin_unlock_bh(&idev->mc_lock);
 
 	for (; pmc; pmc = nextpmc) {
 		nextpmc = pmc->next;
@@ -1904,7 +1898,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 	int type, dtype;
 
 	read_lock_bh(&idev->lock);
-	spin_lock(&idev->mc_lock);
 
 	/* deleted MCA's */
 	pmc_prev = NULL;
@@ -1938,7 +1931,6 @@ static void mld_send_cr(struct inet6_dev *idev)
 		} else
 			pmc_prev = pmc;
 	}
-	spin_unlock(&idev->mc_lock);
 
 	/* change recs */
 	for (pmc = idev->mc_list; pmc; pmc = pmc->next) {
@@ -2579,7 +2571,6 @@ void ipv6_mc_up(struct inet6_dev *idev)
 void ipv6_mc_init_dev(struct inet6_dev *idev)
 {
 	write_lock_bh(&idev->lock);
-	spin_lock_init(&idev->mc_lock);
 	idev->mc_gq_running = 0;
 	INIT_DELAYED_WORK(&idev->mc_gq_work, mld_gq_work);
 	idev->mc_tomb = NULL;
-- 
2.53.0



