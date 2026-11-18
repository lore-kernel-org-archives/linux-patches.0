Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047553;
	b=qxEd7xpm7ff5BDLhSLzCnFqGEClvTnfrQaZM1u2n40N1zl5s7fcQS1APVkP1HVwnE2kY
	 RTcDdR3YL+5LP5kIwpGZtl2eBHj3a7dRc72v9XyS9rVni82ZUd4B/rkIJRu1VO73kslVp
	 MZ6K29BbQ+lwOmn482bFPJyrQs6lq1RTUCdAKAv9jKOOUsNUFwMb99GwtSdx3xp13Cnq3
	 VRTGWloe3WulRPwUNWf5gTrPF1LRaEJuf+/n124sUuf/DXkVZLYflLeTund5WJ0GpTQr1
	 4HbMVDjkX7DsKKEPkYwOFeYkWfhE4P9SH6TsdgO4DB8hH4np5xuourJdQ9YCnDBzbOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p6W8vAx5t0FU3lAtqtBkfQLGFLhpDc3YyAF5w+VcaKg=;
	b=NHLqkaRvBkaGRlKuRb8B/L1SGJ10T+zeNen5JNWR56meNeopTLqFFu+KnIUTBksLdhZQ
	 7jbFBIqCSiKdyzNpK4AYYWteM1R8g7TVsFxJmNmyBpS7mLPZRBQiEGB+83X+MpT4K7kpL
	 Z3V6WcfhCV2h3+cYBXhokPr7So/qVwMhvAh4fppGQlc7jpmnw4q7jeLBvGiR9cox8tzmX
	 s+0GWYWBvJzL3CWYjvdgEZplSjCZIRf3eTFVphJokN6yOJaCjBdA0mIGGFr1Y5LHyEQ+F
	 +snhtnzOJTxqdIMMcr11KjSO7cTcp1tjldodG+WQdIhm9PGO5ADbybtB5E40qr7XPEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0bEc1d4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DCA606A320;
	Thu, 19 Nov 2026 00:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0bEc1d4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66461F000C4;
	Thu, 19 Nov 2026 00:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047553;
	bh=p6W8vAx5t0FU3lAtqtBkfQLGFLhpDc3YyAF5w+VcaKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0bEc1d4FfV5t0zeFoNOwHZvESWRB0UeCakCGtZXNXDXQs2CnGxCICnf2wC3poUgw
	 tF7zd9q6bkifWEQ+AKJUBuhaHvGy6+4xUzFkZTocDHFNa4Ttzb7Be4ssejBZoSvGZ2
	 E7cTRXSu5cwIKhw6Ral67cyrTIyRdQL+gr99kWkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Dev Jain <dev.jain@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1678/2857] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
Date: Wed, 18 Nov 2026 15:45:12 +0100
Message-ID: <20261118150301.750764278@linuxfoundation.org>
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

[ Upstream commit b4417d08034a7b4a3083e0e2d95429d4542524f2 ]

move_huge_pud() reads the old PUD and clears it in separate operations.
Hardware accessed or dirty updates between those operations can be lost
when the saved entry is installed at the new address.

The raw pud_clear() also bypasses page_table_check_pud_clear(), while
set_pud_at() accounts for the destination mapping. This leaves the
checker counts unbalanced for mappings tracked by page table checking.

To fix it, simply use pudp_huge_get_and_clear().

Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-30-d6437171ecc3@kernel.org
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced pmc->old_addr with the direct old_addr parameter in pudp_huge_get_and_clear(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index dab123e521cda..469ebb43518f0 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -400,8 +400,7 @@ static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-- 
2.53.0



