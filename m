Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61923330D27;
	Fri,  9 Jan 2026 12:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962886; cv=none; b=nm4M4fdhrzA4RNef3HaZPG4YwsGPiVO1VS+muOufjVfq0hGplHeW0oGWXpCZCpkaOIYAdA/1SWuTsqht9MIkKIcgvbo834SWwvDarVBqrZ3qRCa9V9OR+Cri37zksC5xWp/QLzRrJohleHuSoodLLAZCq9oPBmBPY72jPGQXpx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962886; c=relaxed/simple;
	bh=K2aOH/TFSshkLEA32+3TJeHiS887ChzpNU9awblDwnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1zjmeKnQLJfBn0uZHorjS1w6QTmv/62UnPBla/M8BXDKQJstpqE2CEUt0zceK9FubsDxrzeS7ec+h+UpeeL1kXVcFsAGLjXWUL96a8quZDLHMdnK5XMKBoWLvXJQEYjKMoUUjfILSTVXU0SB7OoFaUhkrnErJ6jMR840o6OFcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/DFPI9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/DFPI9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E674AC16AAE;
	Fri,  9 Jan 2026 12:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962886;
	bh=K2aOH/TFSshkLEA32+3TJeHiS887ChzpNU9awblDwnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/DFPI9z7zYHg+3qep8I+6B2mIss6Tiu5PvbS+dkchJH7LkRASyk5RoShhGkNbQH/
	 yn1G49LSWo7RXHUc2VuqiaQzMih13Kl9BBXKV7dSjsKDrD4Yx81q7gonuw9V1tgTTd
	 1voyLBGtKWSajzy/Z5+xoiqVoQnzKz0k5UDwfqoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 521/634] mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()
Date: Fri,  9 Jan 2026 12:43:19 +0100
Message-ID: <20260109112137.166810624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 3d443dd29a1db7efa587a4bb0c06a497e13ca9e4 upstream.

damon_test_merge_two() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.  In
the case, inappropriate memory access can happen.  Fix it by appropriately
cleanup pre-allocated memory and skip the execution of the remaining tests
in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-7-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core-test.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -162,10 +162,20 @@ static void damon_test_merge_two(struct
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	r->nr_accesses = 10;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "second region alloc fail");
+	}
 	r2->nr_accesses = 20;
 	damon_add_region(r2, t);
 


