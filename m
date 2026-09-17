Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0CE3A6B66;
	Thu, 17 Sep 2026 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659094; cv=none; b=mKyrm6SoPyW1zUDqhHxRJBD5KGbzndox41FJDjCRpgSh0NKA5fO92pO/8rKlzBh2/4zQrvAaZZClIjN/YaYbO7MtUHiTXlNXBGU598bpvMH10f5FKNwfItX6jgciJ3WNXRjKfbZ2YAtSQ5ObpV5PFXomXaUcEtoln4JDz2wSEa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659094; c=relaxed/simple;
	bh=kRjzSKlPzGcWtz2S+9yHuJdfq2RZP6pUaro/5mcR1s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzgZSC6T6SIK5dvj2lCZG7AvOwVgDRMn7l/LaValWh9VGpRGznW8D5QxJmjDdSAkXvJj9A065vwx9ZLiRIS6n6FFbq6Y0KLWkUHXLy7FCevVZPagBjWCd1OFNRUXPFPUzy+jAMQ9UGAztnIOYgV4P2Ajc+tJa40zMhHj/GIlI+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQofM1KF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQofM1KF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6FB1F000FF;
	Thu, 17 Sep 2026 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659090;
	bh=Ll/9doTKkJd59A4KRTQQAVv0fp4mmjifi9GCY2NtwkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQofM1KFwq1zjlUVadqRrjeDnhFasJrvWSI7IwNlLP/YQBG2eirMzUpbSoA9fSv1L
	 IR0cs46WxGeIpxD62Hu02u2Xj7ibxhGkcidsHXflNijkszddY5lEY5ZwAj8a1qhVFv
	 IuRj6f0rY7SIL6xCW3z2Vrty8LrJDVn05b4fshwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 140/733] ipv6: mcast: fix RCU list diversion in ip6_mc_del1_src()
Date: Thu, 17 Sep 2026 16:07:28 +0100
Message-ID: <20260917151354.523613086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4d2b9377ba2de..54acc9d4cae03 100644
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



