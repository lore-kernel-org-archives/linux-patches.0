Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001D1C290;
	Wed,  3 Jan 2024 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaXMxjlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA384C433C7;
	Wed,  3 Jan 2024 17:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302083;
	bh=Wqs08GntHlBZM+x6TqmTWSZxSeHF7Uz1PHzIrj/rluk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YaXMxjlcMIEkVO+9EjypSC+V5POcBB0VK55fsk4Xf64AM6yx8Cf+3k1z3K1ZuOIUm
	 9x7f5b/P3RK+Aw2uyAKVAJtvvRI7T74bClVb/hACv01GhSx1Iw49EBIOj6byYcDtY1
	 AiEQl42wsBbIyP3uXTqqPPWpItmmvE/SyK8J5Ddc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Shakeel Butt <shakeelb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 40/49] mm: migrate high-order folios in swap cache correctly
Date: Wed,  3 Jan 2024 17:56:00 +0100
Message-ID: <20240103164841.223258992@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

From: Charan Teja Kalla <quic_charante@quicinc.com>

commit fc346d0a70a13d52fe1c4bc49516d83a42cd7c4c upstream.

Large folios occupy N consecutive entries in the swap cache instead of
using multi-index entries like the page cache.  However, if a large folio
is re-added to the LRU list, it can be migrated.  The migration code was
not aware of the difference between the swap cache and the page cache and
assumed that a single xas_store() would be sufficient.

This leaves potentially many stale pointers to the now-migrated folio in
the swap cache, which can lead to almost arbitrary data corruption in the
future.  This can also manifest as infinite loops with the RCU read lock
held.

[willy@infradead.org: modifications to the changelog & tweaked the fix]
Fixes: 3417013e0d18 ("mm/migrate: Add folio_migrate_mapping()")
Link: https://lkml.kernel.org/r/20231214045841.961776-1-willy@infradead.org
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
Closes: https://lkml.kernel.org/r/1700569840-17327-1-git-send-email-quic_charante@quicinc.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -405,6 +405,7 @@ int folio_migrate_mapping(struct address
 	int dirty;
 	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
 	long nr = folio_nr_pages(folio);
+	long entries, i;
 
 	if (!mapping) {
 		/* Anonymous page without mapping */
@@ -442,8 +443,10 @@ int folio_migrate_mapping(struct address
 			folio_set_swapcache(newfolio);
 			newfolio->private = folio_get_private(folio);
 		}
+		entries = nr;
 	} else {
 		VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
+		entries = 1;
 	}
 
 	/* Move dirty while page refs frozen and newpage not yet exposed */
@@ -453,7 +456,11 @@ int folio_migrate_mapping(struct address
 		folio_set_dirty(newfolio);
 	}
 
-	xas_store(&xas, newfolio);
+	/* Swap cache still stores N entries instead of a high-order entry */
+	for (i = 0; i < entries; i++) {
+		xas_store(&xas, newfolio);
+		xas_next(&xas);
+	}
 
 	/*
 	 * Drop cache reference from old page by unfreezing


