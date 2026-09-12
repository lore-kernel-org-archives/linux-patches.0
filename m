Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A9E3148A7;
	Sat, 12 Sep 2026 07:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197341; cv=none; b=FEc3kd3T+GHO/A/vJQ+tfwoCDvTc9WcoFQszqTzbt9nBLhZ7mMV9U11dpawCHOPAtMpInxw9u5BU0UCYEvrJOcn7DSB6t+YqTzC8/0azWEw+/G+gxzXJGRhQrhDNN0ZpsEHZnD8L2pupAfZ0IG5N/nWjeLOp1hC5I2Y64+f/Zg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197341; c=relaxed/simple;
	bh=FTDP0rmRETf/fYXVx8v6izYCNeQ1MGaqyK949d5NKsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phKyJzn0HT00d9DKCroiu7nq2kz9QTnsuWKUP4LdC/jTW+g5IPf/ZWHBvSfZ3F5uT5XEIlUdW7TDTMZUVASDElndSwyTQ3Q4trwIpuufi+g8DmsNEZMUlrDp/k8lAxfOqbqeQqyu7n8ed/b+9c7SO0A1F1LQQiiQVdCgvycpR2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kN7rBYby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kN7rBYby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C3F1F000FF;
	Sat, 12 Sep 2026 07:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197340;
	bh=mb0Ric2r3veI6MVIihmUv90JPl+19tTSFTG01Wkanxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kN7rBYby655/vxuY3zuxoh4Z47uwwH/ubz9qkhRB/pCFqGKmsnnWMgUduiPTfuviM
	 E8OT6wgKvIj1C+LPh0IEwmuJwt3JVJrquW22k0CMM2ro1L2uhLw3reiRj2l4akL1gj
	 cvcYLLqZu5lhXj2kfMuWV8uXSeBydLhbq+IrxlXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0154/1815] bpf,lsm: Drop bpf_prog_free from sleepable_lsm_hooks
Date: Sat, 12 Sep 2026 08:31:44 +0200
Message-ID: <20260912065652.627452166@linuxfoundation.org>
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

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit 2ce3f548cfc6a1fe4c53479cf8a21931cdfd51d8 ]

__bpf_prog_put_rcu() is the call_rcu() callback for non-sleepable programs.
security_bpf_prog_free() called from there fires bpf_prog_free in softirq;
if a sleepable LSM prog is attached to that hook, might_fault() BUGs:

  BUG: sleeping function called from invalid context
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5038
  preempt_count: 101, expected: 0
  Call Trace:
   <IRQ>
   __bpf_prog_enter_sleepable+0x1cd/0x320 kernel/bpf/trampoline.c:1255
   bpf_trampoline_6442549705+0x53/0xd7
   security_bpf_prog_free+0xde/0x130 security/security.c:5465
   __bpf_prog_put_rcu+0xab/0xd0 kernel/bpf/syscall.c:2365
   rcu_do_batch kernel/rcu/tree.c:2617 [inline]
   handle_softirqs+0x236/0x800 kernel/softirq.c:622
   </IRQ>

The call_rcu/call_rcu_tasks_trace split reflects the freed program's
sleepability, not that of any attached observer.

security_bpf_prog_free() also frees prog->aux->security, which has to stay
after the grace period, so drop bpf_prog_free from sleepable_lsm_hooks
rather than move the call. Non-sleepable observers still run there.

Fixes: 1b67772e4e3f ("bpf,lsm: Refactor bpf_prog_alloc/bpf_prog_free LSM hooks")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260701080757.1394144-1-rhkrqnwk98@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 1433809bb166a..3983b4ce73c81 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -295,7 +295,6 @@ BTF_ID(func, bpf_lsm_bpf_map_create)
 BTF_ID(func, bpf_lsm_bpf_map_free)
 BTF_ID(func, bpf_lsm_bpf_prog)
 BTF_ID(func, bpf_lsm_bpf_prog_load)
-BTF_ID(func, bpf_lsm_bpf_prog_free)
 BTF_ID(func, bpf_lsm_bpf_token_create)
 BTF_ID(func, bpf_lsm_bpf_token_free)
 BTF_ID(func, bpf_lsm_bpf_token_cmd)
-- 
2.53.0



