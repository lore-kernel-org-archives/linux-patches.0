Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC4A1DF98F;
	Wed,  6 Nov 2024 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899076; cv=none; b=Btao8HbQDn3jXlVVQBCR/vZfBqAuy/pZC69vIA17H7c4RKrcYQfIIQIxvFLHmZI7APBP0oh/eBcfkSYHayUkLt0rNeZZPh94hZwigWO2jyC8pwHkFU4luOQfXFua5bBokuFd+eyfu61QJ3nD2PlzAagCOrjMydtJbN5X5+ionTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899076; c=relaxed/simple;
	bh=1S6ANel3x2oag6z+uS0r/mMXbfIQMLp12UOZWP6qbBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nj04c9TWOAZIck8hvLg8Sofkv3jJFZTWSYSaEKaUdBuVCqJ9YmmuDyZgUYoC0iCIraWtu11uBcN80ZGBXsnC4yULJeWGeCOVyJC/EW/c1evfdvp7hd48FL8/4cq1n+w7HnFippw+Wg5ADIGt6p7lNGWxRth6rmrlxveZpR+T8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb6OOPtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb6OOPtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2C4C4CED7;
	Wed,  6 Nov 2024 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899076;
	bh=1S6ANel3x2oag6z+uS0r/mMXbfIQMLp12UOZWP6qbBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vb6OOPtp6wnV8/c88PCdtjWrGTQoeqrRiB6T9J6Fg/kM1etrJRjM2iKM1uA4ibg0h
	 KcrZkrF+wsX0A8NUR8EbLgcAPL4aR2zLH5fPoyyzH2uBDKaHDDghSXP4WBswaE4FT5
	 f0eub7VcDi9w+D5Qid0qT0GYmOsd+aBQPMbkePss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 426/462] cgroup: Fix potential overflow issue when checking max_depth
Date: Wed,  6 Nov 2024 13:05:19 +0100
Message-ID: <20241106120342.034747614@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 3cc4e13bb1617f6a13e5e6882465984148743cf4 ]

cgroup.max.depth is the maximum allowed descent depth below the current
cgroup. If the actual descent depth is equal or larger, an attempt to
create a new child cgroup will fail. However due to the cgroup->max_depth
is of int type and having the default value INT_MAX, the condition
'level > cgroup->max_depth' will never be satisfied, and it will cause
an overflow of the level after it reaches to INT_MAX.

Fix it by starting the level from 0 and using '>=' instead.

It's worth mentioning that this issue is unlikely to occur in reality,
as it's impossible to have a depth of INT_MAX hierarchy, but should be
be avoided logically.

Fixes: 1a926e0bbab8 ("cgroup: implement hierarchy limits")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 16ae868941211..79e57b6df7316 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5502,7 +5502,7 @@ static bool cgroup_check_hierarchy_limits(struct cgroup *parent)
 {
 	struct cgroup *cgroup;
 	int ret = false;
-	int level = 1;
+	int level = 0;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -5510,7 +5510,7 @@ static bool cgroup_check_hierarchy_limits(struct cgroup *parent)
 		if (cgroup->nr_descendants >= cgroup->max_descendants)
 			goto fail;
 
-		if (level > cgroup->max_depth)
+		if (level >= cgroup->max_depth)
 			goto fail;
 
 		level++;
-- 
2.43.0



