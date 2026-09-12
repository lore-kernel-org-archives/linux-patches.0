Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40F379DA;
	Sat, 12 Sep 2026 08:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201697; cv=none; b=PCngIyYVgybdVhhWQTDzGaLp3HXOkO6pjYL6d0X0K86/wj/F2utRsoecFKKQxYT4IiAv5K+Qtn6yHR1Rvyye2cK1aVgB5BfOYFqMpc1GYniHQ2p8llvUUiWr6gbTUSr1r7Ulvo0qS45MXECfy/wBm46EW61khZ0qYEWTMgOzk7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201697; c=relaxed/simple;
	bh=2L430yZITExgCGfjnri4VMPD6yNBJ761SLaCXvOr9to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLzCT+g7l/pV+xhLBART4wp/PQK0wK4N8bSMVM9iVmNV0nvYwrw37xnJ5JFXKwbuCrm6IYlC/8MNYSToQlFKskq+GyYNyNUMbPG378NMeB22qFMRYT2TRGmpeYa1TPJGejB3nkSEMzDrC671WMiaZcIlZHz4uBNisYWgevpKgYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBuS7AoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBuS7AoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3041F000FF;
	Sat, 12 Sep 2026 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201695;
	bh=bzUoPaToJa/U0EZGfmZEERDEscD1VujsAUjH9FvIT3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBuS7AoCGVGoW3PBuCKmRL1jMTuLglVZKNYgvcr1bxqjlYUzh5GKaJd0SbgaT4Z/N
	 kJmjvMvBu6Kjy4sgz4avGOFblXyd/qn01oWk4/QioZeCpYozTd0vMLJ/kjjgvqC4AW
	 ZaoyAT3x4865wFxFfxomZs7Xa87LJjew91Rvukvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ning Ding <dingning04@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1047/1815] bpf: Invalidate RCU pointers after final spin unlock
Date: Sat, 12 Sep 2026 08:46:37 +0200
Message-ID: <20260912065713.596219404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit 180c7000712db77063b3a26f4c97e7dd9038f449 ]

In a sleepable BPF program, a spin lock can provide the only RCU protection
for a kptr. The final bpf_spin_unlock() ends that protection, but the
verifier leaves the pointer valid. Another CPU can then free the object
before the pointer is used. A capability-limited runtime PoC triggered a
task_struct use-after-free in __bpf_get_task_stack().

Record whether the program is in an RCU-protected context before releasing
the lock. Invalidate RCU-protected pointers only when the unlock leaves the
final such context. This preserves valid pointers in non-sleepable programs
and inside an explicit RCU read-side section.

Fixes: 5861d1e8dbc4 ("bpf: Allow bpf_spin_{lock,unlock} in sleepable progs")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: ChatGPT:GPT-5.6-Pro
Signed-off-by: Ning Ding <dingning04@gmail.com>
Link: https://lore.kernel.org/bpf/20260803112615.3362122-2-dingning04@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 345987b1ae0e7..a26f38f637bff 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -204,6 +204,7 @@ static int acquire_reference(struct bpf_verifier_env *env, int insn_idx, int par
 static int release_reference_nomark(struct bpf_verifier_state *state, int id);
 static int release_reference(struct bpf_verifier_env *env, int id);
 static void invalidate_non_owning_refs(struct bpf_verifier_env *env);
+static void invalidate_rcu_protected_refs(struct bpf_verifier_env *env);
 static bool in_rbtree_lock_required_cb(struct bpf_verifier_env *env);
 static bool is_tracing_prog_type(enum bpf_prog_type type);
 static int ref_set_non_owning(struct bpf_verifier_env *env,
@@ -7065,6 +7066,7 @@ static int process_spin_lock(struct bpf_verifier_env *env, struct bpf_reg_state
 			return err;
 		}
 	} else {
+		bool was_in_rcu_cs;
 		void *ptr;
 		int type;
 
@@ -7092,10 +7094,13 @@ static int process_spin_lock(struct bpf_verifier_env *env, struct bpf_reg_state
 			verbose(env, "%s_unlock cannot be out of order\n", lock_str);
 			return -EINVAL;
 		}
+		was_in_rcu_cs = in_rcu_cs(env);
 		if (release_lock_state(cur, type, reg->id, ptr)) {
 			verbose(env, "%s_unlock of different lock\n", lock_str);
 			return -EINVAL;
 		}
+		if (was_in_rcu_cs && !in_rcu_cs(env))
+			invalidate_rcu_protected_refs(env);
 
 		invalidate_non_owning_refs(env);
 	}
-- 
2.53.0



