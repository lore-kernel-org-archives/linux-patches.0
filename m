Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1149547884E;
	Fri,  7 Aug 2026 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117161; cv=none; b=APzbGC3fcJixKiK7IK3xGuiN1GRU2YVP7LQR9brJALMN72FRTWkVStHGATQtpe5u3m71n3O6hD0sC1jd7kRhr0bc3vxt4n34OwxILj+bBVGzj+bRL4yZTD87xYBQYhTdnmSGzjuc7NIezrZJZRWyi70mAu4NW38CjYX8IV2yq9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117161; c=relaxed/simple;
	bh=Os0bRZXd1ABCakQ5RG+WerokYGZ3rsqrMTdmGM7V0A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bormrXWrxMD+++lKPaL88EVnNJhUTUSQQZ+q8Fi1Drb40SeMxhrKt7MNGTZSBxpmwgUHOJRq76IHun7T/f0o8Krre1dTWoZm7zOpoMth2zk4A5fdX06RHa0eKZ5QW/N0O3Bvp6ezvJqj7FtHC6wT2jPGnvtlI54op/wAlUIuHPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppFsY5+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppFsY5+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2AC1F000E9;
	Fri,  7 Aug 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117159;
	bh=W6OgVoHSbE+s3Xj8ycoWHLjPxEQLUJ/fSuAghD37mKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppFsY5+IldsRKEu669nA0aD3uTDPCBv0gZKpPFlKTPXF72zbvHHO201UMh/Clt2Dz
	 TpS8hYwRPuvWoSkHvMYdScr+GzaALlofUpHG289mIwcfNnfsr6kUCkqWhoK8Fpmcj1
	 2HxklLwCoU9XXwwCK9cpJQE40+2cHwfJc8Q6V0oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Rik van Riel <riel@surriel.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 222/438] userfaultfd: wait on source PMD during UFFDIO_MOVE
Date: Fri,  7 Aug 2026 16:36:58 +0200
Message-ID: <20260807143432.738677338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

commit 4165b7d1c45c2da0dfefe528f8d1fb7d79f0d344 upstream.

move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
and, for migration entries, waits with pmd_migration_entry_wait().

Passing &src_pmdval is wrong.  pmd_migration_entry_wait() must lock and
re-read the real page-table PMD; on split-PMD-lock kernels, a stack
address also resolves to the wrong lock.  softleaf_entry_wait_on_locked()
then waits without a folio reference, which is safe only while serialized
against migration-entry removal by the real PT lock.

Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().

Link: https://lore.kernel.org/20260705131231.1499198-1-usama.arif@linux.dev
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2836,7 +2836,7 @@ int move_pages_huge_pmd(struct mm_struct
 	if (!pmd_trans_huge(src_pmdval)) {
 		spin_unlock(src_ptl);
 		if (pmd_is_migration_entry(src_pmdval)) {
-			pmd_migration_entry_wait(mm, &src_pmdval);
+			pmd_migration_entry_wait(mm, src_pmd);
 			return -EAGAIN;
 		}
 		return -ENOENT;


