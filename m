Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE5B36C0B7;
	Tue,  6 Jan 2026 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722261; cv=none; b=TzEAgHvY9kt4Wra30CTzjquT05EnyKaAOx88/bc5nfsQahH5Pxn8UEsWEEKHP+mPeE05ue8UdvW7ryG08UfRoxRGqJWggA7KWM5WE3MBruMxfy4gdPiiJuEGnioSrTx9aQFxYE4/3JseNfYxILaATo8IaGQB+eUQGbdigmC1sOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722261; c=relaxed/simple;
	bh=fRkCU9UWvsi8gFfu/upTBz2+fwIBRcHcaZhki3GFxJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+RFSk5hLWSxE+ZcGcvl9Ba+Dpg49VYb1oQ9NUnzvjFMJDU4Wdg6yB1olJTQfMyuRfc5gAMntXrEkLYqslKVxxvHEnQ1BrCQlF9sGPbdGTOPs5x6d+oBLhgOMmOERfXW2NTF1D/0v0aIYxASA7RDu8X1bIS0G/DTVh7SG4I+IJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDPBgCrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDPBgCrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0572C116C6;
	Tue,  6 Jan 2026 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722261;
	bh=fRkCU9UWvsi8gFfu/upTBz2+fwIBRcHcaZhki3GFxJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nDPBgCrryTEGiL2nz9uBUIwueEYRWhrqAkcw/AEz3sRFMJ8/QoABgs7uVEH2anYb/
	 g7TtOMtXZG2ETrYFlc6+pE59kwpUOiWOxBwtdk3ZJySuq8W9+G6oyIHXPYx13flVxh
	 FZosEXYsly5V457r10drx4w863HoJIuRpnbLFLnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 212/312] mm/damon/tests/core-kunit: handle alloc failures on damon_test_set_filters_default_reject()
Date: Tue,  6 Jan 2026 18:04:46 +0100
Message-ID: <20260106170555.509077097@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 84be856cc87317bc60ff54bd7c8f8a5aa8f0e2c8 upstream.

damon_test_set_filters_default_reject() is assuming all dynamic memory
allocation in it will succeed.  Those are indeed likely in the real use
cases since those allocations are too small to fail, but theoretically
those could fail.  In the case, inappropriate memory access can happen.
Fix it by appropriately cleanup pre-allocated memory and skip the
execution of the remaining tests in the failure cases.

Link: https://lkml.kernel.org/r/20251101182021.74868-17-sj@kernel.org
Fixes: 094fb14913c7 ("mm/damon/tests/core-kunit: add a test for damos_set_filters_default_reject()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[6.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -617,6 +617,8 @@ static void damon_test_set_filters_defau
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
 
 	target_filter = damos_new_filter(DAMOS_FILTER_TYPE_TARGET, true, true);
+	if (!target_filter)
+		kunit_skip(test, "filter alloc fail");
 	damos_add_filter(&scheme, target_filter);
 	damos_set_filters_default_reject(&scheme);
 	/*
@@ -642,6 +644,10 @@ static void damon_test_set_filters_defau
 	KUNIT_EXPECT_EQ(test, scheme.ops_filters_default_reject, false);
 
 	anon_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
+	if (!anon_filter) {
+		damos_free_filter(target_filter);
+		kunit_skip(test, "anon_filter alloc fail");
+	}
 	damos_add_filter(&scheme, anon_filter);
 
 	damos_set_filters_default_reject(&scheme);


