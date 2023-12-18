Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36351129EF7;
	Mon, 18 Dec 2023 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/16l+W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C48FC433C8;
	Mon, 18 Dec 2023 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907897;
	bh=V+U3MRd6DIO7Sh+UTqV50zeNYB8cfh3SAlIRt8wCibE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/16l+W0NtEAF55Y96KQC0X2Yn1ju9ixYXzOu9/DLvGfLAyzeRzNAHjxIxQDJwhJx
	 Iw0DRlimqDC5mR9O/ENS3C0/llM6urWqsOOpQ0btjk2fD8d2kFdf7p5IXKgbAX5Url
	 4bu1olOYh8h4euZdncR6mb61OBkjzZqUiP4/dBJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 086/106] mm/shmem: fix race in shmem_undo_range w/THP
Date: Mon, 18 Dec 2023 14:51:40 +0100
Message-ID: <20231218135058.754270289@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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
@@ -1024,7 +1024,24 @@ whole_folios:
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
 			index = folio->index + folio_nr_pages(folio) - 1;
 			folio_unlock(folio);


