Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F220B3E;
	Tue, 23 Apr 2024 21:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908540; cv=none; b=trZTMg4cjMMwNA4kNqbWihBRiYO5l9xo8sVIOpT4x2MgRaXICHQUwYDkE+amj1J96mr4psFhbUdv5Uy7x8spGXNSy+EyHQfYrGveg2D6bfL89xAa4jSg00bIpw3+4MRreEpIk2CFsOwaqR4trR3V1R1Trtw3MYiKE5b3Yeq+BFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908540; c=relaxed/simple;
	bh=Y8adk3WgtCqy9su74nP70t3kbl6l3wjCebrmkAF80AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiG1YmPmpxTnf+4nKM9tZF66kOHW9JHhLrzSnWicODYI954coDFLi9CF7PF+TjGoeYaD5G+fa8B/38kjlw1zhjE1duJ2+NOErXynDWHw0cVAy/Qxj5I2M0Of0q/xzYhl1Rm4x/hmI8ju364cSIY+JhBzD9c3uWJnHgdp9ThJwB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSpb4Knj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSpb4Knj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C21C3277B;
	Tue, 23 Apr 2024 21:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908540;
	bh=Y8adk3WgtCqy9su74nP70t3kbl6l3wjCebrmkAF80AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSpb4KnjhXUCoO5KkvUjOUyQF8864oXRltzYwcY81U36/DuKPSzyze6z3USicC8iF
	 J8ZcNtkaH1wMXgFf5pVmLomEBuzoI4218bRc776cC6ZbxbjzuvLE94jYOkvLjjvV1P
	 oirTONMblDB13uOQ7aQiBdaeiW9FBimlcaMXPgx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	syzbot+b07c8ac8eee3d4d8440f@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 135/158] mm/userfaultfd: allow hugetlb change protection upon poison entry
Date: Tue, 23 Apr 2024 14:39:17 -0700
Message-ID: <20240423213900.272242357@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6943,9 +6943,13 @@ long hugetlb_change_protection(struct vm
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


