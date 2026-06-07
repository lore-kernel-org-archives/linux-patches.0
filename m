Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB3B212564;
	Sun,  7 Jun 2026 10:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827960; cv=none; b=YD0WWJlBHF98X/SuhO9cDYHaQeER4fty9JSr4frCkkcTX0EeJGu8SUbtYSUXXsBBU5jYmgNzoSdWpJRjE6eVh1VZQnLAQ/Kw0cbtgE8WKE+vJMpxBTHwBReyfOrqyF4DTK+5uWMetIocC9oofFtZSePMKMmFxbxCqJIcvqOTFzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827960; c=relaxed/simple;
	bh=8P8LCJNZWG7PkocNuXIJ3t3Uny3ak8TTlhcjeEgd5YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKGoshwdaRXleJhwTDgel7RGz+EeM6K2MBPCIHQd6qUZtUWhKSOkr9nG4nm3ty/MGuX/cGa3k4GMkWZsDyUqMW3JjhK3FjrYXvzad3tTPEX+73BqZgpqE6FOvQKSiW/y334oz7dGCqA+g/9RpNGaOtEHSTGbv3sD43Cnql2sqWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hkta6gPe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hkta6gPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320761F00893;
	Sun,  7 Jun 2026 10:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827958;
	bh=rz14DbPQuNodPcgbz5gk6LWlBSV8xWw8vTOdKN2cvGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hkta6gPeO2lg7A1otCCKq5TVZoH0Hd4jTRiPW/woxKwoKJGdZU7vLrZEk2Sj5ER79
	 klUsvLbRtOd4VHKshJLWNshJossAP8pdHF0Dv+/PzyZQfgmiKISPOcdi1zvS6yvHjo
	 hXs6k7zJ/OhAdSSd3kN1iBFBKPcpnWL96H3P0x6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Patel <nueralspacetech@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 140/332] mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page
Date: Sun,  7 Jun 2026 11:58:29 +0200
Message-ID: <20260607095733.235733630@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunny Patel <nueralspacetech@gmail.com>

commit 2c6f81d58741349298f51ff697d988cb42881453 upstream.

When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
to a PMD check failure, the pgtable allocated earlier via
pte_alloc_one() is never freed, causing a memory leak.

Added free_abort label to release the pgtable in error path.

Link: https://lore.kernel.org/20260501115122.23288-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -846,7 +846,7 @@ static int migrate_vma_insert_huge_pmd_p
 	} else {
 		if (folio_is_zone_device(folio) &&
 		    !folio_is_device_coherent(folio)) {
-			goto abort;
+			goto free_abort;
 		}
 		entry = folio_mk_pmd(folio, vma->vm_page_prot);
 		if (vma->vm_flags & VM_WRITE)
@@ -899,6 +899,8 @@ static int migrate_vma_insert_huge_pmd_p
 
 unlock_abort:
 	spin_unlock(ptl);
+free_abort:
+	pte_free(vma->vm_mm, pgtable);
 abort:
 	for (i = 0; i < HPAGE_PMD_NR; i++)
 		src[i] &= ~MIGRATE_PFN_MIGRATE;


