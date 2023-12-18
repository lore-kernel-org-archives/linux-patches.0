Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03F37865;
	Mon, 18 Dec 2023 14:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEYQI4Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0481C433C7;
	Mon, 18 Dec 2023 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908342;
	bh=kuf4oQ5tRxn08rFjJJHlsC131/aX3/ey+nqx/4l6r6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEYQI4Z38WeUiaqJamc6HXP/g4/G5pvgQOTrF+Z0+NbECqzs1ukUV64y+fBnLS+zS
	 3cAR0DEpicmxwBZxIL6Eut5q12jdvFCTxCmVDsvE+ESmDnPOBExakeC+DGHU04ks7s
	 Q7/rprPTt5q/5Gym6KxaNGDquGfyAe9nDbwsJTMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 141/166] mm/shmem: fix race in shmem_undo_range w/THP
Date: Mon, 18 Dec 2023 14:51:47 +0100
Message-ID: <20231218135111.419769089@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <stevensd@chromium.org>

commit 55ac8bbe358bdd2f3c044c12f249fd22d48fe015 upstream.

Split folios during the second loop of shmem_undo_range.  It's not
sufficient to only split folios when dealing with partial pages, since
it's possible for a THP to be faulted in after that point.  Calling
truncate_inode_folio in that situation can result in throwing away data
outside of the range being targeted.

[akpm@linux-foundation.org: tidy up comment layout]
Link: https://lkml.kernel.org/r/20230418084031.3439795-1-stevensd@google.com
Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Signed-off-by: David Stevens <stevensd@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1098,7 +1098,24 @@ whole_folios:
 				}
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
-				truncate_inode_folio(mapping, folio);
+
+				if (!folio_test_large(folio)) {
+					truncate_inode_folio(mapping, folio);
+				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
+					/*
+					 * If we split a page, reset the loop so
+					 * that we pick up the new sub pages.
+					 * Otherwise the THP was entirely
+					 * dropped or the target range was
+					 * zeroed, so just continue the loop as
+					 * is.
+					 */
+					if (!folio_test_large(folio)) {
+						folio_unlock(folio);
+						index = start;
+						break;
+					}
+				}
 			}
 			folio_unlock(folio);
 		}


