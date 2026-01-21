Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139773563E2;
	Wed, 21 Jan 2026 18:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020394; cv=none; b=mw6ib8DLqydlU3pgDV++HYdbZGaTlpzyVcOQDsx1fCQ+KYJj8QyNmRwjKmBC4IS+ID06f09EBtlTiVIfSrqYWLb9n5O1kyzt1vY7q4En/QnFumJE03QmreLqCWytgyEZFMh3wRCz0+tG7T3Gz2BpG3I9nQybcX5/fJGH82mW4Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020394; c=relaxed/simple;
	bh=CHEeJNwpjhVnkCTKzTMWtV78IN8ND1UKXBgWrbtQdlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPmI7Ma5OqsXWbEZeIaVUcOfWwxzOXc7gOVERVi4lUrA1XKWemsZTC24NRLUQkA6uFvmGEOuWxgSjyLdYjfJIQ4Ccg6ZDfWPDC0vjVPGRUwhEeH4wQCR7QgsX7ITTELgtFQTyK0s975YhaLN3CLq0d1DRylAyq3RXS1zfNIolXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEISUjE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEISUjE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22113C4CEF1;
	Wed, 21 Jan 2026 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020393;
	bh=CHEeJNwpjhVnkCTKzTMWtV78IN8ND1UKXBgWrbtQdlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEISUjE2OFbpDzLrqSZH9PQYOg4OgR0Vz5rOUAyj76fVJ6F88Oa6pBVXY4CofBnLj
	 niMCCxsAE9QPLk5C6SBd3K0JIYVHOzm55hQHgplapVcq5c63l9H0u7sKy90R5WVUrZ
	 Rp0YV22JZi/AzKkSrliWz05vEm2Lx7/fkK4MzHs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 145/198] mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
Date: Wed, 21 Jan 2026 19:16:13 +0100
Message-ID: <20260121181423.777500793@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit a24ca8ebb0cd5ea07a1462b77be0f0823c40f319 upstream.

Patch series "mm/damon/sysfs: free setup failures generated zombie sub-sub
dirs".

Some DAMON sysfs directory setup functions generates its sub and sub-sub
directories.  For example, 'monitoring_attrs/' directory setup creates
'intervals/' and 'intervals/intervals_goal/' directories under
'monitoring_attrs/' directory.  When such sub-sub directories are
successfully made but followup setup is failed, the setup function should
recursively clean up the subdirectories.

However, such setup functions are only dereferencing sub directory
reference counters.  As a result, under certain setup failures, the
sub-sub directories keep having non-zero reference counters.  It means the
directories cannot be removed like zombies, and the memory for the
directories cannot be freed.

The user impact of this issue is limited due to the following reasons.

When the issue happens, the zombie directories are still taking the path.
Hence attempts to generate the directories again will fail, without
additional memory leak.  This means the upper bound memory leak is
limited.  Nonetheless this also implies controlling DAMON with a feature
that requires the setup-failed sysfs files will be impossible until the
system reboots.

Also, the setup operations are quite simple.  The certain failures would
hence only rarely happen, and are difficult to artificially trigger.


This patch (of 4):

When attrs/ DAMON sysfs directory setup is failed after setup of
intervals/ directory, intervals/intervals_goal/ directory is not cleaned
up.  As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directory under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251225023043.18579-2-sj@kernel.org
Fixes: 8fbbcbeaafeb ("mm/damon/sysfs: implement intervals tuning goal directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -764,7 +764,7 @@ static int damon_sysfs_attrs_add_dirs(st
 	nr_regions_range = damon_sysfs_ul_range_alloc(10, 1000);
 	if (!nr_regions_range) {
 		err = -ENOMEM;
-		goto put_intervals_out;
+		goto rmdir_put_intervals_out;
 	}
 
 	err = kobject_init_and_add(&nr_regions_range->kobj,
@@ -778,6 +778,8 @@ static int damon_sysfs_attrs_add_dirs(st
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
+rmdir_put_intervals_out:
+	damon_sysfs_intervals_rm_dirs(intervals);
 put_intervals_out:
 	kobject_put(&intervals->kobj);
 	attrs->intervals = NULL;


