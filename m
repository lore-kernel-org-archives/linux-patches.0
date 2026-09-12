Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76BB479876;
	Sat, 12 Sep 2026 12:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215889; cv=none; b=vBAWnpyII2i5r2mUjGpuhvjcaGazeTZU60TRn6kl8GCRJsHjkfIm5X8GO+oIeMndfZH29fq9+b2RbqzgiC3an8OkbadzxMBxdQS2gxx7aa5kx4WRmWmLziC4LkIyMTauhJpxqndOqZMX7Nq2zcsaTTBZ5eBFUfsldg1Dnq+hXhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215889; c=relaxed/simple;
	bh=Jbbj5XbbgFbWpFIG42FXJ2AOcg/rsyRIgd4p7ZzwUKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI076CAKrwcjEH7xnc/Ero4shOu0xgG7jA8gFNiDk5rtp3OLmqNbIWxES6+tBxJT6/UYaFU4YLQcYmUGXDL6Ez+NUGiD1Nn7w4klRjl2qhk/A5j9T9h7eReGW1Ugx442BXul6dU/8m7KdXwwBP03oNH9XuPwlLMVD2iBR2T2k7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkCmSAQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkCmSAQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E68E1F000FF;
	Sat, 12 Sep 2026 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215887;
	bh=rICrgZ0UQyTJSZTGSG4D7jbt2XCV4YuICn2B5Mg3mkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkCmSAQWBnK3poOf+VPQwMhFgeRUgO3qmyae5cxXcouVX/iVa2dq6c36V6GhORZSp
	 4eDsk6BzkXstJ+u0pZd3o0HleJ4vyP8bqQ5TSFBnkpABRLf60WQWWUG+wJ9/1KSvLJ
	 nXIiJJ2Ug8KOipMA1EKq3zwA0r9a5fFtDHJtntkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0624/1376] bpf: Preserve unique-field state across nested structs
Date: Sat, 12 Sep 2026 08:50:50 +0200
Message-ID: <20260912065621.451873759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 65006b4b84ca4..fbf3e1718bfc8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3565,7 +3565,7 @@ static int btf_repeat_fields(struct btf_field_info *info, int info_cnt,
 static int btf_find_struct_field(const struct btf *btf,
 				 const struct btf_type *t, u32 field_mask,
 				 struct btf_field_info *info, int info_cnt,
-				 u32 level);
+				 u32 level, u32 *seen_mask);
 
 /* Find special fields in the struct type of a field.
  *
@@ -3576,7 +3576,7 @@ static int btf_find_struct_field(const struct btf *btf,
 static int btf_find_nested_struct(const struct btf *btf, const struct btf_type *t,
 				  u32 off, u32 nelems,
 				  u32 field_mask, struct btf_field_info *info,
-				  int info_cnt, u32 level)
+				  int info_cnt, u32 level, u32 *seen_mask)
 {
 	int ret, err, i;
 
@@ -3584,7 +3584,7 @@ static int btf_find_nested_struct(const struct btf *btf, const struct btf_type *
 	if (level >= MAX_RESOLVE_DEPTH)
 		return -E2BIG;
 
-	ret = btf_find_struct_field(btf, t, field_mask, info, info_cnt, level);
+	ret = btf_find_struct_field(btf, t, field_mask, info, info_cnt, level, seen_mask);
 
 	if (ret <= 0)
 		return ret;
@@ -3641,7 +3641,7 @@ static int btf_find_field_one(const struct btf *btf,
 		if (expected_size && expected_size != sz * nelems)
 			return 0;
 		ret = btf_find_nested_struct(btf, var_type, off, nelems, field_mask,
-					     &info[0], info_cnt, level);
+					     &info[0], info_cnt, level, seen_mask);
 		return ret;
 	}
 
@@ -3703,11 +3703,11 @@ static int btf_find_field_one(const struct btf *btf,
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
@@ -3721,7 +3721,7 @@ static int btf_find_struct_field(const struct btf *btf,
 
 		ret = btf_find_field_one(btf, t, member_type, i,
 					 off, 0,
-					 field_mask, &seen_mask,
+					 field_mask, seen_mask,
 					 &info[idx], info_cnt - idx, level);
 		if (ret < 0)
 			return ret;
@@ -3732,11 +3732,11 @@ static int btf_find_struct_field(const struct btf *btf,
 
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
@@ -3744,7 +3744,7 @@ static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
 
 		off = vsi->offset;
 		ret = btf_find_field_one(btf, var, var_type, -1, off, vsi->size,
-					 field_mask, &seen_mask,
+					 field_mask, seen_mask,
 					 &info[idx], info_cnt - idx,
 					 level);
 		if (ret < 0)
@@ -3758,10 +3758,12 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
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



