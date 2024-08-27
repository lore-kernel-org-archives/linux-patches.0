Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7131C3F0D;
	Tue, 27 Aug 2024 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771946; cv=none; b=uRMqiiFHUzxCng2xwvJ5xEEYjC7p4yCeB1/LpEWekFNUaDotMLd2Kut0GOEYAMHgu+seQxpkqDcWdXDSEm7BH+C0t0g0SXOpvhu30VKL3OhnaM4TUQtxHYLFbW8jkWf2zZZafRye37kvU4X2U7Jfeyz6pwVnaLOiMToWTphDWwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771946; c=relaxed/simple;
	bh=OtknPnSPNeqeLUCI2t6CxhYnzAJh0/KTKO3llU4qqng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j26CKg71laMyCmMqc5U+ZWG7D9VzTBnZAmG0ywfZ3rAx/peq2I5hMbWL9au10cAuh5jxAZMRYXQwRVCGS/HuftKzd/1EN7wQhurqTzOnlcjkVuVOUfc8vS5/njHvtoSY4og23PHmENXnUgNzvuGWuq4vnyUpieu8wCg1RQc5ATw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEH8+XrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEH8+XrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE330C61067;
	Tue, 27 Aug 2024 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771945;
	bh=OtknPnSPNeqeLUCI2t6CxhYnzAJh0/KTKO3llU4qqng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEH8+XrVPYqxHhtukL4H56MFKRVWxoRYqn3dt6vxKztNdeE/C2glkjXu/jzXDod+f
	 Y0Dx4VGl/NhsokcX99kk9U4fFpmrAYX0bC60W7L5hQ28mLLh1lWa9e9m7FMumsWa6+
	 U8pUOVNgf7JA7hQesD1jMh8vu6ciKw1HTnJy8aS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	syzbot+9578faa5475acb35fa50@syzkaller.appspotmail.com,
	Zach OKeefe <zokeefe@google.com>,
	Yang Shi <shy828301@gmail.com>,
	Himadri Pandya <himadrispandya@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Song Liu <songliubraving@fb.com>,
	Rik van Riel <riel@surriel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/321] mm: khugepaged: fix kernel BUG in hpage_collapse_scan_file()
Date: Tue, 27 Aug 2024 16:35:45 +0200
Message-ID: <20240827143839.635707929@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit 2ce0bdfebc74f6cbd4e97a4e767d505a81c38cf2 ]

Syzkaller reported the following issue:

kernel BUG at mm/khugepaged.c:1823!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5097 Comm: syz-executor220 Not tainted 6.2.0-syzkaller-13154-g857f1268a591 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:collapse_file mm/khugepaged.c:1823 [inline]
RIP: 0010:hpage_collapse_scan_file+0x67c8/0x7580 mm/khugepaged.c:2233
Code: 00 00 89 de e8 c9 66 a3 ff 31 ff 89 de e8 c0 66 a3 ff 45 84 f6 0f 85 28 0d 00 00 e8 22 64 a3 ff e9 dc f7 ff ff e8 18 64 a3 ff <0f> 0b f3 0f 1e fa e8 0d 64 a3 ff e9 93 f6 ff ff f3 0f 1e fa 4c 89
RSP: 0018:ffffc90003dff4e0 EFLAGS: 00010093
RAX: ffffffff81e95988 RBX: 00000000000001c1 RCX: ffff8880205b3a80
RDX: 0000000000000000 RSI: 00000000000001c0 RDI: 00000000000001c1
RBP: ffffc90003dff830 R08: ffffffff81e90e67 R09: fffffbfff1a433c3
R10: 0000000000000000 R11: dffffc0000000001 R12: 0000000000000000
R13: ffffc90003dff6c0 R14: 00000000000001c0 R15: 0000000000000000
FS:  00007fdbae5ee700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdbae6901e0 CR3: 000000007b2dd000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 madvise_collapse+0x721/0xf50 mm/khugepaged.c:2693
 madvise_vma_behavior mm/madvise.c:1086 [inline]
 madvise_walk_vmas mm/madvise.c:1260 [inline]
 do_madvise+0x9e5/0x4680 mm/madvise.c:1439
 __do_sys_madvise mm/madvise.c:1452 [inline]
 __se_sys_madvise mm/madvise.c:1450 [inline]
 __x64_sys_madvise+0xa5/0xb0 mm/madvise.c:1450
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The xas_store() call during page cache scanning can potentially translate
'xas' into the error state (with the reproducer provided by the syzkaller
the error code is -ENOMEM).  However, there are no further checks after
the 'xas_store', and the next call of 'xas_next' at the start of the
scanning cycle doesn't increase the xa_index, and the issue occurs.

This patch will add the xarray state error checking after the xas_store()
and the corresponding result error code.

Tested via syzbot.

[akpm@linux-foundation.org: update include/trace/events/huge_memory.h's SCAN_STATUS]
Link: https://lkml.kernel.org/r/20230329145330.23191-1-ivan.orlov0322@gmail.com
Link: https://syzkaller.appspot.com/bug?id=7d6bb3760e026ece7524500fe44fb024a0e959fc
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reported-by: syzbot+9578faa5475acb35fa50@syzkaller.appspotmail.com
Tested-by: Zach O'Keefe <zokeefe@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Himadri Pandya <himadrispandya@gmail.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/huge_memory.h |  3 ++-
 mm/khugepaged.c                    | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 760455dfa8600..01591e7995235 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -36,7 +36,8 @@
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
 	EM( SCAN_TRUNCATED,		"truncated")			\
-	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EMe(SCAN_STORE_FAILED,		"store_failed")
 
 #undef EM
 #undef EMe
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 65bd0b105266a..085fca1fa27af 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -55,6 +55,7 @@ enum scan_result {
 	SCAN_CGROUP_CHARGE_FAIL,
 	SCAN_TRUNCATED,
 	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_STORE_FAILED,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1840,6 +1841,15 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 					goto xa_locked;
 				}
 				xas_store(&xas, hpage);
+				if (xas_error(&xas)) {
+					/* revert shmem_charge performed
+					 * in the previous condition
+					 */
+					mapping->nrpages--;
+					shmem_uncharge(mapping->host, 1);
+					result = SCAN_STORE_FAILED;
+					goto xa_locked;
+				}
 				nr_none++;
 				continue;
 			}
@@ -1991,6 +2001,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 
 		/* Finally, replace with the new page. */
 		xas_store(&xas, hpage);
+		/* We can't get an ENOMEM here (because the allocation happened before)
+		 * but let's check for errors (XArray implementation can be
+		 * changed in the future)
+		 */
+		WARN_ON_ONCE(xas_error(&xas));
 		continue;
 out_unlock:
 		unlock_page(page);
@@ -2028,6 +2043,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	/* Join all the small entries into a single multi-index entry */
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	xas_store(&xas, hpage);
+	/* Here we can't get an ENOMEM (because entries were
+	 * previously allocated) But let's check for errors
+	 * (XArray implementation can be changed in the future)
+	 */
+	WARN_ON_ONCE(xas_error(&xas));
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
-- 
2.43.0



