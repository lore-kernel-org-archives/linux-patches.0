Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32CA19B59C;
	Tue, 16 Jul 2024 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145077; cv=none; b=sa7zqsFFl9dWXO0QH/hsrj+y8oUGTCgTOQ/pYSIoKO8C+sglO80jY2J1GKVuXZ44YKZrmdYcbr00id+KeSfoy3QDwO5kfBjicG4IPkrr3ZEwo9FFa0pzaEt/lDC0tgQx+GbdafyMdHYDuWt7hHhxvgff8pSrH8X68GGbWoMamnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145077; c=relaxed/simple;
	bh=oKoESEPueEbvELRrBcBtYNAdZzVJT/ecMNG9UWTQ7pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW9BR5NWahq0gWEeXwYjn66hiJxMLeKHzkheLjBi/IDxnbaksacgcYy6iOdPV1FxenILqpI2KwhB6KlmtYChy0pA6xuyvCCW3GqJUQIRTxIKglsu9LT9QIPFPl0j/6oR71XvomMieCkUMQChLFn05IHzB0Q4tAU7InzvI7j1Uds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjXbqVnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjXbqVnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E338C116B1;
	Tue, 16 Jul 2024 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145076;
	bh=oKoESEPueEbvELRrBcBtYNAdZzVJT/ecMNG9UWTQ7pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjXbqVnKDP3zZyvE+GzPbRb+BnWXh0JfasmDG8zfNKhdcceUdz8I3c8HnVWNbvb+T
	 oBQV45vYMGYRhiWXpjhMASRXqwOnMyEKUlQ4BwhyLrT8NXqicWL3TnAvz/SWz92c+R
	 SRzSgkwkggAdpwGPceFqJ6RV5CKujHYhyhoTxyX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangPeng <zhangpeng362@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Yang Shi <shy828301@gmail.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 089/143] filemap: replace pte_offset_map() with pte_offset_map_nolock()
Date: Tue, 16 Jul 2024 17:31:25 +0200
Message-ID: <20240716152759.398852434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangPeng <zhangpeng362@huawei.com>

commit 24be02a42181f0707be0498045c4c4b13273b16d upstream.

The vmf->ptl in filemap_fault_recheck_pte_none() is still set from
handle_pte_fault().  But at the same time, we did a pte_unmap(vmf->pte).
After a pte_unmap(vmf->pte) unmap and rcu_read_unlock(), the page table
may be racily changed and vmf->ptl maybe fails to protect the actual page
table.  Fix this by replacing pte_offset_map() with
pte_offset_map_nolock().

As David said, the PTL pointer might be stale so if we continue to use
it infilemap_fault_recheck_pte_none(), it might trigger UAF.  Also, if
the PTL fails, the issue fixed by commit 58f327f2ce80 ("filemap: avoid
unnecessary major faults in filemap_fault()") might reappear.

Link: https://lkml.kernel.org/r/20240313012913.2395414-1-zhangpeng362@huawei.com
Fixes: 58f327f2ce80 ("filemap: avoid unnecessary major faults in filemap_fault()")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3207,7 +3207,8 @@ static vm_fault_t filemap_fault_recheck_
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
 		return 0;
 
-	ptep = pte_offset_map(vmf->pmd, vmf->address);
+	ptep = pte_offset_map_nolock(vma->vm_mm, vmf->pmd, vmf->address,
+				     &vmf->ptl);
 	if (unlikely(!ptep))
 		return VM_FAULT_NOPAGE;
 


