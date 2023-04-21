Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4924E6FD7
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 21:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Pwtny366FbTbrb7vPgMXDOxfQYz6bsR4vwvBIbUUYzg=; b=l1UKRS+6uYC4EXAjJgBrQTAp5j
	xsYvwCnnNonL+zWZMEy71A3Ta6km8F6dSzKQvEcpRo5TV7XBXl9OERI0fsz5C845ifOI1VFCEHRc1
	Zre0qUD7V89WFxot/x0Dllx9YnFxYQ7Yz7zDqe598RN0r0tdnLI/4pmF0Tvd/CygY81NUfyF7TcfO
	R1q/JTspIPOKlYq6NoZibJ4hLTLlDqaLHYjGQRhRwv9u7o7cGbziZ6ambxSZLU25fgMv7Z5We7Z9g
	4m2TriUxFygO3OJdPvzDe0pBPp5xw1iklrlut7//xUpzOnTPbemmyDvmuxTGhDtulG3XxP+CyxfK9
	9RMFdwJQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppyY1-00Btok-1t;
	Fri, 21 Apr 2023 21:44:05 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org,
	djwong@kernel.org
Cc: p.raghav@samsung.com,
	da.gomez@samsung.com,
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
Subject: [RFC 2/8] shmem: convert to use folio_test_hwpoison()
Date: Fri, 21 Apr 2023 14:43:54 -0700
Message-Id: <20230421214400.2836131-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230421214400.2836131-1-mcgrof@kernel.org>
References: <20230421214400.2836131-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

The PageHWPoison() call can be converted over to the respective folio call
folio_test_hwpoison(). This introduces no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5bf92d571092..6f117c3cbe89 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3483,7 +3483,7 @@ static const char *shmem_get_link(struct dentry *dentry,
 		folio = filemap_get_folio(inode->i_mapping, 0);
 		if (IS_ERR(folio))
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(folio_page(folio, 0)) ||
+		if (folio_test_hwpoison(folio) ||
 		    !folio_test_uptodate(folio)) {
 			folio_put(folio);
 			return ERR_PTR(-ECHILD);
@@ -3494,7 +3494,7 @@ static const char *shmem_get_link(struct dentry *dentry,
 			return ERR_PTR(error);
 		if (!folio)
 			return ERR_PTR(-ECHILD);
-		if (PageHWPoison(folio_page(folio, 0))) {
+		if (folio_test_hwpoison(folio)) {
 			folio_unlock(folio);
 			folio_put(folio);
 			return ERR_PTR(-ECHILD);
@@ -4672,7 +4672,7 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 		return &folio->page;
 
 	page = folio_file_page(folio, index);
-	if (PageHWPoison(page)) {
+	if (folio_test_hwpoison(folio)) {
 		folio_put(folio);
 		return ERR_PTR(-EIO);
 	}
-- 
2.39.2

