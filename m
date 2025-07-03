Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871D71DC98B;
	Thu,  3 Jul 2025 14:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554177; cv=none; b=HSZBuUKTNKB9WQNM7UZXXDJyXBTs6yCNOKeAgPVSTZacoV1sp3cgz74KTEatTYSjM+dxIuGNjBq+fXBAluOT6ipqoHug+j/LnlRTzsFFe5eRQZjgnBGX6uVND3zhR0hvMNwEeZUlUxh3lk+eIkFqzaOn/5JLvtqaw3kh8Vg7hHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554177; c=relaxed/simple;
	bh=yYYW23QIb7dw0athFO7oLys/48OFb6yIjD0BFm2hxaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ecqw24VnS4eydVlRnimkHbnC/EJbmLKLNqPu/bXk4qL7SnUtlC/QtXwPkQjh1AaS5NbeHX05KkQN/z26rpVobn0yUYj0kZ0bFGsZOsz5ANQtGDg16q+HqyCpvTYFC9H29afdp+EzaD+cNbOl+8TumYSpCsHQ95nabqm9YlZFkcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eB2qQPRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eB2qQPRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94137C4CEE3;
	Thu,  3 Jul 2025 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554177;
	bh=yYYW23QIb7dw0athFO7oLys/48OFb6yIjD0BFm2hxaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eB2qQPRqC7PmK+T4h+iCfqZA0XUgOsdLMqM+VwRt0xeyYyzvZjObOei+6jyYFtsoE
	 tkbOAw+GTetJ+9d5vdNw3QN/DAjKfE0+1zFYkCUzMqCRjp7+2yopHH02/YyFEtJ/74
	 TyXMom3jqG4wxXZ6x5SVutCf8qBjaPckm8ii4lug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adin Scannell <amscanne@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/218] libbpf: Fix possible use-after-free for externs
Date: Thu,  3 Jul 2025 16:40:53 +0200
Message-ID: <20250703144000.135389391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Adin Scannell <amscanne@meta.com>

[ Upstream commit fa6f092cc0a02d0fcee37e9e8172eda372a03d33 ]

The `name` field in `obj->externs` points into the BTF data at initial
open time. However, some functions may invalidate this after opening and
before loading (e.g. `bpf_map__set_value_size`), which results in
pointers into freed memory and undefined behavior.

The simplest solution is to simply `strdup` these strings, similar to
the `essent_name`, and free them at the same time.

In order to test this path, the `global_map_resize` BPF selftest is
modified slightly to ensure the presence of an extern, which causes this
test to fail prior to the fix. Given there isn't an obvious API or error
to test against, I opted to add this to the existing test as an aspect
of the resizing feature rather than duplicate the test.

Fixes: 9d0a23313b1a ("libbpf: Add capability for resizing datasec maps")
Signed-off-by: Adin Scannell <amscanne@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250625050215.2777374-1-amscanne@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c                           | 10 +++++++---
 .../selftests/bpf/progs/test_global_map_resize.c | 16 ++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1290314da6761..36e341b4b77bf 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -596,7 +596,7 @@ struct extern_desc {
 	int sym_idx;
 	int btf_id;
 	int sec_btf_id;
-	const char *name;
+	char *name;
 	char *essent_name;
 	bool is_set;
 	bool is_weak;
@@ -4223,7 +4223,9 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 			return ext->btf_id;
 		}
 		t = btf__type_by_id(obj->btf, ext->btf_id);
-		ext->name = btf__name_by_offset(obj->btf, t->name_off);
+		ext->name = strdup(btf__name_by_offset(obj->btf, t->name_off));
+		if (!ext->name)
+			return -ENOMEM;
 		ext->sym_idx = i;
 		ext->is_weak = ELF64_ST_BIND(sym->st_info) == STB_WEAK;
 
@@ -9062,8 +9064,10 @@ void bpf_object__close(struct bpf_object *obj)
 	zfree(&obj->btf_custom_path);
 	zfree(&obj->kconfig);
 
-	for (i = 0; i < obj->nr_extern; i++)
+	for (i = 0; i < obj->nr_extern; i++) {
+		zfree(&obj->externs[i].name);
 		zfree(&obj->externs[i].essent_name);
+	}
 
 	zfree(&obj->externs);
 	obj->nr_extern = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_global_map_resize.c b/tools/testing/selftests/bpf/progs/test_global_map_resize.c
index a3f220ba7025b..ee65bad0436d0 100644
--- a/tools/testing/selftests/bpf/progs/test_global_map_resize.c
+++ b/tools/testing/selftests/bpf/progs/test_global_map_resize.c
@@ -32,6 +32,16 @@ int my_int_last SEC(".data.array_not_last");
 
 int percpu_arr[1] SEC(".data.percpu_arr");
 
+/* at least one extern is included, to ensure that a specific
+ * regression is tested whereby resizing resulted in a free-after-use
+ * bug after type information is invalidated by the resize operation.
+ *
+ * There isn't a particularly good API to test for this specific condition,
+ * but by having externs for the resizing tests it will cover this path.
+ */
+extern int LINUX_KERNEL_VERSION __kconfig;
+long version_sink;
+
 SEC("tp/syscalls/sys_enter_getpid")
 int bss_array_sum(void *ctx)
 {
@@ -44,6 +54,9 @@ int bss_array_sum(void *ctx)
 	for (size_t i = 0; i < bss_array_len; ++i)
 		sum += array[i];
 
+	/* see above; ensure this is not optimized out */
+	version_sink = LINUX_KERNEL_VERSION;
+
 	return 0;
 }
 
@@ -59,6 +72,9 @@ int data_array_sum(void *ctx)
 	for (size_t i = 0; i < data_array_len; ++i)
 		sum += my_array[i];
 
+	/* see above; ensure this is not optimized out */
+	version_sink = LINUX_KERNEL_VERSION;
+
 	return 0;
 }
 
-- 
2.39.5



