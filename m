Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2477624A06D;
	Wed, 25 Feb 2026 01:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982930; cv=none; b=Qf5z+FgBPxdn7kn8yPt5ByVKGMqChoCdri98ydXv/iIU6HruYgMExdBbQMSYST0xBnMoNB477S/hfpp/JcHQeUkFVNmwGpDEEKYSmMjQ6pq2GgCY+4w43MA4fHlrpVjgzJ3xcCxl6OCyv0UU4/ZSg43QRSiFglDY3bA8UhzSsAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982930; c=relaxed/simple;
	bh=4mnaiSowEEG4AARCcOPacaU42SbOqpd+aV+YmgsMnGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJseUTInvDgTQKAt2QZ4S3WxFGE/kHazQzR6EHJvgu/yULjbxiivOSCkT0t7ImKPPAXzKvm1oXZXz10hu2UpNe/D8c5N0p0GyLeWDvC+KBRg7nu++19q5HQ5ZGI+JtXeNzDOM0MX9F1JG7VKMotWHt3ac9WKGkkyd2J/WHsRKN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WschnhJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WschnhJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEFFC19423;
	Wed, 25 Feb 2026 01:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982930;
	bh=4mnaiSowEEG4AARCcOPacaU42SbOqpd+aV+YmgsMnGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WschnhJA2ouySj1xBR5h5XUlAJgy4s031vr6ow7R4IAqX7Ln1GggBbNnFbQ9Ze41T
	 nS4n1CHdaIn/ETtD7rWbRJgQC/aMHJMexIGCuSI2waToTqgJuGIVVc+JnsdffFvUeB
	 g3D9SNYU9x5eKkhE0+OhlMuVcLPP60XXeUPh/EdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 107/781] ftrace,bpf: Remove FTRACE_OPS_FL_JMP ftrace_ops flag
Date: Tue, 24 Feb 2026 17:13:36 -0800
Message-ID: <20260225012402.308503399@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4be42c92220128b3128854a2d6b0f0ad0bcedbdb ]

At the moment the we allow the jmp attach only for ftrace_ops that
has FTRACE_OPS_FL_JMP set. This conflicts with following changes
where we use single ftrace_ops object for all direct call sites,
so all could be be attached via just call or jmp.

We already limit the jmp attach support with config option and bit
(LSB) set on the trampoline address. It turns out that's actually
enough to limit the jmp attach for architecture and only for chosen
addresses (with LSB bit set).

Each user of register_ftrace_direct or modify_ftrace_direct can set
the trampoline bit (LSB) to indicate it has to be attached by jmp.

The bpf trampoline generation code uses trampoline flags to generate
jmp-attach specific code and ftrace inner code uses the trampoline
bit (LSB) to handle return from jmp attachment, so there's no harm
to remove the FTRACE_OPS_FL_JMP bit.

The fexit/fmodret performance stays the same (did not drop),
current code:

  fentry         :   77.904 ± 0.546M/s
  fexit          :   62.430 ± 0.554M/s
  fmodret        :   66.503 ± 0.902M/s

with this change:

  fentry         :   80.472 ± 0.061M/s
  fexit          :   63.995 ± 0.127M/s
  fmodret        :   67.362 ± 0.175M/s

