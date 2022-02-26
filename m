Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8213D367F
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D84C340E7;
	Sat, 26 Feb 2022 03:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845063;
	bh=NwpuICpm0V8qEMhlsHOVt+1UzXIwqQEEcQj42gz4J88=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=PTb3Pke/oRR+dKf07zJhVHtdD+aLBFWBwReJUQUG4ZcNlaZ9spdEMo2j2asgO1P31
	 BNAUH4HnQUQ12CL+ur5x/4VhXTnbORDsOzpCdxPd7DJo/mknRrRsSyRj/XKtnLFE52
	 jdF3DR8uLyAGBYB14okzqazSU0iCibet+SaHladw=
Date: Fri, 25 Feb 2022 19:11:02 -0800
To: stable@vger.kernel.org,mike.kravetz@oracle.com,liuyuntao10@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 04/12] hugetlbfs: fix a truncation issue in hugepages parameter
Message-Id: <20220226031103.37D84C340E7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Liu Yuntao <liuyuntao10@huawei.com>
Subject: hugetlbfs: fix a truncation issue in hugepages parameter

When we specify a large number for node in hugepages parameter, it may be
parsed to another number due to truncation in this statement:

	node = tmp;

For example, add following parameter in command line:

	hugepagesz=1G hugepages=4294967297:5

and kernel will allocate 5 hugepages for node 1 instead of ignoring it.

I move the validation check earlier to fix this issue, and slightly
simplifies the condition here.

Link: https://lkml.kernel.org/r/20220209134018.8242-1-liuyuntao10@huawei.com
Fixes: b5389086ad7be0 ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Liu Yuntao <liuyuntao10@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlbfs-fix-a-truncation-issue-in-hugepages-parameter
+++ a/mm/hugetlb.c
@@ -4159,10 +4159,10 @@ static int __init hugepages_setup(char *
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
 				return 0;
 			}
+			if (tmp >= nr_online_nodes)
+				goto invalid;
 			node = tmp;
 			p += count + 1;
-			if (node < 0 || node >= nr_online_nodes)
-				goto invalid;
 			/* Parse hugepages */
 			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
 				goto invalid;
_
