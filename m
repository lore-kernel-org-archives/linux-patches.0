Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039067;
	b=Wu5o+ggVAG2Tu4hNiIL0+AcX3tkboH3k/nKVTd8Np2DsXWkmwbt7P2pu7ek2UtzS4Wlr
	 X4CMNclrDUyWftJLuY9c7lrvEfCVZjQ//y6FcL4L3+3FSWZ15xP0HtNmM6oqE2VK2RX5S
	 NmK8UUM7DSxQkrnka30YSZAxFlj0F27PuA7WOm/KuL7b8svg6sOb/TS0+l7Z6APWKDxhQ
	 0NHoghqry0IED3mK12h5fWJwdJTfUNKcqaZ7/q5CIdUKGNtr20DkAyEwiHmFirLXFp6qR
	 Dr/FkVSZS2iexwiGXjLUNLj+wAgw6O230gNACjrSKa+sqfW9VxMNs0ab7G0SzOSnnng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hzNIFG+RWUT2EXx3gg6QHEmtHtDiOVK4K0r44gNg5eU=;
	b=Hto2Gq62O4OHjJ9kjpKUu/HZTvKEyuZm53CrKVgJCQgGbI/JFwOrdarH5Bl981bKKsid
	 nFXTkbywpktxZvlfzN382R/JHDReD29s1C0iTH9u+8QBZzBdPPluACC0LF+wQHlaDnAYJ
	 GgHOxMvmSkTkBwSBBiqIeKROZHDSine3dOFic/5iTaJ68K9Dj3tWRNikXjibD4QoNqHdb
	 /pj9+lBK4pyrxvuRmeTNDP8ZMAHCLu8DBHHeq2pzSIFEov2TI0djwsEawEJb4WFwblq9A
	 1vELv9fw7MWvZ79BwK+UYgNIqzbBFBYinhCWdI7zlOkCi5JKMH14fbteIaW9UQu/RBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMhXPrgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A288606A31C;
	Wed, 18 Nov 2026 21:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aMhXPrgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694A21F000C5;
	Wed, 18 Nov 2026 21:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039066;
	bh=hzNIFG+RWUT2EXx3gg6QHEmtHtDiOVK4K0r44gNg5eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMhXPrgwnpv1ckGntHtUylAsgE4stmkF+IiS+2mm0KAQOn7s0P50wvzYhd8bv9+pI
	 010psGJAjZIa0YoBo6J99VTz50tk9t1hJI/rbJG80/Kb28/4pSn/HdOQyUoPBlPUJe
	 QuAYh4z9TL6i8TsfTt7kTiO3eAIAUxsEMYGGU71g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1915/3318] mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Wed, 18 Nov 2026 15:42:17 +0100
Message-ID: <20261118150419.455068512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 7135a05838e85845e1bbf6caa6596a7e3b791a40 ]

A VMA is considered write locked if vma->vm_lock_seq equals
mm->mm_lock_seq. The latter is incremented each time the mmap write lock is
released or downgraded, while the former is not updated on unlock.

Both are ints, so after 2^32 such cycles mm->mm_lock_seq matches the stale
vma->vm_lock_seq of a VMA which is not write locked. vma_start_write() then
returns without taking the VMA lock, so readers are not excluded and a VMA
can be modified with concurrent readers.

So far the assumption has been that this overflow is benign, resulting only
in readers spuriously falling back to the mmap lock, however it turns out
that this was an unsafe assumption.

This deviates from the upstream patch, which resets every VMA's sequence
number on overflow. That relies upon mm->mm_lock_seq being a seqcount,
which it is not in this tree.

Instead, make both sequence numbers long. In both vm_area_struct and
mm_struct the field is followed by a pointer-aligned field, so on 64-bit
this fills an existing hole and neither struct grows.

User facing effects are - dangerous races that could cause memory
corruption or NULL pointer dereferences (especially on page table
traversal) are avoided.

Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Closes: https://lore.kernel.org/all/20261015143735.1630957-1-4ncienth@gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h       |  7 +++----
 include/linux/mm_types.h | 11 ++++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c365c33b9c3a8..8bce7f49b6e99 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -670,7 +670,6 @@ static inline bool vma_start_read(struct vm_area_struct *vma)
 		return false;
 
 	/*
-	 * Overflow might produce false locked result.
 	 * False unlocked result is impossible because we modify and check
 	 * vma->vm_lock_seq under vma->vm_lock protection and mm->mm_lock_seq
 	 * modification invalidates all existing locks.
@@ -695,7 +694,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 }
 
 /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
+static bool __is_vma_write_locked(struct vm_area_struct *vma, long *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
 
@@ -714,7 +713,7 @@ static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
  */
 static inline void vma_start_write(struct vm_area_struct *vma)
 {
-	int mm_lock_seq;
+	long mm_lock_seq;
 
 	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
@@ -732,7 +731,7 @@ static inline void vma_start_write(struct vm_area_struct *vma)
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
-	int mm_lock_seq;
+	long mm_lock_seq;
 
 	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 91c10d8b00c02..b6f981c8d1d23 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -664,11 +664,12 @@ struct vm_area_struct {
 	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
 	 * while holding nothing (except RCU to keep the VMA struct allocated).
 	 *
-	 * This sequence counter is explicitly allowed to overflow; sequence
-	 * counter reuse can only lead to occasional unnecessary use of the
-	 * slowpath.
+	 * This sequence counter must not be reused while a VMA still holds an
+	 * old value, as that VMA would then be spuriously considered write
+	 * locked and readers would not be excluded. It is therefore a long,
+	 * which on 64-bit will not overflow in practice.
 	 */
-	int vm_lock_seq;
+	long vm_lock_seq;
 	struct vma_lock *vm_lock;
 
 	/* Flag to indicate areas detached from the mm->mm_mt tree */
@@ -847,7 +848,7 @@ struct mm_struct {
 		 * Can be read with ACQUIRE semantics if not holding write
 		 * mmap_lock.
 		 */
-		int mm_lock_seq;
+		long mm_lock_seq;
 #endif
 #ifdef CONFIG_FUTEX
 		atomic64_t futex_unique_id;
-- 
2.53.0



