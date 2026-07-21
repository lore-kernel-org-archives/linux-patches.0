Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59233C73F6;
	Tue, 21 Jul 2026 21:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669616; cv=none; b=hbQDq+BgtwjcMcyLpUJiE+Zbh1cQ8g7Hjgy4vWXeUi9s3B2yWmsW6PqlIDdDYE1tesoZz0sWqjy9Q4T/RnnWQlm18wP0YyAojQBRBEGnJTw1MlLEohuFpM31XXaPeQvYlU7tnzFq3zloLXo4lVb9gDAzNUnvD96jGiL3op01fAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669616; c=relaxed/simple;
	bh=v/eJedN+9jaXZz5YeCHamLJu+5ToXczYbdhm7l9rtQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICRJz8leO/7wyXY1gi212265iNbuiBr/o3Z9hpU01KMsRYOHBSLzCDEooUwHJ19XGMZqECai2n4HXkEt/gSuFkwj3fSnCTrv0BU6wCnM1JwcwwhZy5KvMU9ZA0C+EATC6LsyNcaEBgfm/mrIQ5A3C86Z7cp9vqyXqJyK0XbY0gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsV46yNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsV46yNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5E81F00A3A;
	Tue, 21 Jul 2026 21:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669613;
	bh=KPV+pB6EkUl9CfmbuDVADgLtpbyDqjHQvIr9hem0xRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsV46yNV05CJGea9L80cz5QapVXdz0KaevEV/j+yow6RjtZ9DB7ceq/8JaND2SfaH
	 6d1SgR2Ions0MjPr7cSDGIAliTzTnyhsF9dtWcwGUDomukBBQKsicdfZZw8ILc+VHI
	 qYHkSO8o9syDmvHW025u48VN20V5FPaNnrKtgxTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0622/1067] bpf, lsm: Add disabled BPF LSM hook list
Date: Tue, 21 Jul 2026 17:20:23 +0200
Message-ID: <20260721152438.514565266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 075c06aa9c951e..39f398ca798c47 100644
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



