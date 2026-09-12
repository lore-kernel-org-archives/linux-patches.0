Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314C2397922;
	Sat, 12 Sep 2026 11:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212319; cv=none; b=NP7M/1zBVIONOEn4ZpmlEzv8Z4G9ZJy6cRVOj1IdP81rXGVWDKs+LKe5IPx80e6yGM0YlBZ7v9MzVnz96Ea7vh1LjEJjbP8SIjkaPaAH0rBNdHZ64/+XhHOVMyks9uNUbjUAJ+lBlG1c5i6cNwQP8RL1uLdkpiZ0WH0sqdvoDGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212319; c=relaxed/simple;
	bh=38O7XIqGo2qfutoe9f3PB8x63a4AnWsWv0j/WP/kIYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7f78ciPQqaIO7nkps3IReB96h2PhL6yncyFKWxBXFldi+jDGGmU6QIbrbbtBkd1ZZy1Fcs2mYcR1y40+7yQo6VzPOxuVhSo0/5k1dclbobl2s3yg0lMCqlbV3Pi46ZTTxiUmRIMymh7kiVmt+NoG3TZ7Mp/mOUz+RWdsMzZCXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/5MEVeT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/5MEVeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DF31F000FF;
	Sat, 12 Sep 2026 11:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212317;
	bh=bzA4wzb/p9TiguhdWzsq47gy1dVGqBKJSunIxR/Nsug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/5MEVeT7AGWaG2jw2q66sSNl1ZS7WpQrXUZKSVeBJXb5l/HA9Clab8pWHkflngmE
	 E0R8mKrLJ5/Z9oL9fm8D26WsuAUIPZM2v5c8J1+WmjG7V8Xml9WXeoBW4BjwH7058t
	 mDvLQy9yI/yFyfs/NnH+iuRLE2tLsQrwVfodBELA=
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
Subject: [PATCH 6.18 1411/1518] selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
Date: Sat, 12 Sep 2026 08:59:40 +0200
Message-ID: <20260912065655.469235230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 0df61422467da..af8db738423d4 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1699,8 +1699,13 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
 
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



