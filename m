Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A1B5102D;
	Mon,  8 Jan 2024 15:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2roeKNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10084C433C8;
	Mon,  8 Jan 2024 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728511;
	bh=4Qhk9rb7noh84zEBCiDD1nw6+Bp96aHPll7lj0qN1PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2roeKNhdNsZqNqroZ6MFek/03088p6BudV35I+Fe2pI62hd1GSMV+y8P7FZ/miPM
	 SgADAOXbmxYiGpSBAm7sQP0aq+l+ukKIYGbw9kaaWOmUpD9jhCHHHB4Vvz7RRyg/hV
	 BVEF5bKo9/dlJ6ZmU+L6b/XSgIFayRsKiPafdV4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/150] memory-failure: convert truncate_error_page() to use folio
Date: Mon,  8 Jan 2024 16:35:51 +0100
Message-ID: <20240108153515.809946366@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

[ Upstream commit ac5efa782041670b63a05c36d92d02a80e50bb63 ]

Replace try_to_release_page() with filemap_release_folio().  This change
is in preparation for the removal of the try_to_release_page() wrapper.

Link: https://lkml.kernel.org/r/20221118073055.55694-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 1898efcdbed3 ("block: update the stable_writes flag in bdev_add")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ebd717157c813..6355166a6bb28 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -827,12 +827,13 @@ static int truncate_error_page(struct page *p, unsigned long pfn,
 	int ret = MF_FAILED;
 
 	if (mapping->a_ops->error_remove_page) {
+		struct folio *folio = page_folio(p);
 		int err = mapping->a_ops->error_remove_page(mapping, p);
 
 		if (err != 0) {
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
-		} else if (page_has_private(p) &&
-			   !try_to_release_page(p, GFP_NOIO)) {
+		} else if (folio_has_private(folio) &&
+			   !filemap_release_folio(folio, GFP_NOIO)) {
 			pr_info("%#lx: failed to release buffers\n", pfn);
 		} else {
 			ret = MF_RECOVERED;
-- 
2.43.0



