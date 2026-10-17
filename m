Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC89E555;
	Sat, 17 Oct 2026 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257636; cv=none; b=LyQuO/VjQJMyNKVAc+7bSw/MWjWmfRSW7EIyKNYk1SAlWVjx4otqJBa3ovKQbWPtVbFrwN/uA/o4oA816ZJoRy3amYVsI4hyZR5O/NtC89wVYPG0w9g+qCl5+pfYn7/FcgoovlGKAx6aaPyNn6fD3L/YJzEOtTKd881/OafbKiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257636; c=relaxed/simple;
	bh=yrcu87sGhg5c5Lf0AvIGz9gR/ZC/E2AD2/1iKiYE9gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwNtAkJ9g+e9b0ETQ+rFbh5u9ieLOVd9LmX8tBoQYroqHjzIhssZanZ4nY3u7VOOgkfR22shuvcpRJl9HHb3uvHr/Uh5gX9ksvEjE1cBacPYhHTbxtmO622KbR5I9YEP5Pm0WT9dm1KcmYAa6yGoYeXEkEoNcCF0Nw+2HPFrbXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OhKtBQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OhKtBQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A02B1F000C4;
	Sat, 17 Oct 2026 17:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257635;
	bh=ZO3WzRvgxdM9F4WKeeLBXl0to2QpOrmcgUv05IDlTCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OhKtBQUmhgwDyEJI0UImrcby6mkFOmz/if5J6yZ2GUeVdWN9yQMDJSoISSNB4/sE
	 TIZ0ukiFvIeq3/CPLZwBtb1YP5D32J1BIAOAXZ0o64TnqNaYTCQv2YYr159QH2H1U6
	 Cf1FHluv7hNvxBDQAwRMPFEuPIEUQUudf901sMHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0623/1674] bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()
Date: Sat, 17 Oct 2026 17:48:15 +0200
Message-ID: <20261017160447.074560258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 3fee2723709f3..cb6c3f20b22f9 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -867,14 +867,15 @@ bpf_ctx_narrow_access_offset(u32 off, u32 size, u32 size_default)
 
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
 
 static inline int __must_check
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9fa984ee076bc..ea78ef4774198 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2484,7 +2484,9 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 	}
 
 finalize:
-	bpf_prog_lock_ro(fp);
+	*err = bpf_prog_lock_ro(fp);
+	if (*err)
+		return fp;
 
 	/* The tail call compatibility check can only be done at
 	 * this late stage as we need to determine, if we deal
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 778a68bfb91dd..8edf578a892cd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18900,10 +18900,14 @@ static int jit_subprogs(struct bpf_verifier_env *env)
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
2.53.0



