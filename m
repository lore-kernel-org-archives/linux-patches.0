Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4C01D0954;
	Wed,  2 Oct 2024 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878088; cv=none; b=lRGSm0r7W6OJF6DZY37w8oENVSKNa4o5zNY8LIph7fdTTYPm2pJwSzymr6O3jvCpTznhSPrf71qpKJnR85D/W/nOPr6uDWkCSJtQWHVI7xUdRX5kLzWPPoulhfNl9TTlZomXxDjG8286uO/eqX795fWXKIQ+r5noCXBlFhb5nt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878088; c=relaxed/simple;
	bh=4iKxJiYaw1xIWh6s694KIzpGrZyqi4CYig87hUv2ivE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dE5iwnOvpIMLPTQ5FdRfOvufPkO8yyeFOHY3saH5s2kOGMwWzzlgzSpdojw0UZRT6cbBXCS+GMXuscidEVREtMps0UQQ9y/kt67a/6sXhiwmnARgpCD6t0YLJNDge/X39Gm1oaxt2UwJoWKPkOJ+FCwXgwzNVk6ZZx9Xye9zW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pb/JXyfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pb/JXyfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9920C4CEC2;
	Wed,  2 Oct 2024 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878088;
	bh=4iKxJiYaw1xIWh6s694KIzpGrZyqi4CYig87hUv2ivE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pb/JXyfaaY8Lmur6cGr8I/FdYNYXRBRWXN3HLOd/R0TwnjdDRBPb5SCUtf/Wy+OOe
	 ZU3qVEdcdpiemvPFZQAHz+vC0Fixm8MIdOUarEWUnot08TWxdHGjb5TxusyeRfA3yj
	 nmI4enWg15EVn3BfJa22KHs4HBnqGI996AnKzNpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 270/634] libbpf: Fix bpf_object__open_skeleton()s mishandling of options
Date: Wed,  2 Oct 2024 14:56:10 +0200
Message-ID: <20241002125821.757583368@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit c634d6f4e12d00c954410ba11db45799a8c77b5b ]

We do an ugly copying of options in bpf_object__open_skeleton() just to
be able to set object name from skeleton's recorded name (while still
allowing user to override it through opts->object_name).

This is not just ugly, but it also is broken due to memcpy() that
doesn't take into account potential skel_opts' and user-provided opts'
sizes differences due to backward and forward compatibility. This leads
to copying over extra bytes and then failing to validate options
properly. It could, technically, lead also to SIGSEGV, if we are unlucky.

So just get rid of that memory copy completely and instead pass
default object name into bpf_object_open() directly, simplifying all
this significantly. The rule now is that obj_name should be non-NULL for
bpf_object_open() when called with in-memory buffer, so validate that
explicitly as well.

We adopt bpf_object__open_mem() to this as well and generate default
name (based on buffer memory address and size) outside of bpf_object_open().

Fixes: d66562fba1ce ("libbpf: Add BPF object skeleton support")
Reported-by: Daniel Müller <deso@posteo.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Daniel Müller <deso@posteo.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20240827203721.1145494-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 52 +++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 31f58e3c4059c..3ecb33188336f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7866,16 +7866,19 @@ static int bpf_object_init_progs(struct bpf_object *obj, const struct bpf_object
 }
 
 static struct bpf_object *bpf_object_open(const char *path, const void *obj_buf, size_t obj_buf_sz,
+					  const char *obj_name,
 					  const struct bpf_object_open_opts *opts)
 {
-	const char *obj_name, *kconfig, *btf_tmp_path, *token_path;
+	const char *kconfig, *btf_tmp_path, *token_path;
 	struct bpf_object *obj;
-	char tmp_name[64];
 	int err;
 	char *log_buf;
 	size_t log_size;
 	__u32 log_level;
 
+	if (obj_buf && !obj_name)
+		return ERR_PTR(-EINVAL);
+
 	if (elf_version(EV_CURRENT) == EV_NONE) {
 		pr_warn("failed to init libelf for %s\n",
 			path ? : "(mem buf)");
@@ -7885,16 +7888,12 @@ static struct bpf_object *bpf_object_open(const char *path, const void *obj_buf,
 	if (!OPTS_VALID(opts, bpf_object_open_opts))
 		return ERR_PTR(-EINVAL);
 
-	obj_name = OPTS_GET(opts, object_name, NULL);
+	obj_name = OPTS_GET(opts, object_name, NULL) ?: obj_name;
 	if (obj_buf) {
-		if (!obj_name) {
-			snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
-				 (unsigned long)obj_buf,
-				 (unsigned long)obj_buf_sz);
-			obj_name = tmp_name;
-		}
 		path = obj_name;
 		pr_debug("loading object '%s' from buffer\n", obj_name);
+	} else {
+		pr_debug("loading object from %s\n", path);
 	}
 
 	log_buf = OPTS_GET(opts, kernel_log_buf, NULL);
@@ -7978,9 +7977,7 @@ bpf_object__open_file(const char *path, const struct bpf_object_open_opts *opts)
 	if (!path)
 		return libbpf_err_ptr(-EINVAL);
 
-	pr_debug("loading %s\n", path);
-
-	return libbpf_ptr(bpf_object_open(path, NULL, 0, opts));
+	return libbpf_ptr(bpf_object_open(path, NULL, 0, NULL, opts));
 }
 
 struct bpf_object *bpf_object__open(const char *path)
@@ -7992,10 +7989,15 @@ struct bpf_object *
 bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
 		     const struct bpf_object_open_opts *opts)
 {
+	char tmp_name[64];
+
 	if (!obj_buf || obj_buf_sz == 0)
 		return libbpf_err_ptr(-EINVAL);
 
-	return libbpf_ptr(bpf_object_open(NULL, obj_buf, obj_buf_sz, opts));
+	/* create a (quite useless) default "name" for this memory buffer object */
+	snprintf(tmp_name, sizeof(tmp_name), "%lx-%zx", (unsigned long)obj_buf, obj_buf_sz);
+
+	return libbpf_ptr(bpf_object_open(NULL, obj_buf, obj_buf_sz, tmp_name, opts));
 }
 
 static int bpf_object_unload(struct bpf_object *obj)
@@ -13718,29 +13720,13 @@ static int populate_skeleton_progs(const struct bpf_object *obj,
 int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 			      const struct bpf_object_open_opts *opts)
 {
-	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, skel_opts,
-		.object_name = s->name,
-	);
 	struct bpf_object *obj;
 	int err;
 
-	/* Attempt to preserve opts->object_name, unless overriden by user
-	 * explicitly. Overwriting object name for skeletons is discouraged,
-	 * as it breaks global data maps, because they contain object name
-	 * prefix as their own map name prefix. When skeleton is generated,
-	 * bpftool is making an assumption that this name will stay the same.
-	 */
-	if (opts) {
-		memcpy(&skel_opts, opts, sizeof(*opts));
-		if (!opts->object_name)
-			skel_opts.object_name = s->name;
-	}
-
-	obj = bpf_object__open_mem(s->data, s->data_sz, &skel_opts);
-	err = libbpf_get_error(obj);
-	if (err) {
-		pr_warn("failed to initialize skeleton BPF object '%s': %d\n",
-			s->name, err);
+	obj = bpf_object_open(NULL, s->data, s->data_sz, s->name, opts);
+	if (IS_ERR(obj)) {
+		err = PTR_ERR(obj);
+		pr_warn("failed to initialize skeleton BPF object '%s': %d\n", s->name, err);
 		return libbpf_err(err);
 	}
 
-- 
2.43.0



