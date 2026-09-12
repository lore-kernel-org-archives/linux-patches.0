Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4839B343893;
	Sat, 12 Sep 2026 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214910; cv=none; b=Gs7H1HimII3OttufiyojpI5QdXQoT0iZt4jM7NTLA1ww0ZA5HssxHPclCFZIjb4hADWBBfadUVUk/fwwm3i4HjOcN6V406ofQ1w5EL2xJt6UjR7k/mwD3AOV62KONuPDrYfsbgttGjs3Fi56K7FMG3eRlN2qLfr7QsLAHKP+NKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214910; c=relaxed/simple;
	bh=9Q/I8lQmMVtNVnsV+8hppFB6EKcwEFmmvZicjMuc+jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfKQMbgieHTbKBUrEXE20eIE4f7iJeLicZVnBvaLhtbFSZmCmW6j+DFxkkpkqnLm02jevXACFQCqH6Hpi/0q1+ivBVYecQTlvgy8gtXkSep6UbUU4HWCe2/FwXFcXL8swBsn3ZucOYBli5zDWN91BJj1x/fF2csaPG3N0MtLb1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YaCcB3rD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaCcB3rD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8931F000FF;
	Sat, 12 Sep 2026 12:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214909;
	bh=NylGNyOY+RZMbM4YZtfEa8xEnY0iIeYNGb9WjcwCdLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaCcB3rD9/Ho1jsQoRRd71EUTIc158Duw4ZN++bQ1B/BA5JginFXGe2cyJpUpiyQZ
	 K0Kk2KfNE9fIrCem8BdH2HkmSl3acl64E8w5MyHPewR7wmXjzuXZ9JTDVNILy+RFcJ
	 c8Dv1OKysp/MHZW/+ABhOXe2l7ehbSTlpuDKcHiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0380/1376] bpf,lsm: Drop bpf_prog_free from sleepable_lsm_hooks
Date: Sat, 12 Sep 2026 08:46:46 +0200
Message-ID: <20260912065616.018132155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 969a6ca362ecb..140c63a816d09 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -293,7 +293,6 @@ BTF_ID(func, bpf_lsm_bpf_map_create)
 BTF_ID(func, bpf_lsm_bpf_map_free)
 BTF_ID(func, bpf_lsm_bpf_prog)
 BTF_ID(func, bpf_lsm_bpf_prog_load)
-BTF_ID(func, bpf_lsm_bpf_prog_free)
 BTF_ID(func, bpf_lsm_bpf_token_create)
 BTF_ID(func, bpf_lsm_bpf_token_free)
 BTF_ID(func, bpf_lsm_bpf_token_cmd)
-- 
2.53.0



