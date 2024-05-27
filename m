Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DF168C4;
	Mon, 27 May 2024 19:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837911; cv=none; b=MACDLcMmis0gbHF+C8MJqp3wb66C0R63N2gcxfgvG+/vK/oRjrMVQu4pKTKb5+CUZQDzTibXmegQk/5Tiwv4y21kVJEG38PY05KRBWm1enrFcr5DLCKvWVLxbqlhpr/CYVuBhlIMlTfhKWc2ZpIokZnwKLmtHBZwzPp+hd95v1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837911; c=relaxed/simple;
	bh=Yxl9Am7WxH0FlKKdpYSzMkyJvOJn0qg70U5iVSqdMpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm4tgIo5oPRnrEDmVGdyOAcYEi0hkNsDbORtl91+lsgpASmq5l1AQfwJcdSgSnt/G2UvS7wbJJ4199nXILrnVq3WSkAAjYRk405NvvM+I+TWuF3jrLbEJzF04ZACaLpaa+68tos0EdJ108FN3l5p15ea+gVfu+mA9dNxxW0Pjic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIpcfk9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIpcfk9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E0FC2BBFC;
	Mon, 27 May 2024 19:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837911;
	bh=Yxl9Am7WxH0FlKKdpYSzMkyJvOJn0qg70U5iVSqdMpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIpcfk9lkwgrfWq0bW196ZxVEo7skSrQ/Dr6TuOn5lg0p3TSv7WdClWP0tmAZcHho
	 lwRYD//dScVJp7jM7Fjl4zLBvBDPIHfoN5UwrcdmY0OzIfSxKP6M8todvdQ0UYB963
	 qIg4w+34qkJmO9CN2x17u8tPZ9+KMGtwvGUw0tt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+148110ee7cf72f39f33e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 193/493] bpf: prevent r10 register from being marked as precise
Date: Mon, 27 May 2024 20:53:15 +0200
Message-ID: <20240527185636.655512365@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 1f2a74b41ea8b902687eb97c4e7e3f558801865b ]

r10 is a special register that is not under BPF program's control and is
always effectively precise. The rest of precision logic assumes that
only r0-r9 SCALAR registers are marked as precise, so prevent r10 from
being marked precise.

This can happen due to signed cast instruction allowing to do something
like `r0 = (s8)r10;`, which later, if r0 needs to be precise, would lead
to an attempt to mark r10 as precise.

Prevent this with an extra check during instruction backtracking.

Fixes: 8100928c8814 ("bpf: Support new sign-extension mov insns")
Reported-by: syzbot+148110ee7cf72f39f33e@syzkaller.appspotmail.com
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240404214536.3551295-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 11bc3af33f34f..68ec508057466 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3584,7 +3584,8 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 				 * sreg needs precision before this insn
 				 */
 				bt_clear_reg(bt, dreg);
-				bt_set_reg(bt, sreg);
+				if (sreg != BPF_REG_FP)
+					bt_set_reg(bt, sreg);
 			} else {
 				/* dreg = K
 				 * dreg needs precision after this insn.
@@ -3600,7 +3601,8 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 				 * both dreg and sreg need precision
 				 * before this insn
 				 */
-				bt_set_reg(bt, sreg);
+				if (sreg != BPF_REG_FP)
+					bt_set_reg(bt, sreg);
 			} /* else dreg += K
 			   * dreg still needs precision before this insn
 			   */
-- 
2.43.0



