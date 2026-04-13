Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554433D6D5;
	Mon, 13 Apr 2026 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099752; cv=none; b=L8mjQpW1fwxL+nd/PgkNhinjuFW3LDuNDnBeYJB00pMVtCilmEgPSknKmLWyHGuMcvnaK9B+ZWnm+sohCZtGkx+/1P7kvXmUUb1MamTg9WMXU/e0/0+WkLcJPjT9RATt2nFoEd7N7lsxBGGOdck1RdAUpjgK2A+OhgmkL2iTjOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099752; c=relaxed/simple;
	bh=Jh8eSMQ2Vz0WxWuY/o6pi/Wu55wWlNIi4kIQQt38DMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Php+TB3kMa/v+FnqBm/8bTrohtI+JcehkrD+8E2uT3rLB0DxYTlcJEuPAsR38Xwu6FENBqxKlaUDOCw8SDVxkkyaXKhMy5W9GrjXxWRKW9ilqDS0aKVCNPWjKHWCZt/XZlW8M8idOTDzzK/HTPM/L2SxmvkfIn3vIKDzHOwLySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uazlPAY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uazlPAY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C83AC2BCAF;
	Mon, 13 Apr 2026 17:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099751;
	bh=Jh8eSMQ2Vz0WxWuY/o6pi/Wu55wWlNIi4kIQQt38DMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uazlPAY7sWXUOzrPDVjw+GfxBrOLAkXJvq/qI6rn3XZC2xNgMBDHtwTJ9VmJ6nRFC
	 E/kmbYuSLenrJ87jQei4HhTw1BrkQplQ7diVPPAhXxUrtCtGtNdJQrJYuaGJ8ypDNN
	 RUwU1sOsWCI10e8BhVZh/h8ShugJtnWmNaBnnJuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/491] mm/hugetlb: fix skipping of unsharing of pmd page tables
Date: Mon, 13 Apr 2026 18:01:03 +0200
Message-ID: <20260413155834.675985260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

In the 5.10 backport of commit b30c14cd6102 ("hugetlb: unshare some PMDs
when splitting VMAs") we seemed to have missed that huge_pmd_unshare()
still adjusts the address itself.

For this reason, commit 6dfeaff93be1 ("hugetlb/userfaultfd: unshare all
pmds for hugetlbfs when register wp") explicitly handled this case by
passing a temporary variable instead.

Fix it in 5.10 by doing the same thing.

Fixes: f1082f5f3d02 ("hugetlb: unshare some PMDs when splitting VMAs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8efe35ea0baa7..99a71943c1f69 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5787,11 +5787,14 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	}
 	for (address = start; address < end; address += PUD_SIZE) {
+		unsigned long tmp = address;
+
 		ptep = huge_pte_offset(mm, address, sz);
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		huge_pmd_unshare(mm, vma, &address, ptep);
+		/* We don't want 'address' to be changed */
+		huge_pmd_unshare(mm, vma, &tmp, ptep);
 		spin_unlock(ptl);
 	}
 	flush_hugetlb_tlb_range(vma, start, end);
-- 
2.53.0



