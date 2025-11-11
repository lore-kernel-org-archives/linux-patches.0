Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4364C97;
	Tue, 11 Nov 2025 00:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822784; cv=none; b=L7EGQYt6oP4IYSGHQynBYM6NYkDnflkZ3NUANpxFe5bCe5J880c9VeHcPO6XgY4bet118+w77vK0rWA0hcsT2G/FJEI8JlKfD5OBZRMnAfU+QaquWKVCNaclRaYur5IlsmZwv0amfwFCkrWZivHCTcRQZXc9b36kjluMnrLieYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822784; c=relaxed/simple;
	bh=31Y1PY+3Dz4KHWYTliFURboga9h8tAvwkwiqzowDVUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqblAYN7YsnHUSFxWSTvBMw+hKa+4PINSLLcQH8Wcra4QSRRGlTZmjYzRozsf0vFOspNMmRY7h+DTXKNbBE305jC5VkHjJwQDvXB5UhXO1D7ILL2NYZa4Jfb98TEENIjfIOsAiHFEIS6emB0K82PFavlCfqN+rw+I26PB/QfKuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cumO03UT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cumO03UT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7D9C19421;
	Tue, 11 Nov 2025 00:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822783;
	bh=31Y1PY+3Dz4KHWYTliFURboga9h8tAvwkwiqzowDVUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cumO03UTHJE/zg1B/lfvBaeVBE5jBb1zXSEqEUlcoZAmjiFhvTcZ4Hf9O0pn5BdL6
	 9JekkPtudAoNSktc4BQqzDBIpW4XOJCRB7/R4/0d9GJPWZ5hJokfus9+rmkFgK0fJo
	 S0DNZiJ1EqCDEIFmhYnSE6HGLWb+xFLMsQmzVs4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/565] bpftool: Add CET-aware symbol matching for x86_64 architectures
Date: Tue, 11 Nov 2025 09:39:24 +0900
Message-ID: <20251111004529.386438027@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 6417ca85305ecaffef13cf9063ac35da8fba8500 ]

Adjust symbol matching logic to account for Control-flow Enforcement
Technology (CET) on x86_64 systems. CET prefixes functions with
a 4-byte 'endbr' instruction, shifting the actual hook entry point to
symbol + 4.

Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Quentin Monnet <qmo@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20250829061107.23905-3-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/link.c | 54 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 5cd503b763d72..9ce15febc6f25 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -282,11 +282,52 @@ get_addr_cookie_array(__u64 *addrs, __u64 *cookies, __u32 count)
 	return data;
 }
 
+static bool is_x86_ibt_enabled(void)
+{
+#if defined(__x86_64__)
+	struct kernel_config_option options[] = {
+		{ "CONFIG_X86_KERNEL_IBT", },
+	};
+	char *values[ARRAY_SIZE(options)] = { };
+	bool ret;
+
+	if (read_kernel_config(options, ARRAY_SIZE(options), values, NULL))
+		return false;
+
+	ret = !!values[0];
+	free(values[0]);
+	return ret;
+#else
+	return false;
+#endif
+}
+
+static bool
+symbol_matches_target(__u64 sym_addr, __u64 target_addr, bool is_ibt_enabled)
+{
+	if (sym_addr == target_addr)
+		return true;
+
+	/*
+	 * On x86_64 architectures with CET (Control-flow Enforcement Technology),
+	 * function entry points have a 4-byte 'endbr' instruction prefix.
+	 * This causes kprobe hooks to target the address *after* 'endbr'
+	 * (symbol address + 4), preserving the CET instruction.
+	 * Here we check if the symbol address matches the hook target address
+	 * minus 4, indicating a CET-enabled function entry point.
+	 */
+	if (is_ibt_enabled && sym_addr == target_addr - 4)
+		return true;
+
+	return false;
+}
+
 static void
 show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
 {
 	struct addr_cookie *data;
 	__u32 i, j = 0;
+	bool is_ibt_enabled;
 
 	jsonw_bool_field(json_wtr, "retprobe",
 			 info->kprobe_multi.flags & BPF_F_KPROBE_MULTI_RETURN);
@@ -306,11 +347,13 @@ show_kprobe_multi_json(struct bpf_link_info *info, json_writer_t *wtr)
 	if (!dd.sym_count)
 		goto error;
 
+	is_ibt_enabled = is_x86_ibt_enabled();
 	for (i = 0; i < dd.sym_count; i++) {
-		if (dd.sym_mapping[i].address != data[j].addr)
+		if (!symbol_matches_target(dd.sym_mapping[i].address,
+					   data[j].addr, is_ibt_enabled))
 			continue;
 		jsonw_start_object(json_wtr);
-		jsonw_uint_field(json_wtr, "addr", dd.sym_mapping[i].address);
+		jsonw_uint_field(json_wtr, "addr", (unsigned long)data[j].addr);
 		jsonw_string_field(json_wtr, "func", dd.sym_mapping[i].name);
 		/* Print null if it is vmlinux */
 		if (dd.sym_mapping[i].module[0] == '\0') {
@@ -716,6 +759,7 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 {
 	struct addr_cookie *data;
 	__u32 i, j = 0;
+	bool is_ibt_enabled;
 
 	if (!info->kprobe_multi.count)
 		return;
@@ -739,12 +783,14 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 	if (!dd.sym_count)
 		goto error;
 
+	is_ibt_enabled = is_x86_ibt_enabled();
 	printf("\n\t%-16s %-16s %s", "addr", "cookie", "func [module]");
 	for (i = 0; i < dd.sym_count; i++) {
-		if (dd.sym_mapping[i].address != data[j].addr)
+		if (!symbol_matches_target(dd.sym_mapping[i].address,
+					   data[j].addr, is_ibt_enabled))
 			continue;
 		printf("\n\t%016lx %-16llx %s",
-		       dd.sym_mapping[i].address, data[j].cookie, dd.sym_mapping[i].name);
+		       (unsigned long)data[j].addr, data[j].cookie, dd.sym_mapping[i].name);
 		if (dd.sym_mapping[i].module[0] != '\0')
 			printf(" [%s]  ", dd.sym_mapping[i].module);
 		else
-- 
2.51.0



