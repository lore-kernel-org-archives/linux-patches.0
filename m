Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CFA1F8913;
	Tue,  3 Dec 2024 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238623; cv=none; b=jjllndytXBssRKWULrjhnLo5liALOlmw3fEX1XbWK+++dVzevdEx0BiwoYgQB3YDWyw3GKmZiSQ4tgQW83GINn62Vh2fAiB09y7rjCh3U6H6Eyvx8WcxRkEoGva9UKqMRO9PCKJiPVt+43Njx5kHBNVgsS1juP2r1yN7rdsVxio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238623; c=relaxed/simple;
	bh=tjZ3k/fn+URv+YdrKM96uWgzh7G+vYS6Ghi0lZW/7/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Of7qp/LUABUb8BYelZSxresIAssXVuduzk+Sy9HNh7GjOaDM4fKfy4gTe9unViCR87UPauyMZLk8O3fhiFAWcm0Qwko5sCG0wLOF8B4HfYmjzsBNgt0wA6g6srMmPs8UjCYd00dfyb5iMRw5bRCWZkJXy9Id2Pw1ZSKDWoUcChI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPdsbBv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPdsbBv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4270CC4CED6;
	Tue,  3 Dec 2024 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238623;
	bh=tjZ3k/fn+URv+YdrKM96uWgzh7G+vYS6Ghi0lZW/7/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPdsbBv9duEkNzgjBlO/REzXMZFhefG6Vsqv3AXXjGKfzjB4/Zah8HyJGVMBAX6jH
	 uT2qQsQA6i4Htkbhnb3aYloGy8i3ml/RwanNkQW9gPOgWyigsfRC67m8WLOLfjeLZS
	 pML1sPySvCN2H7FFs4cCEgLflM4cMwxn5QPwnhsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 310/817] bpf: Tighten tail call checks for lingering locks, RCU, preempt_disable
Date: Tue,  3 Dec 2024 15:38:02 +0100
Message-ID: <20241203144007.917808097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 46f7ed32f7a873d6675ea72e1d6317df41a55f81 ]

There are three situations when a program logically exits and transfers
control to the kernel or another program: bpf_throw, BPF_EXIT, and tail
calls. The former two check for any lingering locks and references, but
tail calls currently do not. Expand the checks to check for spin locks,
RCU read sections and preempt disabled sections.

Spin locks are indirectly preventing tail calls as function calls are
disallowed, but the checks for preemption and RCU are more relaxed,
hence ensure tail calls are prevented in their presence.

Fixes: 9bb00b2895cb ("bpf: Add kfunc bpf_rcu_read_lock/unlock()")
Fixes: fc7566ad0a82 ("bpf: Introduce bpf_preempt_[disable,enable] kfuncs")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241103225940.1408302-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a5a9b4e418a68..3bee91db81f0a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10459,11 +10459,26 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 
 	switch (func_id) {
 	case BPF_FUNC_tail_call:
+		if (env->cur_state->active_lock.ptr) {
+			verbose(env, "tail_call cannot be used inside bpf_spin_lock-ed region\n");
+			return -EINVAL;
+		}
+
 		err = check_reference_leak(env, false);
 		if (err) {
 			verbose(env, "tail_call would lead to reference leak\n");
 			return err;
 		}
+
+		if (env->cur_state->active_rcu_lock) {
+			verbose(env, "tail_call cannot be used inside bpf_rcu_read_lock-ed region\n");
+			return -EINVAL;
+		}
+
+		if (env->cur_state->active_preempt_lock) {
+			verbose(env, "tail_call cannot be used inside bpf_preempt_disable-ed region\n");
+			return -EINVAL;
+		}
 		break;
 	case BPF_FUNC_get_local_storage:
 		/* check that flags argument in get_local_storage(map, flags) is 0,
-- 
2.43.0



