Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBAB46A61C;
	Tue, 21 Jul 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655331; cv=none; b=P/Kb4Jzf/+xcUDwZaQftTkneKs4Px/+Jo+kG62I+as5et5JiQcL0RczKsHptW5+0677V64ob3ToMl6Az6ha8horSBudgN5VxbkD2UprSWHF/EQM9bsBZWRhAOAwv6QurFpYKPdR1H17IpdgtK1tdi3LRSaf1NUswlhg51R/jsEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655331; c=relaxed/simple;
	bh=MFZMfbebD9O90lyRtUEg3E+WHwK3VvdGEXXC1HZMeOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZklGGVSGJLfTl7q/+hH6C6j7LtLtE0ymmiURz5yH/5QeovC3l9x2UHRpGQfKkYs1KvOruCDVbyq9GUgcDlezW8GRtOxEb091v3ZQNddsY1iXfRWZeft+yfyx7ZXrnp3MLMfR8Wv+Zm6b+buWovom1U255D023JZ5uFOBl20PD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gq7CCL0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gq7CCL0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C754D1F000E9;
	Tue, 21 Jul 2026 17:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655330;
	bh=ggrPEDmL018Idpl3Clq/4oglyF3m8z07USzm+S0sB+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gq7CCL0TFrh0uxGQOZMupDaOk1OL7nALENQDCOyqK4xSIsDmftAOnLembD9iIr8Rp
	 Nxyjdm3yJj8TAnS1Mf6Lg2KE4anjpANVyCiA9DpLNp7GinYvquaUMATsl9Xb43c7cC
	 Kr+y7Ws8bWmn1AWeDLNJqv/D5bLdezTjEbuJ2UK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Subject: [PATCH 7.1 2044/2077] bpf: Reject negative const offsets for buffer pointers
Date: Tue, 21 Jul 2026 17:28:37 +0200
Message-ID: <20260721152640.905751962@linuxfoundation.org>
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

From: Sun Jian <sun.jian.kdev@gmail.com>

commit fd4cfa8c8f9a17cdec0539334d28754bc1d8a5d9 upstream.

The verifier rejects variable offsets for PTR_TO_TP_BUFFER and PTR_TO_BUF
accesses, but it currently accepts a constant negative offset produced by
pointer arithmetic.

Commit 022ac0750883 ("bpf: use reg->var_off instead of reg->off for
pointers") moved constant pointer offsets from reg->off to reg->var_off.
However, __check_buffer_access() continued to check only the instruction
offset. An access with reg->var_off equal to -8 and an instruction offset
of zero therefore passes verification.

For writable raw tracepoints, the access end is also calculated from the
unsigned reg->var_off.value. An eight-byte access starting at -8 wraps
the calculated end to zero, allowing the program to load and attach
without increasing max_tp_access.

After ensuring that reg->var_off is constant, calculate the effective
access start using signed arithmetic and reject it when it is negative.
Use the validated start to calculate the access end for both
PTR_TO_TP_BUFFER and PTR_TO_BUF.

Fixes: 022ac0750883 ("bpf: use reg->var_off instead of reg->off for pointers")
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: stable@vger.kernel.org # 5.2.0
Link: https://patch.msgid.link/20260714093846.18159-2-sun.jian.kdev@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5559,14 +5559,11 @@ static int check_max_stack_depth(struct
 static int __check_buffer_access(struct bpf_verifier_env *env,
 				 const char *buf_info,
 				 const struct bpf_reg_state *reg,
-				 int regno, int off, int size)
+				 int regno, int off, int size,
+				 u32 *access_end)
 {
-	if (off < 0) {
-		verbose(env,
-			"R%d invalid %s buffer access: off=%d, size=%d\n",
-			regno, buf_info, off, size);
-		return -EACCES;
-	}
+	s64 start;
+
 	if (!tnum_is_const(reg->var_off)) {
 		char tn_buf[48];
 
@@ -5577,6 +5574,15 @@ static int __check_buffer_access(struct
 		return -EACCES;
 	}
 
+	start = (s64)reg->var_off.value + off;
+	if (start < 0) {
+		verbose(env,
+			"R%d invalid negative %s buffer offset: off=%d, var_off=%lld\n",
+			regno, buf_info, off, (s64)reg->var_off.value);
+		return -EACCES;
+	}
+
+	*access_end = start + size;
 	return 0;
 }
 
@@ -5584,14 +5590,14 @@ static int check_tp_buffer_access(struct
 				  const struct bpf_reg_state *reg,
 				  int regno, int off, int size)
 {
+	u32 access_end;
 	int err;
 
-	err = __check_buffer_access(env, "tracepoint", reg, regno, off, size);
+	err = __check_buffer_access(env, "tracepoint", reg, regno, off, size, &access_end);
 	if (err)
 		return err;
 
-	env->prog->aux->max_tp_access = max(reg->var_off.value + off + size,
-					    env->prog->aux->max_tp_access);
+	env->prog->aux->max_tp_access = max(access_end, env->prog->aux->max_tp_access);
 
 	return 0;
 }
@@ -5603,13 +5609,14 @@ static int check_buffer_access(struct bp
 			       u32 *max_access)
 {
 	const char *buf_info = type_is_rdonly_mem(reg->type) ? "rdonly" : "rdwr";
+	u32 access_end;
 	int err;
 
-	err = __check_buffer_access(env, buf_info, reg, regno, off, size);
+	err = __check_buffer_access(env, buf_info, reg, regno, off, size, &access_end);
 	if (err)
 		return err;
 
-	*max_access = max(reg->var_off.value + off + size, *max_access);
+	*max_access = max(access_end, *max_access);
 
 	return 0;
 }


