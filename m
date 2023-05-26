Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0518AD25
	for <patches@lists.linux.dev>; Fri, 26 May 2023 07:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1AhvaQEykxRfZlsh2c4Dug9Lp7odXzIMf8TvoDKNOGw=; b=E15C01rvh8qJUhFpengqZNed+/
	epNw4ByYQ60Hpq6UA2LISl8vHwk8zLvgERrEfiFp3oNWfTARAPEe7kg6OrC9oLUNypcBwftohyOnf
	+kL6CMebLub5C8stfDZczdk0CnTJ2fgF/4xjbR58muAKAcLkhsx0UFbRGlIlzEGokmwyiQyPBh2wB
	bKTkZouYgrnXR+ek49+JL+J0BZFyfmAg080+gR8oRXI7sFUtk8hhGst/KBWs76xcaNZWzGmiur9Ci
	XJdyxvsilz8bhnSS0ZbAagO3yezv4DQzoPICC07AQImRF3Kid2X8VB9bGdRAtSfY4kFBchyEre3KY
	lgFf96ig==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SIk-001WZy-03;
	Fri, 26 May 2023 07:55:54 +0000
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
Subject: [RFC v2 7/8] shmem: add high order page support
Date: Fri, 26 May 2023 00:55:51 -0700
Message-Id: <20230526075552.363524-8-mcgrof@kernel.org>
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
index d347a5ba49f1..080864949fe5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1623,9 +1623,15 @@ static struct folio *shmem_alloc_folio(gfp_t gfp,
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

