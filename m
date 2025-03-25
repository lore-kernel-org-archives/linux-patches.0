Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A808D264F94;
	Tue, 25 Mar 2025 12:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905530; cv=none; b=pLJTXksjSmx6LeMZwdiyDcINB4QJT7eTC99bOC1uADKqrtxuq8UucJvkSmXmTdCE6DILwIeZB3U9P8jJEENn5PLXJVIhcaRJ2ugbfwzx1qI+ldJdVb04vBD8/+kVb27DyTeUNVoQY0Uj5tNy6NdQI6zO3X15RPhO85u1tObo60Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905530; c=relaxed/simple;
	bh=Q47xbCZeo2paoEnjm0S47VBOuelJ6NQuMnoi+YSqakE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de1koeURannB9jblF7+/3kiByWu8UdkNIaK+nsXtAL7SnGMr9QSaIO3kVKDn+Sj3L0Jx66o8vccgFVBYlnMdUNS5tUG3l8APPpVgBphcZ3hQahAUTaHpHPqUSF/ubONN/RSrzsS4zxqL0bRPIdVd3YxM47nzGW7vdN9Xx8CyBH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G57O7GWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G57O7GWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E50C4CEED;
	Tue, 25 Mar 2025 12:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905530;
	bh=Q47xbCZeo2paoEnjm0S47VBOuelJ6NQuMnoi+YSqakE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G57O7GWP76vkY7Q8jz5t7ZnHxUMcib7Ni7iYao8iOP8c7I90cTtIELGBxRzOEcB/2
	 PCmHt1wbxd5ORfFUMbJGhgMiod/m3UgQkaBBQ4/xXho2VheXLhJtVyjfdD/2Ow/IPH
	 v/Cjp1G/aersDiYXRzoE+FfpjCl/Sl34MXIHv8ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/198] netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.
Date: Tue, 25 Mar 2025 08:19:29 -0400
Message-ID: <20250325122156.832173771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6157f8b4a3cea..3641043ca8cc5 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -240,6 +240,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	u16 value = nft_reg_load16(&regs->data[priv->sreg]);
 	struct nf_conn *ct;
+	int oldcnt;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) /* already tracked */
@@ -260,10 +261,11 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
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



