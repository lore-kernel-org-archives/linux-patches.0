Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0978836A37A;
	Thu, 20 Aug 2026 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239091; cv=none; b=BsjIKKtMWn8gOVAIpyFxBfJlTE0o+lQC/N1GjR3pRq6qAot6uRp4nPXV5U0pSMP4jOcR1lglrFoEeIqSbjkMVHkS3Mq3xBOXErp8Ulnm+4fKQvN1+zsq0JqIhwByL49nXcI3J9TkohvdyBz/dg/cILjFp2v+35X2fCdxx6y7310=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239091; c=relaxed/simple;
	bh=bTPr3F0+rnpyTFoOAI1S2hFx6ptkY22DUEA+lGFLeNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnVHMpaSDHM6fiE4IP0QdO30yNzeSnD5MSm8s/qax2Rgj1LT+BTa075E4q7WxaCpodXZ83f2sNc0RVLC6kRt4BedEDagKhOW3r4ffGZKvp5OlOczP1+fbNLz4WO6R9MDDoXQn9BiiIR81HCnDF9qlQIO0+zpkq+286jdYHxWnk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPfOQnfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPfOQnfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438BD1F000E9;
	Thu, 20 Aug 2026 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239089;
	bh=lD9nSUlizuXb/6S+Lv4Hze/FJOrKvQixEqLk6RSfrjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPfOQnfYFfp9ZTHBLKqk3p0EzSowYKOxHnLBjyDAwhOraY9N6u8QSdJtEyqyFCusf
	 oGZe7uP3gPmqYG8W6cdwLI1h3ULLewKzNjlcC5e+SV6SSut07px2sNZO3WML5N9iX1
	 x1qH+WX8jiJJnVTggs2kQR0BwO589eNFf9+s3tPA=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/217] userfaultfd: wait on source PMD during UFFDIO_MOVE
Date: Thu, 20 Aug 2026 16:55:14 +0200
Message-ID: <20260820145242.148528485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit 4165b7d1c45c2da0dfefe528f8d1fb7d79f0d344 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2575,7 +2575,7 @@ int move_pages_huge_pmd(struct mm_struct
 	if (!pmd_trans_huge(src_pmdval)) {
 		spin_unlock(src_ptl);
 		if (pmd_is_migration_entry(src_pmdval)) {
-			pmd_migration_entry_wait(mm, &src_pmdval);
+			pmd_migration_entry_wait(mm, src_pmd);
 			return -EAGAIN;
 		}
 		return -ENOENT;


