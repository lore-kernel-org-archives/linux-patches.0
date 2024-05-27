Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A0961FDF;
	Mon, 27 May 2024 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838676; cv=none; b=stMMzW/etnX2X3F8qjsclmdLla0yWFkvV9NWMJKWEXmQfZhfWubLv249mKTr+tYpHMxvnUNhYc9KJXAqHYmZs/HPQwVrsH5ija+5E9dYJpfi7aO2wCFPk3ejFgUf9QUynlEOOWBDQ+QR0AYx6yK4RIF1PnNdHhxK+YS/5Sy8d/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838676; c=relaxed/simple;
	bh=S4dujCP0o7DL3Wmuy+uY2uv4O9Azl5PbBkN5rXjcnaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB/+GNKGTGFUKw8cfrX6JAB9B3aB6v5nCQ4V6XlNGvSnh9ULJpmsa0cJ33HhM5HamQ0pu5+EkagYk+m9tpodn3qz2nMjeraXtx4jOhxCkp7FXrspFfF+9i849+ZZ4KZzdE7I7LU/1ajXg+wadm/vDGGJf3nn6SV3pQJmzYGblV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1cZn3pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1cZn3pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC0EC2BBFC;
	Mon, 27 May 2024 19:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838676;
	bh=S4dujCP0o7DL3Wmuy+uY2uv4O9Azl5PbBkN5rXjcnaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1cZn3pNDz5Vjia331a9ygjDFD0Liw88ad/JJV48wgSpRo5fYHA6PK9mQ/OHfIXeV
	 Wz9oO6rsSZgkKmYWbPey7w3wj07mxPKN9uF4gBesLGEnxUjDvpZTSBmlUoQ7zl6URE
	 CzMZ17UgAhP/h5JyHVMe+Zv/m+goCUMX2qeZJzdY=
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
Subject: [PATCH 6.8 442/493] mm/ksm: fix ksm exec support for prctl
Date: Mon, 27 May 2024 20:57:24 +0200
Message-ID: <20240527185644.712586539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5ee2545c3e183..f11cfd7bce0b1 100644
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



