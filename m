Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054486;
	b=1tMQIyfWjhtewHRhnNbdaYij+NNBXlGGxehcKGqq8U1Xs7URL3oBoBcQzwTtsI+VD4eZ
	 5OmsxoeBqrOGDaLZ29kVUBI57HSBcUnQEJaJGQAiRPiUmhnSixSF6U3VBwyXmay2yooWQ
	 3abTFdZ7sjFKV7aHbEcpxjWlSP6p8tBkaK7R4tLaxAOTYo2VvW2ox2Xi7OYiMW089i0/n
	 /Km8QMCw56OCnetToDLDtLyAVkkmo2BwIp9IMwjrB80y0SlIWHpJwbjh9Ty9YVRSvPXhS
	 Pk9xLzP1Ay5LUzXZopi5DZg2P+ow8qEJ4ln637O5a/2hO9myECz3arQFKFynlGm4ahQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cV9ywiWYEOBu5Z/peR8gvZz9rMPUXVuEDsRHaDRANmU=;
	b=sPqz9TUwJ2v8BcFyGPi+L644Z3e5k1wFn3IcE6goP6xlnvmHKKvgyjxL1eAKYLYEGYrt
	 +QwftXcsnwIKhE/E3Aivakl8693WcSlmzBrBwoc0ziqbRi/ChQnsiv76ujTUB7T+GDCfN
	 ifWAF2aAz0CNk+wlSxd+Cl6OZfgsMV6j1kmvmoqedq3bb9CFa9XHrlyDDHGQnj4fE9JTY
	 +3WJ8BMmcOdJEu0g25SoWmBBCqhs02srdoHBsbwo5+YjtctRTdqGwgJYYPZ4EeBSYSKqZ
	 pXt8QJwB8S9u4L71OSRYaF+w7eszLsNCHEhy7z67snq8mMvEo3KWrEDu2t9HimhJz8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfqDrTM3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5D2606A320;
	Thu, 19 Nov 2026 02:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfqDrTM3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5351F000C5;
	Thu, 19 Nov 2026 02:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054486;
	bh=cV9ywiWYEOBu5Z/peR8gvZz9rMPUXVuEDsRHaDRANmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfqDrTM3X58+K4F09ydUF0xyVVuWOLlyWp8eUTuWoKtY1OVvLIIZVYHt3qZgW5nZj
	 ec6ANtr513TpCjujeBPhj/D4xiybvfAKIS1/Hd9IKs3IHtu9asLdyBrLqpzEjbHJCh
	 8Xk4RSm3aHX1ldUIbRHkEWZvYgFtqLIRzi3KUqGk=
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
Subject: [PATCH 5.15 1251/2214] mm/mremap: recheck PUDs under the page table lock
Date: Wed, 18 Nov 2026 15:48:47 +0100
Message-ID: <20261118150101.721156922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for separate vma and old_addr parameters instead of pagetable_move_control ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 518d9d36fc9ab..a5dcc91ee93c1 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -314,14 +314,18 @@ static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_addr,
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
@@ -356,7 +360,9 @@ static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
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



