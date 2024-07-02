Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D621A1BD51B;
	Tue,  2 Jul 2024 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940143; cv=none; b=gbbl/RMNS7B2lfkt3ZRd6v2oJRR19zPEjp+QKVrfiELIkYGfF3/G7iytPyRUQ8h5j+IRzufD2H1zdax28r1LxUFOq2cIMUpV9L7Q5rLbt/NZ4YgegIeyjS0KZyrDEYRvbHFbLDNwpAT/qLStCkWJu9fsE+ksSpn/xa4z/bkPa+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940143; c=relaxed/simple;
	bh=OyVM8ok5HXR9p38z1SItW2bq7t0BLAX86eCec9pEbIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1aFy6hKh6cC5RLaLrxr1Ie2kOTlDeWYeP45YUEGf4YQeqS9G7oiCwVvBYtn07tEYjeHmTuCJFipzRDYTIPXS53QRPoclC3xXCHDtlYzIDM6oQLaql6WrnARw1q+mrY99JhX/Iq0Ay42HzSKndeSbWo3R/I7QaGF/Kc5CVmqBNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcmCmVMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcmCmVMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D098C116B1;
	Tue,  2 Jul 2024 17:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940143;
	bh=OyVM8ok5HXR9p38z1SItW2bq7t0BLAX86eCec9pEbIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcmCmVMJycGXoi0CfO24pek5F/1mhPig5B9U59Bb5DRP1r1yBr9rBwyDlYvJgq3iE
	 Krr3IoL0opfc1lmshUKg8+Bf8CtAJkUlfVCwGyNNbk4DGwrI3RcXO/B997AyvXqfNe
	 yF1rpDMprFNoP4q2b5Dgvu9G6jF4IFnEpV8O/F2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 065/222] bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()
Date: Tue,  2 Jul 2024 19:01:43 +0200
Message-ID: <20240702170246.466415590@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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
index 219ee7a768744..35791b1c61c7d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -887,14 +887,15 @@ bpf_ctx_narrow_access_offset(u32 off, u32 size, u32 size_default)
 
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
index 1ea5ce5bb5993..9985988845e36 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2403,7 +2403,9 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	}
 
 finalize:
-	bpf_prog_lock_ro(fp);
+	*err = bpf_prog_lock_ro(fp);
+	if (*err)
+		return fp;
 
 	/* The tail call compatibility check can only be done at
 	 * this late stage as we need to determine, if we deal
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ab558eea1c9ee..d5fca9deac5a1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19354,10 +19354,14 @@ static int jit_subprogs(struct bpf_verifier_env *env)
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



