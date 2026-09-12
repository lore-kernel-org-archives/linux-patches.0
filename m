Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D0A38DC7B;
	Sat, 12 Sep 2026 18:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238259; cv=none; b=Ck6U6M0Sz1MD/Sxx0D1KNaZ9TV78KnZDk1yxKneSjVbidqokWF0dHEnubzCMIdD7hbH1ywvFHY6uKV0T0UTdD2D9ik1x9sR7v1JHnaJz0gOwd/60i1Mwn6Ny5KF0hf4bEzJCP5fmTGmyJjKN685ojbeeAB4XRylzxJ4cQOGxLwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238259; c=relaxed/simple;
	bh=sKPLGa9o3FSzxrdsJ+RvWXqw/s6sn+NwT4j9f8ZVOnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGmuHWnCIozKv9LbIM4ov0qqn+ylP632i+oTygpxmuhn+uHqBt9F8vEytjTx4xXKFriMJkCkoZ51aSQRXNrIJBr03BUkc4lWGpvqERspDeE13b67EvPL0nBIaapSozdupvarngzwF9BQADB8kL3W55+SatSwGqPv7tgzzHtAnPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ond0NhEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ond0NhEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518331F000FF;
	Sat, 12 Sep 2026 18:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238257;
	bh=wkFISBA6eYzTfRPfjeBSh0q8p1BgLb5Kx3YedtZij9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ond0NhEbPg1OOuvbJ+zn4L9kLv9Ap+Y+tWUxGN6VRBG1KFnbDODFYenRg8kgmBYJl
	 0MbK05SypK8cqkjrTwUzBgo4ad7hZYZ8MJXlaMywUp63bCfvFpXu5/xmb9rP6fXbmf
	 P14tm0Og4Zm1uAOooaAVkeTf/jqsg6CAOflVWhZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/935] bpftool: Use libbpf_get_error() to check error
Date: Sat, 12 Sep 2026 08:57:35 +0200
Message-ID: <20260912065536.573086340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit e5043894b21f7d99d3db31ad06308d6c5726caa6 ]

Currently, LIBBPF_STRICT_ALL mode is enabled by default for
bpftool which means on error cases, some libbpf APIs would
return NULL pointers. This makes IS_ERR check failed to detect
such cases and result in segfault error. Use libbpf_get_error()
instead like we do in libbpf itself.

Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211115012436.3143318-1-hengqi.chen@gmail.com
Stable-dep-of: 66d7e39e49b0 ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c        |  9 +++++----
 tools/bpf/bpftool/gen.c        | 10 ++++++----
 tools/bpf/bpftool/iter.c       |  7 ++++---
 tools/bpf/bpftool/map.c        | 10 +++++-----
 tools/bpf/bpftool/struct_ops.c | 14 +++++++-------
 5 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index d4c7cd3025171..cc0707ab1374f 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -411,8 +411,9 @@ static int dump_btf_c(const struct btf *btf,
 	int err = 0, i;
 
 	d = btf_dump__new(btf, btf_dump_printf, NULL, NULL);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	err = libbpf_get_error(d);
+	if (err)
+		return err;
 
 	printf("#ifndef __VMLINUX_H__\n");
 	printf("#define __VMLINUX_H__\n");
@@ -539,8 +540,8 @@ static int do_dump(int argc, char **argv)
 		}
 
 		btf = btf__parse_split(*argv, base ?: base_btf);
