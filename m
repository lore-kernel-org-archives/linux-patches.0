Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB461519AF;
	Wed,  5 Feb 2025 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765894; cv=none; b=G7DFMamsUzOK6NY6nd4NgM7UHRyTaWqNw/bOuAaEUUsVTl0YeF8STZ8GH71MEaTYxhkoJYFDk4Rf6/P43sN/1ntLNqsCD5LA339vsI12Y9SnROie/Rf2Gy0Kvfmo6xx+TDv9KGMKGQ11Rx1J20OGwoX02oO/1t7gbMhHaegylk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765894; c=relaxed/simple;
	bh=87FxbpYxF7EXFR2mUGpS0x6PdP1BKPxOzZnoAGn8nBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOnbK1rAZSsaYIj6G0gOHVsfbS/gRAQJlDXnEQurBDUTs5PCwucwRBrhK56XSEgfEaP6v+C+vUIdV9cwYq7RgpTHvJAlpAU2qwTN0czoiBmBSjUYid6WvGBumtXaO7qFwK7s3C9vwb9C5QR9DYkF8y4pTHiNEzuo8wvFgYCpl1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmcHjZn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmcHjZn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A128EC4CED6;
	Wed,  5 Feb 2025 14:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765894;
	bh=87FxbpYxF7EXFR2mUGpS0x6PdP1BKPxOzZnoAGn8nBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmcHjZn4G7DmhhzW5hDk8i/h0K9cJa0+8JHw+Gz5E8IfR8mJY8zcDtKpJhCx4ufle
	 /0U/yn3yVMeqGraOHsxgrIxs2wcbAh2clHPD9Nmm6bnMr+xJ0uBCpbqynhTfkbTHaW
	 sAMtXMHkCQdoSvccYz85n8+w95kHq8tpuhxTfWqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/590] bpf: Reject struct_ops registration that uses module ptr and the module btf_id is missing
Date: Wed,  5 Feb 2025 14:40:20 +0100
Message-ID: <20250205134505.415062602@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 96ea081ed52bf077cad6d00153b6fba68e510767 ]

There is a UAF report in the bpf_struct_ops when CONFIG_MODULES=n.
In particular, the report is on tcp_congestion_ops that has
a "struct module *owner" member.

For struct_ops that has a "struct module *owner" member,
it can be extended either by the regular kernel module or
by the bpf_struct_ops. bpf_try_module_get() will be used
to do the refcounting and different refcount is done
based on the owner pointer. When CONFIG_MODULES=n,
the btf_id of the "struct module" is missing:

WARN: resolve_btfids: unresolved symbol module

Thus, the bpf_try_module_get() cannot do the correct refcounting.

Not all subsystem's struct_ops requires the "struct module *owner" member.
e.g. the recent sched_ext_ops.

This patch is to disable bpf_struct_ops registration if
the struct_ops has the "struct module *" member and the
"struct module" btf_id is missing. The btf_type_is_fwd() helper
is moved to the btf.h header file for this test.

This has happened since the beginning of bpf_struct_ops which has gone
through many changes. The Fixes tag is set to a recent commit that this
patch can apply cleanly. Considering CONFIG_MODULES=n is not
common and the age of the issue, targeting for bpf-next also.

Fixes: 1611603537a4 ("bpf: Create argument information for nullable arguments.")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/bpf/74665.1733669976@localhost/
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241220201818.127152-1-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/btf.h         |  5 +++++
 kernel/bpf/bpf_struct_ops.c | 21 +++++++++++++++++++++
 kernel/bpf/btf.c            |  5 -----
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index b8a583194c4a9..d99178ce01d21 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -352,6 +352,11 @@ static inline bool btf_type_is_scalar(const struct btf_type *t)
 	return btf_type_is_int(t) || btf_type_is_enum(t);
 }
 
+static inline bool btf_type_is_fwd(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_FWD;
+}
+
 static inline bool btf_type_is_typedef(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF;
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index b3a2ce1e5e22e..b70d0eef8a284 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -311,6 +311,20 @@ void bpf_struct_ops_desc_release(struct bpf_struct_ops_desc *st_ops_desc)
 	kfree(arg_info);
 }
 
+static bool is_module_member(const struct btf *btf, u32 id)
+{
+	const struct btf_type *t;
+
+	t = btf_type_resolve_ptr(btf, id, NULL);
+	if (!t)
+		return false;
+
+	if (!__btf_type_is_struct(t) && !btf_type_is_fwd(t))
+		return false;
+
+	return !strcmp(btf_name_by_offset(btf, t->name_off), "module");
+}
+
 int bpf_struct_ops_desc_init(struct bpf_struct_ops_desc *st_ops_desc,
 			     struct btf *btf,
 			     struct bpf_verifier_log *log)
@@ -390,6 +404,13 @@ int bpf_struct_ops_desc_init(struct bpf_struct_ops_desc *st_ops_desc,
 			goto errout;
 		}
 
+		if (!st_ops_ids[IDX_MODULE_ID] && is_module_member(btf, member->type)) {
+			pr_warn("'struct module' btf id not found. Is CONFIG_MODULES enabled? bpf_struct_ops '%s' needs module support.\n",
+				st_ops->name);
+			err = -EOPNOTSUPP;
+			goto errout;
+		}
+
 		func_proto = btf_type_resolve_func_ptr(btf,
 						       member->type,
 						       NULL);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 41d20b7199c4a..a44f4be592be7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -498,11 +498,6 @@ bool btf_type_is_void(const struct btf_type *t)
 	return t == &btf_void;
 }
 
-static bool btf_type_is_fwd(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_FWD;
-}
-
 static bool btf_type_is_datasec(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
-- 
2.39.5



