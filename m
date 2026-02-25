Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE09F2D77F5;
	Wed, 25 Feb 2026 06:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002719; cv=none; b=sDzg6pB7V7qBMymMlkQXcwHtsarCnaAkdR6WV1lmVdtswTduY0ypnRsom0gAn4yFQVpJaLoUBlsfjRazY5FIDxnooahgQ2XdR+WVChaDrcbX3gt0LuEcuTKTPyIKbZMMeUbYTIxTj9Pwn73C1erk9sP5LLPLxzlAtnBs96H03DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002719; c=relaxed/simple;
	bh=W4NS5XVgYx0IOnm15nP0sQPpfDoPsbfq5c/eRo4XnDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhnBKIjDP4rmJ5PHuobhyDEDEfjqWc5+MyAxk03dkBHTkhX7zyL5e2lcrE6nrSXw7t6gtGY8T6iRJ2ZSoh7Q1f0+dAAifwEOI/+lq7ArnM+gMCesECLVyNkReWdPBvUVW7vBReIQ9OmYKqYNwr1FDan5uEfYWlf3/8UFweL7ZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmV+OnY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmV+OnY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C798DC116D0;
	Wed, 25 Feb 2026 06:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002718;
	bh=W4NS5XVgYx0IOnm15nP0sQPpfDoPsbfq5c/eRo4XnDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmV+OnY+FJkE8eYiiDH+BF2IUi5qGXckLbT7DpJ+15NLm+U063MMoqPJxAzZtn8lC
	 P87kEXrcRYxN48AsHuh4Poqy55eposQLmf0/fAzdHsQky+PGgkBXDWFXNgJC8Zyr9K
	 yaG87bhyLWuQu6nv/l3O44rxZS58+XWwOrrmaF1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5a0f1995634f7c1dadbf@syzkaller.appspotmail.com,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/641] bpf: Fix a potential use-after-free of BTF object
Date: Tue, 24 Feb 2026 17:24:14 -0800
Message-ID: <20260225012401.323106339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit ccd2d799ed4467c07f5ee18c2f5c59bcc990822c ]

Refcounting in the check_pseudo_btf_id() function is incorrect:
the __check_pseudo_btf_id() function might get called with a zero
refcounted btf. Fix this, and patch related code accordingly.

v3: rephrase a comment (AI)
v2: fix a refcount leak introduced in v1 (AI)

Reported-by: syzbot+5a0f1995634f7c1dadbf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5a0f1995634f7c1dadbf
Fixes: 76145f725532 ("bpf: Refactor check_pseudo_btf_id")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260209132904.63908-1-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 52 +++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4338d233beecf..dade674ffe071 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20219,29 +20219,29 @@ static int find_btf_percpu_datasec(struct btf *btf)
 }
 
 /*
- * Add btf to the used_btfs array and return the index. (If the btf was
- * already added, then just return the index.) Upon successful insertion
- * increase btf refcnt, and, if present, also refcount the corresponding
- * kernel module.
+ * Add btf to the env->used_btfs array. If needed, refcount the
+ * corresponding kernel module. To simplify caller's logic
+ * in case of error or if btf was added before the function
+ * decreases the btf refcount.
  */
 static int __add_used_btf(struct bpf_verifier_env *env, struct btf *btf)
 {
 	struct btf_mod_pair *btf_mod;
+	int ret = 0;
 	int i;
 
 	/* check whether we recorded this BTF (and maybe module) already */
 	for (i = 0; i < env->used_btf_cnt; i++)
 		if (env->used_btfs[i].btf == btf)
-			return i;
+			goto ret_put;
 
 	if (env->used_btf_cnt >= MAX_USED_BTFS) {
 		verbose(env, "The total number of btfs per program has reached the limit of %u\n",
 			MAX_USED_BTFS);
-		return -E2BIG;
+		ret = -E2BIG;
+		goto ret_put;
 	}
 
-	btf_get(btf);
-
 	btf_mod = &env->used_btfs[env->used_btf_cnt];
 	btf_mod->btf = btf;
 	btf_mod->module = NULL;
@@ -20250,12 +20250,18 @@ static int __add_used_btf(struct bpf_verifier_env *env, struct btf *btf)
 	if (btf_is_module(btf)) {
 		btf_mod->module = btf_try_get_module(btf);
 		if (!btf_mod->module) {
-			btf_put(btf);
-			return -ENXIO;
+			ret = -ENXIO;
+			goto ret_put;
 		}
 	}
 
-	return env->used_btf_cnt++;
+	env->used_btf_cnt++;
+	return 0;
+
+ret_put:
+	/* Either error or this BTF was already added */
+	btf_put(btf);
+	return ret;
 }
 
 /* replace pseudo btf_id with kernel symbol address */
@@ -20352,9 +20358,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 
 	btf_fd = insn[1].imm;
 	if (btf_fd) {
-		CLASS(fd, f)(btf_fd);
-
-		btf = __btf_get_by_fd(f);
+		btf = btf_get_by_fd(btf_fd);
 		if (IS_ERR(btf)) {
 			verbose(env, "invalid module BTF object FD specified.\n");
 			return -EINVAL;
@@ -20364,17 +20368,17 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
 			return -EINVAL;
 		}
+		btf_get(btf_vmlinux);
 		btf = btf_vmlinux;
 	}
 
 	err = __check_pseudo_btf_id(env, insn, aux, btf);
-	if (err)
+	if (err) {
+		btf_put(btf);
 		return err;
+	}
 
-	err = __add_used_btf(env, btf);
-	if (err < 0)
-		return err;
-	return 0;
+	return __add_used_btf(env, btf);
 }
 
 static bool is_tracing_prog_type(enum bpf_prog_type type)
@@ -24094,13 +24098,9 @@ static int add_fd_from_fd_array(struct bpf_verifier_env *env, int fd)
 		return 0;
 	}
 
-	btf = __btf_get_by_fd(f);
-	if (!IS_ERR(btf)) {
-		err = __add_used_btf(env, btf);
-		if (err < 0)
-			return err;
-		return 0;
-	}
+	btf = btf_get_by_fd(fd);
+	if (!IS_ERR(btf))
+		return __add_used_btf(env, btf);
 
 	verbose(env, "fd %d is not pointing to valid bpf_map or btf\n", fd);
 	return PTR_ERR(map);
-- 
2.51.0



