Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0334A956
	for <patches@lists.linux.dev>; Fri, 26 May 2023 07:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BFzqBMItEZgQr8hCk3V5r6qhiIrmiWlEy/D5f4lnA2E=; b=pl0lkfgoZtZTjPznudekY5HK9v
	zjooPlpEqlCsqaFtZOKe2oOkIsjXewFeAQUggQ0csrXmSEg/LbbbdByZrqoA1JUWEE/IU4kNuymSJ
	2PQI3eei+8ip/2EgJUWqJQ6fyolpTquvIN/Of0kbRh1En7RzoMnd5svO6VEDqQ5FNLqtaeoergkmA
	daR7xOt3hf8BaukiXWg6nQ/9K/UWIgZ0z4x0y7N0NMwIzBK8u4CbLDUJKSFkxKC+aR8FG7TqHLNvl
	4k8J+vfFgnEXegtEH6jRcR3cZIkGRcxjX4qlO5MaTXcafNcifBPHAdfH3KlUS18vB41SdwI5z1HLe
	vCHZUpSw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SIj-001WZj-2b;
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
Subject: [RFC v2 2/8] shmem: convert to use is_folio_hwpoison()
Date: Fri, 26 May 2023 00:55:46 -0700
Message-Id: <20230526075552.363524-3-mcgrof@kernel.org>
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

The PageHWPoison() call can be converted over to the respective folio
call is_folio_hwpoison(). This introduces no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 351803415ad2..a947f2678a39 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3360,7 +3360,7 @@ static const char *shmem_get_link(struct dentry *dentry,
 		folio = filemap_get_folio(inode->i_mapping, 0);
 		if (IS_ERR(folio))
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(folio_page(folio, 0)) ||
+		if (is_folio_hwpoison(folio) ||
 		    !folio_test_uptodate(folio)) {
 			folio_put(folio);
 			return ERR_PTR(-ECHILD);
@@ -3371,7 +3371,7 @@ static const char *shmem_get_link(struct dentry *dentry,
 			return ERR_PTR(error);
 		if (!folio)
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(folio_page(folio, 0))) {
+		if (is_folio_hwpoison(folio)) {
 			folio_unlock(folio);
 			folio_put(folio);
 			return ERR_PTR(-ECHILD);
@@ -4548,7 +4548,7 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 		return &folio->page;
 
 	page = folio_file_page(folio, index);
-	if (PageHWPoison(page)) {
+	if (is_folio_hwpoison(folio)) {
 		folio_put(folio);
 		return ERR_PTR(-EIO);
 	}
-- 
2.39.2

