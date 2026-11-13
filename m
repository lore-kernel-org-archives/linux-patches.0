Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585714;
	b=KJtVrdMSwAVOebV9ad9GMJyXvq1nudgUCZnzjbp/77MjFImTGdqWiFsMzP2EjT5ZGXkP
	 39SyVya+V7a1yaAmQSc57BNxKBxFcznhpRxgll6EghEncpEA1YmMvrXZBVCySXtFJMc4m
	 /NB3srEDQRIAw6q3jQDDjBv/qDQUnFnXSstem4q82xoVQM6YYyqJvwnGND1WeaX2HlI//
	 ZVsmLzUWvuBcEbCQa9Pm2Z9lAeR31Q2hp6IrULIsWnWRgM+qAxOO4UGJwC3JIxnSjurW6
	 F7su/Y21aI14Vgp8FJRM+Uy1A6Lvib/0KUea/MAax0gtqlGvLGqLZVagFqt+j4NwGEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P3N79i9n3oI/dN4cLVB98y3AmQkL4Ml/ul8I0TsUoe4=;
	b=AQHoURh4yfX6+451rZ3braXGHHznlQ8C+ov9OvjUmHq0olXuZW+OUEfdbg+oJoT2ZBOw
	 EtXepOzRDZ2iTQ5X/I0HaWsEuXGRdJLHkIM/6wdZDNwc5kBRsUZHQMqVmenYEoJ6M+gOP
	 CK+BRCxleLF9E7T2ye6FMQAi3sK8j4BDlV8/93EcNrdJKqwY1mGga1USB6xosIwDrLUmt
	 6ODynV9AAx2e4sPqikGxesd5pGeuPD/aUTVg1u9l1lt2na51DdlZ7Qq6FqKYFTrySUEUe
	 CvBkeABn6tAHuMlf/IlZY2lh47t0/VJlXm/XOy9XPPUbRwMqQe3nJAYEfemX4liPmKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvZfnOjF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1196660A5BCA;
	Fri, 13 Nov 2026 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvZfnOjF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66421F000C5;
	Fri, 13 Nov 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585713;
	bh=P3N79i9n3oI/dN4cLVB98y3AmQkL4Ml/ul8I0TsUoe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvZfnOjFeFO3HVvnYVey5NLibonW0S0GhTkdWvsj/x80hK6RBi8x4/Vyru+HBAdWn
	 ErXoKVSGluIhqdZHdnSyUaAiPapjKvmfUncjvN/wDV4pLubA1A9BWVPyuLs79fLlRR
	 /7LydXKw61MTLvYkaOWSA4yyo7HT/gRtkGZiHn64=
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
Subject: [PATCH 7.3 316/507] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
Date: Fri, 13 Nov 2026 10:50:20 -0500
Message-ID: <20261113153806.144969829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index d404e4b1b6cbd..961569eaa8d7c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -509,8 +509,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, pmc->old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-- 
2.53.0



