Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436391DD9D3;
	Tue, 25 Mar 2025 12:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905997; cv=none; b=NBKBULnQUnvjGnf1D4R/sbMXHqhtyFMYWu+FOZyjHk7CcoK369OVH1GIaVk+miuxS4/TZEIpecNUyzQ4CzrYPcZcUPWkH8Za65bRW20I5ZcXFMkGvCGhycYMyxC6nnqFUumC5D8O6Huw0pt+J9Miv41KKqCQL3puWW3z5GqRSkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905997; c=relaxed/simple;
	bh=bZAeLUJcFxejPtybDaWcuoagkkxTE55jr7YvUlFKxXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0eji+vkuoFIYlboL7sQytRatOH6zk3TvsMNJHlSauke0quTtikQ2JI4tFlMWWMNdmX7yYOjbrwuM14SlEUR8Gp9XNvBz2TQbWzi1cfOVPK7Bf3+bwqt16MPXpRB63zhuvLnzQJu+ubF3C1MTUts2Tyok+e3W4UU8ChT0to/bv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfJAgU3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfJAgU3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E703AC4CEE4;
	Tue, 25 Mar 2025 12:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905997;
	bh=bZAeLUJcFxejPtybDaWcuoagkkxTE55jr7YvUlFKxXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfJAgU3nNXNJtomIu2HS3hh8vfM3Pq28E6CpSPcaoKKpDFVsQJvvIQhDieSHTu+iE
	 6x1aVKT8xDSJej8riPb+vIo+xJ9JjWSrJ7q226hfchpnDpH4egiBtquKFuvePOmM1u
	 OfAdSrSJoTenb3uxi6PE2h8qk0piAiVPlsu/jLC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Aquini <raquini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 078/119] selftests/mm: run_vmtests.sh: fix half_ufd_size_MB calculation
Date: Tue, 25 Mar 2025 08:22:16 -0400
Message-ID: <20250325122151.051037358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Aquini <raquini@redhat.com>

commit 67a2f86846f244d81601cf2e1552c4656b8556d6 upstream.

We noticed that uffd-stress test was always failing to run when invoked
for the hugetlb profiles on x86_64 systems with a processor count of 64 or
bigger:

  ...
  # ------------------------------------
  # running ./uffd-stress hugetlb 128 32
  # ------------------------------------
  # ERROR: invalid MiB (errno=9, @uffd-stress.c:459)
  ...
  # [FAIL]
  not ok 3 uffd-stress hugetlb 128 32 # exit=1
  ...

The problem boils down to how run_vmtests.sh (mis)calculates the size of
the region it feeds to uffd-stress.  The latter expects to see an amount
of MiB while the former is just giving out the number of free hugepages
halved down.  This measurement discrepancy ends up violating uffd-stress'
assertion on number of hugetlb pages allocated per CPU, causing it to bail
out with the error above.

This commit fixes that issue by adjusting run_vmtests.sh's
half_ufd_size_MB calculation so it properly renders the region size in
MiB, as expected, while maintaining all of its original constraints in
place.

Link: https://lkml.kernel.org/r/20250218192251.53243-1-aquini@redhat.com
Fixes: 2e47a445d7b3 ("selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation")
Signed-off-by: Rafael Aquini <raquini@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/run_vmtests.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -302,7 +302,9 @@ uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
 # Hugetlb tests require source and destination huge pages. Pass in half
 # the size of the free pages we have, which is used for *each*.
-half_ufd_size_MB=$((freepgs / 2))
+# uffd-stress expects a region expressed in MiB, so we adjust
+# half_ufd_size_MB accordingly.
+half_ufd_size_MB=$(((freepgs * hpgsize_KB) / 1024 / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16


