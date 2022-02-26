Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE83686
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424C0C340EF;
	Sat, 26 Feb 2022 03:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845087;
	bh=W3P5l/SyI4KFIXMVfsva+hVRh5NGYVo7KLQvUoPp0mM=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=d9WWMCqNnphPiA9rdvBZ5V9522Pbost2zJYUnApl7gESmG/CkTpJ2JTlht8zN8+Hg
	 eiYIjPqdQZrmXZl1oRE3tjI2xqdoxgnJiWFEU+7Ts+CyzJ1TWpk2Xq1twNrA1qgl7v
	 33pBXQSo2ZJ6NVinBzDRii2U9Tk9Z7yAvfCQ0Z/A=
Date: Fri, 25 Feb 2022 19:11:26 -0800
To: shuah@kernel.org,joel@joelfernandes.org,mike.kravetz@oracle.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 12/12] selftests/memfd: clean up mapping in mfd_fail_write
Message-Id: <20220226031127.424C0C340EF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests/memfd: clean up mapping in mfd_fail_write

Running the memfd script ./run_hugetlbfs_test.sh will often end in error
as follows:

memfd-hugetlb: CREATE
memfd-hugetlb: BASIC
memfd-hugetlb: SEAL-WRITE
memfd-hugetlb: SEAL-FUTURE-WRITE
memfd-hugetlb: SEAL-SHRINK
fallocate(ALLOC) failed: No space left on device
./run_hugetlbfs_test.sh: line 60: 166855 Aborted                 (core dumped) ./memfd_test hugetlbfs
opening: ./mnt/memfd
fuse: DONE

If no hugetlb pages have been preallocated, run_hugetlbfs_test.sh will
allocate 'just enough' pages to run the test.  In the SEAL-FUTURE-WRITE
test the mfd_fail_write routine maps the file, but does not unmap.  As a
result, two hugetlb pages remain reserved for the mapping.  When the
fallocate call in the SEAL-SHRINK test attempts allocate all hugetlb
pages, it is short by the two reserved pages.

Fix by making sure to unmap in mfd_fail_write.

Link: https://lkml.kernel.org/r/20220219004340.56478-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-clean-up-mapping-in-mfd_fail_write
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -455,6 +455,7 @@ static void mfd_fail_write(int fd)
 			printf("mmap()+mprotect() didn't fail as expected\n");
 			abort();
 		}
+		munmap(p, mfd_def_size);
 	}
 
 	/* verify PUNCH_HOLE fails */
_
