Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96972D8376;
	Tue, 21 Jul 2026 20:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666676; cv=none; b=RIbxtTAzuIN/5zs9BKnyyUVrrDNywUEnbpxA4gXCHbhqRm9Py9M40DVBKGeXTrusZ9iCcmolo/vAM4chzaDa3led5PeOOg5wspPcNdxzIG9k6UTUj9LPuhb8STPJKLhlNpEtfCq6yhA09Fd8Hq04pjmx3xk3BadtHQTinZNczsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666676; c=relaxed/simple;
	bh=qfyweJNVd7maCaMMNkp/93TmJYNXV4vBqmVJ2ssLv0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKGXBIm8j1Kt9xM3sM/iTq5PqXsRRpt8OfIUqKiLVzfl14yMteIkFNSkUx2krr8qaCHcnU60wQHpbl1dW+vMsL3kzF9VWf1r3SR17yU5RLHvAR3da0akaOr8YTOlWxGRXjTWfhoN6Hv1eT4UINrLdmSwTvMNA5SUiNlqkDFYSI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KASVfXNR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KASVfXNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE181F000E9;
	Tue, 21 Jul 2026 20:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666675;
	bh=Ez1zuZ/u+J7FLla1dEsPfoBmr646uYuXtXim6KzNAt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KASVfXNRdCADWKONmmiNbLPc65GD0CVg2nCOak++TZS/AJM2v+taC4wqwaCHwxh9t
	 RBGQaFUgpyJiD6sEm2/2JhNVzvASW/H1XBDawEV86zNnUAvvjH3+lGm44HYnAN0sHz
	 7T5YTep+Pahy/hXkRICPIQMx7ldpCEtw+JJPx4Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0772/1266] bpf, lsm: Add disabled BPF LSM hook list
Date: Tue, 21 Jul 2026 17:20:09 +0200
Message-ID: <20260721152459.140898269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 21c7063f6d08ab9afa088584939791bee0c177e5 ]

Add a disabled hooks list for BPF LSM. progs being attached to the
listed hooks will be rejected by the verifier.

Suggested-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20240719110059.797546-2-xukuohai@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Stable-dep-of: 12091470c6b4 ("bpf: Disable xfrm_decode_session hook attachment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 92486a7b916e38..c7c4201644322b 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -36,6 +36,24 @@ BTF_SET_START(bpf_lsm_hooks)
 #undef LSM_HOOK
 BTF_SET_END(bpf_lsm_hooks)
 
+BTF_SET_START(bpf_lsm_disabled_hooks)
+BTF_ID(func, bpf_lsm_vm_enough_memory)
+BTF_ID(func, bpf_lsm_inode_need_killpriv)
+BTF_ID(func, bpf_lsm_inode_getsecurity)
+BTF_ID(func, bpf_lsm_inode_listsecurity)
+BTF_ID(func, bpf_lsm_inode_copy_up_xattr)
+BTF_ID(func, bpf_lsm_getselfattr)
+BTF_ID(func, bpf_lsm_getprocattr)
+BTF_ID(func, bpf_lsm_setprocattr)
+#ifdef CONFIG_KEYS
+BTF_ID(func, bpf_lsm_key_getsecurity)
+#endif
+#ifdef CONFIG_AUDIT
+BTF_ID(func, bpf_lsm_audit_rule_match)
+#endif
+BTF_ID(func, bpf_lsm_ismaclabel)
+BTF_SET_END(bpf_lsm_disabled_hooks)
+
 /* List of LSM hooks that should operate on 'current' cgroup regardless
  * of function signature.
  */
@@ -97,15 +115,24 @@ void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 			const struct bpf_prog *prog)
 {
+	u32 btf_id = prog->aux->attach_btf_id;
+	const char *func_name = prog->aux->attach_func_name;
+
 	if (!prog->gpl_compatible) {
 		bpf_log(vlog,
 			"LSM programs must have a GPL compatible license\n");
 		return -EINVAL;
 	}
 
-	if (!btf_id_set_contains(&bpf_lsm_hooks, prog->aux->attach_btf_id)) {
+	if (btf_id_set_contains(&bpf_lsm_disabled_hooks, btf_id)) {
+		bpf_log(vlog, "attach_btf_id %u points to disabled hook %s\n",
+			btf_id, func_name);
+		return -EINVAL;
+	}
+
+	if (!btf_id_set_contains(&bpf_lsm_hooks, btf_id)) {
 		bpf_log(vlog, "attach_btf_id %u points to wrong type name %s\n",
-			prog->aux->attach_btf_id, prog->aux->attach_func_name);
+			btf_id, func_name);
 		return -EINVAL;
 	}
 
-- 
2.53.0



