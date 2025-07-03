Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AA72E339E;
	Thu,  3 Jul 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554925; cv=none; b=URh2L6zbFhOZ7VQ5BOPyce3vuv8JWKAL6BNy7D0oLpiOiNA6RQgQsefMkbZgQk/7/44FmuC20ElKfK7Z1x/s0BAOd2Fesim2Xn9vK7RSA0pAO4oRuAcJo2ADrTlKA9Xnc46cix11ItPb3YWPcSBiCejiWD19hsveCgWIOxEPjhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554925; c=relaxed/simple;
	bh=xWIzM1K8nlJmVNpN8UF+r/dny4KhKnB+wR2BhW3xk/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvpD5fdawc/s2ODUOkz6NKWMSqQgafc8+fwF+I6k128tVSJ1JteW/a3L/CNqCevERGCOq+DaF2PtrkSMBte2k5hMSCiNJIMogBFBwWuPtJVXqotWHG9EQnnXbNS86oQ0aOhtPNjkN0O0y6mAk72nasb3DpvFN5+ufMhYaEyKLJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMeI6O2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMeI6O2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696A9C4CEE3;
	Thu,  3 Jul 2025 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554924;
	bh=xWIzM1K8nlJmVNpN8UF+r/dny4KhKnB+wR2BhW3xk/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMeI6O2O31VYC+KgJDvrA2F61fiWFuCORKKpQXp/v8k8CNm2KIhnhmEGcPXEEVtCW
	 vyiwp4FEjX07n+N99DSUaCqAAhR+Y9IHUZpk/sbqlk7o3P1xwSv2Dvd8fnKbCO1NGo
	 c4Up7nB08cJP8tY9WT54NY5rPATKeFkGroqCM0AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 120/263] fs/proc/task_mmu: fix PAGE_IS_PFNZERO detection for the huge zero folio
Date: Thu,  3 Jul 2025 16:40:40 +0200
Message-ID: <20250703144009.166000886@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 4a5e85f4eb8fd18b1266342d100e4f0849544ca0 upstream.

is_zero_pfn() does not work for the huge zero folio. Fix it by using
is_huge_zero_pmd().

This can cause the PAGEMAP_SCAN ioctl against /proc/pid/pagemap to
present pages as PAGE_IS_PRESENT rather than as PAGE_IS_PFNZERO.

Found by code inspection.

Link: https://lkml.kernel.org/r/20250617143532.2375383-1-david@redhat.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2179,7 +2179,7 @@ static unsigned long pagemap_thp_categor
 				categories |= PAGE_IS_FILE;
 		}
 
-		if (is_zero_pfn(pmd_pfn(pmd)))
+		if (is_huge_zero_pmd(pmd))
 			categories |= PAGE_IS_PFNZERO;
 		if (pmd_soft_dirty(pmd))
 			categories |= PAGE_IS_SOFT_DIRTY;


