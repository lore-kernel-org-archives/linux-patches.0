Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB013CF1F8;
	Sat, 17 Oct 2026 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260140; cv=none; b=PHrmzjTX66sWBN5z1OZgHaNhAEn5TAVrpgg7mefrDWb7L5nmElIURuSwyuoa+naUx8sJfe0dIV/cf+3gpLtCcKLSL1y+jz5fJFFFg00CxgYbNg8MCyzNvXjc6NUPJhXJiR7xK4VjX+iWjzVgCxySJYq4+1aU2nUsKKdPdTIGE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260140; c=relaxed/simple;
	bh=AZYbFswAQAGUntXU+BSD1MYUt3gMDOMFWOksyYGdGKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1Jyi9/PqIoeDpP4MHd41rVZmixMfHZRiKkh5vZ9t605Fr/bZCOzVScg2mK1o/w/CVptodBvwYtH0vzmZTfChqndGjaGyJ3fYvTNZ5e8ywndgkUuwlobb5Mp7ZUE30xAblOXJaBa8z7fkF/J4GulMjxHOZKbQAfVFFrJ5CNU/TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pox4D+Gd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pox4D+Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4A71F000C5;
	Sat, 17 Oct 2026 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260137;
	bh=reaNPpio0ajfp21iIQRAp4KLiAD06/VCQJKTGC9TGKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pox4D+Gdu1pwJaTIF8LYUGMtt0yRxtr6DAKg+8xerp0SfnA39wbg2CdkF5q0/3ocA
	 OF4KzkHthejfYiqjwAkclK8dbpgwghuV/JGuhJrvF9fSQ/ztFHG0Ag3pVWE0LUX3FL
	 QzsxHXhOmZyvkMb8lHfGJiI7fXscUhLz2XKlzPbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1445/1674] bpf, x86: Fix trampoline stack size for 128-bit arguments
Date: Sat, 17 Oct 2026 18:01:57 +0200
Message-ID: <20261017160508.273394025@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 814cba835ef648e0c5eb79505c96c0493b29eea6 ]

btf_distill_func_proto() accepts a function argument up to 16 bytes, so a
128-bit scalar such as __int128 reaches the x86 trampoline with
arg_size == 16. But the current implementation assumes an __int128
argument only needs one register, so the register save area is
under-allocated and save_args() overwrites adjacent stack slots.

Compute the register count from arg_size for all arguments to fix it.

Fixes: a9c5ad31fbdc ("bpf: x86: Support in-register struct arguments in trampoline programs")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260729050204.2586457-1-yonghong.song@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 8028a5a4ab645..3d33aafa2cc26 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2467,10 +2467,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	u8 *prog;
 	bool save_ret;
 
-	/* extra registers for struct arguments */
 	for (i = 0; i < m->nr_args; i++)
-		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
-			nr_regs += (m->arg_size[i] + 7) / 8 - 1;
+		nr_regs += (m->arg_size[i] + 7) / 8 - 1;
 
 	/* x86-64 supports up to MAX_BPF_FUNC_ARGS arguments. 1-6
 	 * are passed through regs, the remains are through stack.
-- 
2.53.0



