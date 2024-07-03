Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0022B17DE09;
	Wed,  3 Jul 2024 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006143; cv=none; b=N7Ld3DS+WRQ9NS9MRwQwjF3sqgSaRKtzawVnZphQWTSTgUzweWmBOXzR+TaqcNMEzVCKx44Bp0VkO1gl1TnPCAD+lwOzbI7if+Z5EKReVeLUOz3n949XX9vIY52Q39h3inpAqgA+eqRW4720NEFN8yQDxrplMrEMW7k7WTV1K9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006143; c=relaxed/simple;
	bh=GP3AlTYBaxDwzf6YAcfOSqeT9SVo7ipv51DtlZa0tL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7WE6MwVyZ4IIs4ZBTxxhIiAsoim97xvu1UQtdxOL1JTFW45mfMKo0Omm+OV5mOJBwKjFlbDR7AmdUQrr0ZZAOiskvfPWA+VpdSZ2xOi8j4seEZP6mkJhvGSFVI0FfDp/BEE3Gi2FzF1RY5+wdaGhaKENOUFqgFO4gNSDbvX90Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBQuYSx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBQuYSx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC28C2BD10;
	Wed,  3 Jul 2024 11:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006142;
	bh=GP3AlTYBaxDwzf6YAcfOSqeT9SVo7ipv51DtlZa0tL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBQuYSx10/i+z4DhoBUt+2fPKLLMZVj12VPAJHFiKcb4IRg5iBM8sUYZwVrUQH0pl
	 RnP296MOAxscVDrD8Zv8iANAMj7b/IVhEnircnB6xtReeOLN97iv6+P1JZBWSdiN2L
	 erbpqS/2Hh29qcmWHAovjLrGOwHkmTOgA5LMLI5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/356] bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()
Date: Wed,  3 Jul 2024 12:40:19 +0200
Message-ID: <20240703102923.821740919@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7d2cc63eca0c993c99d18893214abf8f85d566d8 ]

set_memory_ro() can fail, leaving memory unprotected.

Check its return and take it into account as an error.

Link: https://github.com/KSPP/linux/issues/7
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linux-hardening@vger.kernel.org <linux-hardening@vger.kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Message-ID: <286def78955e04382b227cb3e4b6ba272a7442e3.1709850515.git.christophe.leroy@csgroup.eu>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h | 5 +++--
 kernel/bpf/core.c      | 4 +++-
 kernel/bpf/verifier.c  | 8 ++++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index af0103bebb7bf..9cb3558683393 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -875,14 +875,15 @@ bpf_ctx_narrow_access_offset(u32 off, u32 size, u32 size_default)
 
 #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
 
-static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
+static inline int __must_check bpf_prog_lock_ro(struct bpf_prog *fp)
 {
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 	if (!fp->jited) {
 		set_vm_flush_reset_perms(fp);
-		set_memory_ro((unsigned long)fp, fp->pages);
+		return set_memory_ro((unsigned long)fp, fp->pages);
 	}
 #endif
+	return 0;
 }
 
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 36c2896ee45f4..f36f7b71dc07b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1940,7 +1940,9 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	}
 
 finalize:
-	bpf_prog_lock_ro(fp);
+	*err = bpf_prog_lock_ro(fp);
+	if (*err)
+		return fp;
 
 	/* The tail call compatibility check can only be done at
 	 * this late stage as we need to determine, if we deal
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 07ca1157f97cf..b9f63c4b8598c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12812,10 +12812,14 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 	 * bpf_prog_load will add the kallsyms for the main program.
 	 */
 	for (i = 1; i < env->subprog_cnt; i++) {
-		bpf_prog_lock_ro(func[i]);
-		bpf_prog_kallsyms_add(func[i]);
+		err = bpf_prog_lock_ro(func[i]);
+		if (err)
+			goto out_free;
 	}
 
+	for (i = 1; i < env->subprog_cnt; i++)
+		bpf_prog_kallsyms_add(func[i]);
+
 	/* Last step: make now unused interpreter insns from main
 	 * prog consistent for later dump requests, so they can
 	 * later look the same as if they were interpreted only.
-- 
2.43.0



