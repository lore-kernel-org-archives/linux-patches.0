Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727E3308F3B;
	Sat, 12 Sep 2026 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223424; cv=none; b=k/r2H7q64jT6QohaEnkxGcwl9UK5qF4CiC1DH+vrKF2NZIiehlvASDvHBxEfHBGuBk2Rtdh7uJNS8Dl0E6qBrDV8XpxAF+pyG/HXV1K9h/vjkZEgmnIRKq1E6XUsoxP0kftGYIBLiEMipi6s5B+nLtld9Hu2CtAcMYApkfrk4rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223424; c=relaxed/simple;
	bh=liyC3b7n97UFqdJ59RTKiAyjonsOg83VozUalW5Jizw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8DsqqxIgvYh7A9zonPG/ZY+Wr9ZMuj3QGjo45P4ntLa1KwsV0qrrWq4nUxDAsCCZvkCxQy5fa16mDAxqIH5VQiPrtspOKvKF7Su8xcXZHEsVhk3sYFRRTtKwFf4uJ8jT4iezUW/9yE2OmB5lOzWaKHFVa6eAR9Rw6M5R0Enj2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/TfjI2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/TfjI2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113331F000FF;
	Sat, 12 Sep 2026 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223423;
	bh=ytITYzfgZCK25BAuZC+rFgTqUFClY1VXk6g4o1VD5FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/TfjI2J8s5sazqpdS0+y/IHMMLjZEQ2a4f84zj2RxG9zwRReA7FmvK+dclK8cMQn
	 CNjPRI/qO/pWPsjNSp77WGWDUli8kRkE9EcSoUvwUXF8AXMOHYdRiDBiQt49594W4T
	 fvfTjRCtVFw3Wo22RSdATneKsMYA6kJJJ1/SaBZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0787/1424] bpf: Sync tail_call_reachable with callee state on entry
Date: Sat, 12 Sep 2026 08:53:39 +0200
Message-ID: <20260912065624.923073650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 3513ea9dab6c1a3d2dc8e6160c41f690206948b6 ]

Currently in check_max_stack_depth_subprog, when the verifier enters a
new callee branch, the local tail_call_reachable is not properly
synchronized with the callee's state.

Consider a main prog branching into multiple subprogs:

       subprog0 -> tailcall
main <
       subprog1 -> subprog2

When the verifier finishes checking subprog0 and backtracks to main
prog, the local tail_call_reachable state is left as true. As it
proceeds to subprog1, this uncleared state leaks into the new branch,
falsely marking subprog1 and subprog2 as tailcall reachable.

Fix this by explicitly syncing tail_call_reachable with the callee's
has_tail_call state on entry. The caller's state is safely preserved and
restored via the existing backtracking logic.

Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://patch.msgid.link/20260716120157.835937-2-pulehui@huaweicloud.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f7f5f54dc4485..509809ac40b9b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6027,8 +6027,8 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx)
 		i = next_insn;
 		idx = sidx;
 
-		if (subprog[idx].has_tail_call)
-			tail_call_reachable = true;
+		/* sync tail_call_reachable with callee state on entry */
+		tail_call_reachable = subprog[idx].has_tail_call;
 
 		frame++;
 		if (frame >= MAX_CALL_FRAMES) {
-- 
2.53.0



