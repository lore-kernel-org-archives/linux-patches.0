Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513093A89AF;
	Wed, 21 Jan 2026 18:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019885; cv=none; b=rWOl4hvNwtLbuaP3Xlrscwg90tB9z0a9KvnBmhPYHVnGHZavl6O4sOzcO38XuUGdN91F/ulaZgIxz7crp0i/zIr/2ot9Fav8aCsoU92yNz8CimmmHSlOJPIQyFUZaT+DniPr5EnHRVZLSes1v5WlWwL3TEuw3Th8qF0P/Ndle48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019885; c=relaxed/simple;
	bh=8FQ9tHohm+EhqBZenO0/dZwQQMxH34vEkvaSRJUtVRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJFo4xNvgGfq48420nvO1pp4Qn59BgkFSOFotJ9bQ9UK/PIYSxj+bw2B6Ogo7EPyZavSf+hxLvpzUF0TTmZlouj8F2ysuf4SXEW5iurzPxsm6gLqEj9Tabs0X1J9wZ02JC8zk5pCLr6sfxKhwuLXxZ9WVZxm88564TRGnbfcvh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHQp1WMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHQp1WMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF56C16AAE;
	Wed, 21 Jan 2026 18:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019885;
	bh=8FQ9tHohm+EhqBZenO0/dZwQQMxH34vEkvaSRJUtVRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHQp1WMnOmdrrCSNdhPaYa7D4XJMRxZ/BAcQtfxWK2GuhDb8AFkocT3tblObcnSaF
	 FZw05clkYRAekpfuD1mzkHFWXvNsxnPKqraZ6wDa4wyZpg+v6wSFwcsuikpR9vQWk7
	 5UmKmNAv3OAhBRcrkACRABOw9KVWPzYaF6Krs0BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Mason <clm@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Michal Hocko <mhocko@suse.com>,
	SeongJae Park <sj@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 6.12 137/139] mm/page_alloc: batch page freeing in decay_pcp_high
Date: Wed, 21 Jan 2026 19:16:25 +0100
Message-ID: <20260121181416.388412079@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hahn <joshua.hahnjy@gmail.com>

[ Upstream commit fc4b909c368f3a7b08c895dd5926476b58e85312 ]

It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot.
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once and
starve out other threads that need the pcp or zone lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Link: https://lkml.kernel.org/r/20251014145011.3427205-3-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 038a102535eb ("mm/page_alloc: prevent pcp corruption with SMP=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2365,7 +2365,7 @@ static int rmqueue_bulk(struct zone *zon
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2383,11 +2383,14 @@ bool decay_pcp_high(struct zone *zone, s
 	}
 
 	to_drain = pcp->count - pcp->high;
-	if (to_drain > 0) {
+	while (to_drain > 0) {
+		to_drain_batched = min(to_drain, batch);
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
 		spin_unlock(&pcp->lock);
 		todo = true;
+
+		to_drain -= to_drain_batched;
 	}
 
 	return todo;


