Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550D4CF49B;
	Sat, 17 Oct 2026 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256395; cv=none; b=GwJIODZVHlisSCNbji7I6tpdONF8HQssfgGQfL0wHmh4v/vQ2USJdJHs9HrKVAS7o+xyzGIZBdnLooHJ5BYk3pVSyNEtl3cEFyq3D20pZYz7ko1DIfPxphMuBESWQ/Jc/90bNeDn9bid8foU4PFlTycvcV87Y/k3Yudjx/Vq5Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256395; c=relaxed/simple;
	bh=YYUBTps0TYIkBG5TGH96jcmeff6/I6O4on1WNBUJKBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhvjuQC7q6scXrNehXnOf8T9S8cV1w53GIJ/WvKdlpcTqHPKFa5uoJLE0y6Jo4up4TkCLHznOlYdnEwaR0TgmIlIlsl2/+EfM0JUj31wz/5ZnuUwZzWd9A06ZpxUrQa1G6a95L85B5Bsixs8JneZYmN0RxcxNNDMZmooe0WLMKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bizsTnDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bizsTnDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE90D1F000C4;
	Sat, 17 Oct 2026 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256394;
	bh=S8uP4eMQJZjRza2+3bCVJuhs2ejoNoBBYMwBc0v4jks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bizsTnDfiVc0PvBdzhMMqN+RVe2t+dCOVAAxcf4WuqaTf7yapp/WM2oJLxya2jQf4
	 7qcv5nJ9TUlh+2Bm1HpkXG/BwEeBQ88VP+vtyLrNSwI7a0A6mNHpPAWFoW4PminMK2
	 UJFKVPMQ47f8GL2djdiEzrICJiKCHDx0UEr0OgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0223/1674] netfilter: bpf: reject invalid NAT manipulation types
Date: Sat, 17 Oct 2026 17:41:35 +0200
Message-ID: <20261017160436.870006399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 16d464013ec2267b00a83f4bfbb97b3ecc63bfa7 ]

As bpf_ct_set_nat_info() is not validating the NAT manipulation type a
wrong value can be passed directly to nf_nat_setup_info(). This triggers
the WARN_ON() at nf_nat_setup_info() and if panic_on_warn isn't set,
then IPS_SRC_NAT_DONE is set without adding nat_bysource and conntrack
cleanup tries to unlink an uninitialized hlist node.

Fix this by checking that NAT manipulation type is correct before
calling nf_nat_setup_info(). In addition, if the WARN_ON is hit, return
NF_DROP instead of continuing with the processing to avoid similar
situations in the future.

Reported-by: VEGA <vega@nebusec.ai>
Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_bpf.c  | 3 +++
 net/netfilter/nf_nat_core.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
index 141ee7783223d..2fd62678e7752 100644
--- a/net/netfilter/nf_nat_bpf.c
+++ b/net/netfilter/nf_nat_bpf.c
@@ -41,6 +41,9 @@ __bpf_kfunc int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
 	if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
 		return -EINVAL;
 
+	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
+		return -EINVAL;
+
 	memset(&range, 0, sizeof(struct nf_nat_range2));
 	range.flags = NF_NAT_RANGE_MAP_IPS;
 	range.min_addr = *addr;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d29767646ffa5..2fc334a442f6c 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -794,8 +794,9 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		return NF_ACCEPT;
 
-	WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
-		maniptype != NF_NAT_MANIP_DST);
+	if (WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
+		    maniptype != NF_NAT_MANIP_DST))
+		return NF_DROP;
 
 	if (WARN_ON(nf_nat_initialized(ct, maniptype)))
 		return NF_DROP;
-- 
2.53.0



