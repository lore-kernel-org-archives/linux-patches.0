Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADD4314D2D;
	Mon, 13 Oct 2025 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369241; cv=none; b=Vy3mGEF1YIRIN/bZPxgz5eS8p4Kz+Yj+05ug9vCTc/w6nGLatSTivLVMA3Sp3rg5QWkxAUBvtDd1GX9oM8pROZFJSUwKLFld8czasJH52NZCONlmVp+2KlzWOTWSTtSW27r0YtcPr6OZ2iR6ohWuY2HNLyYSBe4JG/ATnMo4vUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369241; c=relaxed/simple;
	bh=KlGr9K6x4g0qP9rh2TjpADi/MRZuMxA/YjOwMkABqx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCZ2A/BvQ6SwLvkyO4rOtNHneNuT3RJk3jHspSgzS38HDzATc2Gcg/lTg6o9+AHtIyVHtyq6zfutg5uEo/NtEZk8sn18aTZ6kUzaaTyNO8L0uBjVFWdnDOPkst97Z0/nkXL2pcLw0rJXDyhBTJYOhQcJdG8MQUHfraWLvY0s3Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNq5cuIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNq5cuIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97C6C116B1;
	Mon, 13 Oct 2025 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369241;
	bh=KlGr9K6x4g0qP9rh2TjpADi/MRZuMxA/YjOwMkABqx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNq5cuIJXw8u5GWXDg6+fiARSGGkQ4dTE4yokaVvCKRQC/PbkBt2T1532KhrzIpF/
	 JtFV+dv4CDBmLXGZrG+huvJI56wyWIkTtk+uUIXG7dXgkSqohlCAgOWxqJrX3ecI68
	 N4fH957zJActbBfTUR8XYbp/4NmvQNSBn7OMJiD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3afc814e8df1af64b653@syzkaller.appspotmail.com,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 178/563] bpf: dont report verifier bug for missing bpf_scc_visit on speculative path
Date: Mon, 13 Oct 2025 16:40:39 +0200
Message-ID: <20251013144417.734702019@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit a3c73d629ea1373af3c0c954d41fd1af555492e3 ]

Syzbot generated a program that triggers a verifier_bug() call in
maybe_exit_scc(). maybe_exit_scc() assumes that, when called for a
state with insn_idx in some SCC, there should be an instance of struct
bpf_scc_visit allocated for that SCC. Turns out the assumption does
not hold for speculative execution paths. See example in the next
patch.

maybe_scc_exit() is called from update_branch_counts() for states that
reach branch count of zero, meaning that path exploration for a
particular path is finished. Path exploration can finish in one of
three ways:
a. Verification error is found. In this case, update_branch_counts()
   is called only for non-speculative paths.
b. Top level BPF_EXIT is reached. Such instructions are never a part of
   an SCC, so compute_scc_callchain() in maybe_scc_exit() will return
   false, and maybe_scc_exit() will return early.
c. A checkpoint is reached and matched. Checkpoints are created by
   is_state_visited(), which calls maybe_enter_scc(), which allocates
   bpf_scc_visit instances for checkpoints within SCCs.

Hence, for non-speculative symbolic execution paths, the assumption
still holds: if maybe_scc_exit() is called for a state within an SCC,
bpf_scc_visit instance must exist.

This patch removes the verifier_bug() call for speculative paths.

Fixes: c9e31900b54c ("bpf: propagate read/precision marks over state graph backedges")
Reported-by: syzbot+3afc814e8df1af64b653@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/68c85acd.050a0220.2ff435.03a4.GAE@google.com/
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250916212251.3490455-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9fb1f957a0937..6ad0dc226183a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1946,9 +1946,24 @@ static int maybe_exit_scc(struct bpf_verifier_env *env, struct bpf_verifier_stat
 		return 0;
 	visit = scc_visit_lookup(env, callchain);
 	if (!visit) {
-		verifier_bug(env, "scc exit: no visit info for call chain %s",
-			     format_callchain(env, callchain));
-		return -EFAULT;
+		/*
+		 * If path traversal stops inside an SCC, corresponding bpf_scc_visit
+		 * must exist for non-speculative paths. For non-speculative paths
+		 * traversal stops when:
+		 * a. Verification error is found, maybe_exit_scc() is not called.
+		 * b. Top level BPF_EXIT is reached. Top level BPF_EXIT is not a member
+		 *    of any SCC.
+		 * c. A checkpoint is reached and matched. Checkpoints are created by
+		 *    is_state_visited(), which calls maybe_enter_scc(), which allocates
+		 *    bpf_scc_visit instances for checkpoints within SCCs.
+		 * (c) is the only case that can reach this point.
+		 */
+		if (!st->speculative) {
+			verifier_bug(env, "scc exit: no visit info for call chain %s",
+				     format_callchain(env, callchain));
+			return -EFAULT;
+		}
+		return 0;
 	}
 	if (visit->entry_state != st)
 		return 0;
-- 
2.51.0



