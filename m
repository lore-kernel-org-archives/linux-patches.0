Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA5DA95C
	for <patches@lists.linux.dev>; Fri, 26 May 2023 07:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5oQ2gGbUsqL42uQDz21dyQWBbUA0px4CnOLURAD/lus=; b=LdiDWYPfbsR2VwE3muTukBHf1n
	2WKuZw7xVn16RN6k6Wo9ylU0o5DsPwzzrnruYbzYdoYyEpJt744EXDXhFgaq3aPLQM0XtiDj2f8FP
	2plHBSw0sndtNX7DTHqerD4102mCieETYl1G0dRVa+cHO3vzNpp7xWDo8hVulJyMeNAOkZv4L98nW
	6TmrmiHMZRz3tMGsyF1olHjbXr53o35bSOXIQ23JnCL7T/TEVq47iBber3uY3gk1HYKtkAuea4Vam
	CYKjwRSPO0HEhImDxfLN6W/tI67qgSTWbDSI9uMVp9MT7NiJOiaImnK7AjLb+fCQHpyGYE6dCefwT
	r8p56qVA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SIj-001WZg-2T;
	Fri, 26 May 2023 07:55:53 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org,
	djwong@kernel.org
Cc: p.raghav@samsung.com,
	da.gomez@samsung.com,
	rohan.puri@samsung.com,
	rpuri.linux@gmail.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	hare@suse.de,
	kbusch@kernel.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 1/8] page_flags: add is_folio_hwpoison()
Date: Fri, 26 May 2023 00:55:45 -0700
Message-Id: <20230526075552.363524-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526075552.363524-1-mcgrof@kernel.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Provide a helper similar to is_page_hwpoison() for folios
which tests the first head and if the folio is large any page in
the folio is tested for the poison flag.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 include/linux/page-flags.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 1c68d67b832f..4d5f395edf03 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -883,6 +883,13 @@ static inline bool is_page_hwpoison(struct page *page)
 	return PageHuge(page) && PageHWPoison(compound_head(page));
 }
 
+static inline bool is_folio_hwpoison(struct folio *folio)
+{
+       if (folio_test_hwpoison(folio))
+               return true;
+       return folio_test_large(folio) && folio_test_has_hwpoisoned(folio);
+}
+
 /*
  * For pages that are never mapped to userspace (and aren't PageSlab),
  * page_type may be used.  Because it is initialised to -1, we invert the
-- 
2.39.2

