Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75CD4E3EF6;
	Fri,  9 Oct 2026 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555317; cv=none; b=OZr6a01wf7pUD8QRaHW6Znx3gZGG2ZJ6zWyTA8c7HkN0HIhWIq71IU1KywT8tjxL/3zLZGIpi0y67GvzNVCWbcHQrA3QxXZD9INxvGwcnIUa67CuiuabDYJzC0EwHq2ZignSO57F9vg+cTc+LIjVeGAv0wv26/KqHO/qkAwKNVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555317; c=relaxed/simple;
	bh=oB0tg2Q6ZJK/RmrtSdu1GLns0c1Jmy27x4a4n/oyMR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6py+C6YwBqfNLnWSfiiBHVkRxD6JjzVMGkuCKt+7wD4f8LSsvACbXGT7V2QpnAmOeCShn0Avu//EfZmgIlXHeRawn+PXsflQHAiG36GOKwCdZfqHLxoCnaEDmBD2Fk7zfeyK80N/NeiotFGs82jtkAQlrLVxj4dghVI47JCRtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL1q5d4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL1q5d4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65C91F00893;
	Fri,  9 Oct 2026 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555313;
	bh=Y6IsvsktR1JCVjuBDrepAc8EXiqqd6FGrFlHF7Yz9J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL1q5d4xoQY5PtJJz298h1zVW+OX15MnCwNcRIVAZRX4sElaTc7zbX3OKrnz4JlyX
	 FvnHMKPB17lBII2dPIGPrvaFHUhWTpLe5pQ2VTVzBJxTgB3M9CkTxqhw7y0Nmm+qQV
	 bYZSjI1JTW4MYGrXMWrCnJUIirOTHdMh9AFBTfLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	Li Wang <li.wang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/403] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Fri,  9 Oct 2026 16:06:05 +0200
Message-ID: <20261009140952.223803167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit a914785f6349da754e1226420bf4e51961956769 upstream.

hugetlb-mremap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-42-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ Backport-notes: this is a partial backport containing only the aligning
of 'length' to the hugepage size. The hugepage_settings.h include line and
the hugetlb_setup_default() call are omitted. Without this fix, the
uffd_register() call always fails on arm64 with 64K base pages and 512 MiB
default HugeTLB page size causing the test to fail with the error below as
'length' is 10 MiB and not aligned to the HugeTLB page size.

  # -------------------------
  # running ./hugepage-mremap
  # -------------------------
  # TAP version 13
  # 1..1
  # # Map haddr: Returned address is 0x7eaa40000000
  # # Map daddr: Returned address is 0x7daa40000000
  # # Map vaddr: Returned address is 0x7faa40000000
  # Bail out! ioctl-UFFDIO_REGISTER: Invalid argument
  # # Planned tests != run tests (1 != 0)
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 hugepage-mremap # exit=1
  # NOTE: These hugetlb tests provide minimal coverage.  Use
  #       https://github.com/libhugetlbfs/libhugetlbfs.git for
  #       hugetlb regression testing.
  # SKIP ./uffd-wp-mremap
]
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index 928c1045e2954..d6caa075a86a0 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -97,6 +97,7 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
 	size_t length = 0;
 	int ret = 0, fd;
 
@@ -114,7 +115,11 @@ int main(int argc, char *argv[])
 	else
 		length = DEFAULT_LENGTH_MB;
 
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		ksft_exit_skip("Could not detect default hugetlb page size\n");
 	length = MB_TO_BYTES(length);
+	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
-- 
2.53.0



