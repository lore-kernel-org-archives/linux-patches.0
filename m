Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2A363090;
	Tue, 13 Oct 2026 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894909; cv=none; b=GSWMLcStsrLQXzfCy+anPgh+VzO6qNmCRkdSjFH2QWS7Xi+czZKsuIpMDC7boRVEYkOKpgIAAOM6tkvOA0/5jsbyFse4qtYqLjZ43XdBoAO63Vxu/1jhertfXgsNla07J02CIHsbU8H4bkoGsjADYsf/ZksqmiQXQYk6FXLDxRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894909; c=relaxed/simple;
	bh=ZFF1e4zjk5/6mGtL/5fZieZXFCgttWvD3yXLacrwGRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ1nctyuK+lYCeZAMCYvuCSaTQOAVr0Ljgsat+X7TG+uPOKg++JFuY46niEfYQfEIdzO7aEV3YEBGF5q2a2ftRygt2/8JVd8recV2X8zh403To/osQGW+8pQYKm+Oa8iyOJjWKwZXQye8eF66llTs6luSq+A2yXb6cETHvol1oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaUJu7wS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaUJu7wS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EAA1F000FF;
	Tue, 13 Oct 2026 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894907;
	bh=pzJIF2xlDfIcxskeWgQymi4acefiaKzLSRO3cTIyjVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CaUJu7wS2mz0Qbxq0CBZSRRrdcvoufHqdVvi3RIJtaJ6iumrNNwJZl1uOY53ru6Gs
	 uF5k9ZYCzK1dIpUAhA3YGwNxct2ZdbLmFOLG7QMRwMKOf+QvYxl16pArDz3r091CL8
	 UgE+bfTag+dpjFffgkBdZ0T/Y2fHlMDfPCWBeb4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/497] netfilter: bpf: reject invalid NAT manipulation types
Date: Tue, 13 Oct 2026 13:34:25 +0200
Message-ID: <20261013112910.216178180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 481be15609b16..ed01633c9289d 100644
--- a/net/netfilter/nf_nat_bpf.c
+++ b/net/netfilter/nf_nat_bpf.c
@@ -39,6 +39,9 @@ __bpf_kfunc int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
 	if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
 		return -EINVAL;
 
+	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
+		return -EINVAL;
+
 	memset(&range, 0, sizeof(struct nf_nat_range2));
 	range.flags = NF_NAT_RANGE_MAP_IPS;
 	range.min_addr = *addr;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 041ab3733baa3..34e1ff930e28d 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -785,8 +785,9 @@ nf_nat_setup_info(struct nf_conn *ct,
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



