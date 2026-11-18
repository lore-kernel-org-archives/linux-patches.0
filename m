Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038987;
	b=grhJf8UQ97zDXR5uC+r77OWhhUTPBUD81zjZ/hCFmAalsILbFG2ZXfqCf5F14Fw2RksS
	 MXvTublPlArJ4U0BvvJrAhbL/HLKw8/WcDwM0jZl0WvVCkXGEsglYGOUV4l/S2v1B9ZdC
	 yQPcD6t0JGa3ekiHAB2OxZuVdbKfl1j2plWeNPo0HqZRK4gycUGKx1l2RaIRmPyo0Noh2
	 5rmRmuLbI0aZiPjA5lXL5NrRnH9unolthYPXrzf+wRXHa6tbKokNOFl2Svst1kTZxfztg
	 e/uHAZmiNxe//NglirGlAwSej1/chnws1CCIEdIpIFp5MJfNgxC4L977knfukSLBPzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ouqErwGAlf5wFddUoQ+N8I3Bl+fA6uufLm3BwRNzbu8=;
	b=CJghxD6QrwH7soX4hVpGDLMGq/Dol4bP0DuW+lWXvZsZqNqmJD6hHMdKGzIb/2ejRbGi
	 RNFRcTLil6oJh8KwdqG0jg+C3FksEUEmZXx1EUHObk3h/1hKjObw+rA53G4b5o2Mx3mRi
	 tyTPF9mrMFG+wTCOsKA7c/Vo0pU0uzvTlrCE3RPObiOmalcsoqTcI/rqNH0zdoEN+qa5g
	 dHbeZi0SHIbkod+S9cZQdvNyEFrATyXh7CZQPdQ2Qe88xZ+5Ua64M92XqznUqqTQSrmXy
	 pHPOm6A5PhSVDZ7UGD56+BeztjfwLYhZ5D6eLBYHscpxy1NjkZL9cCXoDHyzal/jTlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HGgRZYkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791D2606A31C;
	Wed, 18 Nov 2026 21:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HGgRZYkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00FF1F000C4;
	Wed, 18 Nov 2026 21:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038987;
	bh=ouqErwGAlf5wFddUoQ+N8I3Bl+fA6uufLm3BwRNzbu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGgRZYkgL5nmfZxUZwBESiFNr1xrxmHHn1yGDZvqC21LonspsDVj1rbuVj+CpaQH7
	 hYvR7ripDV9PacCqozVm1P9/tgePWQICzhMs0P/Io120t6DxapbfR4/roUzJIoSzr5
	 bZ04UPQQAqi3QeKnuKLSs4D5QOczYiPE5hNDuDLE=
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
Subject: [PATCH 6.6 1939/3318] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
Date: Wed, 18 Nov 2026 15:42:41 +0100
Message-ID: <20261118150420.215703980@linuxfoundation.org>
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
[ sashal: Replaced pmc->old_addr with the existing old_addr parameter in pudp_huge_get_and_clear(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 494064a9719de..19734461d39dc 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -418,8 +418,7 @@ static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-- 
2.53.0



