Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054455;
	b=aOzLJ8kDPJXEQNlrLUBZZnLdEarDI2p4Pft8B6VCNyLQD0jH3KdTg2MUpzd/IgT2IpmQ
	 VISNhlHRv9uLw5axJFxUTIWTxlbq+1hzfskg1ZS/8y+mSNUacQnxaPlQ5tIZvTOzmmNWk
	 6PcqR/oPko9cgQdCX60bMWysNGkrYObiGss5Iee0ZktGGgdAcLknlQhSX2srRMDdVMOMg
	 l7y6U8us3kBNUvs2d/F0033HkjvZjcwiWbzdJ2OK34Eq4xq9hxNBqdHTdNhUnC8BiQeI/
	 rxi1oYpdVB0P1ap/va+9WE2dLwqIdzna0Ugoz5QZQfgtRwFnhZbTKdfHLR8M5Cp8vDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4glQXorHrIL9HV7uvrkjZZ1h2EunXH3j9D9/SFmjtrE=;
	b=47j798iPPRDOroNFauV22XSsWeGHJTR7XJJ838b6duWPyQSJL3lAR2isamz+2elhb2b7
	 HX6KDKTXJsKH9BXAjFe2CyWwLZDKW5jVaTL82mje+clJ/Zy/SmcMjkO0SokVg1hKDgs8D
	 mgS/iZdrhj9yBjC12QLrEF0XidgZ6fmxPFeZbXUNLFbDkqSsnYyb+CnhD7XDlfkH8aVHY
	 ab/Kr0QwwETlDBGrFUrgwiyoh4MpjQjHq0o40ALIrK1qicm0Jr2W/nwBiWldS4vRYKFEH
	 L6HYieEQb5cF7tPkXexZ/WMPKgs7N9kF7jf5oMsdT3erwUXXtK+3bolhKNVknL6sNQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GU+if9aZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE7F606A31C;
	Thu, 19 Nov 2026 02:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GU+if9aZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A3C1F000C4;
	Thu, 19 Nov 2026 02:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054455;
	bh=4glQXorHrIL9HV7uvrkjZZ1h2EunXH3j9D9/SFmjtrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GU+if9aZr3XhCf9qPKNP5Va8vZOi+BR5dsJlMG2rSco8sGCRNXyNcYsbKWXqtvf9x
	 tqVfQe+oeCz52Q1WYxu+vJxqXqPWG9fD033B5MLqMwiPOs6Xl0snWkEpVHMjt0QIKW
	 6Z4YB/6Go21SPvE39dpRKP8ttzGU7opo4IvG0wvw=
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
Subject: [PATCH 5.15 1279/2214] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
Date: Wed, 18 Nov 2026 15:49:15 +0100
Message-ID: <20261118150102.739930280@linuxfoundation.org>
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
[ sashal: Replaced pmc->old_addr with the existing old_addr argument in pudp_huge_get_and_clear(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index a5dcc91ee93c1..d2d3a0a8940bc 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -368,8 +368,7 @@ static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-- 
2.53.0



