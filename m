Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BD42F619D;
	Thu, 15 Jan 2026 17:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497659; cv=none; b=AtZdtxPB/iD41d4fXWLTAXBzzDeoF5j+WrvhSu+aBOwvG1HqGl8mxYIAA2W04jCo7Rjt13voL3h04mAcPZK1SOyJT4K0ajpJCuARoL5KwinBAVZXwl4ZEoOUaURXx37E4G/TR5tuvYC7wTF8G0CDv/viUK6DquQztTlZoiYsEqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497659; c=relaxed/simple;
	bh=6kk479/nM7nGxBQVpc8rFEz8xZRSMPn18HwkkDwNCKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClPv/CfT0PvBnZIhNHjLLmjS5k9fBbuMf3vYMdQz3vIWaijSsxg2tHM0+N7iqM+je5K+KS8CN4XWpmjLaG9Z7LMmUH/eujglPmJK5zjW4ZKBcEMiokpkBTy9FMUq9IJiDvtd8Jl2oXUaeWg4SyC4qaiTnEppfqkFSYaptx0uxT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDSm/xiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDSm/xiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D6CC116D0;
	Thu, 15 Jan 2026 17:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497659;
	bh=6kk479/nM7nGxBQVpc8rFEz8xZRSMPn18HwkkDwNCKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDSm/xiI2/Oe9W3j5XCBJIdKjOEewRH1x6d2EO7Z55TWKIdDyNElx2DguOcgUa4Mu
	 uixy2h07NgPhE7XZzV8tS9YheSX9sjK6bOwjdV+iX4Eq7DUwEfWT06hBK2qo6X+neP
	 Zco6BQVZU8RDa6vETzEHZTICex7x2t9s2/oEAE+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Tu <u9012063@gmail.com>,
	Greg Rose <gvrose8192@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Yifeng Sun <pkusunyifeng@gmail.com>
Subject: [PATCH 5.15 158/554] netfilter: nf_conncount: reduce unnecessary GC
Date: Thu, 15 Jan 2026 17:43:44 +0100
Message-ID: <20260115164251.985532817@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Tu <u9012063@gmail.com>

[ Upstream commit d265929930e2ffafc744c0ae05fb70acd53be1ee ]

Currently nf_conncount can trigger garbage collection (GC)
at multiple places. Each GC process takes a spin_lock_bh
to traverse the nf_conncount_list. We found that when testing
port scanning use two parallel nmap, because the number of
connection increase fast, the nf_conncount_count and its
subsequent call to __nf_conncount_add take too much time,
causing several CPU lockup. This happens when user set the
conntrack limit to +20,000, because the larger the limit,
the longer the list that GC has to traverse.

The patch mitigate the performance issue by avoiding unnecessary
GC with a timestamp. Whenever nf_conncount has done a GC,
a timestamp is updated, and beforce the next time GC is
triggered, we make sure it's more than a jiffies.
By doin this we can greatly reduce the CPU cycles and
avoid the softirq lockup.

To reproduce it in OVS,
$ ovs-appctl dpctl/ct-set-limits zone=1,limit=20000
$ ovs-appctl dpctl/ct-get-limits

At another machine, runs two nmap
$ nmap -p1- <IP>
$ nmap -p1- <IP>

Signed-off-by: William Tu <u9012063@gmail.com>
Co-authored-by: Yifeng Sun <pkusunyifeng@gmail.com>
Reported-by: Greg Rose <gvrose8192@gmail.com>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was skipped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_count.h |  1 +
 net/netfilter/nf_conncount.c               | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 9645b47fa7e41..e227d997fc716 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -10,6 +10,7 @@ struct nf_conncount_data;
 
 struct nf_conncount_list {
 	spinlock_t list_lock;
+	u32 last_gc;		/* jiffies at most recent gc */
 	struct list_head head;	/* connections with the same filtering key */
 	unsigned int count;	/* length of list */
 };
diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index a66a27fe7f458..ee808b018e4e1 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -132,6 +132,9 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 
+	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
+		goto add_new_node;
+
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		if (collect > CONNCOUNT_GC_MAX_NODES)
@@ -177,6 +180,7 @@ static int __nf_conncount_add(struct net *net,
 		nf_ct_put(found_ct);
 	}
 
+add_new_node:
 	if (WARN_ON_ONCE(list->count > INT_MAX))
 		return -EOVERFLOW;
 
@@ -190,6 +194,7 @@ static int __nf_conncount_add(struct net *net,
 	conn->jiffies32 = (u32)jiffies;
 	list_add_tail(&conn->node, &list->head);
 	list->count++;
+	list->last_gc = (u32)jiffies;
 	return 0;
 }
 
@@ -214,6 +219,7 @@ void nf_conncount_list_init(struct nf_conncount_list *list)
 	spin_lock_init(&list->list_lock);
 	INIT_LIST_HEAD(&list->head);
 	list->count = 0;
+	list->last_gc = (u32)jiffies;
 }
 EXPORT_SYMBOL_GPL(nf_conncount_list_init);
 
@@ -227,6 +233,10 @@ bool nf_conncount_gc_list(struct net *net,
 	unsigned int collected = 0;
 	bool ret = false;
 
+	/* don't bother if we just did GC */
+	if (time_is_after_eq_jiffies((unsigned long)READ_ONCE(list->last_gc)))
+		return false;
+
 	/* don't bother if other cpu is already doing GC */
 	if (!spin_trylock(&list->list_lock))
 		return false;
@@ -258,6 +268,7 @@ bool nf_conncount_gc_list(struct net *net,
 
 	if (!list->count)
 		ret = true;
+	list->last_gc = (u32)jiffies;
 	spin_unlock(&list->list_lock);
 
 	return ret;
-- 
2.51.0



