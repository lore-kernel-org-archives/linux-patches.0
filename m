Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADF91C4A13;
	Wed, 19 Mar 2025 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394843; cv=none; b=HKRF+ZiBVeC5FCh0+EkG7Dc2zsGWHsXOLKy+jEEuVhPJpm0+SSdFvGBXp02WTfkHSyr7qnOL0NU109yaXWP9aKf4UM/3vP81sbhzvtcyk/RjzaARv4dKmzam5vLXQMFygwnFIfg6jinkvLXOrsBDCA5j12nz7mnCi0LIW7EhqYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394843; c=relaxed/simple;
	bh=rdEAHFCdntq4UA3nMP8pq9W05BosX+9s+GzpZzfvg4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LygYLv0VMZhd0h8SuNsvXLO0RaA73u59u6CsCHrPbgTLsroCEqClh6DiIiVSK3eGoPqPM33xDwXO2rkCL0a22zcvBUSQogKODiTWhno9L6AEgqC9D3gMz6Fv9GdXSLKfBY+lKctnG8tsXnA7ZrZUmEgg1pK7zpSF61CLgE1fMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TOAzWlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TOAzWlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F35AC4CEE4;
	Wed, 19 Mar 2025 14:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394843;
	bh=rdEAHFCdntq4UA3nMP8pq9W05BosX+9s+GzpZzfvg4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TOAzWlJijDR84KXwPMuxhZ9ru7+Gc56vvitZDjNuT0DHW4BEJTHDzqNhy+kV5kbq
	 vZR2hkhhqFDc8nk6N0OmlG5fg9b+oM2B6VK8KcL3bZab3bsPkMnDmUX64YjUaa4qnh
	 WkAejJKlP3uSf35eu7PvqxWpyVGwosXAaRHdWoUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 008/241] netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.
Date: Wed, 19 Mar 2025 07:27:58 -0700
Message-ID: <20250319143027.902023886@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



