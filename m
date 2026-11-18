Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060108;
	b=hU1JgqvPIQVBewNONG33h7p9cm4Dd6mSXA8ssxl3XMSyLIpy6/wIGEo2dXZyhqjDTUjl
	 zsIigq7PfGLbdPgP8Lsqf7+gvk1yWmcl3iSF1exCAXejs05ZHMx4G4d1yzjVtsUZbg0Zs
	 AFbE+Vbgb0iWH5L2PnKIsOM7VTr7w3j4xhLosqsqGnni/FZdI0VS+CedJ7HLzF0F0EnFF
	 E5E/D9TaGNuJiUkpJZGMFByNeX0EcK1FBE6/sUrQRSl+rXkQad3kPEb4YBplY+kmJZkzZ
	 yvnP+FAduZu2dxQVe8XbYYkaYZj7HveZ12O1TmuNwPjz4o5XmFtbjfWmDC96M2XK46g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2HB4C5eDRrxopyJySfsbiKTFNmEEDwmInx+fsf+s1FA=;
	b=edQBLs262EJTbEIarr8O6ydYcb5ZiCBYAZ+cD4RW214Ee3DEEUk8V3VSiplUWsF4cl3L
	 LAdf1sGB4YY3RK6/Yb0ZBu9lSLjKtnj2T1XbOQC4Xf7dZyW7tLMqjbeKVFd5Zn+lw857L
	 q1J/ipha3/y+4xTbsJWVQLREf76GQLHUYRJAgJBJ9TdGT3AGFAnPB0kgAw4EuWYHUnQUe
	 bCrwhBWCSjXW+Mrmpdaacg4j0My1RYDzGxmpPoR7buCSxbmJoHIhD/hjo1uCD/yWGblx9
	 C+/xzesN3LNs3DHuWo49QJxxEjfzVhw5l7Avyjo9hKE5A0Rsd3ox7c7mcttyoqbEHMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYgwJ8dX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737A0606A326;
	Thu, 19 Nov 2026 03:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vYgwJ8dX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0601F000C4;
	Thu, 19 Nov 2026 03:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060108;
	bh=2HB4C5eDRrxopyJySfsbiKTFNmEEDwmInx+fsf+s1FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYgwJ8dXFGCDqhLHcq6n7IgnSiV1xNgqHFUUGtXC84GzC5CoAfYsjXbabd1TJMRsM
	 nNfc7Lc5xDhRrfi/2VCipHBZZMIIBcaXZR9Ud4i30PCSwmQJNqhjHdwU2xs+nCg4IT
	 a9WbACMAz02rjiVb3ywuAO1aw1zqnlnMfZhKkYyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	SJ Park <sj@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1081/1848] fork: take mmap_lock before copying mm_struct
Date: Wed, 18 Nov 2026 15:51:59 +0100
Message-ID: <20261118150003.652604162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit ef694e2d210111cc08c52fd25da9ab130170bfa3 ]

dup_mm() copies the parent's mm_struct before dup_mmap() takes the
mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
and newer heap mappings, causing later brk() requests to fail.

Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
cause inconsistencies.

As a simple and robust fix, grab the parent's mmap_lock earlier. This
way we don't need to update individual mm fields in dup_mmap() and
keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
exec_vm, stack_vm), as that is now no longer required.

Keep releasing the parent's mmap_lock in dup_mmap(), before
userfaultfd completion, to avoid moving the userfaultfd handling into the
caller. This should get cleaned up later.

Move uprobe_start_dup_mmap() to preserve the lock ordering.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-2-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adjusted dup_mm() failure handling for existing uprobe cleanup in dup_mmap() to avoid a double unlock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index c39de3ee8f537..93da8037f1ed1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -478,11 +478,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	unsigned long charge;
 	LIST_HEAD(uf);
 
-	uprobe_start_dup_mmap();
-	if (mmap_write_lock_killable(oldmm)) {
-		retval = -EINTR;
-		goto fail_uprobe_end;
-	}
+	mmap_assert_write_locked(oldmm);
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
 	/*
@@ -493,11 +489,6 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	/* No ordering required: file already has been exposed. */
 	RCU_INIT_POINTER(mm->exe_file, get_mm_exe_file(oldmm));
 
-	mm->total_vm = oldmm->total_vm;
-	mm->data_vm = oldmm->data_vm;
-	mm->exec_vm = oldmm->exec_vm;
-	mm->stack_vm = oldmm->stack_vm;
-
 	rb_link = &mm->mm_rb.rb_node;
 	rb_parent = NULL;
 	pprev = &mm->mmap;
@@ -608,7 +599,6 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	flush_tlb_mm(oldmm);
 	mmap_write_unlock(oldmm);
 	dup_userfaultfd_complete(&uf);
-fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
 fail_nomem_anon_vma_fork:
@@ -636,7 +626,7 @@ static inline void mm_free_pgd(struct mm_struct *mm)
 #else
 static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	mmap_write_lock(oldmm);
+	mmap_assert_write_locked(oldmm);
 	RCU_INIT_POINTER(mm->exe_file, get_mm_exe_file(oldmm));
 	mmap_write_unlock(oldmm);
 	return 0;
@@ -1375,10 +1365,18 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	if (!mm)
 		goto fail_nomem;
 
+	uprobe_start_dup_mmap();
+	if (mmap_write_lock_killable(oldmm)) {
+		free_mm(mm);
+		goto fail_uprobe;
+	}
+
 	memcpy(mm, oldmm, sizeof(*mm));
 
-	if (!mm_init(mm, tsk, mm->user_ns))
-		goto fail_nomem;
+	if (!mm_init(mm, tsk, mm->user_ns)) {
+		mmap_write_unlock(oldmm);
+		goto fail_uprobe;
+	}
 
 	err = dup_mmap(mm, oldmm);
 	if (err)
@@ -1397,7 +1395,10 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 	mm->binfmt = NULL;
 	mm_init_owner(mm, NULL);
 	mmput(mm);
+	return NULL;
 
+fail_uprobe:
+	uprobe_end_dup_mmap();
 fail_nomem:
 	return NULL;
 }
-- 
2.53.0



