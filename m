Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB0342C9F;
	Mon, 18 Aug 2025 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526362; cv=none; b=vBoOcWnNL0uMXryslloAFcG+QTofFdBeLO9HZklabnXMOS5IZY84OS1m+zEgBWty6uJAPK3KBAqjPde9X2Kj10LhU+nCxK7Puc1oO6JxtC/F4A9QtiuCdpbYEcSc/fIrwcjE2O+Te+3IibqCHHZPjV1ZXdOBzxc7CaYjJLazBuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526362; c=relaxed/simple;
	bh=qOtyls+kFNfb+yHU0OOS1urHIMs1WRax1Lsty+1yLhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShjbeRm9XrdU2hOabcUW6qBN5prrdOGUr9MltFOrQMKeikAj02LyMSZmXYWFiF1NOjBjIMpVZODsVwVH89g8QH16J3FAyGxjWszC8aP4GeUpUu+w9ahPdIKsPopbQqCaU017fplpUKlEDwQPwgBRtiNVaLADbgBzOMRd2fRpffg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwFB4hkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwFB4hkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D5AC4CEEB;
	Mon, 18 Aug 2025 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526362;
	bh=qOtyls+kFNfb+yHU0OOS1urHIMs1WRax1Lsty+1yLhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwFB4hkThfUODf1eiVtR36s8ilBfdixApJiPsR9P7G/BeK8I4xZXye6AxivvjtV4p
	 ji9mWdhJ0lGtA7dsnGIUFWBrzKfXPZx1hrBFcVKHGNPPAPd09P/0VOEh/2yxd/JUku
	 fjWQvdZuh3hcUgcnD2UsE8ydlUdc3UI2itY10NYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 534/570] userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry
Date: Mon, 18 Aug 2025 14:48:41 +0200
Message-ID: <20250818124526.450521884@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit aba6faec0103ed8f169be8dce2ead41fcb689446 upstream.

When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
obtaining a folio and accessing it even though the entry is swp_entry_t.
Add the missing check and let split_huge_pmd() handle migration entries.
While at it also remove unnecessary folio check.

[surenb@google.com: remove extra folio check, per David]
  Link: https://lkml.kernel.org/r/20250807200418.1963585-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250806220022.926763-1-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1829,13 +1829,16 @@ ssize_t move_pages(struct userfaultfd_ct
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
+				/* Can be a migration entry */
+				if (pmd_present(*src_pmd)) {
+					struct folio *folio = pmd_folio(*src_pmd);
 
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
-					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+					if (!is_huge_zero_folio(folio) &&
+					    !PageAnonExclusive(&folio->page)) {
+						spin_unlock(ptl);
+						err = -EBUSY;
+						break;
+					}
 				}
 
 				spin_unlock(ptl);


