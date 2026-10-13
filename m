Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5032D155C87;
	Tue, 13 Oct 2026 12:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894096; cv=none; b=E6NKPUJs6hs6cqzm08ZYk8vmqrI9CD7IBOLUWJB8G+kqYzKz/eYo5eEsfP8eEaNS0lh34TppTRgprPguglh30QsBrJ8G2CYPojZ4IWkwBfOv/9qJ7n9L9VZYyJ8IBJpKy1E60o//z/9ADdmn62ecVDUpOSsw+IZhaQk+nsCe2TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894096; c=relaxed/simple;
	bh=mOaaHoRJhdIvqhSKhEULmP7v5Y1Y+NqanAbFflnWvsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkdrCxOSS01SD79tze/GWVZ5XJLXHCRwV2GUYkbjPuKVUzTK/9kdhqOHZYZtXKYj7VpRFXoaKK1okJz0ktesSy1Y9ZvvmEZ867KXu9vpKW4pAO/rMG1wzLdb25zjL9m1YucsCIq5xVyzRw4eslh64TQ1DqjIRQL1hxcu8EL8QNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSo6lV/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSo6lV/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B5E1F000FF;
	Tue, 13 Oct 2026 12:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894095;
	bh=AHWprFT/7kyXrkarX/hKhtGdlpHoMkecj5Exr8KrXrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSo6lV/ZbUr7E4wWfn8m6UHtdkTFWs1EhzthRynfBP840+ytXeoCu15N8RGMXf4t1
	 TCNZHANkQtRvDpSDQyfCBsrEgruNl51XJrOZpMis3Xdi0lmZ1LJoynPAu0Okj+BoUj
	 PWBXfgHM2Toj/UaKdUWi2q0prNWCeFO1nEgg+Zrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ning Ding <dingning04@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 446/621] bpf: Invalidate RCU pointers after final spin unlock
Date: Tue, 13 Oct 2026 13:37:21 +0200
Message-ID: <20261013112931.416023124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
 kernel/bpf/verifier.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 947b501a58aee..d35ac3df9a052 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8585,6 +8585,10 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno, int flags)
 			return err;
 		}
 	} else {
+		u32 clear_mask = (1 << STACK_SPILL) | (1 << STACK_ITER);
+		struct bpf_func_state *state;
+		struct bpf_reg_state *rcu_reg;
+		bool was_in_rcu_cs;
 		void *ptr;
 		int type;
 
@@ -8612,10 +8616,19 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno, int flags)
 			verbose(env, "%s_unlock cannot be out of order\n", lock_str);
 			return -EINVAL;
 		}
+		was_in_rcu_cs = in_rcu_cs(env);
 		if (release_lock_state(cur, type, reg->id, ptr)) {
 			verbose(env, "%s_unlock of different lock\n", lock_str);
 			return -EINVAL;
 		}
+		if (was_in_rcu_cs && !in_rcu_cs(env)) {
+			bpf_for_each_reg_in_vstate_mask(env->cur_state, state, rcu_reg, clear_mask, ({
+				if (rcu_reg->type & MEM_RCU) {
+					rcu_reg->type &= ~(MEM_RCU | PTR_MAYBE_NULL);
+					rcu_reg->type |= PTR_UNTRUSTED;
+				}
+			}));
+		}
 
 		invalidate_non_owning_refs(env);
 	}
-- 
2.53.0



