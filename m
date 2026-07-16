Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14933FF1C7;
	Thu, 16 Jul 2026 13:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209730; cv=none; b=E0zH7euZen7q5AmJNpR1VCysuYMEEF0H1ajw9MS/yuSMIMRNu5+wyA3pJMG9GH8rKG/jw+L3Rw1lh7UmDmUd+0i7HPcebJoIbu64YaT0ogdr+InITic5VxlKH2HYjnu8pG8ThhjvMDqS/KDHDQqIqshww9ds/D8foaw47RPrmNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209730; c=relaxed/simple;
	bh=Q+EqNgRnkYu40i1H1B6QdU1AdhrhGUs/g80J3Ikg4mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvUaeJQxuw7bKwg4ejwiZdP0zkTTo9CGnBVdUk2AFPixzrWQ6sXFOF/9sVbHE00KkkTSBUp175o3oLGi2LGyO0kfhe/7AlZlGrFQ0jgX29/qf/QVf43KO1JfWa4iG28kRGB2ckafLdHp1SFDh2MBAF0hdEQazk9hOeiRfLxITJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8EvVYkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8EvVYkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8122C1F000E9;
	Thu, 16 Jul 2026 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209725;
	bh=975+7Uwn3SLH5xbxpArVJ/VKPjWDTN1I88Q+wvfTgMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8EvVYkTTIK03fldPwPa7sF/zvxOWcUfoejSJs5lCEBgQVgoqxnVMPQOlH45qGOlJ
	 d2aLJDmQ7gUxdlDPvxNvqTi4Mxav/r2R8ceMSaEYhrO/ouoTglgKXTRjqaNvb07U8O
	 9jYIPX60UVfdKCg9JmVfOb5C+LU01aD2lp1voQPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 7.1 294/518] bpf: Keep dynamic inner array lookups nullable
Date: Thu, 16 Jul 2026 15:29:22 +0200
Message-ID: <20260716133054.252085290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

commit 53040a81ae57cdca8af8ac36fe4e661730cf7c6b upstream.

An ARRAY_OF_MAPS can use an array created with BPF_F_INNER_MAP as its
inner map template. A concrete inner array with a different max_entries
value can then replace the template.

After a successful outer map lookup, the verifier represents the
resulting map pointer using the inner map template. Const-key lookup
nullness elision consequently uses the template max_entries even though
the runtime helper uses the concrete inner map max_entries.

Do not elide lookup result nullness for maps marked with BPF_F_INNER_MAP,
because the template max_entries does not prove that the key is in bounds
for the concrete runtime map.

Fixes: d2102f2f5d75 ("bpf: verifier: Support eliding map lookup nullness")
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260607-f01-v2-v2-1-da48453146e8@mails.tsinghua.edu.cn
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8471,7 +8471,7 @@ static int get_constant_map_key(struct b
 	return 0;
 }
 
-static bool can_elide_value_nullness(enum bpf_map_type type);
+static bool can_elide_value_nullness(const struct bpf_map *map);
 
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			  struct bpf_call_arg_meta *meta,
@@ -8621,7 +8621,7 @@ skip_type_check:
 		err = check_helper_mem_access(env, regno, key_size, BPF_READ, false, NULL);
 		if (err)
 			return err;
-		if (can_elide_value_nullness(meta->map.ptr->map_type)) {
+		if (can_elide_value_nullness(meta->map.ptr)) {
 			err = get_constant_map_key(env, reg, key_size, &meta->const_map_key);
 			if (err < 0) {
 				meta->const_map_key = -1;
@@ -10221,13 +10221,16 @@ static void update_loop_inline_state(str
 				 state->callback_subprogno == subprogno);
 }
 
-/* Returns whether or not the given map type can potentially elide
+/* Returns whether or not the given map can potentially elide
  * lookup return value nullness check. This is possible if the key
  * is statically known.
  */
-static bool can_elide_value_nullness(enum bpf_map_type type)
+static bool can_elide_value_nullness(const struct bpf_map *map)
 {
-	switch (type) {
+	if (map->map_flags & BPF_F_INNER_MAP)
+		return false;
+
+	switch (map->map_type) {
 	case BPF_MAP_TYPE_ARRAY:
 	case BPF_MAP_TYPE_PERCPU_ARRAY:
 		return true;
@@ -10589,7 +10592,7 @@ static int check_helper_call(struct bpf_
 		}
 
 		if (func_id == BPF_FUNC_map_lookup_elem &&
-		    can_elide_value_nullness(meta.map.ptr->map_type) &&
+		    can_elide_value_nullness(meta.map.ptr) &&
 		    meta.const_map_key >= 0 &&
 		    meta.const_map_key < meta.map.ptr->max_entries)
 			ret_flag &= ~PTR_MAYBE_NULL;


