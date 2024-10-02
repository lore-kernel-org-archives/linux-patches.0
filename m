Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25851D07A0;
	Wed,  2 Oct 2024 14:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879705; cv=none; b=i2zYxN4DpgEo7QzsBY1dbG/9eIz+kBXdU0C4+pAiJ/xI7guoxVfCUmwGiLGZRAUfWw8EzEM7VPlx1HBCaDxwN42yxh3Wca/B5GMwkye5CtcLAarCG9Hoq/91VKZUJFULIf52TTMsHWO31LOGvRW2uOMrWRbmXQ3PCwkSSZPO6og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879705; c=relaxed/simple;
	bh=oYYn3LPF1zVtuxgJ18TqvyE/r8vwKsOsp5T4LbGJgNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiUcPNdBtZnf8VFl6Ah5IlfMoAWr6UaRJk+gwrK8j9U+6njZVh8X8vFTiHAb1kAv6NQ9L8qVoib3CM6YA+bOR/e10S7N3FlrWRBMcK4X32/bIX0X3xmJOsvZxJhDxYiVzeB2rWa9DOfrCqFLVhfuA95JYxyiSv0OWlPS456VU5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmKSUHoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmKSUHoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CF9C4CEC2;
	Wed,  2 Oct 2024 14:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879705;
	bh=oYYn3LPF1zVtuxgJ18TqvyE/r8vwKsOsp5T4LbGJgNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmKSUHoKSf/R1nhM/NTtzPvbI+BWa0wWtbECRYyHqxk2QMIVjTDPfyjD+OF3dCfsi
	 GGBBzOTBntlATldflQZctj7EqGCGSkT4+A9zUdKZQXESMbcCbfyH+9QKyLzBsqG9uL
	 ClrswtBjL0Lf1LzIk4Zi0oLeQmdQAWQNYq6F6uwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/538] libbpf: Sync progs autoload with maps autocreate for struct_ops maps
Date: Wed,  2 Oct 2024 14:57:30 +0200
Message-ID: <20241002125800.587092087@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit fe9d049c3da06373a1a35914b7f695509e4cb1fe ]

Automatically select which struct_ops programs to load depending on
which struct_ops maps are selected for automatic creation.
E.g. for the BPF code below:

    SEC("struct_ops/test_1") int BPF_PROG(foo) { ... }
    SEC("struct_ops/test_2") int BPF_PROG(bar) { ... }

    SEC(".struct_ops.link")
    struct test_ops___v1 A = {
        .foo = (void *)foo
    };

    SEC(".struct_ops.link")
    struct test_ops___v2 B = {
        .foo = (void *)foo,
        .bar = (void *)bar,
    };

And the following libbpf API calls:

    bpf_map__set_autocreate(skel->maps.A, true);
    bpf_map__set_autocreate(skel->maps.B, false);

The autoload would be enabled for program 'foo' and disabled for
program 'bar'.

During load, for each struct_ops program P, referenced from some
struct_ops map M:
- set P.autoload = true if M.autocreate is true for some M;
- set P.autoload = false if M.autocreate is false for all M;
- don't change P.autoload, if P is not referenced from any map.

Do this after bpf_object__init_kern_struct_ops_maps()
to make sure that shadow vars assignment is done.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240306104529.6453-9-eddyz87@gmail.com
Stable-dep-of: 04a94133f1b3 ("libbpf: Don't take direct pointers into BTF data from st_ops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c91917868b557..aeed9bc44247b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1007,6 +1007,48 @@ static bool is_valid_st_ops_program(struct bpf_object *obj,
 	return false;
 }
 
+/* For each struct_ops program P, referenced from some struct_ops map M,
+ * enable P.autoload if there are Ms for which M.autocreate is true,
+ * disable P.autoload if for all Ms M.autocreate is false.
+ * Don't change P.autoload for programs that are not referenced from any maps.
+ */
+static int bpf_object_adjust_struct_ops_autoload(struct bpf_object *obj)
+{
+	struct bpf_program *prog, *slot_prog;
+	struct bpf_map *map;
+	int i, j, k, vlen;
+
+	for (i = 0; i < obj->nr_programs; ++i) {
+		int should_load = false;
+		int use_cnt = 0;
+
+		prog = &obj->programs[i];
+		if (prog->type != BPF_PROG_TYPE_STRUCT_OPS)
+			continue;
+
+		for (j = 0; j < obj->nr_maps; ++j) {
+			map = &obj->maps[j];
+			if (!bpf_map__is_struct_ops(map))
+				continue;
+
+			vlen = btf_vlen(map->st_ops->type);
+			for (k = 0; k < vlen; ++k) {
+				slot_prog = map->st_ops->progs[k];
+				if (prog != slot_prog)
+					continue;
+
+				use_cnt++;
+				if (map->autocreate)
+					should_load = true;
+			}
+		}
+		if (use_cnt)
+			prog->autoload = should_load;
+	}
+
+	return 0;
+}
+
 /* Init the map's fields that depend on kern_btf */
 static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
 {
@@ -8003,6 +8045,7 @@ static int bpf_object_load(struct bpf_object *obj, int extra_log_level, const ch
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
 	err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
+	err = err ? : bpf_object_adjust_struct_ops_autoload(obj);
 	err = err ? : bpf_object__relocate(obj, obj->btf_custom_path ? : target_btf_path);
 	err = err ? : bpf_object__create_maps(obj);
 	err = err ? : bpf_object__load_progs(obj, extra_log_level);
-- 
2.43.0