-		if (IS_ERR(btf)) {
-			err = -PTR_ERR(btf);
+		err = libbpf_get_error(btf);
+		if (err) {
 			btf = NULL;
 			p_err("failed to load BTF from %s: %s",
 			      *argv, strerror(err));
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 25efbb868e9ea..2556c13d26fa4 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -198,8 +198,9 @@ static int codegen_datasecs(struct bpf_object *obj, const char *obj_name)
 	int i, err = 0;
 
 	d = btf_dump__new(btf, codegen_btf_dump_printf, NULL, NULL);
-	if (IS_ERR(d))
-		return PTR_ERR(d);
+	err = libbpf_get_error(d);
+	if (err)
+		return err;
 
 	for (i = 1; i <= n; i++) {
 		const struct btf_type *t = btf__type_by_id(btf, i);
@@ -664,10 +665,11 @@ static int do_skeleton(int argc, char **argv)
 		get_obj_name(obj_name, file);
 	opts.object_name = obj_name;
 	obj = bpf_object__open_mem(obj_data, file_sz, &opts);
-	if (IS_ERR(obj)) {
+	err = libbpf_get_error(obj);
+	if (err) {
 		char err_buf[256];
 
-		libbpf_strerror(PTR_ERR(obj), err_buf, sizeof(err_buf));
+		libbpf_strerror(err, err_buf, sizeof(err_buf));
 		p_err("failed to open BPF object file: %s", err_buf);
 		obj = NULL;
 		goto out;
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index 84a9b01d956dc..4d0f4cea03d14 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -46,7 +46,8 @@ static int do_pin(int argc, char **argv)
 	}
 
 	obj = bpf_object__open(objfile);
-	if (IS_ERR(obj)) {
+	err = libbpf_get_error(obj);
+	if (err) {
 		p_err("can't open objfile %s", objfile);
 		goto close_map_fd;
 	}
@@ -64,8 +65,8 @@ static int do_pin(int argc, char **argv)
 	}
 
 	link = bpf_program__attach_iter(prog, &iter_opts);
-	if (IS_ERR(link)) {
-		err = PTR_ERR(link);
+	err = libbpf_get_error(link);
+	if (err) {
 		p_err("attach_iter failed for program %s",
 		      bpf_program__name(prog));
 		goto close_obj;
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c775a677688ae..12d782962c8c8 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -799,7 +799,7 @@ static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
 	if (info->btf_vmlinux_value_type_id) {
 		if (!btf_vmlinux) {
 			btf_vmlinux = libbpf_find_kernel_btf();
-			if (IS_ERR(btf_vmlinux))
+			if (libbpf_get_error(btf_vmlinux))
 				p_err("failed to get kernel btf");
 		}
 		return btf_vmlinux;
@@ -819,13 +819,13 @@ static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
 
 static void free_map_kv_btf(struct btf *btf)
 {
-	if (!IS_ERR(btf) && btf != btf_vmlinux)
+	if (!libbpf_get_error(btf) && btf != btf_vmlinux)
 		btf__free(btf);
 }
 
 static void free_btf_vmlinux(void)
 {
-	if (!IS_ERR(btf_vmlinux))
+	if (!libbpf_get_error(btf_vmlinux))
 		btf__free(btf_vmlinux);
 }
 
@@ -850,8 +850,8 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 
 	if (wtr) {
 		btf = get_map_kv_btf(info);
-		if (IS_ERR(btf)) {
-			err = PTR_ERR(btf);
+		err = libbpf_get_error(btf);
+		if (err) {
 			goto exit_free;
 		}
 
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index ab2d2290569a4..407ae9fc20b10 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -32,7 +32,7 @@ static const struct btf *get_btf_vmlinux(void)
 		return btf_vmlinux;
 
 	btf_vmlinux = libbpf_find_kernel_btf();
-	if (IS_ERR(btf_vmlinux))
+	if (libbpf_get_error(btf_vmlinux))
 		p_err("struct_ops requires kernel CONFIG_DEBUG_INFO_BTF=y");
 
 	return btf_vmlinux;
@@ -45,7 +45,7 @@ static const char *get_kern_struct_ops_name(const struct bpf_map_info *info)
 	const char *st_ops_name;
 
 	kern_btf = get_btf_vmlinux();
-	if (IS_ERR(kern_btf))
+	if (libbpf_get_error(kern_btf))
 		return "<btf_vmlinux_not_found>";
 
 	t = btf__type_by_id(kern_btf, info->btf_vmlinux_value_type_id);
@@ -63,7 +63,7 @@ static __s32 get_map_info_type_id(void)
 		return map_info_type_id;
 
 	kern_btf = get_btf_vmlinux();
-	if (IS_ERR(kern_btf)) {
+	if (libbpf_get_error(kern_btf)) {
 		map_info_type_id = PTR_ERR(kern_btf);
 		return map_info_type_id;
 	}
@@ -415,7 +415,7 @@ static int do_dump(int argc, char **argv)
 	}
 
 	kern_btf = get_btf_vmlinux();
-	if (IS_ERR(kern_btf))
+	if (libbpf_get_error(kern_btf))
 		return -1;
 
 	if (!json_output) {
@@ -495,7 +495,7 @@ static int do_register(int argc, char **argv)
 	file = GET_ARG();
 
 	obj = bpf_object__open(file);
-	if (IS_ERR_OR_NULL(obj))
+	if (libbpf_get_error(obj))
 		return -1;
 
 	set_max_rlimit();
@@ -516,7 +516,7 @@ static int do_register(int argc, char **argv)
 			continue;
 
 		link = bpf_map__attach_struct_ops(map);
-		if (IS_ERR(link)) {
+		if (libbpf_get_error(link)) {
 			p_err("can't register struct_ops %s: %s",
 			      bpf_map__name(map),
 			      strerror(-PTR_ERR(link)));
@@ -596,7 +596,7 @@ int do_struct_ops(int argc, char **argv)
 
 	err = cmd_select(cmds, argc, argv, do_help);
 
-	if (!IS_ERR(btf_vmlinux))
+	if (!libbpf_get_error(btf_vmlinux))
 		btf__free(btf_vmlinux);
 
 	return err;
-- 
2.53.0



