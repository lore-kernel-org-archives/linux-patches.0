Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C397374E60;
	Sat, 17 Oct 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257756; cv=none; b=MAlcReZs5fkN9U8H+2DHdTsTKIXnnGdrre2kp/L4jCCcfKIv8UtHCoDrF5OYzshQrbz3qDtNGxUkjGHetpHiVSqz9kCfTYRHaksrBzWDTLsNjIxMq/Q9xZiyCIu+pbwFRfcT3Jlb0uUk4/6xFtTQDIB9ORcgSXKr2BqpHXHaIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257756; c=relaxed/simple;
	bh=ooC4PMAhpQFR5apQ19nk7yTRvk5Vhj+vvcc5j7whsaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbkGa4bBWYYPl8bf1OE3hR19quq2XAduOcY4wcr8A0uimYKcUkLpMvQdkJaXswo+bWuAg9wpsqAUyICxSI6OGmfg3qVIqZG9xQQr5lLAG9aF1xoNEkDI38HTxTiUfu0lWkEkw9dtSyQTg/8enaSxouP0TyIBUMrXfRjd7vjU7co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b13Ma9ux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b13Ma9ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697491F000C4;
	Sat, 17 Oct 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257755;
	bh=rGithO/+4ooZup/j0E5s1cpKETJp/Cq21lQM7v7mzKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b13Ma9uxchmQj4EBa+1Uyl8ssuGJS7bnkSXel8BPdBjHXPSdoPCY+QHw5KT5vFm8L
	 zhXyxXbmI3crJVo2fboPoWgOpT/m5fmvuhNa6V113p1NFoRQe4UKMewdU5s7UQPVYl
	 4rEucE8Om+vjaPxteXfpYyos7D+iDjVcatFwadVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0618/1674] net: nexthop: Increase weight to u16
Date: Sat, 17 Oct 2026 17:48:10 +0200
Message-ID: <20261017160446.940994138@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit b72a6a7ab9573e06d5c2fcb92eaa28614a735bfd ]

In CLOS networks, as link failures occur at various points in the network,
ECMP weights of the involved nodes are adjusted to compensate. With high
fan-out of the involved nodes, and overall high number of nodes,
a (non-)ECMP weight ratio that we would like to configure does not fit into
8 bits. Instead of, say, 255:254, we might like to configure something like
1000:999. For these deployments, the 8-bit weight may not be enough.

To that end, in this patch increase the next hop weight from u8 to u16.

Increasing the width of an integral type can be tricky, because while the
code still compiles, the types may not check out anymore, and numerical
errors come up. To prevent this, the conversion was done in two steps.
First the type was changed from u8 to a single-member structure, which
invalidated all uses of the field. This allowed going through them one by
one and audit for type correctness. Then the structure was replaced with a
vanilla u16 again. This should ensure that no place was missed.

The UAPI for configuring nexthop group members is that an attribute
NHA_GROUP carries an array of struct nexthop_grp entries:

	struct nexthop_grp {
		__u32	id;	  /* nexthop id - must exist */
		__u8	weight;   /* weight of this nexthop */
		__u8	resvd1;
		__u16	resvd2;
	};

The field resvd1 is currently validated and required to be zero. We can
lift this requirement and carry high-order bits of the weight in the
reserved field:

	struct nexthop_grp {
		__u32	id;	  /* nexthop id - must exist */
		__u8	weight;   /* weight of this nexthop */
		__u8	weight_high;
		__u16	resvd2;
	};

Keeping the fields split this way was chosen in case an existing userspace
makes assumptions about the width of the weight field, and to sidestep any
endianness issues.

The weight field is currently encoded as the weight value minus one,
because weight of 0 is invalid. This same trick is impossible for the new
weight_high field, because zero must mean actual zero. With this in place:

- Old userspace is guaranteed to carry weight_high of 0, therefore
  configuring 8-bit weights as appropriate. When dumping nexthops with
  16-bit weight, it would only show the lower 8 bits. But configuring such
  nexthops implies existence of userspace aware of the extension in the
  first place.

- New userspace talking to an old kernel will work as long as it only
  attempts to configure 8-bit weights, where the high-order bits are zero.
  Old kernel will bounce attempts at configuring >8-bit weights.

