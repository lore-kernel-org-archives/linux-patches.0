Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602A40803B;
	Tue, 21 Jul 2026 19:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660762; cv=none; b=UFo983u+8U9peacAw8EkgELGkmy0oOpMfV+8q9jlakOLvC6wu2cnz08wmrNlX7L3uCLgd4JHDyuTurpMa9N78uDR3NXa4tB1YU7XThsVNN8zG7v+YzriWMDXcg9+wppwJFTWlLf+ldR9iatbEyZM0zkOgMuan0H0y1mlMEwqmtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660762; c=relaxed/simple;
	bh=dRjfYsaTjDAseG6Y6EOR6byqgZAs7S9VszkDBam19gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWdGQrXmxCgFls3jKlLDjrm0n1NhdnWRZLf1Wd+5P73a3E4L4tMS6HOjqCfeG3b6zPTTS+/4ifjL6WkJZ5fQSUgApZomV5MspWfhmGHygrNR0zmACrV65Ny8joRqBQ58QVJJPdLHoe3R3Ovjsg8HX5J9/If+fv+jgZ9SxUrSNKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwlMMcO8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwlMMcO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BDF1F000E9;
	Tue, 21 Jul 2026 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660761;
	bh=HfzkZfzM1cHkTj/KXhWKyyTs+UDUT1S9H19PGXdnVC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwlMMcO8x78gSHzbuE/8/2E8hJBhHVKj554CEXd0lghnZX602accLAR/ZkvjG4fbx
	 7G9IkLethQIjnw5zrLe4ZBc0KmdQFIdfxjvZnSWaQTslpdcohysZ/0Q5BV3490jrJn
	 V1xKCTLxZAeTfvx07teOQXuMTfnOKBBDZZqNMUF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1100/2077] perf bpf: Validate array presence before casting BPF prog info pointers
Date: Tue, 21 Jul 2026 17:12:53 +0200
Message-ID: <20260721152618.764093159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5ebf4137d23a4fd6c0cc6a6fb766ee60d2b09193 ]

Several functions cast bpf_prog_info fields (jited_ksyms,
jited_func_lens, jited_prog_insns) from u64 to pointers and
dereference them.  These fields are only valid pointers if
bpil_offs_to_addr() converted their file offsets to addresses, which
only happens when the corresponding PERF_BPIL_* bits are set in
info_linear->arrays.

A crafted perf.data can leave these bits unset while setting non-zero
counts and offset values, causing the functions to dereference raw file
offsets as pointers.

Add array bitmask validation to all perf.data processing paths:

  - __bpf_event__print_bpf_prog_info(): check JITED_KSYMS and
    JITED_FUNC_LENS (changed to take struct perf_bpil *)
  - machine__process_bpf_event_load(): check JITED_KSYMS
  - bpf_read(): check JITED_INSNS before memcpy from jited_prog_insns
  - dso__disassemble_filename(): check JITED_INSNS before returning
    jited_prog_insns pointer

