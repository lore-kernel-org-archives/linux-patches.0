Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8504A44238C;
	Fri,  7 Aug 2026 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115141; cv=none; b=Zu0HOVS/PaHM4yYNdIkiq2mPzynt21OiveSyS+b8HJ98m2jJtku2vZBxhXtQsyfnztDTea+vpQqdbUMV/PmZzKkLsWF6h25Ri6GN3/YfzlriTF5KHP25NeS8XzSBLNkqPCGrrsEUbogrLb3RlTY0ADqG/zy0tI1zfZgPbSHmhy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115141; c=relaxed/simple;
	bh=ceawn95A07pLs/7vrLyrW6BbY8JuQ+54c0Ktm7EUKKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOl0KOLwO+rEX3Y02OHp6m1Ie/K03rDMyi5Eog1kJgRtI0Fq4t0jzW6EDMcs19hiEbwm2amw6hUOzvckU5dz3L7fNIu2zElRZeOT+XBeo4FatKfaQd4VuOIfYu0r9lRaJktPD2RIdL3XLj9fP0jiS2RJYDhi7ditKm2CU2fDmec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1X3rCcCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1X3rCcCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DA31F000E9;
	Fri,  7 Aug 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115138;
	bh=8s448cT0X0G6O90Cfb4RzDO43TLNKQzSa4guR2ytPyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1X3rCcCgn/aMCIf4h8+t/4ZoPZ+kNOMvgqCCKRhTIyrdB6paQ7CyyldxtFVZ9x4Jm
	 iBry65baExySbZr55CCP+XhXafPvp7Co9x/VRvIq6zvjgx9FGSdGtGEnQ/SnDFaJBU
	 UdGOOrRZ8CXoZW1bfrnxn26jg2YJPOuH2/aKj6gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 170/396] mm/util: dont read __page_2 for order-1 folios in snapshot_page()
Date: Fri,  7 Aug 2026 16:35:30 +0200
Message-ID: <20260807143427.967409808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

commit 7441d6348c70738e9ed307510db171c7a9b3f4bf upstream.

snapshot_page() currently reads __page_2 after checking nr_pages > 1, but
it should only do so when nr_pages > 2.

If an order-1 folio is allocated at the end of a vmemmap section,
__page_2 will not exist and reading it will cause a fault.

During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page() oopsed
on the page isolation path while reading an order-1 folio's __page_2 from
an adjacent absent section (unmapped vmemmap).

Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
hole).

Link: https://lore.kernel.org/20260708201954.686111-1-aboorvad@linux.ibm.com
Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -1263,7 +1263,7 @@ again:
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
 		nr_pages = folio_nr_pages(&ps->folio_snapshot);
-		if (nr_pages > 1)
+		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);


