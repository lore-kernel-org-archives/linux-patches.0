Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAFE36D9E9;
	Sat, 28 Feb 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301441; cv=none; b=nEUyCb40EmH4jw94i7dz+fHo9jggp89itbFfOmETu7mqRvux7I+SkITa8lrWqaEsE9L8bhEwjTDpa1xfNU5YJ03QjCNj78KQyoevfMsO20JM5icHBfGQT0SZksT5vPIQOj4fJtTAuqpsM9THt46rk+ahWKlmWlr0BdU4h2WCv0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301441; c=relaxed/simple;
	bh=5s8BBKdf4ztkBwOi4i6eDwdPKMgB3eEiCkhMfk7U7/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXLw7GemV7YnTP0OImRDGgfHnbY8a9IUM5884CM3FYhR9G3pO0npohgh5/K0l5iWK0Rpt8sXasfReVpvPcIoqcQ6JGylCKCP1wLDfPeyB2aGgQGeS36HJxhmEwHiO4EsFnpsAi138adSaKrgkkiav7UBEawTuSkzeAqmYStXfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PgqvI3s4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgqvI3s4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397DAC2BC87;
	Sat, 28 Feb 2026 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301441;
	bh=5s8BBKdf4ztkBwOi4i6eDwdPKMgB3eEiCkhMfk7U7/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgqvI3s4uqnL3DfUfiAH4lq2UgquU02rCVyh82FY3zDXPtwSjniftHwAVF1rVQgGc
	 OKei7XXggxwn8tlzRKTXX0C0O0eRtr2ZO/t3wbBnvbMgHVLEh2qPcslTrMGJRBWh2F
	 jR1sIc+Z9KYPXESMRAsLJHXKpWDWlrsHKE+WMf/ACrv+BeVVpXuUU/0JCC99uF6PQu
	 9LgkIVz5iaepsYPKPUoZLJR5DSfwps84SmqsOBjN9ZNxgPr3Ix3g12moa8YycmvNgQ
	 RJ/GxSKsRDWGC6QPj7eHXJl4e5cDcAg46+ZLNMmuoz0LuPneEdhSSSfv092oohpmLU
	 oCHlaNaErxUOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com,
	Uladzislau Rezki <urezki@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 627/752] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node
Date: Sat, 28 Feb 2026 12:45:38 -0500
Message-ID: <20260228174750.1542406-627-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 5747435e0fd474c24530ef1a6822f47e7d264b27 ]

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU read
locks.  Processing a large purge_list without rescheduling can cause the
task to hold CPU for extended periods (10+ seconds), leading to RCU stalls
and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs stack
unwinding under RCU read lock.  Without yielding, this creates an
unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with a
batch count of 32 as a guaranteed upper bound to prevent worst-case stalls
even under light load.

Link: https://lkml.kernel.org/r/20260112103612.627247-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4fbd6e7dc479a..e2f526ad7abba 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2241,11 +2241,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 	reclaim_list_global(&decay_list);
 }
 
+#define KASAN_RELEASE_BATCH_SIZE 32
+
 static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2255,6 +2258,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
+			cond_resched();
+			batch_count = 0;
+		}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
-- 
2.51.0

