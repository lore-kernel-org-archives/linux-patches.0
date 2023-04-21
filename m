Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3727479
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 21:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LRGm8v+C2VnFh3pJYXzbKwj2NvliqmXVbLHOoz9D9rs=; b=Gv4xXUfwg6Tqrov7HtOq12Iot5
	YO5wR1wBRRe+FoidC8runo8IO16BDwaMfjnowR194HePAotck078Dc52Y5LhgHsJWaSdFz/ExDOoW
	7UvJg+gaENVFRZFuUklS2jbQPIu6sP031vvUKDVO8op0VWHJ/pcNAbKtxQ6EJtE3JOGWA8i9aCI4G
	c82Y5dwvzAyUa4CC4Jt/QPxPn6XSF0jejQ+JpFEAjr1mjFYM6xQTv/oz9ZsmadJRNPxXXDoGL2kGk
	x5ARZON7gmkNiGzDhbMd8jQFJ5x3RYgTnUCgMJhDF50jxO3kH/6kEmfu6+iJAJL3r0nsysDSme+ZO
	aDY1SY0g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppyY1-00Btou-2Z;
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
Subject: [RFC 7/8] shmem: add high order page support
Date: Fri, 21 Apr 2023 14:43:59 -0700
Message-Id: <20230421214400.2836131-8-mcgrof@kernel.org>
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

To support high order block sizes we want to support a high order
folios so to treat the larger block atomically. Add support for this
for tmpfs mounts.

Right now this produces no functional changes since we only allow one
single block size, matching the PAGE_SIZE and so the order is always 0.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 5a64efd1f3c2..740b4448f936 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1621,9 +1621,15 @@ static struct folio *shmem_alloc_folio(gfp_t gfp,
 {
 	struct vm_area_struct pvma;
 	struct folio *folio;
+	struct inode *inode = &info->vfs_inode;
+	struct super_block *i_sb = inode->i_sb;
+	int order = 0;
+
+	if (!(i_sb->s_flags & SB_KERNMOUNT))
+		order = i_sb->s_blocksize_bits - PAGE_SHIFT;
 
 	shmem_pseudo_vma_init(&pvma, info, index);
-	folio = vma_alloc_folio(gfp, 0, &pvma, 0, false);
+	folio = vma_alloc_folio(gfp, order, &pvma, 0, false);
 	shmem_pseudo_vma_destroy(&pvma);
 
 	return folio;
-- 
2.39.2

