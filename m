Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5FA3B8D5F;
	Thu, 15 Jan 2026 17:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498388; cv=none; b=nBGS1lOYxncdFvaZ7n45Izmu4nJF9yAhfqQ5cgjWQn+u+MDfgupc7mVzuV/v0K9ofV5/0McVjz/eX/W2swhrT7xHu9OU+zGdPkLUvJ2CgduTpso/KGaIqHrJOVNQRcriKsI8YLeJTC0J7B44o9pIGy/Artq39RPe3fsgOmGfUY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498388; c=relaxed/simple;
	bh=ctPlRb8VNegU8YBJczQ4OedyiLzmrl3VFKSc56fKA7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj24wwYYK5JHFFq/YJt2IUFs9CdFbQVLs5oJuYkA8W5pLuipX+OiQPIaNUaVwi2kaMyWkyqby2vSXPQTea2qMJyYyuuESdiXSO++6f09QhbPjPwWw3Pjk0f6C9XqOb/R4fVwv060e0FpgRmIvsymfyv7+OyKH5JwKwNbsW70d+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dN9WHFM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dN9WHFM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BA7C116D0;
	Thu, 15 Jan 2026 17:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498388;
	bh=ctPlRb8VNegU8YBJczQ4OedyiLzmrl3VFKSc56fKA7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dN9WHFM0Vk/FTj5AJkoDuk5bGYN4uhvDJN3DesIuGrhPDx0kKueupk7O7jqSBRbfS
	 tCQj8XjXm38LZ79JU/Z2YFlems5tvMZyBWFWTIVvCBYzjRQTMuA5+SDkV1Vd7XnoEX
	 yR6JL/OUr9nuCfsi/7JEG8DctXgQoOcXCKsDx7Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 413/554] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()
Date: Thu, 15 Jan 2026 17:47:59 +0100
Message-ID: <20260115164301.186626633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 2b22d0fcc6320ba29b2122434c1d2f0785fb0a25 upstream.

damon_do_test_apply_three_regions() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-18-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr-test.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/vaddr-test.h
+++ b/mm/damon/vaddr-test.h
@@ -141,8 +141,14 @@ static void damon_do_test_apply_three_re
 	int i;
 
 	t = damon_new_target(42);
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	for (i = 0; i < nr_regions / 2; i++) {
 		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
+		if (!r) {
+			damon_destroy_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
 		damon_add_region(r, t);
 	}
 	damon_add_target(ctx, t);


