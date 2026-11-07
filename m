Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063623;
	b=5fnc+j7Kpar0BXr8TB0sf0kxjp77UgURXpy2Zn6Yew5DQY7e+85d6Uv6xJxA8X7Q24s3
	 RlamRhmESikW+GcHae5tG0AuggtgUbq3LgO0M/61FLbRW08vgD23H5aBEV1lTXYZ5IaWD
	 p4INDEE0n4Ev9mkSA4omaTSXfjkV8qjQ2gk1f/gznrBDxY0TvTVva+++of9hCoWfdJM2X
	 nFazB+A3mE6qFO83Y3ZQe+UGRP+I5lTLP45FfGBxWvrA+E7gya442wzZsdMzYdSLBzPCF
	 qk7bQewBk9Da39axTHgSg2LR6w4fhVP/cLV+crpQ4/QQB3cpP1EdhIpG9B+J5jyYZJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRGfaq7byPaeaqoAovwtvEuXMiXyet+GGLI2FjfxtTQ=;
	b=cNXDf6OcNJjQStsW+ZLS0Qz98rIu0O8WtYCZL8nzDCrOKXJ8UFmV8cH+1G8loavF1D2g
	 o3El2N9XwbX8KwwkMWhsdr3bX5v3TJeVICV26/+EU5TZ95B8XoYl74Gj/3NUSvN4HJUmx
	 Ljf3rOM1hz64/1x8HQz/hFGjYkhUkBrt7bkoy2m9xGVMaUTMGX56EcqWPdpG7dYfP2W7N
	 G0/9NLD2SFhRtuv7YHpqja+PdMDOc1pMEf+LhGZ+ETWQDF76oeM5tIxGfpORSayXTUoOG
	 Iu3zjl7rhzxHLrlDjQeSVLzX6T+zef8oT/EXCyJNkEBzeT5j6sYsXa05ryrJpUWvynQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=neYI+NrT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7A86082BE9;
	Sat,  7 Nov 2026 15:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=neYI+NrT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A4E1F0089F;
	Sat,  7 Nov 2026 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063623;
	bh=uRGfaq7byPaeaqoAovwtvEuXMiXyet+GGLI2FjfxtTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neYI+NrTjDsY/GmAvVXP0FOtAXEWXsxwsJN4SnhE+ilgK0kU/RpXTaBbNy/S7GRez
	 8IZ9qvhHxvfedQLx4EAldbpVKyw3pYBXvM/f638JZTZNMTksxpmKM8JmQL78WhKhVr
	 ElOnHtWCzzLfYR+O79yAHCiljo507aMsdRzbBQ+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 742/869] mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
Date: Sat,  7 Nov 2026 08:57:04 -0500
Message-ID: <20261107134917.965747960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

[ Upstream commit cc078ca0b5b79b4a9e514b7f1b489f2afc83b195 ]

In case we fail to move the page tables, for example, because we fail
to allocate a page table, we actually keep the old VMA.

Calling fixup_hugetlb_reservations() on the old VMA is wrong. Fix it
by just calling it on the VMA that will be removed.

The user-visible impact is that the VMA loses its reservations, meaning
that the existing reservations get stranded (leaked) and new hugetlb folios
that are getting allocated in the VMA cannot make use of the
reservations, failing these allocations.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-10-42796911043b@kernel.org
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index f0e63d3b3c148..f023b05dfb3d9 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1245,7 +1245,7 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 		mremap_userfaultfd_prep(new_vma, vrm->uf);
 	}
 
-	fixup_hugetlb_reservations(vma);
+	fixup_hugetlb_reservations(vrm->vma);
 
 	*new_vma_ptr = new_vma;
 	return err;
-- 
2.53.0



