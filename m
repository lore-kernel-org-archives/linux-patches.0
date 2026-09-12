Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACD81D7E5C;
	Sat, 12 Sep 2026 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224921; cv=none; b=fMc66zpq9gZUOfsU3mPwaHOXeAcUJNhbdCIdfqJ+LabipYfzNYRSYUWqZoqHZUJwlzxn0pfORVRCbOcCmcUbZxnFoIOs68BHJ0QAmum9ddqquoxn4WqwBJ2Mncj52M666R/a9vwvvMdI3ORKLb06Pjiy7OgQtG794nExcTqWDhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224921; c=relaxed/simple;
	bh=v8DOyLGw85n5wLBWjbOUPvmnFJGane72FfshEd5sJFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnXozzd4KzjJWZlLWJM7F6vwOqs6nP/+6LJMuc2UJU7NMRNkCTE+SHNOOqCu078AY16G/C8Ftnt4F1cmyKmqI4zck0mMuGYprChKBgxyZoE+7bdxcjzjABqMjcczBjqU+Pzkfl7YI4Coes/JlSY0xVplde4KBuYQPOk0AV2qjvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EBZbSZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EBZbSZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E6A1F000FF;
	Sat, 12 Sep 2026 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224920;
	bh=O7RROCD5zDL0j/hyuS9oeU5qOJ+AsJ4MpS8EKvw3uIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EBZbSZX8l/x6H1YCJLuZkjzQXXichTaWVOeNTBjpdxUxeJKSjGsia+eJbyhX8lAb
	 Neji45pNv+XSL2zqyKKpp11o26PFiavTi4lmg1NEvx3ITi02lJ31Q54DwMivTWHRM/
	 cC/i07G43pr9isBemzU3tdrc0OO3zLI0K7lRKQh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Rientjes <rientjes@google.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Itaru Kitayama <itaru.kitayama@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yang Shi <shy828301@gmail.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1050/1424] selftests/mm/kugepaged: restore thp settings at exit
Date: Sat, 12 Sep 2026 08:58:02 +0200
Message-ID: <20260912065630.819651871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit b6aab3384cafba151c53d3b5f7e1f8d073aadf03 ]

Previously, the saved thp settings would be restored upon a signal or at
the natural end of the test suite.  But there are some tests that directly
call exit() upon failure.  In this case, the thp settings were not being
restored, which could then influence other tests.

Fix this by installing an atexit() handler to do the actual restore.  The
signal handler can now just call exit() and the atexit handler is invoked.

Link: https://lkml.kernel.org/r/20231207161211.2374093-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 15828a150c58 ("selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 030667cb55337..fc47a1c4944c4 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -374,18 +374,22 @@ static void pop_settings(void)
 	write_settings(current_settings());
 }
 
-static void restore_settings(int sig)
+static void restore_settings_atexit(void)
 {
 	if (skip_settings_restore)
-		goto out;
+		return;
 
 	printf("Restore THP and khugepaged settings...");
 	write_settings(&saved_settings);
 	success("OK");
-	if (sig)
-		exit(EXIT_FAILURE);
-out:
-	exit(exit_status);
+
+	skip_settings_restore = true;
+}
+
+static void restore_settings(int sig)
+{
+	/* exit() will invoke the restore_settings_atexit handler. */
+	exit(sig ? EXIT_FAILURE : exit_status);
 }
 
 static void save_settings(void)
@@ -415,6 +419,7 @@ static void save_settings(void)
 
 	success("OK");
 
+	atexit(restore_settings_atexit);
 	signal(SIGTERM, restore_settings);
 	signal(SIGINT, restore_settings);
 	signal(SIGHUP, restore_settings);
-- 
2.53.0



