Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E73235358;
	Sat, 12 Sep 2026 07:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199381; cv=none; b=S//7vU0bJFv/RWan2Lm4uErCF8W1t0W3DUVR7clXKdMLo1SQYgoudISByMoNX2LMBXH4KFczR0zb1u2ci2xjP9LuzynlDYbnfWHSmc7YScu0HAFF+4EhIVax4mE1zsA5cx1/k4lnUJLQpksy4CQ8JGyWGtY2ettGJt0qNtYIqL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199381; c=relaxed/simple;
	bh=V5XsthY/Ypx+u8Mivt6OhW0az92jgNQQfX+sy28+ey8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmcV6OjeGn+sdt6EXzMQt3qzwNHkifDclamLqEgzzq4twUKYvmVY3Ow6Ytp72EWeEXI93tedr9ZVCV4pwADSvY0ETrLPipUuszr6JW1HsMGQsgS9Z1eT8NqSPPOTFR801W10g0/dmPVYSmw82JCVQguEECEPX6VgDObKIqXSWao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHU42BYW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHU42BYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2A81F000FF;
	Sat, 12 Sep 2026 07:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199380;
	bh=EMpXDCuooaRi+NXzg//GH6atcMVrmoukPxGOWLSh5pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHU42BYWuYqDrVlvdRoshKHfRFVc8A5Eqr6wNjMlV6QIc097UgIgcgnyTtjlBl3sc
	 2a4OsCf5HQvJvEFCe2koeweqP3wwK95A9rMIoBsKooWUcUdfNQHdAr1EewMoc63SLA
	 O6k/nXiHHTQuUuc8GS7xxiBZtxJjszQFGn/MmXts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0573/1815] bpf: Preserve unique-field state across nested structs
Date: Sat, 12 Sep 2026 08:38:43 +0200
Message-ID: <20260912065702.333886808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit f08619f060468076e4acbdc10e0713af20d60e65 ]

btf_find_struct_field() initializes a fresh seen mask for every recursive
descent. Unique special fields in different levels of the same aggregate
therefore do not see one another. The duplicate fields can reach
btf_parse_fields(), where they trigger an invariant WARN_ON_ONCE(). A
crafted user BTF can consequently trigger the warning before map creation
checks capabilities.

Initialize the seen mask once in btf_find_field() and pass the same pointer
through struct, datasec, and nested-struct walks. This gives the entire field
traversal one shared uniqueness state.

Fixes: 64e8ee814819 ("bpf: look into the types of the fields of a struct type recursively.")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://patch.msgid.link/20260719153634.2908692-3-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index fc1fb7659e1b1..1991003f1e87a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3751,7 +3751,7 @@ static int btf_repeat_fields(struct btf_field_info *info, int info_cnt,
 static int btf_find_struct_field(const struct btf *btf,
 				 const struct btf_type *t, u32 field_mask,
 				 struct btf_field_info *info, int info_cnt,
-				 u32 level);
+				 u32 level, u32 *seen_mask);
 
 /* Find special fields in the struct type of a field.
  *
@@ -3762,7 +3762,7 @@ static int btf_find_struct_field(const struct btf *btf,
 static int btf_find_nested_struct(const struct btf *btf, const struct btf_type *t,
 				  u32 off, u32 nelems,
 				  u32 field_mask, struct btf_field_info *info,
-				  int info_cnt, u32 level)
+				  int info_cnt, u32 level, u32 *seen_mask)
 {
 	int ret, err, i;
 
@@ -3770,7 +3770,7 @@ static int btf_find_nested_struct(const struct btf *btf, const struct btf_type *
 	if (level >= MAX_RESOLVE_DEPTH)
 		return -E2BIG;
 
-	ret = btf_find_struct_field(btf, t, field_mask, info, info_cnt, level);
+	ret = btf_find_struct_field(btf, t, field_mask, info, info_cnt, level, seen_mask);
 
 	if (ret <= 0)
 		return ret;
@@ -3827,7 +3827,7 @@ static int btf_find_field_one(const struct btf *btf,
 		if (expected_size && expected_size != sz * nelems)
 			return 0;
 		ret = btf_find_nested_struct(btf, var_type, off, nelems, field_mask,
-					     &info[0], info_cnt, level);
+					     &info[0], info_cnt, level, seen_mask);
 		return ret;
 	}
 
@@ -3892,11 +3892,11 @@ static int btf_find_field_one(const struct btf *btf,
 static int btf_find_struct_field(const struct btf *btf,
 				 const struct btf_type *t, u32 field_mask,
 				 struct btf_field_info *info, int info_cnt,
-				 u32 level)
+				 u32 level, u32 *seen_mask)
 {
 	int ret, idx = 0;
 	const struct btf_member *member;
-	u32 i, off, seen_mask = 0;
+	u32 i, off;
 
 	for_each_member(i, t, member) {
 		const struct btf_type *member_type = btf_type_by_id(btf,
@@ -3910,7 +3910,7 @@ static int btf_find_struct_field(const struct btf *btf,
 
 		ret = btf_find_field_one(btf, t, member_type, i,
 					 off, 0,
-					 field_mask, &seen_mask,
+					 field_mask, seen_mask,
 					 &info[idx], info_cnt - idx, level);
 		if (ret < 0)
 			return ret;
@@ -3921,11 +3921,11 @@ static int btf_find_struct_field(const struct btf *btf,
 
 static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
 				u32 field_mask, struct btf_field_info *info,
-				int info_cnt, u32 level)
+				int info_cnt, u32 level, u32 *seen_mask)
 {
 	int ret, idx = 0;
 	const struct btf_var_secinfo *vsi;
-	u32 i, off, seen_mask = 0;
+	u32 i, off;
 
 	for_each_vsi(i, t, vsi) {
 		const struct btf_type *var = btf_type_by_id(btf, vsi->type);
@@ -3933,7 +3933,7 @@ static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
 
 		off = vsi->offset;
 		ret = btf_find_field_one(btf, var, var_type, -1, off, vsi->size,
-					 field_mask, &seen_mask,
+					 field_mask, seen_mask,
 					 &info[idx], info_cnt - idx,
 					 level);
 		if (ret < 0)
@@ -3947,10 +3947,12 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
 			  u32 field_mask, struct btf_field_info *info,
 			  int info_cnt)
 {
+	u32 seen_mask = 0;
+
 	if (__btf_type_is_struct(t))
-		return btf_find_struct_field(btf, t, field_mask, info, info_cnt, 0);
+		return btf_find_struct_field(btf, t, field_mask, info, info_cnt, 0, &seen_mask);
 	else if (btf_type_is_datasec(t))
-		return btf_find_datasec_var(btf, t, field_mask, info, info_cnt, 0);
+		return btf_find_datasec_var(btf, t, field_mask, info, info_cnt, 0, &seen_mask);
 	return -EINVAL;
 }
 
-- 
2.53.0



