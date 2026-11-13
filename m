Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590413;
	b=Jm+RL1SY+3b6AZHs5OtgL2kAvFz0IkaJ4EzdPBp4dAh4qTa7HJo0wvNah/8m5Yp/t/3O
	 zgZnVkLDneOPEU2aW7CI5ljJahtewB39SDI2aDj/nGKcAqO4HxOW5uBc6e1f5nCCwsnIU
	 WEBOoac7tF5e6IwhIMwho4tfoEpzQBmqze8uVokyhk1H8GXNmotl7o565boUmx2LSzLKS
	 nshOnneOgFmUJtfGS0+mX/SSmTieDzFLccuLmUM/NIQpV5i3L3pHYOhZok05QXQ0CtXcU
	 NYMNrxvNfntPYPChwOxKL1Mg2y4dpSNOkn9kskPrQWjekM6cYGvrlX8RSPwBOwuDArw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4pHXppHSd/N9yaCc7+6llSWCABu/XVB5QDT2U+M4cuw=;
	b=N4xOcHp8N3O/qEZdna0tKaQQY+0/4mgEwY7mjUr+roBKu/eG0cXovTKOUde1sgzKdBrI
	 UgbMB9fuldyRFB3bumkVrY6sfzpbTzFoFWBmocdWjrzR1J6kxEjncE1nrkk8QG5MlV4zy
	 c1uqSnH6uhw5tM1GeQwXhPugyn+m265Qtz+9iVP4eDEHM4sU8h6V6J2cjn08zU8ZrhBCm
	 ZIfgo9+w3dGtYeUHDP3/ZqYjYM2JZ5nXvTKhXpATTSvJXqkXvWcOQFmbRJ8RClDGtey8g
	 kGLIRatA0/Ey+dk6L8EA3EfYPyPwlu/mXzSWX/ICOJntPSTU0r9kH7aVZcZTJGktMhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu2kIS8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A20606F71F;
	Fri, 13 Nov 2026 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bu2kIS8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C821F000C8;
	Fri, 13 Nov 2026 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590413;
	bh=4pHXppHSd/N9yaCc7+6llSWCABu/XVB5QDT2U+M4cuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bu2kIS8QnFvpicy5prDgcq20akPxs5GcTOhuzKAHc9/fXXhdr6i09O3qcGsuCcJU3
	 g4YtlpiK/b1rpyKtrcBG1WORO26eLUcGZgLdTMkRy2Rd2VS9RrCgRN3TJnssZ+W+Vx
	 hZg5cVwysPuJpzoipFo806RsyChwSI63ClTBvPZE=
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
Subject: [PATCH 6.18 379/686] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
Date: Fri, 13 Nov 2026 10:48:32 -0500
Message-ID: <20261113153833.757585228@linuxfoundation.org>
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
index 8ed7c50e499b8..1830ecb91e3c1 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -496,8 +496,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, pmc->old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-- 
2.53.0



