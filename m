Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C341494C3;
	Tue, 23 Apr 2024 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908666; cv=none; b=KgcNZTZ94jqtRRLDojA4/Slt86jjzJ/S8nsL5FLKDqcEBzJl66voVStgZYJRVg3KyAUgNI+Of4SSwfoP9vSeSTYHLg4Ed2J//Uhbcwnv4XNMfxOCJhBJj1Mvawq2lmVybzP5AveZ/TosA4zf3aA2h5jVmgsZWDfxhNPa8Ho7QCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908666; c=relaxed/simple;
	bh=C6Bz1pyJg1sKNcsZnlfP919m0MVianviUb4OKEHcqyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Txe1j8IJT+3JTbXs+Yn04tHK4qAaZwu+NQBt2SUxIOkTVhY9dRLgS551iL7o43hepo84aVUHba4SfuT9+TermvKF6BcGBbgpRG6yZwK6sMadIGd/S/tHck6B9KQuFIDu0s+FwsLGGZg+EqJifoHw2jd74fp2Qpn+gNePj1/ACkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJ6gOGI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJ6gOGI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D65C3277B;
	Tue, 23 Apr 2024 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908665;
	bh=C6Bz1pyJg1sKNcsZnlfP919m0MVianviUb4OKEHcqyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ6gOGI9RDUCl54/4XJmzyUSNmIF5oqDRWjJ2KB/QTLnojnj16IOCqlM3F9lcMTm8
	 8Qa9pvAtXEL4mOvMKFYPxiyCtO6aKXozNfHKOcxs4YZl6gh9/2Ad4l6YldEfG2jcLC
	 I9lYcjzhhEWrISnh/+IQu1PM+RrUTQE4FpOTGXWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	syzbot+b07c8ac8eee3d4d8440f@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 136/158] mm/userfaultfd: allow hugetlb change protection upon poison entry
Date: Tue, 23 Apr 2024 14:39:33 -0700
Message-ID: <20240423213900.122009374@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

commit c5977c95dff182d6ee06f4d6f60bcb0284912969 upstream.

After UFFDIO_POISON, there can be two kinds of hugetlb pte markers, either
the POISON one or UFFD_WP one.

Allow change protection to run on a poisoned marker just like !hugetlb
cases, ignoring the marker irrelevant of the permission.

Here the two bits are mutual exclusive.  For example, when install a
poisoned entry it must not be UFFD_WP already (by checking pte_none()
before such install).  And it also means if UFFD_WP is set there must have
no POISON bit set.  It makes sense because UFFD_WP is a bit to reflect
permission, and permissions do not apply if the pte is poisoned and
destined to sigbus.

So here we simply check uffd_wp bit set first, do nothing otherwise.

Attach the Fixes to UFFDIO_POISON work, as before that it should not be
possible to have poison entry for hugetlb (e.g., hugetlb doesn't do swap,
so no chance of swapin errors).

Link: https://lkml.kernel.org/r/20240405231920.1772199-1-peterx@redhat.com
Link: https://lore.kernel.org/r/000000000000920d5e0615602dd1@google.com
Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+b07c8ac8eee3d4d8440f@syzkaller.appspotmail.com
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6653,9 +6653,13 @@ long hugetlb_change_protection(struct vm
 			if (!pte_same(pte, newpte))
 				set_huge_pte_at(mm, address, ptep, newpte, psize);
 		} else if (unlikely(is_pte_marker(pte))) {
-			/* No other markers apply for now. */
-			WARN_ON_ONCE(!pte_marker_uffd_wp(pte));
-			if (uffd_wp_resolve)
+			/*
+			 * Do nothing on a poison marker; page is
+			 * corrupted, permissons do not apply.  Here
+			 * pte_marker_uffd_wp()==true implies !poison
+			 * because they're mutual exclusive.
+			 */
+			if (pte_marker_uffd_wp(pte) && uffd_wp_resolve)
 				/* Safe to modify directly (non-present->none). */
 				huge_pte_clear(mm, address, ptep, psize);
 		} else if (!huge_pte_none(pte)) {


