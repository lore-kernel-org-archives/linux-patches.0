Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204C5FC03;
	Sat,  3 Feb 2024 04:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933467; cv=none; b=naS7uV1iOWdpp2ms+AZypRfnxT/1obeQTV2UGHnaWaqJ3iEuKB26VP2OzF/AeM+x2vnfN8iY7LIzovQfF91+sGxtI+RVfNBSEFnQk/GSKRAjRwnNp26KYowFy/Pg77qUopZ0iNIzbWTZhPpcRto1+4zf3N22pDl/xbAYpU0XhX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933467; c=relaxed/simple;
	bh=BFRxOgs980Lh2tyWFhQvcy8vMcQudOkoTILzWkmPRWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q76n92tYN3KeMW+DVtvyRRjmMW4MLa0raISGknqMdC6QpHrZIP5guKt7uPs98XN9aJ5H8pXjYoXg6KrgXhboV8rMg/6NVRZ9s27Qke+wdFWDPHHJsshNxiq27pxjPlc3LVh8lWwg+sdm9pAjBD1HaEg4B73d1BvCk7IkEKDlWDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TW00g3pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TW00g3pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA2AC43390;
	Sat,  3 Feb 2024 04:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933467;
	bh=BFRxOgs980Lh2tyWFhQvcy8vMcQudOkoTILzWkmPRWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TW00g3pXgk7ofvx8beGeR/2PgyYyIM5MmkiuAA2zY90aNFQjwK3mxenmMlEan/p65
	 SNZrNobrWyZLTHAdoEDEM13glpewtFHmXOWmW0KRLfCVduWF7LdqowI1c8m84UCbWn
	 vZk6A14jfTdkjKwT2WDXsd7gjnsrxQbi/Ak/fvVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/219] perf: Fix the nr_addr_filters fix
Date: Fri,  2 Feb 2024 20:05:55 -0800
Message-ID: <20240203035342.284485591@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 388a1fb7da6aaa1970c7e2a7d7fcd983a87a8484 ]

Thomas reported that commit 652ffc2104ec ("perf/core: Fix narrow
startup race when creating the perf nr_addr_filters sysfs file") made
the entire attribute group vanish, instead of only the nr_addr_filters
attribute.

Additionally a stray return.

Insufficient coffee was involved with both writing and merging the
patch.

Fixes: 652ffc2104ec ("perf/core: Fix narrow startup race when creating the perf nr_addr_filters sysfs file")
Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lkml.kernel.org/r/20231122100756.GP8262@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1e4841ebc22e..872d149b1959 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11232,12 +11232,10 @@ static umode_t pmu_dev_is_visible(struct kobject *kobj, struct attribute *a, int
 	struct device *dev = kobj_to_dev(kobj);
 	struct pmu *pmu = dev_get_drvdata(dev);
 
-	if (!pmu->nr_addr_filters)
+	if (n == 2 && !pmu->nr_addr_filters)
 		return 0;
 
 	return a->mode;
-
-	return 0;
 }
 
 static struct attribute_group pmu_dev_attr_group = {
-- 
2.43.0