Renaming reserved fields as they are allocated for some purpose is commonly
done in Linux. Whoever touches a reserved field is doing so at their own
risk. nexthop_grp::resvd1 in particular is currently used by at least
strace, however they carry an own copy of UAPI headers, and the conversion
should be trivial. A helper is provided for decoding the weight out of the
two fields. Forcing a conversion seems preferable to bending backwards and
introducing anonymous unions or whatever.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/483e2fcf4beb0d9135d62e7d27b46fa2685479d4.1723036486.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nexthop.h        |  4 ++--
 include/uapi/linux/nexthop.h |  7 ++++++-
 net/ipv4/nexthop.c           | 37 ++++++++++++++++++++++--------------
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index f7d4239347351..f37e96f93f20b 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -97,7 +97,7 @@ struct nh_res_table {
 
 struct nh_grp_entry {
 	struct nexthop	*nh;
-	u8		weight;
+	u16		weight;
 
 	union {
 		struct {
@@ -180,7 +180,7 @@ struct nh_notifier_single_info {
 };
 
 struct nh_notifier_grp_entry_info {
-	u8 weight;
+	u16 weight;
 	struct nh_notifier_single_info nh;
 };
 
diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
index d8ffa8c9ca784..6b0de563beec1 100644
--- a/include/uapi/linux/nexthop.h
+++ b/include/uapi/linux/nexthop.h
@@ -16,10 +16,15 @@ struct nhmsg {
 struct nexthop_grp {
 	__u32	id;	  /* nexthop id - must exist */
 	__u8	weight;   /* weight of this nexthop */
-	__u8	resvd1;
+	__u8	weight_high;	/* high order bits of weight */
 	__u16	resvd2;
 };
 
+static inline __u16 nexthop_grp_weight(const struct nexthop_grp *entry)
+{
+	return ((entry->weight_high << 8) | entry->weight) + 1;
+}
+
 enum {
 	NEXTHOP_GRP_TYPE_MPATH,  /* hash-threshold nexthop group
 				  * default type if not specified
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 67f98a136a6d8..dbb12e9d0b48f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -660,6 +660,7 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 	size_t len = nhg->num_nh * sizeof(*p);
 	struct nlattr *nla;
 	u16 group_type = 0;
+	u16 weight;
 	int i;
 
 	if (nhg->hash_threshold)
@@ -676,9 +677,12 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 
 	p = nla_data(nla);
 	for (i = 0; i < nhg->num_nh; ++i) {
+		weight = nhg->nh_entries[i].weight - 1;
+
 		*p++ = (struct nexthop_grp) {
 			.id = nhg->nh_entries[i].nh->id,
-			.weight = nhg->nh_entries[i].weight - 1,
+			.weight = weight,
+			.weight_high = weight >> 8,
 		};
 	}
 
@@ -1062,11 +1066,14 @@ static int nh_check_attr_group(struct net *net,
 
 	nhg = nla_data(tb[NHA_GROUP]);
 	for (i = 0; i < len; ++i) {
-		if (nhg[i].resvd1 || nhg[i].resvd2) {
-			NL_SET_ERR_MSG(extack, "Reserved fields in nexthop_grp must be 0");
+		if (nhg[i].resvd2) {
+			NL_SET_ERR_MSG(extack, "Reserved field in nexthop_grp must be 0");
 			return -EINVAL;
 		}
-		if (nhg[i].weight > 254) {
+		if (nexthop_grp_weight(&nhg[i]) == 0) {
+			/* 0xffff got passed in, representing weight of 0x10000,
+			 * which is too heavy.
+			 */
 			NL_SET_ERR_MSG(extack, "Invalid value for weight");
 			return -EINVAL;
 		}
@@ -1655,9 +1662,9 @@ static void nh_res_table_cancel_upkeep(struct nh_res_table *res_table)
 static void nh_res_group_rebalance(struct nh_group *nhg,
 				   struct nh_res_table *res_table)
 {
-	int prev_upper_bound = 0;
-	int total = 0;
-	int w = 0;
+	u16 prev_upper_bound = 0;
+	u32 total = 0;
+	u32 w = 0;
 	int i;
 
 	INIT_LIST_HEAD(&res_table->uw_nh_entries);
@@ -1667,11 +1674,12 @@ static void nh_res_group_rebalance(struct nh_group *nhg,
 
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
-		int upper_bound;
+		u16 upper_bound;
+		u64 btw;
 
 		w += nhge->weight;
-		upper_bound = DIV_ROUND_CLOSEST(res_table->num_nh_buckets * w,
-						total);
+		btw = ((u64)res_table->num_nh_buckets) * w;
+		upper_bound = DIV_ROUND_CLOSEST_ULL(btw, total);
 		nhge->res.wants_buckets = upper_bound - prev_upper_bound;
 		prev_upper_bound = upper_bound;
 
@@ -1737,8 +1745,8 @@ static void replace_nexthop_grp_res(struct nh_group *oldg,
 
 static void nh_hthr_group_rebalance(struct nh_group *nhg)
 {
-	int total = 0;
-	int w = 0;
+	u32 total = 0;
+	u32 w = 0;
 	int i;
 
 	for (i = 0; i < nhg->num_nh; ++i)
@@ -1746,7 +1754,7 @@ static void nh_hthr_group_rebalance(struct nh_group *nhg)
 
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
-		int upper_bound;
+		u32 upper_bound;
 
 		w += nhge->weight;
 		upper_bound = DIV_ROUND_CLOSEST_ULL((u64)w << 31, total) - 1;
@@ -2492,7 +2500,8 @@ static struct nexthop *nexthop_create_group(struct net *net,
 			nhg->has_v4 = true;
 
 		nhg->nh_entries[i].nh = nhe;
-		nhg->nh_entries[i].weight = entry[i].weight + 1;
+		nhg->nh_entries[i].weight = nexthop_grp_weight(&entry[i]);
+
 		list_add(&nhg->nh_entries[i].nh_list, &nhe->grp_list);
 		nhg->nh_entries[i].nh_parent = nh;
 	}
-- 
2.53.0



