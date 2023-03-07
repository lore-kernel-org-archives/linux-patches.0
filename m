Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97277BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D809EC433EF;
	Tue,  7 Mar 2023 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211521;
	bh=RedV5afMVfSXdxpAGoCKNMqxPPePpV0dczkxtQWbeGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIOt39IV1N5CEjDLD+fF2P2pjqCez/RHBVN4kyofo4ekLKdEfWq+KPX2a2/WEzcFo
	 JAkAVTfoYRxWTKXxfca0RdMWHIUHvgWDU1+muU6bevrOEkCs7pEvzug8CFlnN9RnxF
	 c5k4b2PVD9eq4Jn7k6JVJxJOCLjdziGhOTHzNKf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"andrew.yang" <andrew.yang@mediatek.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 0888/1001] mm/damon/paddr: fix missing folio_put()
Date: Tue,  7 Mar 2023 18:01:00 +0100
Message-Id: <20230307170100.480677307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: andrew.yang <andrew.yang@mediatek.com>

commit 3f98c9a62c338bbe06a215c9491e6166ea39bf82 upstream.

damon_get_folio() would always increase folio _refcount and
folio_isolate_lru() would increase folio _refcount if the folio's lru flag
is set.

If an unevictable folio isolated successfully, there will be two more
_refcount.  The one from folio_isolate_lru() will be decreased in
folio_puback_lru(), but the other one from damon_get_folio() will be left
behind.  This causes a pin page.

Whatever the case, the _refcount from damon_get_folio() should be
decreased.

Link: https://lkml.kernel.org/r/20230222064223.6735-1-andrew.yang@mediatek.com
Fixes: 57223ac29584 ("mm/damon/paddr: support the pageout scheme")
Signed-off-by: andrew.yang <andrew.yang@mediatek.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.16.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/paddr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -219,12 +219,11 @@ static unsigned long damon_pa_pageout(st
 			put_page(page);
 			continue;
 		}
-		if (PageUnevictable(page)) {
+		if (PageUnevictable(page))
 			putback_lru_page(page);
-		} else {
+		else
 			list_add(&page->lru, &page_list);
-			put_page(page);
-		}
+		put_page(page);
 	}
 	applied = reclaim_pages(&page_list);
 	cond_resched();


