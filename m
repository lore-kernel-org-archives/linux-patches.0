Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473C415F0E;
	Sat, 12 Sep 2026 10:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207976; cv=none; b=YFQ9mPbWz5NzdKMGdpA1VQenC86f1tOrO3XAUGgAKkCxFPxN2BwHfemOUIEEur+mKt0kgK8/63VV5BwAHnWKderU8fzUNYb10qK5pa+nuGoBvRe9Qf1HpCzEtXFsbIwOtWLxvC1uR7qL0Gf/vAN+JFDTS2SnMbTgG230/M1Jkng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207976; c=relaxed/simple;
	bh=tX9LhABGQRll/nQgNPkVBov+cir/rJs9NdmXduyG7BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyYIRoaqr2XVk3Yr/UMPVbQQwqLLptenTQluN5o1TGKNamtqATn8VWejKVcqjFvnuOmcSHaGlkFIAt9OV8BI6k7bAEpk0Kl7p2Ia21Nr0GhncfmxWwdFQQSust+kPwy3gwwRLWpSsQJlDFphqt6GCyD8TvY4nmojnKSJhZPlw64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjnwoXCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjnwoXCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1A31F000FF;
	Sat, 12 Sep 2026 10:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207975;
	bh=820WwGpJ13oAkzNcqihNEG0ESMrXsyyUaZy1fbILW2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjnwoXCn58n87FYVmayXw1NiB9NUdfSBKnUTV15VR6wV0p1z5mzBelcSPm7Rh14bc
	 HvVimjh2LvtyjvApt65uqoh7iRE9tSDrzx+t9DQPdY8Jev4oudqhTidhH8edjux7ll
	 J9DlS40j0QPpCLYyZ5q2d4pJ0N9TXlngdBADfyZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0506/1518] bpf: Preserve unique-field state across nested structs
Date: Sat, 12 Sep 2026 08:44:35 +0200
Message-ID: <20260912065634.891589026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e576b3eda5ea7..6d616a67aa40c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3586,7 +3586,7 @@ static int btf_repeat_fields(struct btf_field_info *info, int info_cnt,
 static int btf_find_struct_field(const struct btf *btf,
 				 const struct btf_type *t, u32 field_mask,
 				 struct btf_field_info *info, int info_cnt,
-				 u32 level);
+				 u32 level, u32 *seen_mask);
 
 /* Find special fields in the struct type of a field.
  *
@@ -3597,7 +3597,7 @@ static int btf_find_struct_field(const struct btf *btf,
 static int btf_find_nested_struct(const struct btf *btf, const struct btf_type *t,
 				  u32 off, u32 nelems,
 				  u32 field_mask, struct btf_field_info *info,
-				  int info_cnt, u32 level)
+				  int info_cnt, u32 level, u32 *seen_mask)
 {
 	int ret, err, i;
 
@@ -3605,7 +3605,7 @@ static int btf_find_nested_struct(const struct btf *btf, const struct btf_type *
 	if (level >= MAX_RESOLVE_DEPTH)
 		return -E2BIG;
 
-	ret = btf_find_struct_field(btf, t, field_mask, info, info_cnt, level);
+	ret = btf_find_struct_field(btf, t, field_mask, info, info_cnt, level, seen_mask);
 
 	if (ret <= 0)
 		return ret;
@@ -3662,7 +3662,7 @@ static int btf_find_field_one(const struct btf *btf,
 		if (expected_size && expected_size != sz * nelems)
 			return 0;
 		ret = btf_find_nested_struct(btf, var_type, off, nelems, field_mask,
-					     &info[0], info_cnt, level);
+					     &info[0], info_cnt, level, seen_mask);
 		return ret;
 	}
 
@@ -3727,11 +3727,11 @@ static int btf_find_field_one(const struct btf *btf,
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
@@ -3745,7 +3745,7 @@ static int btf_find_struct_field(const struct btf *btf,
 
 		ret = btf_find_field_one(btf, t, member_type, i,
 					 off, 0,
-					 field_mask, &seen_mask,
+					 field_mask, seen_mask,
 					 &info[idx], info_cnt - idx, level);
 		if (ret < 0)
 			return ret;
@@ -3756,11 +3756,11 @@ static int btf_find_struct_field(const struct btf *btf,
 
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
@@ -3768,7 +3768,7 @@ static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
 
 		off = vsi->offset;
 		ret = btf_find_field_one(btf, var, var_type, -1, off, vsi->size,
-					 field_mask, &seen_mask,
+					 field_mask, seen_mask,
 					 &info[idx], info_cnt - idx,
 					 level);
 		if (ret < 0)
@@ -3782,10 +3782,12 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
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



