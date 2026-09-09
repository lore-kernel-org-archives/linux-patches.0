Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAA127280A;
	Wed,  9 Sep 2026 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961863; cv=none; b=MKKOK9thoIc5Ry1rjt/GQ/l4b5MefjHYEuTGsmS5b7VjCNN/M9EVYsIZ7/Xkp9/SfysHVhFwJ/nfmTXqFc267tPcDD8sLI7shiXtYS2zszsQlBuXCWQD9mQ4KUrZ8550uW1GymKTCEoaaCCfof7XGRpw298YMiuneokpLAxACXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961863; c=relaxed/simple;
	bh=ERJb107Pbk0vjij+vDrMu1vOidEQiUxPnhBfqulIqQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vh/HZIIPKNnjGpOt7Ap3K2BCyC9t+LbQBkqqnhp71OjQsKq0EI59I1iMA89AeVMIbaL/+meMxSFCowuAGirq8I642JV3VlZvClHL3C7PjCmDNaTzGbhkFj3X1+xz3A4sqjJaiPgZcwcn0xM1RBlqZeMFWbv/4ouRD2GbT/vPMsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfQMzIN4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfQMzIN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88141F00A3A;
	Wed,  9 Sep 2026 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961862;
	bh=WKbJ1jWaF7NuQTsxx6bOi5GFkoyopWgtLv9K+ybkgNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfQMzIN40mHbSBGhjD5dJMQNq6QtJ5BLcqFVkrhou8CMnKiV6gG2Pgn3hTSbu/5vz
	 Kl1EihkASZJbWevZk2XxdVc2SVSK17ZotRAzPGjrFj9b8r7x09bzF7CR/cGeL8wHG3
	 3F+gQVC3glSafBtWSRrfRUcRrh1a6ffFlq9rMNR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 093/556] mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()
Date: Wed,  9 Sep 2026 15:36:13 +0200
Message-ID: <20260909134233.772836308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 867bbe6dbd5a68eb58e79cc7f068a6cf184c40d8 upstream.

damos_test_commit_quota_goals_for() traverses damos quota goals after
damos_commit_quota_goals() call.  It assumes damos_commit_quota_goals()
made expected numbers of goals.  It might not.  Because the traversal is
made based on destination struct length, it could do out of bounds access
for source expectation value array.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited though.  It would affect only test
run setups.

Fix it by testing if the number of goals was also changed as expected and
exit early for the failure.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-7-sj@kernel.org
Link: https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org [1]
Fixes: d9adfb8a28e7 ("mm/damon/tests/core-kunit: add damos_commit_quota_goals() test")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/tests/core-kunit.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -733,6 +733,7 @@ static void damos_test_commit_quota_goal
 	struct damos_quota_goal *goal, *next;
 	bool skip = true;
 	int i;
+	int nr_dst = 0, nr_src = 0;
 
 	INIT_LIST_HEAD(&dst.goals);
 	INIT_LIST_HEAD(&src.goals);
@@ -755,6 +756,14 @@ static void damos_test_commit_quota_goal
 
 	damos_commit_quota_goals(&dst, &src);
 
+	damos_for_each_quota_goal(goal, &dst)
+		nr_dst++;
+	damos_for_each_quota_goal(goal, &src)
+		nr_src++;
+	KUNIT_EXPECT_EQ(test, nr_dst, nr_src);
+	if (nr_dst != nr_src)
+		goto out;
+
 	i = 0;
 	damos_for_each_quota_goal(goal, (&dst)) {
 		KUNIT_EXPECT_EQ(test, goal->metric, src_goals[i].metric);


