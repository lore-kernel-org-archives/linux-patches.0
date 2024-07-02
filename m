Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8F41BE22B;
	Tue,  2 Jul 2024 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940840; cv=none; b=tOD79C54g2sLd13eg0gQGRFsRtY8d3QIIPdsrIQPfhF/KxTBqI3zUZqKXc0FQsHrJuHoBTnMfBVrlZ9cU2Tt/FtNLt7pxhK0Lgc8r7m+/9+x9zXaYGQhrLk9qS3IFqUAeCkF87Le5JgVsOM1FKUTuBbjmBsaGycxgup5A4KUV9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940840; c=relaxed/simple;
	bh=umC2O5XeVuFr4aTqNYSa4/Vqk2C1UygoDWuv89HVRko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixHuHFktqo5ZGeGHRr8dPeel4BErFOt+QCDGxlVCLCNZXn4jTKyMWdanGkwwHf3V/VBHDTwpkR4ZBSPqjZt7CFrza4BJeOCaVlyteS7nvufS+clRY4Ni25enl/hkC+RwZRDZmluEX8QUqjBMNmYvJEpIrj/E9IFy1LLnrRIT9BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDO5mI5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDO5mI5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDE6C116B1;
	Tue,  2 Jul 2024 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940840;
	bh=umC2O5XeVuFr4aTqNYSa4/Vqk2C1UygoDWuv89HVRko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDO5mI5oFJi0S/kGTRXKeaqt0BoSJxP9K9XU3gQq4uhpqs8pUZrFTHPS2aIoYzZRO
	 YkcGpO9830X2bPO36krZiBlFErwW3w54YN/03Pb5HVz6K5FN6FIf8gYg2B4QWB29tY
	 MCs4I9rJk81u5z8kHj+L16wIambPlMDLdECOi4Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 6.6 052/163] bpf: Take return from set_memory_rox() into account with bpf_jit_binary_lock_ro()
Date: Tue,  2 Jul 2024 19:02:46 +0200
Message-ID: <20240702170235.032610427@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit e60adf513275c3a38e5cb67f7fd12387e43a3ff5 ]

set_memory_rox() can fail, leaving memory unprotected.

Check return and bail out when bpf_jit_binary_lock_ro() returns
an error.

Link: https://github.com/KSPP/linux/issues/7
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linux-hardening@vger.kernel.org <linux-hardening@vger.kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Puranjay Mohan <puranjay12@gmail.com>
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>  # s390x
Acked-by: Tiezhu Yang <yangtiezhu@loongson.cn>  # LoongArch
Reviewed-by: Johan Almbladh <johan.almbladh@anyfinetworks.com> # MIPS Part
Message-ID: <036b6393f23a2032ce75a1c92220b2afcb798d5d.1709850515.git.christophe.leroy@csgroup.eu>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/net/bpf_jit_32.c        | 25 ++++++++++++-------------
 arch/loongarch/net/bpf_jit.c     | 22 ++++++++++++++++------
 arch/mips/net/bpf_jit_comp.c     |  3 ++-
 arch/parisc/net/bpf_jit_core.c   |  8 +++++++-
 arch/s390/net/bpf_jit_comp.c     |  6 +++++-
 arch/sparc/net/bpf_jit_comp_64.c |  6 +++++-
 arch/x86/net/bpf_jit_comp32.c    |  3 +--
 include/linux/filter.h           |  5 +++--
 8 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 6a1c9fca5260b..ac8e4d9bf9544 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1982,28 +1982,21 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	/* If building the body of the JITed code fails somehow,
 	 * we fall back to the interpretation.
 	 */
-	if (build_body(&ctx) < 0) {
-		image_ptr = NULL;
-		bpf_jit_binary_free(header);
-		prog = orig_prog;
-		goto out_imms;
-	}
+	if (build_body(&ctx) < 0)
+		goto out_free;
 	build_epilogue(&ctx);
 
 	/* 3.) Extra pass to validate JITed Code */
-	if (validate_code(&ctx)) {
-		image_ptr = NULL;
-		bpf_jit_binary_free(header);
-		prog = orig_prog;
-		goto out_imms;
-	}
+	if (validate_code(&ctx))
+		goto out_free;
 	flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
 
 	if (bpf_jit_enable > 1)
 		/* there are 2 passes here */
 		bpf_jit_dump(prog->len, image_size, 2, ctx.target);
 
-	bpf_jit_binary_lock_ro(header);
+	if (bpf_jit_binary_lock_ro(header))
+		goto out_free;
 	prog->bpf_func = (void *)ctx.target;
 	prog->jited = 1;
 	prog->jited_len = image_size;
@@ -2020,5 +2013,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		bpf_jit_prog_release_other(prog, prog == orig_prog ?
 					   tmp : orig_prog);
 	return prog;
+
+out_free:
+	image_ptr = NULL;
+	bpf_jit_binary_free(header);
+	prog = orig_prog;
+	goto out_imms;
 }
 
diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index 9eb7753d117df..13cd480385ca8 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1206,16 +1206,19 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	flush_icache_range((unsigned long)header, (unsigned long)(ctx.image + ctx.idx));
 
 	if (!prog->is_func || extra_pass) {
+		int err;
+
 		if (extra_pass && ctx.idx != jit_data->ctx.idx) {
 			pr_err_once("multi-func JIT bug %d != %d\n",
 				    ctx.idx, jit_data->ctx.idx);
-			bpf_jit_binary_free(header);
-			prog->bpf_func = NULL;
-			prog->jited = 0;
-			prog->jited_len = 0;
-			goto out_offset;
+			goto out_free;
+		}
+		err = bpf_jit_binary_lock_ro(header);
+		if (err) {
+			pr_err_once("bpf_jit_binary_lock_ro() returned %d\n",
+				    err);
+			goto out_free;
 		}
-		bpf_jit_binary_lock_ro(header);
 	} else {
 		jit_data->ctx = ctx;
 		jit_data->image = image_ptr;
@@ -1246,6 +1249,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	out_offset = -1;
 
 	return prog;
+
+out_free:
+	bpf_jit_binary_free(header);
+	prog->bpf_func = NULL;
+	prog->jited = 0;
+	prog->jited_len = 0;
+	goto out_offset;
 }
 
 /* Indicate the JIT backend supports mixing bpf2bpf and tailcalls. */
diff --git a/arch/mips/net/bpf_jit_comp.c b/arch/mips/net/bpf_jit_comp.c
index a40d926b65139..e355dfca44008 100644
--- a/arch/mips/net/bpf_jit_comp.c
+++ b/arch/mips/net/bpf_jit_comp.c
@@ -1012,7 +1012,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_prog_fill_jited_linfo(prog, &ctx.descriptors[1]);
 
 	/* Set as read-only exec and flush instruction cache */
-	bpf_jit_binary_lock_ro(header);
+	if (bpf_jit_binary_lock_ro(header))
+		goto out_err;
 	flush_icache_range((unsigned long)header,
 			   (unsigned long)&ctx.target[ctx.jit_index]);
 
diff --git a/arch/parisc/net/bpf_jit_core.c b/arch/parisc/net/bpf_jit_core.c
index d6ee2fd455503..979f45d4d1fbe 100644
--- a/arch/parisc/net/bpf_jit_core.c
+++ b/arch/parisc/net/bpf_jit_core.c
@@ -167,7 +167,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_flush_icache(jit_data->header, ctx->insns + ctx->ninsns);
 
 	if (!prog->is_func || extra_pass) {
-		bpf_jit_binary_lock_ro(jit_data->header);
+		if (bpf_jit_binary_lock_ro(jit_data->header)) {
+			bpf_jit_binary_free(jit_data->header);
+			prog->bpf_func = NULL;
+			prog->jited = 0;
+			prog->jited_len = 0;
+			goto out_offset;
+		}
 		prologue_len = ctx->epilogue_offset - ctx->body_len;
 		for (i = 0; i < prog->len; i++)
 			ctx->offset[i] += prologue_len;
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 62ee557d4b499..05746e22fe79c 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1973,7 +1973,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		print_fn_code(jit.prg_buf, jit.size_prg);
 	}
 	if (!fp->is_func || extra_pass) {
-		bpf_jit_binary_lock_ro(header);
+		if (bpf_jit_binary_lock_ro(header)) {
+			bpf_jit_binary_free(header);
+			fp = orig_fp;
+			goto free_addrs;
+		}
 	} else {
 		jit_data->header = header;
 		jit_data->ctx = jit;
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index fa0759bfe498e..73bf0aea8baf1 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1602,7 +1602,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	bpf_flush_icache(header, (u8 *)header + header->size);
 
 	if (!prog->is_func || extra_pass) {
-		bpf_jit_binary_lock_ro(header);
+		if (bpf_jit_binary_lock_ro(header)) {
+			bpf_jit_binary_free(header);
+			prog = orig_prog;
+			goto out_off;
+		}
 	} else {
 		jit_data->ctx = ctx;
 		jit_data->image = image_ptr;
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 429a89c5468b5..f2fc8c38629b5 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -2600,8 +2600,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	if (bpf_jit_enable > 1)
 		bpf_jit_dump(prog->len, proglen, pass + 1, image);
 
-	if (image) {
-		bpf_jit_binary_lock_ro(header);
+	if (image && !bpf_jit_binary_lock_ro(header)) {
 		prog->bpf_func = (void *)image;
 		prog->jited = 1;
 		prog->jited_len = proglen;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 5a2800ec94ea6..a74d97114a542 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -853,10 +853,11 @@ static inline int __must_check bpf_prog_lock_ro(struct bpf_prog *fp)
 	return 0;
 }
 
-static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
+static inline int __must_check
+bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
 {
 	set_vm_flush_reset_perms(hdr);
-	set_memory_rox((unsigned long)hdr, hdr->size >> PAGE_SHIFT);
+	return set_memory_rox((unsigned long)hdr, hdr->size >> PAGE_SHIFT);
 }
 
 int sk_filter_trim_cap(struct sock *sk, struct sk_buff *skb, unsigned int cap);
-- 
2.43.0



