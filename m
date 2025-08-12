Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15233F9D2;
	Tue, 12 Aug 2025 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023148; cv=none; b=CGRiCbV2jTQhOWtt/hE6cPwxsASsSUMNVfR1cVIMobj2yKREKBZivEKzTtwvXMY7Nhg/TG4dTN8EcrRu39dv5HgjV+8eu1WAHTCZzBhAr40zK1MxK9Vh/+DAdFZKlJXm3DmlFme97SFwSeh+uxR3N9LCFvCG5njkGMhpQKjkZmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023148; c=relaxed/simple;
	bh=Z+uzInZ6aXXmQfLPPFzPNTjQ1m7iX1a9Rl5CUyQDkHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9+Y2Hv4Q0IhC9/8y7+2neqif0e0DfYpma8t+3OoSzaTrFTVRcr9m9EGU4DBUL76eO+RaQV/9j5Z+lCjq5DhxxmRY9ihelA81I32WRg8Sa4KEGZmwybztSM1T2JXGkQRWRqho5XbMPlrnokl4UKgbfZTomZZs8luIJi+PATQ28A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvOsN7c8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvOsN7c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706E3C4CEF0;
	Tue, 12 Aug 2025 18:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023147;
	bh=Z+uzInZ6aXXmQfLPPFzPNTjQ1m7iX1a9Rl5CUyQDkHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvOsN7c8gxGQd5sFC81j3OXzgylLdpMCKFjxWbO/6BPN67IooKeZFSL8FAVQvpurZ
	 p6tHWSsk8eLYnEB/5W+8PU6cOssRs9yKQaRngJIfvDuuE36z/7MzB1UvCsZTfOP3uX
	 wkL6zBC09LOtS8T45BoLUPyEKsUcXSyRCmtiHDzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <bhe@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 364/369] mm: swap: fix potential buffer overflow in setup_clusters()
Date: Tue, 12 Aug 2025 19:31:01 +0200
Message-ID: <20250812173030.374139350@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 152c1339dc13ad46f1b136e8693de15980750835 upstream.

In setup_swap_map(), we only ensure badpages are in range (0, last_page].
As maxpages might be < last_page, setup_clusters() will encounter a buffer
overflow when a badpage is >= maxpages.

Only call inc_cluster_info_page() for badpage which is < maxpages to fix
the issue.

Link: https://lkml.kernel.org/r/20250522122554.12209-4-shikemeng@huaweicloud.com
Fixes: b843786b0bd0 ("mm: swapfile: fix SSD detection with swapfile on btrfs")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3309,9 +3309,13 @@ static struct swap_cluster_info *setup_c
 	 * and the EOF part of the last cluster.
 	 */
 	inc_cluster_info_page(si, cluster_info, 0);
-	for (i = 0; i < swap_header->info.nr_badpages; i++)
-		inc_cluster_info_page(si, cluster_info,
-				      swap_header->info.badpages[i]);
+	for (i = 0; i < swap_header->info.nr_badpages; i++) {
+		unsigned int page_nr = swap_header->info.badpages[i];
+
+		if (page_nr >= maxpages)
+			continue;
+		inc_cluster_info_page(si, cluster_info, page_nr);
+	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++)
 		inc_cluster_info_page(si, cluster_info, i);
 


