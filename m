Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBED228000F;
	Tue, 12 Aug 2025 18:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024674; cv=none; b=aGSUXzv2eCrWw9N+IahbinA3Qt5Xu1zKQXdnpX3o4PeekdeWdh6EzfYIQlN+podTQy4DHMJCQjYA114kHRZy2a8WgAIP8lhSB0Kbj9arZ8Lu0e74dX9bpDZ+wem4m/L3Kxxb9lWbHY0atgRIaq93FlJCU+mw3Qg49uEf3YgflpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024674; c=relaxed/simple;
	bh=ACgSJEsiE0P0EH/7ba3hMmwx9bEkoTeRmzGYXnlMvQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jU/uPslnyCJhJDAwK6+iNhRu3o5pBu/XrV218Mv4gnkKfrdoGvS3f4agXD16kVOXUzh6JG0vUpVDEKcHMh/1A0a3UuZ/DQO6KAMH0WoG4J5BM4F9NB7j5o1FxOqJ9GMcwWmyehXdyupSkBYvUx4thAgcNgxRQUDufBwwa6VHjGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvBS9mmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvBS9mmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62251C4CEF0;
	Tue, 12 Aug 2025 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024674;
	bh=ACgSJEsiE0P0EH/7ba3hMmwx9bEkoTeRmzGYXnlMvQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvBS9mmNZFoKwQ+xyg14TfOj7shYVenittmWAXGBEckWAEhCsjBfUICy9vjwYGmdo
	 VZ7a8EVVKu3TyyIMX1dxatp97WWtgs7NR9t1R2XIs7z21bGifoAsJXg/Fb1mpC+EOM
	 imjgVNZwLj0kUDkd51QcRv24X0B1Wo8jJwk6fXZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 443/627] bpf: Move cgroup iterator helpers to bpf.h
Date: Tue, 12 Aug 2025 19:32:18 +0200
Message-ID: <20250812173436.132862987@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 9621e60f59eae87eb9ffe88d90f24f391a1ef0f0 ]

Move them into bpf.h given we also need them in core code.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: abad3d0bad72 ("bpf: Fix oob access in cgroup local storage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup.h |  5 -----
 include/linux/bpf.h        | 22 ++++++++++++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 70c8b94e797a..501873758ce6 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -77,9 +77,6 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
 extern struct static_key_false cgroup_bpf_enabled_key[MAX_CGROUP_BPF_ATTACH_TYPE];
 #define cgroup_bpf_enabled(atype) static_branch_unlikely(&cgroup_bpf_enabled_key[atype])
 
-#define for_each_cgroup_storage_type(stype) \
-	for (stype = 0; stype < MAX_BPF_CGROUP_STORAGE_TYPE; stype++)
-
 struct bpf_cgroup_storage_map;
 
 struct bpf_storage_buffer {
@@ -511,8 +508,6 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
 				       kernel_optval) ({ 0; })
 
-#define for_each_cgroup_storage_type(stype) for (; false; )
-
 #endif /* CONFIG_CGROUP_BPF */
 
 #endif /* _BPF_CGROUP_H */
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a2876101f9b6..d5f720d6cb81 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -208,6 +208,20 @@ enum btf_field_type {
 	BPF_RES_SPIN_LOCK = (1 << 12),
 };
 
+enum bpf_cgroup_storage_type {
+	BPF_CGROUP_STORAGE_SHARED,
+	BPF_CGROUP_STORAGE_PERCPU,
+	__BPF_CGROUP_STORAGE_MAX
+#define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
+};
+
+#ifdef CONFIG_CGROUP_BPF
+# define for_each_cgroup_storage_type(stype) \
+	for (stype = 0; stype < MAX_BPF_CGROUP_STORAGE_TYPE; stype++)
+#else
+# define for_each_cgroup_storage_type(stype) for (; false; )
+#endif /* CONFIG_CGROUP_BPF */
+
 typedef void (*btf_dtor_kfunc_t)(void *);
 
 struct btf_field_kptr {
@@ -1085,14 +1099,6 @@ struct bpf_prog_offload {
 	u32			jited_len;
 };
 
-enum bpf_cgroup_storage_type {
-	BPF_CGROUP_STORAGE_SHARED,
-	BPF_CGROUP_STORAGE_PERCPU,
-	__BPF_CGROUP_STORAGE_MAX
-};
-
-#define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
-
 /* The longest tracepoint has 12 args.
  * See include/trace/bpf_probe.h
  */
-- 
2.39.5



