Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7221172A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B459C433C7;
	Mon, 11 Sep 2023 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444755;
	bh=L3bzhZI5CMrW02F42ht27H9mM9FL1bNHvelDKh4N5Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11oASucPH+QMItwVkdeZIUF3tlpkY9v2WRquE68k5acHx0pYP3JTlDaKV9RCJek0d
	 49FfFJuGFd1tZc1EXitebj41rqDf2XdAF4mzEV6G1Z2ddTn/Y/PlfsTV+BNyBN/AEO
	 6m9j+AaZbRJJ/MLnSretf+p/1LnIDUSP92OkOQgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/600] iomap: Remove large folio handling in iomap_invalidate_folio()
Date: Mon, 11 Sep 2023 15:42:17 +0200
Message-ID: <20230911134636.670934537@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit a221ab717c43147f728d93513923ba3528f861bf ]

We do not need to release the iomap_page in iomap_invalidate_folio()
to allow the folio to be split.  The splitting code will call
->release_folio() if there is still per-fs private data attached to
the folio.  At that point, we will check if the folio is still dirty
and decline to release the iomap_page.  It is possible to trigger the
warning in perfectly legitimate circumstances (eg if a disk read fails,
we do a partial write to the folio, then we truncate the folio), which
will cause those writes to be lost.

Fixes: 60d8231089f0 ("iomap: Support large folios in invalidatepage")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91ee0b308e13d..a0a4d8de82cad 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -488,11 +488,6 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
 		WARN_ON_ONCE(folio_test_writeback(folio));
 		folio_cancel_dirty(folio);
 		iomap_page_release(folio);
-	} else if (folio_test_large(folio)) {
-		/* Must release the iop so the page can be split */
-		WARN_ON_ONCE(!folio_test_uptodate(folio) &&
-			     folio_test_dirty(folio));
-		iomap_page_release(folio);
 	}
 }
 EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
-- 
2.40.1



