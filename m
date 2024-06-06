Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487C8199382;
	Thu,  6 Jun 2024 14:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683206; cv=none; b=k7szqd4ZURuHvn7tgp9Qe8hLNAQPJLEwV7VlXa8V1zKFEZ0yJCLMbQINFaxQEQjm1GS7c7fXRmteB1EZhjktyylqj2Bd9Bs15H8ZVTVA1SGVxAksFAKbiS0hOrmkvbriP2bA9QqGJytcToyKPk0zk/DKDOe/ewTyXZy1Lhkvsgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683206; c=relaxed/simple;
	bh=91NUApFMJubCpxPZ5al8kl2zIexS+bICSSSMuZFcZCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTdiAEKHR6VfIUzx+vdqUjxQ0nqLjQZY6SsuxupCxx74hzk+Z+tDglTT8KACWXTiRItLkP+Qs197wuHChNfwDAWR6H+JAMWFIih/i49xw8g8Iry3u1dmKEbuP+nEatTwxCFwhdNSmFMssRkdvile8JgcA59UXxdnSkdgYGyi5RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVy+1GGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVy+1GGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2809CC2BD10;
	Thu,  6 Jun 2024 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683206;
	bh=91NUApFMJubCpxPZ5al8kl2zIexS+bICSSSMuZFcZCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVy+1GGk7tp5GDbYvLtfv8WYQVXix/YDpHy3GKKuU2H5DKF22JgNeKxpw2TDFnRHa
	 wWByAMjgFjhxjabkdtDsXh1nLSLBCwFQgNGiYdUDweZfhmXCPXmVkeMcUVKkgkjZ2V
	 yIysPSHF/Rn313SC5eTkCmwYL56UhF/3uKeKUbfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+148110ee7cf72f39f33e@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/744] bpf: prevent r10 register from being marked as precise
Date: Thu,  6 Jun 2024 15:57:01 +0200
Message-ID: <20240606131737.198376710@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 818bac019d0d3..105fa54a492ab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3679,7 +3679,8 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 				 * sreg needs precision before this insn
 				 */
 				bt_clear_reg(bt, dreg);
-				bt_set_reg(bt, sreg);
+				if (sreg != BPF_REG_FP)
+					bt_set_reg(bt, sreg);
 			} else {
 				/* dreg = K
 				 * dreg needs precision after this insn.
@@ -3695,7 +3696,8 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
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



