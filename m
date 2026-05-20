Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D42356754;
	Wed, 20 May 2026 16:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294542; cv=none; b=IlREYMK0JL9bXTJ+O0lhGVjVMuTxBUXF/XVshsCDGFC2Z3gwHVk6tkqM/URepus6Jtcuuw/144eKZ/ayxclmBX/bexmaNWpH/xXtpB7awaLlV5U0R5pj+15E6rLlmc8IqEuHYf2TUPoRHA1ChPF96Xm0+HOEBKNyTqpWhUwFD3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294542; c=relaxed/simple;
	bh=2hwO071DZe1IdTHtWe2iaxBWQcXmyOM0UGB5L5X8maU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6pb+WyKitkK7O/EZffsLZdvvIN8Pma/UHWnjNmDAU8ChPkqui7lByPpR4/3ao8f05WBFqu9AX+nX0DNJGfwRCbwjKA8Vk50Dy9eM2TZpiN3isV1undfK0DKg1qN0HY9LuCZRxVzgb7K1yQ/lcRaDhG6MIKaLqq6qI2LghPjpDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmtBfgjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmtBfgjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D1F1F00893;
	Wed, 20 May 2026 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294540;
	bh=8pPvjNFifYx9S+QRH8n6h2GkVBQL+pSl27XUEWG0c5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmtBfgjJhAfOZbZGjmdS9rK7ZBpxW7PPj/hCfjbWTUWjx2FtDkuPpG5BtJasz6Mbe
	 lBB18/sojLWEot60MTsx8LYv4YF6P52Pq7OPDzf8zQHtVPfysKDH+yRLhk/Ke2t9yL
	 N+bSG3QPk6wyYCP0GV54Q8M2qKhn7LwJbCNhk9Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colm Harrington <colm.harrington@oracle.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0076/1146] selftests/bpf: Handle !CONFIG_SMC in bpf_smc.c
Date: Wed, 20 May 2026 18:05:26 +0200
Message-ID: <20260520162150.074724881@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit e95e85b8914be1c951a1ead34b1353592719e26e ]

Currently BPF selftests will fail to compile if CONFIG_SMC
is not set.

Use BPF CO-RE to work around the case where CONFIG_SMC is
not set; use ___local variants of relevant structures and
utilize bpf_core_field_exists() for net->smc.

The test continues to pass where

  CONFIG_SMC=y
  CONFIG_SMC_HS_CTRL_BPF=y

but these changes allow the selftests to build in the absence
of CONFIG_SMC=y.

Also ensure that we get a pure skip rather than a skip+fail
by removing the SMC is unsupported part from the ASSERT_FALSE()
in get_smc_nl_family(); doing this means we get a skip without
a fail when CONFIG_SMC is not set:

$ sudo ./test_progs -t bpf_smc
Summary: 1/0 PASSED, 1 SKIPPED, 0 FAILED

Fixes: beb3c67297d9 ("bpf/selftests: Add selftest for bpf_smc_hs_ctrl")
Reported-by: Colm Harrington <colm.harrington@oracle.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Tested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://patch.msgid.link/20260310111330.601765-1-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/test_bpf_smc.c   |  6 ++--
 tools/testing/selftests/bpf/progs/bpf_smc.c   | 28 +++++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_bpf_smc.c b/tools/testing/selftests/bpf/prog_tests/test_bpf_smc.c
index de22734abc4d2..40d38280c091e 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_bpf_smc.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_bpf_smc.c
@@ -131,8 +131,10 @@ static bool get_smc_nl_family_id(void)
 		goto fail;
 
 	ret = recv(fd, &msg, sizeof(msg), 0);
-	if (!ASSERT_FALSE(msg.n.nlmsg_type == NLMSG_ERROR || ret < 0 ||
-			  !NLMSG_OK(&msg.n, ret), "nl_family response"))
+	if (msg.n.nlmsg_type == NLMSG_ERROR)
+		goto fail;
+	if (!ASSERT_FALSE(ret < 0 || !NLMSG_OK(&msg.n, ret),
+			  "nl_family response"))
 		goto fail;
 
 	nl = (struct nlattr *)GENLMSG_DATA(&msg);
diff --git a/tools/testing/selftests/bpf/progs/bpf_smc.c b/tools/testing/selftests/bpf/progs/bpf_smc.c
index 70d8b08f59140..6263a45bf0066 100644
--- a/tools/testing/selftests/bpf/progs/bpf_smc.c
+++ b/tools/testing/selftests/bpf/progs/bpf_smc.c
@@ -8,6 +8,10 @@
 
 char _license[] SEC("license") = "GPL";
 
+#ifndef SMC_HS_CTRL_NAME_MAX
+#define SMC_HS_CTRL_NAME_MAX 16
+#endif
+
 enum {
 	BPF_SMC_LISTEN	= 10,
 };
@@ -18,6 +22,20 @@ struct smc_sock___local {
 	bool use_fallback;
 } __attribute__((preserve_access_index));
 
+struct smc_hs_ctrl___local {
+	char name[SMC_HS_CTRL_NAME_MAX];
+	int (*syn_option)(struct tcp_sock *);
+	int (*synack_option)(const struct tcp_sock  *, struct inet_request_sock *);
+} __attribute__((preserve_access_index));
+
+struct netns_smc___local {
+	struct smc_hs_ctrl___local *hs_ctrl;
+} __attribute__((preserve_access_index));
+
+struct net___local {
+	struct netns_smc___local smc;
+} __attribute__((preserve_access_index));
+
 int smc_cnt = 0;
 int fallback_cnt = 0;
 
@@ -88,8 +106,14 @@ int BPF_PROG(smc_run, int family, int type, int protocol)
 
 	task = bpf_get_current_task_btf();
 	/* Prevent from affecting other tests */
-	if (!task || !task->nsproxy->net_ns->smc.hs_ctrl)
+	if (!task) {
 		return protocol;
+	} else {
+		struct net___local *net = (struct net___local *)task->nsproxy->net_ns;
+
+		if (!bpf_core_field_exists(struct net___local, smc) || !net->smc.hs_ctrl)
+			return protocol;
+	}
 
 	return IPPROTO_SMC;
 }
@@ -110,7 +134,7 @@ int BPF_PROG(bpf_smc_set_tcp_option, struct tcp_sock *tp)
 }
 
 SEC(".struct_ops")
-struct smc_hs_ctrl  linkcheck = {
+struct smc_hs_ctrl___local  linkcheck = {
 	.name		= "linkcheck",
 	.syn_option	= (void *)bpf_smc_set_tcp_option,
 	.synack_option	= (void *)bpf_smc_set_tcp_option_cond,
-- 
2.53.0