Fixes: f8dfeae009effc0b ("perf bpf: Show more BPF program info in print_bpf_prog_info()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 20 +++++++++++++++++---
 tools/perf/util/bpf-event.h |  4 ++--
 tools/perf/util/dso.c       | 10 ++++++++++
 tools/perf/util/header.c    |  3 +--
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 57d53ba848359e..fa3ebc8ea7f09c 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -59,6 +59,10 @@ static int machine__process_bpf_event_load(struct machine *machine,
 		return 0;
 	info_linear = info_node->info_linear;
 
+	/* jited_ksyms is only valid if bpil_offs_to_addr() converted it */
+	if (!(info_linear->arrays & (1UL << PERF_BPIL_JITED_KSYMS)))
+		return 0;
+
 	for (i = 0; i < info_linear->info.nr_jited_ksyms; i++) {
 		u64 *addrs = (u64 *)(uintptr_t)(info_linear->info.jited_ksyms);
 		u64 addr = addrs[i];
@@ -959,12 +963,15 @@ int evlist__add_bpf_sb_event(struct evlist *evlist, struct perf_env *env)
 	return evlist__add_sb_event(evlist, &attr, bpf_event__sb_cb, env);
 }
 
-void __bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
+void __bpf_event__print_bpf_prog_info(struct perf_bpil *info_linear,
 				      struct perf_env *env,
 				      FILE *fp)
 {
-	__u32 *prog_lens = (__u32 *)(uintptr_t)(info->jited_func_lens);
-	__u64 *prog_addrs = (__u64 *)(uintptr_t)(info->jited_ksyms);
+	struct bpf_prog_info *info = &info_linear->info;
+	__u64 required_arrays = (1UL << PERF_BPIL_JITED_KSYMS) |
+				(1UL << PERF_BPIL_JITED_FUNC_LENS);
+	__u32 *prog_lens;
+	__u64 *prog_addrs;
 	char name[KSYM_NAME_LEN];
 	struct btf *btf = NULL;
 	u32 sub_prog_cnt, i;
@@ -974,6 +981,13 @@ void __bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
 	    sub_prog_cnt != info->nr_jited_func_lens)
 		return;
 
+	/* Ensure the arrays were present and converted by bpil_offs_to_addr() */
+	if ((info_linear->arrays & required_arrays) != required_arrays)
+		return;
+
+	prog_lens = (__u32 *)(uintptr_t)(info->jited_func_lens);
+	prog_addrs = (__u64 *)(uintptr_t)(info->jited_ksyms);
+
 	if (info->btf_id) {
 		struct btf_node *node;
 
diff --git a/tools/perf/util/bpf-event.h b/tools/perf/util/bpf-event.h
index 60d2c6637af5d6..da4eeb4a1a7320 100644
--- a/tools/perf/util/bpf-event.h
+++ b/tools/perf/util/bpf-event.h
@@ -40,7 +40,7 @@ struct btf_node {
 int machine__process_bpf(struct machine *machine, union perf_event *event,
 			 struct perf_sample *sample);
 int evlist__add_bpf_sb_event(struct evlist *evlist, struct perf_env *env);
-void __bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
+void __bpf_event__print_bpf_prog_info(struct perf_bpil *info_linear,
 				      struct perf_env *env,
 				      FILE *fp);
 void bpf_metadata_free(struct bpf_metadata *metadata);
@@ -58,7 +58,7 @@ static inline int evlist__add_bpf_sb_event(struct evlist *evlist __maybe_unused,
 	return 0;
 }
 
-static inline void __bpf_event__print_bpf_prog_info(struct bpf_prog_info *info __maybe_unused,
+static inline void __bpf_event__print_bpf_prog_info(struct perf_bpil *info_linear __maybe_unused,
 						    struct perf_env *env __maybe_unused,
 						    FILE *fp __maybe_unused)
 {
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 233c313bf3311a..3547cbd5ca8d23 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -880,6 +880,12 @@ static ssize_t bpf_read(struct dso *dso, u64 offset, char *data)
 		return -1;
 	}
 
+	/* jited_prog_insns is only valid if bpil_offs_to_addr() converted it */
+	if (!(node->info_linear->arrays & (1UL << PERF_BPIL_JITED_INSNS))) {
+		dso__data(dso)->status = DSO_DATA_STATUS_ERROR;
+		return -1;
+	}
+
 	len = node->info_linear->info.jited_prog_len;
 	buf = (u8 *)(uintptr_t)node->info_linear->info.jited_prog_insns;
 
@@ -1988,6 +1994,10 @@ const u8 *dso__read_symbol(struct dso *dso, const char *symfs_filename,
 			return NULL;
 		}
 		info_linear = info_node->info_linear;
+		if (!(info_linear->arrays & (1UL << PERF_BPIL_JITED_INSNS))) {
+			errno = SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF;
+			return NULL;
+		}
 		assert(len <= info_linear->info.jited_prog_len);
 		*out_buf_len = len;
 		return (const u8 *)(uintptr_t)(info_linear->info.jited_prog_insns);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7b641a569af139..7bea1c41ced790 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2058,8 +2058,7 @@ static void print_bpf_prog_info(struct feat_fd *ff __maybe_unused, FILE *fp)
 		node = rb_entry(next, struct bpf_prog_info_node, rb_node);
 		next = rb_next(&node->rb_node);
 
-		__bpf_event__print_bpf_prog_info(&node->info_linear->info,
-						 env, fp);
+		__bpf_event__print_bpf_prog_info(node->info_linear, env, fp);
 	}
 
 	up_read(&env->bpf_progs.lock);
-- 
2.53.0



