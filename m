Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14627388E40;
	Tue, 21 Jul 2026 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661067; cv=none; b=uM8XbZ59tJkDDM7CEVnDn/V3xa7Crf6dxjaffva5MVUG5T91wveWu3luAAWlUILdk+pOvr0OlDisxtq7MuUa/xUbTuiVlN27u3ES4Oz6RjZSsMYq92GpxREcFqmuyptdpEFRvanMdVSrt6+DyyCtZ4qbtYN+Yz+mHx09bx5lHro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661067; c=relaxed/simple;
	bh=GyoJpHbC/xnWzEWnzW1diIp0+2bUox3uKWIwcqq3zZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYDrB/0IQNFaRG31G6OkkArhOVCCa0GiJwybxQdlZp2IthXHB35iktLJI/XHITB+AK4tE13Nw3BSCkvrtqd/5gQ0GllprVSBsnon82w6EbJNM5OjaGm+IhI5MjI7aTA7z9b88H81pHu9ZbaT0hqSJJb7cu0KQv95pbd2+uROyxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2p0jNMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2p0jNMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B691F000E9;
	Tue, 21 Jul 2026 19:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661066;
	bh=yrWFyfAbF2c+FZ+xY4UY3+IoVt8JNJDK40ril23b1KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2p0jNMikm94N+hkCGuJo5ROJV4gPCzf9IvWVYL9JzC6JS0Mu1yX5ggSLbGEDdvGZ
	 6WovjNrbiEfi34Oqi2ZJ+Hn+Rj6YuM52EPxARycYTV4we/heYum6wkvzTfT3nLe3cp
	 Vajb0iI/16+4nTdnF0beZOgo4ASXTzs0IttiPVjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1218/2077] selftests/bpf: Cover small conntrack opts error writes
Date: Tue, 21 Jul 2026 17:14:51 +0200
Message-ID: <20260721152621.543916994@linuxfoundation.org>
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

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit 38ba6d43af3844ae502092ee9dcc47214e82acb8 ]

Add a conntrack kfunc regression check for opts__sz values that do not
cover opts->error. The BPF program initializes opts->error with a guard
value, calls the lookup and allocation kfuncs with opts__sz set to
sizeof(opts->netns_id), and verifies that the guard is still intact
after the kfunc returns NULL.

Without the conntrack wrapper guard, the kfunc error path overwrites
that guard with -EINVAL even though the verifier checked only the first
four bytes of the options object.

Fixes: b4c2b9593a1c ("net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF")
Fixes: d7e79c97c00c ("net: netfilter: Add kfuncs to allocate and insert CT")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/r/007dfd0341cd84560e4795a2a951cc56d4adff1d.1781765747.git.chenyy23@mails.tsinghua.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  6 +++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 215878ea04deec..4b06a549071449 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -5,6 +5,8 @@
 #include "test_bpf_nf.skel.h"
 #include "test_bpf_nf_fail.skel.h"
 
+#define CT_OPTS_ERROR_GUARD 0x12345678
+
 static char log_buf[1024 * 1024];
 
 struct {
@@ -119,6 +121,10 @@ static void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_einval_reserved_new, -EINVAL, "Test EINVAL for reserved in new struct not set to 0");
 	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
 	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
+	ASSERT_EQ(skel->bss->test_einval_len_opts_small_lookup, CT_OPTS_ERROR_GUARD,
+		  "Test no error write for lookup opts__sz before error field");
+	ASSERT_EQ(skel->bss->test_einval_len_opts_small_alloc, CT_OPTS_ERROR_GUARD,
+		  "Test no error write for alloc opts__sz before error field");
 	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
 	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
 	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 076fbf03a1268f..df43649ecb7854 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -10,6 +10,8 @@
 #define EINVAL 22
 #define ENOENT 2
 
+#define CT_OPTS_ERROR_GUARD 0x12345678
+
 #define NF_CT_ZONE_DIR_ORIG (1 << IP_CT_DIR_ORIGINAL)
 #define NF_CT_ZONE_DIR_REPL (1 << IP_CT_DIR_REPLY)
 
@@ -19,6 +21,8 @@ int test_einval_reserved = 0;
 int test_einval_reserved_new = 0;
 int test_einval_netns_id = 0;
 int test_einval_len_opts = 0;
+int test_einval_len_opts_small_lookup = 0;
+int test_einval_len_opts_small_alloc = 0;
 int test_eproto_l4proto = 0;
 int test_enonet_netns_id = 0;
 int test_enoent_lookup = 0;
@@ -124,6 +128,28 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 	else
 		test_einval_len_opts = opts_def.error;
 
+	opts_def.error = CT_OPTS_ERROR_GUARD;
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def.netns_id));
+	if (ct) {
+		bpf_ct_release(ct);
+		test_einval_len_opts_small_lookup = -EINVAL;
+	} else {
+		test_einval_len_opts_small_lookup = opts_def.error;
+	}
+
+	opts_def.error = CT_OPTS_ERROR_GUARD;
+	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		      sizeof(opts_def.netns_id));
+	if (ct) {
+		ct = bpf_ct_insert_entry(ct);
+		if (ct)
+			bpf_ct_release(ct);
+		test_einval_len_opts_small_alloc = -EINVAL;
+	} else {
+		test_einval_len_opts_small_alloc = opts_def.error;
+	}
+
 	opts_def.l4proto = IPPROTO_ICMP;
 	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
 		       sizeof(opts_def));
-- 
2.53.0



