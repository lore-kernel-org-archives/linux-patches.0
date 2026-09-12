Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8B3366045;
	Sat, 12 Sep 2026 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226230; cv=none; b=DQXvbCMpoA3tDdigt7rqUoAWpL7ZlrzzOyzWQjy5powPR7tx9ltrzIyxYKkdaJQ5DCV6RB9DpYAow3gXfYZBK2D1JTTV7nz7Z2YxCk+QqjUC4U2KOUdzss3lzbTlgem4Am9vSSVYCYY+ItK1HFIkSkY1DDyIynHL4JTxTP0367A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226230; c=relaxed/simple;
	bh=3Ar7I5o+pswh0+P0vMpG3wtaigmsKlfo32HKCFR8h9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0mSxvP9NkI90gSRBX8aCUEka3FFLHKvSOWHg07sRQonyiGgUEfHeuZVJ998wBTbANoLyvy/zRSzxGFfEr4SBo8db3UNtRPrF4i/xeHeHEONiZTGdmxNvrH7/B8mCXI3EyZFSLxIkaw8BmBAB7qe70fm9ODrjvKziDpL59t6a24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvFLPHch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvFLPHch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9601F000FF;
	Sat, 12 Sep 2026 15:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226228;
	bh=VVTMjYIS1VWGhYxcECrB5Bt8J+mFog/FJdSryWA/EVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvFLPHchyUFgxlJG7ibhIXXzEciOwIHMRCF4ZRn33mMewaKgxF8kjHsxqQgfDW58M
	 eFgxqzQh1QNAutB7UFjSDI75ybv0n8zo28X+cY91qBJ4TILlzmJQyAYcqC1jKxVdEN
	 idAu1rUlWHoShrMY8V6RP4LUklsod4323Bi9tnq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1358/1424] selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Sat, 12 Sep 2026 09:03:10 +0200
Message-ID: <20260912065637.675157195@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit 4004c130c358b1561a55323b0e747f20f5133f7b ]

Patch series "selftests/mm: Handle unsupported and transient test
conditions", v3.

Several MM selftests report failures when the test environment lacks
an underlying prerequisite, such as fallocate() support, MADV_REMOVE,
local page-cache semantics, or swap.

This series converts those unsupported cases to SKIP while preserving
failures for unexpected errors. It also allows migration tests to retry
transient move_pages() failures.

This patch (of 4):

The tmpfile-backed COW cases allocate a one-page file with fallocate()
before exercising private and shared mappings.  When the filesystem
backing tmpfile() does not implement fallocate(), setup fails with
EOPNOTSUPP and no COW behavior is exercised.

This occurs when the temporary directory resides on a filesystem with
limited allocation support, such as NFSv3.  Reporting a failure adds noise
because the test prerequisite is absent rather than the COW implementation
being broken.

Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
error as a failure so unexpected setup regressions remain visible.

Link: https://lore.kernel.org/20260727095225.372655-1-usama.anjum@arm.com
Link: https://lore.kernel.org/20260727095225.372655-2-usama.anjum@arm.com
Fixes: f8664f3c4a08 ("selftests/vm: cow: basic COW tests for non-anonymous pages")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 6da407f1728de..0b7660c5f08f7 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1670,8 +1670,13 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 
 	/* File consists of a single page filled with zeroes. */
 	if (fallocate(fd, 0, 0, pagesize)) {
-		ksft_perror("fallocate() failed");
-		log_test_result(KSFT_FAIL);
+		if (errno == EOPNOTSUPP) {
+			ksft_print_msg("fallocate() not supported by filesystem\n");
+			log_test_result(KSFT_SKIP);
+		} else {
+			ksft_perror("fallocate() failed");
+			log_test_result(KSFT_FAIL);
+		}
 		goto close;
 	}
 
-- 
2.53.0



