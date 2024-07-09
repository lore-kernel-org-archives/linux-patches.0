Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0C13A25F;
	Tue,  9 Jul 2024 11:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523939; cv=none; b=C284E2pkj4M4wiG2gA8dd9GedkJbWV5l1GT95a2UVfdrgfuu/+zbhoO/ds3h8N1oeD3nXdB+RdaKx+FbuZlU+EvzJjiyihRV6VsXM6MZnYZUbGsFKmkvs4CH6Qzn1z76k1P1YmFo288wXHVc+qxx+BqZT0YcXgwVDO4COPKxI74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523939; c=relaxed/simple;
	bh=OLqvBd+8jViJ8vPFjRf368YSxQjSm4V106YetB+eX9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGyAtD9jTFu7BZlKIGx2w1gA0Qwoe2EsOU7RKaunXPN2vI9e47swvVCdoGe4rEWijuFRQ84zmxbCmZwuueChM+6FO5W8gNoyl2YS2VOBZJtYl6JoHcCG/PFDCwgQQhwjQTMRzkK6luczBwzVHuIEZgHyR0uqzhnYY6R6BizJguA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2B0GXKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2B0GXKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6398FC3277B;
	Tue,  9 Jul 2024 11:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523938;
	bh=OLqvBd+8jViJ8vPFjRf368YSxQjSm4V106YetB+eX9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2B0GXKGKCMjGaDgSqY+Z/1jrypqT1z8tQXEqgVr7w7ibp4I4rlfxynqNj4SlgL09
	 lfImo5QyReZDk5Wta4FqAI/M1rZTfylsHq2HuUjp0Bk4FSPbPoJzJmPz12VgY1CWpt
	 78lXhsXHrnG55/rUPNqSxuyYTjG3t2X1SS4hQniM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <sinquersw@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 019/197] bpf: check bpf_dummy_struct_ops program params for test runs
Date: Tue,  9 Jul 2024 13:07:53 +0200
Message-ID: <20240709110709.659766014@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 980ca8ceeae69ddf362870ea9183f389ae26324a ]

When doing BPF_PROG_TEST_RUN for bpf_dummy_struct_ops programs,
reject execution when NULL is passed for non-nullable params.
For programs with non-nullable params verifier assumes that
such params are never NULL and thus might optimize out NULL checks.

Suggested-by: Kui-Feng Lee <sinquersw@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240424012821.595216-5-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/bpf_dummy_struct_ops.c | 51 +++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
index fdbe30ad8db2f..7236349cf0598 100644
--- a/net/bpf/bpf_dummy_struct_ops.c
+++ b/net/bpf/bpf_dummy_struct_ops.c
@@ -79,6 +79,51 @@ static int dummy_ops_call_op(void *image, struct bpf_dummy_ops_test_args *args)
 		    args->args[3], args->args[4]);
 }
 
+static const struct bpf_ctx_arg_aux *find_ctx_arg_info(struct bpf_prog_aux *aux, int offset)
+{
+	int i;
+
+	for (i = 0; i < aux->ctx_arg_info_size; i++)
+		if (aux->ctx_arg_info[i].offset == offset)
+			return &aux->ctx_arg_info[i];
+
+	return NULL;
+}
+
+/* There is only one check at the moment:
+ * - zero should not be passed for pointer parameters not marked as nullable.
+ */
+static int check_test_run_args(struct bpf_prog *prog, struct bpf_dummy_ops_test_args *args)
+{
+	const struct btf_type *func_proto = prog->aux->attach_func_proto;
+
+	for (u32 arg_no = 0; arg_no < btf_type_vlen(func_proto) ; ++arg_no) {
+		const struct btf_param *param = &btf_params(func_proto)[arg_no];
+		const struct bpf_ctx_arg_aux *info;
+		const struct btf_type *t;
+		int offset;
+
+		if (args->args[arg_no] != 0)
+			continue;
+
+		/* Program is validated already, so there is no need
+		 * to check if t is NULL.
+		 */
+		t = btf_type_skip_modifiers(bpf_dummy_ops_btf, param->type, NULL);
+		if (!btf_type_is_ptr(t))
+			continue;
+
+		offset = btf_ctx_arg_offset(bpf_dummy_ops_btf, func_proto, arg_no);
+		info = find_ctx_arg_info(prog->aux, offset);
+		if (info && (info->reg_type & PTR_MAYBE_NULL))
+			continue;
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 extern const struct bpf_link_ops bpf_struct_ops_link_lops;
 
 int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
@@ -87,7 +132,7 @@ int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
 	const struct bpf_struct_ops *st_ops = &bpf_bpf_dummy_ops;
 	const struct btf_type *func_proto;
 	struct bpf_dummy_ops_test_args *args;
-	struct bpf_tramp_links *tlinks;
+	struct bpf_tramp_links *tlinks = NULL;
 	struct bpf_tramp_link *link = NULL;
 	void *image = NULL;
 	unsigned int op_idx;
@@ -109,6 +154,10 @@ int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (IS_ERR(args))
 		return PTR_ERR(args);
 
+	err = check_test_run_args(prog, args);
+	if (err)
+		goto out;
+
 	tlinks = kcalloc(BPF_TRAMP_MAX, sizeof(*tlinks), GFP_KERNEL);
 	if (!tlinks) {
 		err = -ENOMEM;
-- 
2.43.0



