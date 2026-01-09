Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E65F15ADB4;
	Fri,  9 Jan 2026 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961357; cv=none; b=O3cYHpW+j3sGuMDuM/bbGbowta5KV2oxaxk6yu4OffzJTCkdQyd8dUXVFrQ06ihkiUj4DJjHZ0JAC3n9uQq4AS0nogQETEhgocZ4ibbOPTXIgZoM1V5RmOg7yGb5wxYp/pHzcmBAJ5DBTTqYQPMttwXZn7iIgjJpTi7ymfbK2FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961357; c=relaxed/simple;
	bh=WKS31AP09BZepchob93cdBDJ4gXfcWlBnTrE1lTDz/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFf7r1xOfRAsxUODY6e9ylyhq399yvb6GS0qgVx8kzME0mNZfFzIEf2aj1ncNV70q9esMbFPQiL9M2dg1R658xQgRAFLjzivJRwi3+j13W8gueixNtJi8jvAq8j4eViWP7+tPJARO2AcTgMhJvHvGkNqG27awnUahBhM2ZBpL94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7+aQa94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7+aQa94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F78C4CEF1;
	Fri,  9 Jan 2026 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961357;
	bh=WKS31AP09BZepchob93cdBDJ4gXfcWlBnTrE1lTDz/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7+aQa94znGJt10nMytm8ld/AORRbETroCh1mAaCFzzdKWVKQH7kiy3bS26obhE0z
	 cDBu/bqnIi34IbRVt9PYdtJCu410wlvlDfpdsm4vKCYhxQoZahmIupf3Qm8Sl+Rc4U
	 q5sWwqJzYv6ZSFcA5XMSIWrRLpJ2ksbipnqUyFCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 707/737] mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()
Date: Fri,  9 Jan 2026 12:44:06 +0100
Message-ID: <20260109112200.668653338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -136,8 +136,14 @@ static void damon_do_test_apply_three_re
 	int i;
 
 	t = damon_new_target();
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
 


