Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819BE32C947;
	Fri, 17 Oct 2025 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713863; cv=none; b=H1W1c52tlF8ruGIp0GAbjbIIrE9LMRVabnXJfERj3BHI1oDLDWtv+98+wqIim01Iy1iBwMAHWHvIj5d/51TJ1/OtHkO+NNZfNRqv3oULltx2giUk22g8Of6FLcS4KzX7sw6Ns89romZeUyrHPqGH6/hk6ay3cB+OVOpc4gBwfM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713863; c=relaxed/simple;
	bh=tjzxIPYrnvYc7zCSUHSg/aRdoAF9DS1Vw8ImP0Qk52U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixCVCTMwvjleX+3LdX6YqAYBzYpD0g+8p29AR8dIYkj3FS5zssdRdviMgvoqHKkDDSCt9gR5eKqUo7vDPRfb4bYLKIp8PBfx7i5VCwgKhng5YPhmcCCQw0SgeW5oB786QjPxEW56ZTAcvaHnZ9MMf12+hW7Y3xZRsk1WAtLtU60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyMhownD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyMhownD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20E9C4CEF9;
	Fri, 17 Oct 2025 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713863;
	bh=tjzxIPYrnvYc7zCSUHSg/aRdoAF9DS1Vw8ImP0Qk52U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyMhownD1/XopkwV+JAgr5ztkMx9hyo/jYSazWKg0K00pM4wPMFe97UUFw9ukA/i4
	 kDYxfEZSExoPKLKupKKQjMtMRfVsD7PfrIh3s4xwk8U97k26D3REDaObU0D1AnffT5
	 WmI2/iM3luBkUOl2UiBd3RUowylWTEEvt0AxGqDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Xinyu Zheng <zhengxinyu6@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 145/201] mm/damon/vaddr: do not repeat pte_offset_map_lock() until success
Date: Fri, 17 Oct 2025 16:53:26 +0200
Message-ID: <20251017145140.059698918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit b93af2cc8e036754c0d9970d9ddc47f43cc94b9f upstream.

DAMON's virtual address space operation set implementation (vaddr) calls
pte_offset_map_lock() inside the page table walk callback function.  This
is for reading and writing page table accessed bits.  If
pte_offset_map_lock() fails, it retries by returning the page table walk
callback function with ACTION_AGAIN.

pte_offset_map_lock() can continuously fail if the target is a pmd
migration entry, though.  Hence it could cause an infinite page table walk
if the migration cannot be done until the page table walk is finished.
This indeed caused a soft lockup when CPU hotplugging and DAMON were
running in parallel.

Avoid the infinite loop by simply not retrying the page table walk.  DAMON
is promising only a best-effort accuracy, so missing access to such pages
is no problem.

Link: https://lkml.kernel.org/r/20250930004410.55228-1-sj@kernel.org
Fixes: 7780d04046a2 ("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Xinyu Zheng <zhengxinyu6@huawei.com>
Closes: https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -324,10 +324,8 @@ static int damon_mkold_pmd_entry(pmd_t *
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	if (!pte_present(ptep_get(pte)))
 		goto out;
 	damon_ptep_mkold(pte, walk->vma, addr);
@@ -479,10 +477,8 @@ regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;


