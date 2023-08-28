Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417D469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC3C433C7;
	Mon, 28 Aug 2023 10:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218747;
	bh=xilxuoOirtyYakOLJoJ/JQswp6wCizkBrqsuh5Bd4tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyML9BAi4wCKsJzTCRUcpRR/1SgP1lD6L5mCjK112CYvnsjs6GAyH0B4sfxOR7pyp
	 HsPKNDmbXxGqx0Fi27SNNil5iyAcyJfILxb0NHQDOqN97mfc8XIRP+OA1w5vN5GvuD
	 vBMex+aRJUnD/4zev4jSzNxfwMQ6k+YZPACVonzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 069/122] shmem: fix smaps BUG sleeping while atomic
Date: Mon, 28 Aug 2023 12:13:04 +0200
Message-ID: <20230828101158.742995218@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Hugh Dickins <hughd@google.com>

commit e5548f85b4527c4c803b7eae7887c10bf8f90c97 upstream.

smaps_pte_hole_lookup() is calling shmem_partial_swap_usage() with page
table lock held: but shmem_partial_swap_usage() does cond_resched_rcu() if
need_resched(): "BUG: sleeping function called from invalid context".

Since shmem_partial_swap_usage() is designed to count across a range, but
smaps_pte_hole_lookup() only calls it for a single page slot, just break
out of the loop on the last or only page, before checking need_resched().

Link: https://lkml.kernel.org/r/6fe3b3ec-abdf-332f-5c23-6a3b3a3b11a9@google.com
Fixes: 230100321518 ("mm/smaps: simplify shmem handling of pte holes")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>	[5.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -800,14 +800,16 @@ unsigned long shmem_partial_swap_usage(s
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct page *page;
 	unsigned long swapped = 0;
+	unsigned long max = end - 1;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, end - 1) {
+	xas_for_each(&xas, page, max) {
 		if (xas_retry(&xas, page))
 			continue;
 		if (xa_is_value(page))
 			swapped++;
-
+		if (xas.xa_index == max)
+			break;
 		if (need_resched()) {
 			xas_pause(&xas);
 			cond_resched_rcu();


