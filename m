Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD13E47A64;
	Mon,  1 Apr 2024 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991382; cv=none; b=ThF4KWf4NBmtoW+IztpjrBkIt0OlskkXl7XAZF5cMGDHLJrahyMVE+sDKJiRJYPxSFGhaXe5LvcUWrwzkZlOxsRqCpBP7wdIQuLe+ckGrDOrzym+78QWZrDOxKRl4xrFZxYIzAboHnRH9ValhhcM4RtlESfJ1pwgzooDkPN40LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991382; c=relaxed/simple;
	bh=0j5Z+kgeCqVXjIC3i/npApGI00sfYF6JgyIgXnbc0nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcrCbJifF2xXVjRnXt4mQrjsZxNccProAgxW/VM3yYUXLGXpXGAwZ1OYr2j+tdCyFcUhSLnCl5P11cRr+OYdUHN/8ixL1nJbOCDkKzcStBQnufn7WLjbEUTUQhq1Yw/TbLT752G1F3HBe7uSlFjWiUc7/HVSvzrycXk0bV0Y7tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o887GtsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o887GtsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65719C433C7;
	Mon,  1 Apr 2024 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991381;
	bh=0j5Z+kgeCqVXjIC3i/npApGI00sfYF6JgyIgXnbc0nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o887GtsLH02QhcI3nCXSv9r3TjHBEri97kUnYuDFs9O0uSGVt+DHQXldtZiKOI0n1
	 GWSMKAVW2ZnOndPjmxhdS/hR1YUWHDGvYK9OQwA1A3nccmQ0/fluMYMsZSFkVAQVPc
	 C5jNBxqe3AJRTJ6JYDKOG/TWvvLLDiR3U/D0AU7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Charan Teja Kalla <quic_charante@quicinc.com>
Subject: [PATCH 6.1 209/272] mm/migrate: set swap entry values of THP tail pages properly.
Date: Mon,  1 Apr 2024 17:46:39 +0200
Message-ID: <20240401152537.445741433@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Reported-and-tested-by: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -423,8 +423,12 @@ int folio_migrate_mapping(struct address
 	if (folio_test_swapbacked(folio)) {
 		__folio_set_swapbacked(newfolio);
 		if (folio_test_swapcache(folio)) {
+			int i;
+
 			folio_set_swapcache(newfolio);
-			newfolio->private = folio_get_private(folio);
+			for (i = 0; i < nr; i++)
+				set_page_private(folio_page(newfolio, i),
+					page_private(folio_page(folio, i)));
 		}
 		entries = nr;
 	} else {


