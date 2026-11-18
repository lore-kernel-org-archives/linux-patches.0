Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038891;
	b=FRbZjfXzLdTKR1AN+ynaZ5X3j+UyGRHmk0HkbW+l9QTEnbu4sdi0GnIMsexGma9jB2zq
	 C+4CgE2HdXsxOY6KL8KmJZHvDBHvkM4LpLnCbu7QCIGDT2Eul0hfyeClOXfGXxF2etv6T
	 i3h/d6dnvxK5xtMCOENRCTlt7rfYYBTUPrXnuikuJzwG5S/z5gkHHRONN17T8bdMB2WLF
	 spjn4/8EyylABCRILAQ3BlOBEUKyMPgjdyrRk60U6yb8oxfpVrBVtTZuGFzmH28OobxoV
	 RiecAXsbsEOFy69276n6jDl3bw8PX3OTZ+1jfMrezHnH6K2YPEERu6oPYeTQpF6BGaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=slLStzR0KKTys96lS6DrIMNVwWlZGuj3Ojk2d6+pWY4=;
	b=erHugyf20mDjEjnPUeCII/mNN6896oD9xqA1Xbjm/ol194/qgZQsqxD6/Mq0JuH4HDye
	 a4Mr8R8bKFBZuTXGo/30wvzCioF/iRwG8TA4oWu6AMZVooFc3Xaq1oX+uW6vpKxPH5u/O
	 CD+xXL+ZZfJxehLII+1x35uzskIWZRcvpFArqT1A3ePjwriRXiGjRTThpiDb1o+EtqjQu
	 7ev9fZaleoceM/KY9ikB4JN10+QYTYqfeBt6WOMWykfqfiybxm7Da8scb5at4UiJSok/N
	 sMvyGv990bgBLVClvDOaNBPgcHB1jJe6VNeewhdp9c1BU8cTM5vk+uHN9VvdP8O4NDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/LFhtiR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BC9606A31C;
	Wed, 18 Nov 2026 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/LFhtiR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707191F000C4;
	Wed, 18 Nov 2026 21:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038890;
	bh=slLStzR0KKTys96lS6DrIMNVwWlZGuj3Ojk2d6+pWY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/LFhtiRA8gGxPvorZd2dIwdQMCna9PpCoJbJyahPbe4+5xskqQIdxiXlfjEq0J+m
	 A6xVE4Vpe3HYHqV9WaS/dr/YywT3mLRYbD6LEMf3aB9J/Y3xuX4AL7QgJnmhe18HgN
	 20L41Yv3QrktYq6z3eDAhxaMXyGmMZfW8uJK4HTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1903/3318] mm/mremap: recheck PUDs under the page table lock
Date: Wed, 18 Nov 2026 15:42:05 +0100
Message-ID: <20261118150419.098345640@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 402882943dfa8bab5c2bcc66189f9fb2828f248e ]

Once get_old_pud() is fixed to accept PUD leaves, unmap_mapping_range() can
clear a leaf between the lookup and the move. Holding mmap_lock in write
mode does not prevent this.

If the zap happens before move_page_tables() tests the entry, an empty
PUD can reach move_normal_pud(), where pud_populate() turns it into a
present page table entry. If it happens after the test, move_huge_pud()
can instead try to move an empty entry, triggering CONFIG_DEBUG_VM
warnings on powerpc.

Recheck the source under the page table lock in both helpers. Treat an
empty source in move_normal_pud() as a completed move, and use
__pud_trans_huge_lock() in move_huge_pud().

In the future we should likely have the code lookup a PUD/PMD lockless
once, instead of multiple times, because one of the problematic bits
here is the:

	pud_trans_huge(*old_pud)

Fixes: 0881ace292b6 ("mm/mremap: use pmd/pud_poplulate to update page table entries")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-31-d6437171ecc3@kernel.org
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: adjusted context for move functions using explicit vma and old_addr parameters instead of pagetable_move_control ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index b5812dab84d55..494064a9719de 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -364,14 +364,18 @@ static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_addr,
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
-	/* Clear the pud */
 	pud = *old_pud;
+	if (unlikely(pud_none(pud)))
+		goto out_unlock;
+
+	/* Clear the pud */
 	pud_clear(old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
 	pud_populate(mm, new_pud, pud_pgtable(pud));
 	flush_tlb_range(vma, old_addr, old_addr + PUD_SIZE);
+out_unlock:
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
@@ -406,7 +410,9 @@ static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
-	old_ptl = pud_lock(vma->vm_mm, old_pud);
+	old_ptl = __pud_trans_huge_lock(old_pud, vma);
+	if (unlikely(!old_ptl))
+		return false;
 	new_ptl = pud_lockptr(mm, new_pud);
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
-- 
2.53.0