Fixes: 25e4e3565d45 ("ftrace: Introduce FTRACE_OPS_FL_JMP")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/bpf/20251230145010.103439-2-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace.h  |  1 -
 kernel/bpf/trampoline.c | 32 ++++++++++++++------------------
 kernel/trace/ftrace.c   | 14 --------------
 3 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index a3a8989e3268d..cc869c59c1a68 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -359,7 +359,6 @@ enum {
 	FTRACE_OPS_FL_DIRECT			= BIT(17),
 	FTRACE_OPS_FL_SUBOP			= BIT(18),
 	FTRACE_OPS_FL_GRAPH			= BIT(19),
-	FTRACE_OPS_FL_JMP			= BIT(20),
 };
 
 #ifndef CONFIG_DYNAMIC_FTRACE_WITH_ARGS
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 976d89011b157..b9a358d7a78f1 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -214,10 +214,15 @@ static int modify_fentry(struct bpf_trampoline *tr, u32 orig_flags,
 	int ret;
 
 	if (tr->func.ftrace_managed) {
+		unsigned long addr = (unsigned long) new_addr;
+
+		if (bpf_trampoline_use_jmp(tr->flags))
+			addr = ftrace_jmp_set(addr);
+
 		if (lock_direct_mutex)
-			ret = modify_ftrace_direct(tr->fops, (long)new_addr);
+			ret = modify_ftrace_direct(tr->fops, addr);
 		else
-			ret = modify_ftrace_direct_nolock(tr->fops, (long)new_addr);
+			ret = modify_ftrace_direct_nolock(tr->fops, addr);
 	} else {
 		ret = bpf_trampoline_update_fentry(tr, orig_flags, old_addr,
 						   new_addr);
@@ -240,10 +245,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 	}
 
 	if (tr->func.ftrace_managed) {
+		unsigned long addr = (unsigned long) new_addr;
+
+		if (bpf_trampoline_use_jmp(tr->flags))
+			addr = ftrace_jmp_set(addr);
+
 		ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
 		if (ret)
 			return ret;
-		ret = register_ftrace_direct(tr->fops, (long)new_addr);
+		ret = register_ftrace_direct(tr->fops, addr);
 	} else {
 		ret = bpf_trampoline_update_fentry(tr, 0, NULL, new_addr);
 	}
@@ -499,13 +509,6 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
 	if (err)
 		goto out_free;
 
-#ifdef CONFIG_DYNAMIC_FTRACE_WITH_JMP
-	if (bpf_trampoline_use_jmp(tr->flags))
-		tr->fops->flags |= FTRACE_OPS_FL_JMP;
-	else
-		tr->fops->flags &= ~FTRACE_OPS_FL_JMP;
-#endif
-
 	WARN_ON(tr->cur_image && total == 0);
 	if (tr->cur_image)
 		/* progs already running at this address */
@@ -533,15 +536,8 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
 	tr->cur_image = im;
 out:
 	/* If any error happens, restore previous flags */
-	if (err) {
+	if (err)
 		tr->flags = orig_flags;
-#ifdef CONFIG_DYNAMIC_FTRACE_WITH_JMP
-		if (bpf_trampoline_use_jmp(tr->flags))
-			tr->fops->flags |= FTRACE_OPS_FL_JMP;
-		else
-			tr->fops->flags &= ~FTRACE_OPS_FL_JMP;
-#endif
-	}
 	kfree(tlinks);
 	return err;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index aa758efc37314..93f617e1f191d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6049,15 +6049,8 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 	if (ftrace_hash_empty(hash))
 		return -EINVAL;
 
-	/* This is a "raw" address, and this should never happen. */
-	if (WARN_ON_ONCE(ftrace_is_jmp(addr)))
-		return -EINVAL;
-
 	mutex_lock(&direct_mutex);
 
-	if (ops->flags & FTRACE_OPS_FL_JMP)
-		addr = ftrace_jmp_set(addr);
-
 	/* Make sure requested entries are not already registered.. */
 	size = 1 << hash->size_bits;
 	for (i = 0; i < size; i++) {
@@ -6178,13 +6171,6 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	lockdep_assert_held_once(&direct_mutex);
 
-	/* This is a "raw" address, and this should never happen. */
-	if (WARN_ON_ONCE(ftrace_is_jmp(addr)))
-		return -EINVAL;
-
-	if (ops->flags & FTRACE_OPS_FL_JMP)
-		addr = ftrace_jmp_set(addr);
-
 	/* Enable the tmp_ops to have the same functions as the direct ops */
 	ftrace_ops_init(&tmp_ops);
 	tmp_ops.func_hash = ops->func_hash;
-- 
2.51.0



