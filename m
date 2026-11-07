Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065335;
	b=vvr217F8l4iVyovJqDEAOpQr2BLGXJQ295ELCW4cuqICNKPTlKMO2LiSZdxVO6B1pxDu
	 A5sV4e7Qj0WYYBHkrJwHiEKeXsY8kkysoDOtAvClt6QeRum0i5ty5wp6/gOz4H++n36Gg
	 hhv+yWrtstY7ldmycxyIFup28DCpv5gqb4pd35fzCNbs0jc2ZdNiPae7on22Lu/BwT78S
	 Mn21JCfRgYoeaiYics0d/23A2YYHJlTiZuLuwpig280SAd+c95ncjvgtS8BGmbTJbdyRS
	 Ofc0N2SGJ8LnEZzyl/6VT0sL9dUn46cImjYNGHf3T2cDONVw111fWBNZgZtNx/afWdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=If+KYIs5C6Q46PqAVMZruZb8laUM0dubO6DVqiY0eys=;
	b=sGlxcqwFvNpNN4P0WP8LrFvWXaw7+r8m6rdCig712MoGkiYLtZcRtYouOw3HKJFPM9J0
	 mnHCC7kj0fh8ESH2+I61bX0yfGOBvmb9xPFGJHCX9RvR/KDH82F5UrTiGBYw0BHTwL6Z1
	 U2yVO4FsNH/dK8KIjIVlcoMrTrGZxmdCZlkwXRXdiWwb7/7pZP1hCyXZWsZJJk27AxQcQ
	 xKZFvdBVVGnLtXbCBkhs50JcUu6qgmBZwGhDzir0Lc8hRkJuT+B7/YyYox3auWt5Gse8R
	 51uF1MxeUdrfXEYk1t9T8N+9JlAaIvW9qWy95zl+A+khEYCZ/Dh+2InVD8BwPlNsUBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GV4nTwwR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D75606A326;
	Sat,  7 Nov 2026 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GV4nTwwR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65BB1F0089F;
	Sat,  7 Nov 2026 15:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065335;
	bh=If+KYIs5C6Q46PqAVMZruZb8laUM0dubO6DVqiY0eys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GV4nTwwRi/KOjQVq1EPWjnFN3NAA1vLg0+b1Tilu0gVhWRhSSTt1ccCN3cESrXHP7
	 Ae+dW6UTMfFyxuIuc0oFP5eheU35d+4+ImsJktqbrowuANBSed/STcKD5RJswZ9VUZ
	 mD31ljKxvgrQvgGJnD1KFP1qDYQJslA5x57U6byY=
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
Subject: [PATCH 7.3 1074/1257] mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
Date: Sat,  7 Nov 2026 08:56:10 -0500
Message-ID: <20261107135008.929545166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 444f37d7cd28e..ace0c6a343b1b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1345,7 +1345,7 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 		mremap_userfaultfd_prep(new_vma, vrm->uf);
 	}
 
-	fixup_hugetlb_reservations(vma);
+	fixup_hugetlb_reservations(vrm->vma);
 
 	*new_vma_ptr = new_vma;
 	return err;
-- 
2.53.0



