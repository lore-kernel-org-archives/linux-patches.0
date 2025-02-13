Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DC32A1D1;
	Thu, 13 Feb 2025 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458240; cv=none; b=UArAiLRcH0sfqUnAV919xGJquB90XgW3solh1DMjvwWZe8JcTHV1RQGbprZUD6PaMPuS+Em4KnmxmcjtrsNrKU2brF9zXnzCi54cc19bP2O++JBSluIldleWV1hBgYGzQQDHM08F9gxqhLgrATXfL/F5TQLxhRPY6k0GiBsUwew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458240; c=relaxed/simple;
	bh=NECLSObHoS7zeUidH5DrmMCVm4FUDTsiLBpX1ENv/+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQds2SGOuPt+nCzNhm+U90HKGuSIjDy6aU/SXuw+r1nYYRby04JSAXhwwcY9gk2YZLTTyGGMFj+zdTTJ0ajC81akGbs45EJCvjFW2ZxnIOYqUFWw8nvX/0O2U0JdCPk4loxlZezlrQu1pKsebHxo0yH+BXwHGXuXCg9zF9l8/j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPsvpH25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPsvpH25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75793C4CED1;
	Thu, 13 Feb 2025 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458239;
	bh=NECLSObHoS7zeUidH5DrmMCVm4FUDTsiLBpX1ENv/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPsvpH25b3zDWkvnxIvDQx5hCIw1HaRNoARvtrMrs4UqfYtiN0aeqDlcPg89kp9jA
	 mVl7ohDntN2V6qewbg/QZZ0M/eEkmyaI2YnUB4up5IfrHaUxfOCuK9yBudXGd9cp3Q
	 QP+tamu3p/OeY5NmegwQ++oJEv/1kdHEm4OSprgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 342/422] mm/vmscan: accumulate nr_demoted for accurate demotion statistics
Date: Thu, 13 Feb 2025 15:28:11 +0100
Message-ID: <20250213142449.752680518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

commit a479b078fddb0ad7f9e3c6da22d9cf8f2b5c7799 upstream.

In shrink_folio_list(), demote_folio_list() can be called 2 times.
Currently stat->nr_demoted will only store the last nr_demoted( the later
nr_demoted is always zero, the former nr_demoted will get lost), as a
result number of demoted pages is not accurate.

Accumulate the nr_demoted count across multiple calls to
demote_folio_list(), ensuring accurate reporting of demotion statistics.

[lizhijian@fujitsu.com: introduce local nr_demoted to fix nr_reclaimed double counting]
  Link: https://lkml.kernel.org/r/20250111015253.425693-1-lizhijian@fujitsu.com
Link: https://lkml.kernel.org/r/20250110122133.423481-1-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Acked-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1053,7 +1053,7 @@ static unsigned int shrink_folio_list(st
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0;
+	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1522,8 +1522,9 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	stat->nr_demoted = demote_folio_list(&demote_folios, pgdat);
-	nr_reclaimed += stat->nr_demoted;
+	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_reclaimed += nr_demoted;
+	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */


