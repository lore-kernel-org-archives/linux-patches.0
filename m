Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBBD4E0B7C;
	Thu, 17 Sep 2026 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668887; cv=none; b=MHVYKMfDCvz5oTBoTd6Zue+cMjfcLEXVK+EMPG4seBri2pKdPP4s6LWt3ClgqJb6wqQycofJ6GJaOEMDDnii786NDPCufZBqglVnaBaRNyvJa7qFypnpN2/aurFXU52KkCcv45DI1c3jr8x50xfgsbKwrp300sYKZc6PN6DMtZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668887; c=relaxed/simple;
	bh=C1gHOUvzkVwiY50mfAqmDcXIIa4/q3GOexNfSXPFnEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aayh1AEvzOspY7dXvnfNwB/PPxh24UDgptswG5uYGHkuGfuSBI+M1zBOn81883SFy/9+LFZ1ZvbCVsZUUQAhdzzs+l132/9WVc9VbTzGIJgnVOSHl31gFLPygQ0pqbzbbNU7R8P2rI1zECnsEWiZvt7uAu63yD+zdJ4BGQ7nI9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6Jg7MGF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6Jg7MGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8633B1F000FF;
	Thu, 17 Sep 2026 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668886;
	bh=8BzTOtk7zwSxuHR85+8yI3hclUnEAbTMFrJTmkaj+yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6Jg7MGFOq4RcPbvax1zqiT0aLkLUY0vnA5/9dSv2oyRr4BOBPZAM24LpkvCSpBKK
	 SvGCwyJdgH6p7VOyyYo2AHG868JtmLAJ5lZrHr8TOsUdT6Sy1aBh1p1E+Jz4ZOcAA7
	 BgTGSgaFeEGxq41lQV1EVy12lI+yTfJEPPlWEKq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0573/1102] ipv6: mcast: fix RCU list diversion in ip6_mc_del1_src()
Date: Thu, 17 Sep 2026 16:08:36 +0100
Message-ID: <20260917151554.311881798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 92f321635e4ec..c060954c52757 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2331,14 +2331,18 @@ static int ip6_mc_del1_src(struct ifmcaddr6 *pmc, int sfmode,
 
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



