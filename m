Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674D14C97;
	Tue, 11 Nov 2025 00:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822670; cv=none; b=S0g7oY+Yf0lYdPyZKzWvfwCe2/0pxMFiEQamgiEbKX3NzN/h7s31sLfDDZnROwh3ZyMBugi2PunPCIA3q6kVFWwZcDHcvwJet2AIyG0stLHJceWxXXlTWEA1cWs0e14C5ecUtvrQkzyzFR8DWYSHU82PuMwOe8crjjNz2v7BOy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822670; c=relaxed/simple;
	bh=mvxqgDY/ZwZDY0G1szpA/vulWeCZS2hp7etNuFGo4q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TceKQ4bzQ8r7498s3WGIu7ac1lsc0IlqcYZuVztgDz5GMbTRUWz2Gso4kTkHfPcfyHW3hzfC9jY2VzdhkG5aXq54FP7JeQHcf7zS8Nu7+wNYrNSzZappzXOYazprtaOVcxJboZdWaVp1UEhM1Sg0vFZtZzi+hI4NT6Ax1DD7Zvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaXwUHU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaXwUHU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF248C19421;
	Tue, 11 Nov 2025 00:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822670;
	bh=mvxqgDY/ZwZDY0G1szpA/vulWeCZS2hp7etNuFGo4q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaXwUHU9XVL06TveT89I4dP6QEKtGI/sFCVWeL1ebIFPY7zmfD9EmCCQDAca3PgN6
	 hxFZ59M+7q9KqZUVDJjI5jbYMNg37Za2UzdeX93q0jvH+eoShQpa2mIyLrDd6zEHg6
	 bTMIPHznRznOyBAdKHcxmHYZQe03PxSGa6ZL4F2Y=
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
Subject: [PATCH 6.17 145/849] bpftool: Add CET-aware symbol matching for x86_64 architectures
Date: Tue, 11 Nov 2025 09:35:15 +0900
Message-ID: <20251111004539.911440769@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a773e05d5ade4..bdcd717b0348f 100644
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
@@ -719,6 +762,7 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
 {
 	struct addr_cookie *data;
 	__u32 i, j = 0;
+	bool is_ibt_enabled;
 
 	if (!info->kprobe_multi.count)
 		return;
@@ -742,12 +786,14 @@ static void show_kprobe_multi_plain(struct bpf_link_info *info)
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



