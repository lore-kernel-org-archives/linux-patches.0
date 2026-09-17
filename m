Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324B7081A;
	Thu, 17 Sep 2026 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668872; cv=none; b=Kaig7R00kk+F25Jkm8ug/tSO/Hi+vDQsGCgNSE1PyOf9wEKM+Y4MwHXNFnFzn1BM5C7PbtPVK/UcQ4lQck1u6ncDvfd1cs3DIzUYC/QijdUWGFf9H+xorrf2YoCoPKQ+JjHVzYIWPUj1yFtF3gpaL1g+J17q3Pd5/yoVL8YEQhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668872; c=relaxed/simple;
	bh=zDKygK/IZvElakxa9QybhoNGWYalCy68t5yVAfq368M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/PXHAfzGX5cRnCVqruAIeEf5l+TOBBiTi1PD3L7wY7CtwyzvNxMxmH68JLAxz48ZPZmdD3yijKSiascL3PIw3+X/N1NQ6/5tmmvmx6gGugueL4tLwQsMqFV5ovlj6uizopdxxuCcWbOwbVwp4aITSEfOyz2eRggXoeQYOGV1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9ivVz/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9ivVz/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18451F000FF;
	Thu, 17 Sep 2026 18:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668871;
	bh=lGJOB1RABz7jP69hx/oNIi5UCtJuAiJHXZp1AyqwIQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9ivVz/Wv2QRSlTtkU6ASP8PfcJQNeIMEyz44gVKqnLXC7Q1t8TLrYJkeLnv6/3vr
	 ztE66eqF/Mn7B+zQD9taEARJgpsCOgruNDYhXUg8twSa8QFO3C0MsJrTdUZnA0FS9a
	 aWJtlels3LW5XYD/oIAGptTFyjwM6XJH/k3RYTCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0569/1102] net/sched: cls_u32: fix duplicate handle when node ID pool is exhausted
Date: Thu, 17 Sep 2026 16:08:32 +0100
Message-ID: <20260917151554.197070896@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit d7e7e98d23f42a92d9ab7e36302bd96bd9b33b5f ]

gen_new_kid() falls back to returning max (htid | 0xFFF) when both
idr_alloc_u32() ranges are full, instead of reporting an error.
u32_change() trusts that value and inserts a new knode with a handle
that is already live in the hash table, breaking handle uniqueness
within the table's node ID space.

The handle was never reserved in ht->handle_idr, so every later error
path that does idr_remove(&ht->handle_idr, handle) removes the
reservation of a different, live knode, which is then reused — one
failed add compounds into further duplicates.

The 4095 limit is per (table, bucket) — ht->handle_idr is per hash
table and the range is derived from htid (bucketid), so a table with
divisor 256 can legitimately hold 256*4095 knodes.

The sibling helper gen_new_htid() has the same silent in-band failure:
it returns 0 when the tp_c handle pool (1..0x7FF) is full, and
u32_init() publishes the root hash table with handle 0 without
checking.  Two root tables with handle 0 alias in u32_lookup_ht(),
allowing cross-tcf_proto knode add/lookup/delete.  Add the same
exhaustion check that the divisor path already has.

Return an error so u32_change() fails with ENOSPC/ENOMEM when the
node ID space is exhausted, and so u32_init() fails with -ENOMEM
when the hash table ID space is exhausted.  The extack message
distinguishes pool exhaustion (-ENOSPC) from a transient allocation
failure (-ENOMEM).

Conditions to recreate the bug:
- CONFIG_NET_SCHED=y, CONFIG_CLS_U32=y (or =m with module loaded)
- Create a clsact qdisc on a device, then add 4095 u32 filters with
  auto-generated handles to fill the node ID space for the root hash
  table (single bucket). The 4096th auto-handle filter add triggers
  the duplicate handle (fh 800::fff reused). Reachable at Level 2
  (unshare -Urn, namespace-local CAP_NET_ADMIN).
- For gen_new_htid: create 2047 u32 proto entries on the same block
  to fill the tp_c handle pool, then create one more. The root table
  gets handle 0 and aliases with other handle-0 root tables.

Fixes: 7801db8aec95 ("net_sched: avoid generating same handle for u32 filters")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260825081052.133898-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index a90de52e1ac8d..83a60698cc009 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -370,6 +370,10 @@ static int u32_init(struct tcf_proto *tp)
 
 	refcount_set(&root_ht->refcnt, 1);
 	root_ht->handle = tp_c ? gen_new_htid(tp_c, root_ht) : id2handle(0);
+	if (root_ht->handle == 0) {
+		kfree(root_ht);
+		return -ENOMEM;
+	}
 	root_ht->prio = tp->prio;
 	root_ht->is_root = true;
 	idr_init(&root_ht->handle_idr);
@@ -695,21 +699,33 @@ static int u32_delete(struct tcf_proto *tp, void *arg, bool *last,
 	return ret;
 }
 
-static u32 gen_new_kid(struct tc_u_hnode *ht, u32 htid)
+static u32 gen_new_kid(struct tc_u_hnode *ht, u32 htid, int *err)
 {
 	u32 index = htid | 0x800;
 	u32 max = htid | 0xFFF;
 
+	*err = 0;
+
 	if (idr_alloc_u32(&ht->handle_idr, NULL, &index, max, GFP_KERNEL)) {
 		index = htid + 1;
-		if (idr_alloc_u32(&ht->handle_idr, NULL, &index, max,
-				 GFP_KERNEL))
-			index = max;
+		*err = idr_alloc_u32(&ht->handle_idr, NULL, &index, max,
+				     GFP_KERNEL);
+		if (*err)
+			return 0;
 	}
 
 	return index;
 }
 
+static int u32_kid_extack(int err, struct netlink_ext_ack *extack)
+{
+	if (err == -ENOSPC)
+		NL_SET_ERR_MSG_MOD(extack, "Hash table node ID pool exhausted");
+	else
+		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate node ID");
+	return err;
+}
+
 static const struct nla_policy u32_policy[TCA_U32_MAX + 1] = {
 	[TCA_U32_CLASSID]	= { .type = NLA_U32 },
 	[TCA_U32_HASH]		= { .type = NLA_U32 },
@@ -1076,7 +1092,9 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		 * handle which is used to uniquely identify the match entry.
 		 */
 		if (!TC_U32_NODE(handle)) {
-			handle = gen_new_kid(ht, htid);
+			handle = gen_new_kid(ht, htid, &err);
+			if (err)
+				return u32_kid_extack(err, extack);
 		} else {
 			handle = htid | TC_U32_NODE(handle);
 			err = idr_alloc_u32(&ht->handle_idr, NULL, &handle,
@@ -1088,7 +1106,9 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		/* The user did not give us a handle; lets just generate one
 		 * from the table's pool of nodeids.
 		 */
-		handle = gen_new_kid(ht, htid);
+		handle = gen_new_kid(ht, htid, &err);
+		if (err)
+			return u32_kid_extack(err, extack);
 	}
 
 	if (tb[TCA_U32_SEL] == NULL) {
-- 
2.53.0



