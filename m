Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC9A145FF0;
	Thu, 11 Apr 2024 10:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830886; cv=none; b=eVKYg/zAcW7eknZ1sObUTZhKYWJAc4AKemhvwxGk1/6QFy1lj1OaeQY0kDiHCc2jdCXjlaSYcQGV87M/1K1wESq3dz6wQfhQBR9kx4cbfHkdNfZcpN2gOuhWYCueheuyMCVgt6766lDc52vH6b1FeSS+DTd140D3IAjySjKHkcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830886; c=relaxed/simple;
	bh=Iq5K7A8uFjZrqSnN+w34b2KhusY6jVdQQC9Qj8MV2hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AE231DrmZK4BBG/4DF7j14LX2AA1oiJ1C4ufn2g6mOM4HxZlqLWrjfsQkV5Fs+Jymxn7TNK2bm09RL0KaQbGDRychXz+BuSD52odp+bk+DYTBGetTMpxV0Zx0S428r8H7ltiKVRXHyrTLtyeosFOB4u3hf1yaZ14PryTMieAtbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo+YQpjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo+YQpjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573E0C43390;
	Thu, 11 Apr 2024 10:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830885;
	bh=Iq5K7A8uFjZrqSnN+w34b2KhusY6jVdQQC9Qj8MV2hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo+YQpjmy+ch9WUDLYcPhUbl56CQ6/sxOlPTesZPmCCz+b4RQFixB9OBHfAmjIXBM
	 sVHearCeI7mIrOjLjLDaoaZR15hXqChI4obK/Bd6gDiwZgv0izqyScNKE54/PAX2w2
	 MVxFDOGsy3IWzkqjFnCFd/blzzczv/90tLzlIXwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.4 112/215] mm/migrate: set swap entry values of THP tail pages properly.
Date: Thu, 11 Apr 2024 11:55:21 +0200
Message-ID: <20240411095428.274262052@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

The tail pages in a THP can have swap entry information stored in their
private field. When migrating to a new page, all tail pages of the new
page need to update ->private to avoid future data corruption.

This fix is stable-only, since after commit 07e09c483cbe ("mm/huge_memory:
work on folio->swap instead of page->private when splitting folio"),
subpages of a swapcached THP no longer requires the maintenance.

Adding THPs to the swapcache was introduced in commit
38d8b4e6bdc87 ("mm, THP, swap: delay splitting THP during swap out"),
where each subpage of a THP added to the swapcache had its own swapcache
entry and required the ->private field to point to the correct swapcache
entry. Later, when THP migration functionality was implemented in commit
616b8371539a6 ("mm: thp: enable thp migration in generic path"),
it initially did not handle the subpages of swapcached THPs, failing to
update their ->private fields or replace the subpage pointers in the
swapcache. Subsequently, commit e71769ae5260 ("mm: enable thp migration
for shmem thp") addressed the swapcache update aspect. This patch fixes
the update of subpage ->private fields.

Closes: https://lore.kernel.org/linux-mm/1707814102-22682-1-git-send-email-quic_charante@quicinc.com/
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -441,8 +441,12 @@ int migrate_page_move_mapping(struct add
 	if (PageSwapBacked(page)) {
 		__SetPageSwapBacked(newpage);
 		if (PageSwapCache(page)) {
+			int i;
+
 			SetPageSwapCache(newpage);
-			set_page_private(newpage, page_private(page));
+			for (i = 0; i < (1 << compound_order(page)); i++)
+				set_page_private(newpage + i,
+						 page_private(page + i));
 		}
 	} else {
 		VM_BUG_ON_PAGE(PageSwapCache(page), page);


