Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590414;
	b=B0/IyMXwEkfoXiTDpTgKy/aUlr+QZlvK6znedXg0MhHKc9XGTmNDIt1CCSmqqcXlKJ+e
	 t/DADQ0do2MFoScSQbsYvysBxRvnPqqqtZZJoNTFwYRBmwuwXIkt0Zl2XJGxi73bN8j1W
	 myVJHCL33tZsSdbRBxMptgjjM4Ll4J47NZw8UIYUceSQgWkwCMkdJ9LCuojG2xMhJusBO
	 YfkEdOZiyCtH0C+cNdvTjVp3Y9VOv56RGa8eMNSRto97y5ziIM5SxkysNbV46oOp+R6QI
	 VPI0wpd3n2XU/yJK0ny2p9sH3QhH7wZWpWY2JGwq5QcrIcc3mtWUgIHvlAoano2bbNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vo8EZQnxxxQCInbVsQRSw15zky5zFIvamxv9n10//8s=;
	b=2GYOptUQAWMGERgx0pPqWyTf3GEjHjPnie3S74iWAIEedzsHmGYwRB5NIvVA92UJlMie
	 3NaIRnut+9PqbJi508v3ZRB3Waz191lZLc+Y1cjiri9mv/HDBLmEMowThhJen1yH5N18o
	 Bd6MlMtmzgdWMssdHfz7/n3H79cH5Dfz8lcPBlvJCKtNIWaP/AYt1p3bQr5HTp1RCKB7T
	 /HFNmmNdMwmDMVvJEVVYcNORhhcdQ8VZN0llLvf/QPCDdd2XSIp9NokOzFR1uA/XqtF9p
	 h8RTkzsTJkMD+l5/seTNZkpAtUXi/nZF+orPXzsMri9czpXvtpr37MiEHNZIoXXE0pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNJevJm6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885B5606A8A2;
	Fri, 13 Nov 2026 17:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNJevJm6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4AD1F000C6;
	Fri, 13 Nov 2026 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590414;
	bh=vo8EZQnxxxQCInbVsQRSw15zky5zFIvamxv9n10//8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNJevJm6fekrJt6GtjKiTx2jFRtAKOgM9QRiLSjzJyqALOW23YPPDfMSom+7RI8q2
	 lYBlyS2zz5mmS27iMbXqSjOvPyB5IfpcDqzGoOIU0d/GtA0uL4S8+SuGMk5Ud1uSl+
	 yhwasiQkwt/72nNplqseXbu9+rduXXwpYBHVqsYU=
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
Subject: [PATCH 6.18 380/686] mm/mremap: recheck PUDs under the page table lock
Date: Fri, 13 Nov 2026 10:48:33 -0500
Message-ID: <20261113153833.799773016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 1830ecb91e3c1..369e1406854d3 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -448,14 +448,18 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
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
 	flush_tlb_range(vma, pmc->old_addr, pmc->old_addr + PUD_SIZE);
+out_unlock:
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
@@ -490,7 +494,9 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
-	old_ptl = pud_lock(mm, old_pud);
+	old_ptl = __pud_trans_huge_lock(old_pud, vma);
+	if (unlikely(!old_ptl))
+		return false;
 	new_ptl = pud_lockptr(mm, new_pud);
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
-- 
2.53.0



