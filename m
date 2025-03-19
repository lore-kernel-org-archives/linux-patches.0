Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815FF2139D4;
	Wed, 19 Mar 2025 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395027; cv=none; b=hmzyblX0Bc09bpGCF45NuYnP2FCS0vjS8zHOBf/W5g0xKF+VuEufLq6+AiXMXD5TOoPCi9dzgEfXDNuVHOmLoLriqBmV4F9UgFpU4j8Muvj5ZqqiQg3MWrMI93y27KAEIZfiuKNgRFmr8fZ8/c5CqxBvawxf9GH7rvmdtufNmQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395027; c=relaxed/simple;
	bh=ApLEVyDPL7+hEU3Re5i358a4aa68JTGT8bs+x8ruuhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7ws0mxlOKqj4qiIZkOCHZ3jmboXIP/9/2boUmfQiCw7C7aWykLXwMkIehSDOVsvea2915rQC7i9qB/bDID1v6OFqTDJ10uBb9UOS7Z0LEqF18jSlB+cEjTA1+YCZhY8+42JIZBmIA6VxLrZr/ITLCQlnbfm21+Nxsv3Yb7mBck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1G+rKdEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1G+rKdEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F5BC4CEE8;
	Wed, 19 Mar 2025 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395027;
	bh=ApLEVyDPL7+hEU3Re5i358a4aa68JTGT8bs+x8ruuhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1G+rKdEwg3TVC9oHM24w8Rmdrf3/Ne2SHn9IdSbcAV9W/pi9daH5jRVlCtPHUJ2wI
	 UQqmOpxUtkk56FHI3z6ccYg/WHyEdN1HTIKi2eWpkHgvDTvmS/zWDvt3BRBIKz0NVc
	 8IZKXnFZ6/yh7y4BhSg+En/36jYmuM4VrS3iuPlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/231] netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.
Date: Wed, 19 Mar 2025 07:28:20 -0700
Message-ID: <20250319143027.046292513@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5cfe5612ca9590db69b9be29dc83041dbf001108 ]

nft_ct_pcpu_template is a per-CPU variable and relies on disabled BH for its
locking. The refcounter is read and if its value is set to one then the
refcounter is incremented and variable is used - otherwise it is already
in use and left untouched.

Without per-CPU locking in local_bh_disable() on PREEMPT_RT the
read-then-increment operation is not atomic and therefore racy.

This can be avoided by using unconditionally __refcount_inc() which will
increment counter and return the old value as an atomic operation.
In case the returned counter is not one, the variable is in use and we
need to decrement counter. Otherwise we can use it.

Use __refcount_inc() instead of read and a conditional increment.

Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 67a41cd2baaff..a1b373b99f7b8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -230,6 +230,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	u16 value = nft_reg_load16(&regs->data[priv->sreg]);
 	struct nf_conn *ct;
+	int oldcnt;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) /* already tracked */
@@ -250,10 +251,11 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
-		refcount_inc(&ct->ct_general.use);
+	__refcount_inc(&ct->ct_general.use, &oldcnt);
+	if (likely(oldcnt == 1)) {
 		nf_ct_zone_add(ct, &zone);
 	} else {
+		refcount_dec(&ct->ct_general.use);
 		/* previous skb got queued to userspace, allocate temporary
 		 * one until percpu template can be reused.
 		 */
-- 
2.39.5



