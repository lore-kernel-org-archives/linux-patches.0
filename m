Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603F961FFE;
	Tue, 12 Aug 2025 18:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023183; cv=none; b=gHUXt9KETJNzcgOm5PUrLjxWED7eQY8K2ED+QO847jWE2WjYkUbS+AkKw4AJENibHqr6LQVLRs3T5J2tbRbN2hcZJ3CyDdFu5GUQcim4MDwLmn80dSdHHME67h/XG/ciGeQV3N1Tkd/FNZCuAy+/Gkq1zQ+emIOzSM4oX+6tnuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023183; c=relaxed/simple;
	bh=5gQ+en5/HXJp16egaus4InteHj0M212Bk2F54VdYH5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEPVeiEoDs2+nI2bFRqkUEvvdoRk6WqJqh7spDs9EVGZE0R3l4/eZF5rrZr8vs+kMbIgyAd/XBxft2PNv1JDBF1ARCOsc3kbYB6R1VkmR2axUHtNRlTYMaj6AjNiXLB9bi+QcIT62E1CwslSuthv+sG32iyPbda1Kz76yz/ttn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjJddG9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjJddG9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D77C4CEF0;
	Tue, 12 Aug 2025 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023182;
	bh=5gQ+en5/HXJp16egaus4InteHj0M212Bk2F54VdYH5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjJddG9pJpK8vwgZBvcQ7x4WEuRyL1ElRtHaJOdpTMt3baPSsLO9N14tbT7UkMwTv
	 uKkSBrTb67tGoV0URZRU3s/SCDA0eFwrDWbCqPVOnsoplNKyun7I41vhwfDnOSMHex
	 dnY8TGMHvpZ378Tqn4Vr4i8lG3UNjvhD1ENm9Fdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: [PATCH 6.12 360/369] s390/mm: Remove possible false-positive warning in pte_free_defer()
Date: Tue, 12 Aug 2025 19:30:57 +0200
Message-ID: <20250812173030.228840513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 5647f61ad9171e8f025558ed6dc5702c56a33ba3 upstream.

Commit 8211dad627981 ("s390: add pte_free_defer() for pgtables sharing
page") added a warning to pte_free_defer(), on our request. It was meant
to warn if this would ever be reached for KVM guest mappings, because
the page table would be freed w/o a gmap_unlink(). THP mappings are not
allowed for KVM guests on s390, so this should never happen.

However, it is possible that the warning is triggered in a valid case as
false-positive.

s390_enable_sie() takes the mmap_lock, marks all VMAs as VM_NOHUGEPAGE and
splits possibly existing THP guest mappings. mm->context.has_pgste is set
to 1 before that, to prevent races with the mm_has_pgste() check in
MADV_HUGEPAGE.

khugepaged drops the mmap_lock for file mappings and might run in parallel,
before a vma is marked VM_NOHUGEPAGE, but after mm->context.has_pgste was
set to 1. If it finds file mappings to collapse, it will eventually call
pte_free_defer(). This will trigger the warning, but it is a valid case
because gmap is not yet set up, and the THP mappings will be split again.

Therefore, remove the warning and the comment.

Fixes: 8211dad627981 ("s390: add pte_free_defer() for pgtables sharing page")
Cc: <stable@vger.kernel.org> # 6.6+
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pgalloc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -219,11 +219,6 @@ void pte_free_defer(struct mm_struct *mm
 	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
 
 	call_rcu(&ptdesc->pt_rcu_head, pte_free_now);
-	/*
-	 * THPs are not allowed for KVM guests. Warn if pgste ever reaches here.
-	 * Turn to the generic pte_free_defer() version once gmap is removed.
-	 */
-	WARN_ON_ONCE(mm_has_pgste(mm));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 


