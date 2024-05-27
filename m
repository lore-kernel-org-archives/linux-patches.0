Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D086A17E90E;
	Mon, 27 May 2024 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837262; cv=none; b=TbUPnb3S3cGklK53sLCXGcE048QdTERds8SZ/bGtplVAjN6YYeIVZ7nWSVGCPu3rJwOplsEBaeH4zhNEKJXkArdnm1uZ7HhgJpxc6+ldyhuLZo25/YVBbSSB00BfaZ5jNecgfcCTr3a4XTGHY0CAS8weqX20DDCt9Nw+FYxmU5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837262; c=relaxed/simple;
	bh=/TMd9Tshwti61BWkQg4Hmul84FTInqAHTDJwfOGvrsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+esTdCvZkxw0f6CDVlV8a0VfYv9T1B19jVr0s0wgrORohkWbbMseBEAbZ9QMvyf7DcogfuyA2vI02rB6E5LmVUTe0dqf8SjPPSrOiYEneYNonO+/6w9JymFij7jnLNrYCqWRP+37mzB+/SbfcuBsoj3Cb5yIk4pDaBu6ZVknzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TREWwSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TREWwSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B4CC2BBFC;
	Mon, 27 May 2024 19:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837262;
	bh=/TMd9Tshwti61BWkQg4Hmul84FTInqAHTDJwfOGvrsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TREWwSh+zipddUCer3rYHdV7ZfNC0aPrGnaua+APO1rHL7Pyxdy9lL67ofvzqNhU
	 VxEVuJ2jvq41xkJZx9GoebgZFTBFjCSuQMfjb5wTn3pZbzHjxrIqNdt8Lv9p+Xbaak
	 g10P/8WyHkbBZz5I92UYiiJ4c5OoGheH1heHFx14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Rik van Riel <riel@surriel.com>,
	Stefan Roesch <shr@devkernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 374/427] mm/ksm: fix ksm exec support for prctl
Date: Mon, 27 May 2024 20:57:01 +0200
Message-ID: <20240527185634.304744343@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

[ Upstream commit 3a9e567ca45fb5280065283d10d9a11f0db61d2b ]

Patch series "mm/ksm: fix ksm exec support for prctl", v4.

commit 3c6f33b7273a ("mm/ksm: support fork/exec for prctl") inherits
MMF_VM_MERGE_ANY flag when a task calls execve().  However, it doesn't
create the mm_slot, so ksmd will not try to scan this task.  The first
patch fixes the issue.

The second patch refactors to prepare for the third patch.  The third
patch extends the selftests of ksm to verfity the deduplication really
happens after fork/exec inherits ths KSM setting.

This patch (of 3):

commit 3c6f33b7273a ("mm/ksm: support fork/exec for prctl") inherits
MMF_VM_MERGE_ANY flag when a task calls execve().  Howerver, it doesn't
create the mm_slot, so ksmd will not try to scan this task.

To fix it, allocate and add the mm_slot to ksm_mm_head in __bprm_mm_init()
when the mm has MMF_VM_MERGE_ANY flag.

Link: https://lkml.kernel.org/r/20240328111010.1502191-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20240328111010.1502191-2-tujinjiang@huawei.com
Fixes: 3c6f33b7273a ("mm/ksm: support fork/exec for prctl")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c           | 11 +++++++++++
 include/linux/ksm.h | 13 +++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index cf1df7f16e55c..0c5f06d08c355 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -67,6 +67,7 @@
 #include <linux/time_namespace.h>
 #include <linux/user_events.h>
 #include <linux/rseq.h>
+#include <linux/ksm.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -267,6 +268,14 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 		goto err_free;
 	}
 
+	/*
+	 * Need to be called with mmap write lock
+	 * held, to avoid race with ksmd.
+	 */
+	err = ksm_execve(mm);
+	if (err)
+		goto err_ksm;
+
 	/*
 	 * Place the stack at the largest stack address the architecture
 	 * supports. Later, we'll move this to an appropriate place. We don't
@@ -288,6 +297,8 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 	bprm->p = vma->vm_end - sizeof(void *);
 	return 0;
 err:
+	ksm_exit(mm);
+err_ksm:
 	mmap_write_unlock(mm);
 err_free:
 	bprm->vma = NULL;
diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 401348e9f92b4..7e2b1de3996ac 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -59,6 +59,14 @@ static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 	return 0;
 }
 
+static inline int ksm_execve(struct mm_struct *mm)
+{
+	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags))
+		return __ksm_enter(mm);
+
+	return 0;
+}
+
 static inline void ksm_exit(struct mm_struct *mm)
 {
 	if (test_bit(MMF_VM_MERGEABLE, &mm->flags))
@@ -107,6 +115,11 @@ static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 	return 0;
 }
 
+static inline int ksm_execve(struct mm_struct *mm)
+{
+	return 0;
+}
+
 static inline void ksm_exit(struct mm_struct *mm)
 {
 }
-- 
2.43.0



