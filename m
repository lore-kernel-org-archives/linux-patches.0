Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6849200C2;
	Tue,  6 Jan 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721109; cv=none; b=SxzFhoVmvFvPlgWL1d8BEYQicnl4dCSYgi4CXaP5qduk0aLhu8CrVrKjOwLGqq3TwnQGtSldYaWo8xF4ROuxys97GsWAWu5vTEVJ6IJxDaLqGvpY/2FDtBB1rsYAdUu9rIN2N1VORuYf6jebcXESPfMig5j3py02+9+mqhOZWec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721109; c=relaxed/simple;
	bh=OTe5l9+vr8D1jTYk6nZTvgCAVmiJiWezhawRAIqitd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XV7zECrSgM25dygTK6Bu8lDsLIJQu5gWWuvscraaM4cdAJt09NcYxYEfanhE8TLzCDed/ZVnDP2a6jMc1gVIiKsOz8qmvy0O5Md2T06ze8NhcJm5RUzpxFvEPtzuRx3pv4/fwbbs0fkuZ+y19nhP77wTn+yQW665Rtj+t7xgNzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTTXGcnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTTXGcnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D9DC116C6;
	Tue,  6 Jan 2026 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721109;
	bh=OTe5l9+vr8D1jTYk6nZTvgCAVmiJiWezhawRAIqitd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTTXGcnjq2Brkl1cqAwcRXRNE/f9N9KhfPadVwzFI0WmW0LEKOQ1tzD5P5/qzF23o
	 y3/vSg8rigfb+aT4qUfaX2gTIsemA7ZpPyaKkdNTksEWaOHcQTRI1dqwP+m75UJaiQ
	 44zaVKzrMAAEDwtiK9jYl5n9D8T0hBc2tnWz/Gn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 421/567] mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()
Date: Tue,  6 Jan 2026 18:03:23 +0100
Message-ID: <20260106170506.914477222@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 7d808bf13943f4c6a6142400bffe14267f6dc997 upstream.

damon_sysfs_test_add_targets() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-21-sj@kernel.org
Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/sysfs-kunit.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
index 7b5c7b307da9..ce7218469f20 100644
--- a/mm/damon/tests/sysfs-kunit.h
+++ b/mm/damon/tests/sysfs-kunit.h
@@ -45,16 +45,41 @@ static void damon_sysfs_test_add_targets(struct kunit *test)
 	struct damon_ctx *ctx;
 
 	sysfs_targets = damon_sysfs_targets_alloc();
+	if (!sysfs_targets)
+		kunit_skip(test, "sysfs_targets alloc fail");
 	sysfs_targets->nr = 1;
 	sysfs_targets->targets_arr = kmalloc_array(1,
 			sizeof(*sysfs_targets->targets_arr), GFP_KERNEL);
+	if (!sysfs_targets->targets_arr) {
+		kfree(sysfs_targets);
+		kunit_skip(test, "targets_arr alloc fail");
+	}
 
 	sysfs_target = damon_sysfs_target_alloc();
+	if (!sysfs_target) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kunit_skip(test, "sysfs_target alloc fail");
+	}
 	sysfs_target->pid = __damon_sysfs_test_get_any_pid(12, 100);
 	sysfs_target->regions = damon_sysfs_regions_alloc();
+	if (!sysfs_target->regions) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target);
+		kunit_skip(test, "sysfs_regions alloc fail");
+	}
+
 	sysfs_targets->targets_arr[0] = sysfs_target;
 
 	ctx = damon_new_ctx();
+	if (!ctx) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target);
+		kfree(sysfs_target->regions);
+		kunit_skip(test, "ctx alloc fail");
+	}
 
 	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
-- 
2.52.0



