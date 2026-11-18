Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047464;
	b=ZuMKRxifkybWDKVNGrnAHRZBc8SYhkkyg38gMofNMdA4ZqXPozyy3BmZJMjh7mDNdvAY
	 EYbIVjzVLy0fUK19M1ItvyBX71EbCw7Wkf0W7sRKLkWvGDAO8mWaIPUa4j/8+Ay4LoAsK
	 eh/o94usanCvXa8OTyTU/o5MVE6s4QjtWTcAoD8E5dpUJVzFQmx0qpGihswMw3TVx5zvU
	 CQM2zt4xIbyp6JueJBS5SgDlSRKJpfQOKHFHZ/uskZPEA606rpj14ahh0Uxlc1POx//Ey
	 wC4FLBSwd3n1IQmvhmN8M+UvYo1IS9s1FH2QwJbrrhfPZZvqSkyfmz2sJLk0DViKhrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZwCHs2YWxSWaY9ca68RYSU/KLNgy9pg6SBVvJOvdQh4=;
	b=lML6z5GHCRpcJFFwdwmVQhigsQcFVeklENI6RqHxxxYS97TJCQsYslUzHs6yVeNlHz5A
	 cRoBXPVLVuIQ669cMkaFcNVFTVtXA4n3MGftzebokcJh9U8L1wEJvTXkCPgUxiSVIvNSw
	 Y1OPBxzmzaYuRrOCHfNKrl6dSBWOmZS6iG+TB/SSOX1Q2nzedYN9EQbzuGG1IimmEvfC7
	 Lp2mC2x/baXYLVwxVd+aVeu09Y6s0+ztB2Ag7lyA+3cz5+T4syK4dpw4KVQoXnNPF/gvK
	 eFwV/YznI30PEVUpsTQi5KoTVVgc/qov1KEr8Qwu82lTERt852pnxJI7Tg49bM5rz+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oDVP2/fj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD773606A32A;
	Thu, 19 Nov 2026 00:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDVP2/fj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347C61F000C4;
	Thu, 19 Nov 2026 00:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047464;
	bh=ZwCHs2YWxSWaY9ca68RYSU/KLNgy9pg6SBVvJOvdQh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDVP2/fj2U9HyG/gymSjrE/7OmBeU0OZ+/ItjdVqcrqSO749yEZpL8s24rQHsulro
	 ZwszkuLQ2c2lWBhxv5okRiYsLwNl695HB03BZkJNKPqfGBqXJrg8js+Qi5QN5BPbe3
	 PmUsQYxfcRQ4tiFOpSaagxdeqI/AR3Fo0fSIGLvw=
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
Subject: [PATCH 6.1 1649/2857] mm/mremap: recheck PUDs under the page table lock
Date: Wed, 18 Nov 2026 15:44:43 +0100
Message-ID: <20261118150300.709668987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for move helpers using direct vma and old_addr arguments instead of pagetable_move_control ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index b60be8b941674..dab123e521cda 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -346,14 +346,18 @@ static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_addr,
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
@@ -388,7 +392,9 @@ static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
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



