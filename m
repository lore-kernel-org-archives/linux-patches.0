Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4F841F379;
	Sat, 12 Sep 2026 10:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209485; cv=none; b=mK+5rQxiUw1ssNoAKxjcbx4RHjU6qkiq/7lRcosmufx6aRAGmRPGIfpgl7iL0tD3poO/OHxvhP3z1Bi2x3E3SXY67QkT7+WWOrhJImEj9Ix8vCsBKgE1XTDU4IKEzJk2A64W8MY6gvAJ6N5d2R0Bi15nhZX5eCsFotHXvcTDNfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209485; c=relaxed/simple;
	bh=syyih6C6AqxO7ejfImS7Ib7+4o/fTgEKgEc5UNqrCxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUXPoUQvIt/2zpz63/VSPL8gLKNNcA1aywQqHI3MuH0aIDc1lofvVvCxtIBVbVEeTyFtjdXhY+Cu5mQYqfCa5sFFAGkskOO6TVFBEhZUw6iYNT2zjOKC/xql38Kx1FCLdwnFwchD7WLnGX8kNKNXhjOYh7Hd/QbiT4gXXRLiyno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYt7jj3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYt7jj3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7E11F000FF;
	Sat, 12 Sep 2026 10:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209483;
	bh=+HwSKTupYxHzla6soyGwOv7HnAZI2vHq8SLdCSbcmxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYt7jj3TYO4zicOKLIKz7KIpfmtvLXZx5lt0g5jhvShabyuKkJY7N1q1rO6fhnThr
	 Fl107ezEkmJaX1pJM0dRV3QnHFlgfzLlsa7mJxNYYyCafn73fLcb1JcT1va9dvZKnT
	 OHFlr5Tw57Yfva1JLJV3lX0Y/K3wixRj1nxuuSc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0787/1518] bpf, x86: Fix trampoline stack size for 128-bit arguments
Date: Sat, 12 Sep 2026 08:49:16 +0200
Message-ID: <20260912065641.238518109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
 arch/x86/net/bpf_jit_comp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 88a1bbfa918fa..cfd44906c31dd 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -3187,11 +3187,8 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 	WARN_ON_ONCE((flags & BPF_TRAMP_F_INDIRECT) &&
 		     (flags & ~(BPF_TRAMP_F_INDIRECT | BPF_TRAMP_F_RET_FENTRY_RET)));
 
-	/* extra registers for struct arguments */
-	for (i = 0; i < m->nr_args; i++) {
-		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
-			nr_regs += (m->arg_size[i] + 7) / 8 - 1;
-	}
+	for (i = 0; i < m->nr_args; i++)
+		nr_regs += (m->arg_size[i] + 7) / 8 - 1;
 
 	/* x86-64 supports up to MAX_BPF_FUNC_ARGS arguments. 1-6
 	 * are passed through regs, the remains are through stack.
-- 
2.53.0



