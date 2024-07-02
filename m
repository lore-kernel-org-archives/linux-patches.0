Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206FF63D;
	Tue,  2 Jul 2024 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941451; cv=none; b=PXGPnKAKzbcN9OSTYUybZUZFXpo4qcuyRYUqQ+ILTW5ghC6eJ0JxejNVulCxjYOYKfiFdBIGxfHE+IVZTJk3wO3ZXarff7ca9Z5bKF8ySPqRJgdQXVta1CcWJis9gxFbH6rDUpodzGBygihNg5aBxKMTpRXn/0PRHdUWzU/dN48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941451; c=relaxed/simple;
	bh=aOdxVO6jAMuTx9ebKtJyYepgVycESJ4xutwP7Hyx8T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sb4RVXdT2SUVbeNZlP9Op1bEwCeOjL1Ee4rkODr3OYo21xpzrqagrYtBpm8GWxuYtvzmu9bVgglV/sl2j/uq2jZbwhBVZKaUUq8MxhLJaJMfYgNeob0vDXLT2H5fW5/Ba1aLsOGFCYtqPCZGcsRqlOyMApmAUEXCe0VqAN+F5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiYkgEWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiYkgEWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0A2C116B1;
	Tue,  2 Jul 2024 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941451;
	bh=aOdxVO6jAMuTx9ebKtJyYepgVycESJ4xutwP7Hyx8T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiYkgEWaD4UrDWmk7DWmrc6grxOFOPxviLF0ZcQTGp6+WZMIOGu+G+pIzt8A6rgHl
	 liuri0EiExwvkiW7OObH4o1g+NJCOAaBdwbA15NGzo+Jimc7RntLFzlgDCPOR+dwvM
	 DTCAT9Osg8EXflOO5aMD3tOfMeEl1uWZs01jyBR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/128] bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()
Date: Tue,  2 Jul 2024 19:03:57 +0200
Message-ID: <20240702170227.597574859@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index face590b24e17..01f97956572ce 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -850,14 +850,15 @@ bpf_ctx_narrow_access_offset(u32 off, u32 size, u32 size_default)
 
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
index 44abf88e1bb0d..16d15d5d1e197 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2223,7 +2223,9 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	}
 
 finalize:
-	bpf_prog_lock_ro(fp);
+	*err = bpf_prog_lock_ro(fp);
+	if (*err)
+		return fp;
 
 	/* The tail call compatibility check can only be done at
 	 * this late stage as we need to determine, if we deal
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1d851e2f48590..56a5c8beb553d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14113,10 +14113,14 @@ static int jit_subprogs(struct bpf_verifier_env *env)
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



